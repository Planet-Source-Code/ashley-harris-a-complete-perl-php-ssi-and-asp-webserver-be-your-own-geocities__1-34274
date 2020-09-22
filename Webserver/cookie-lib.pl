# Perl Routines to Manipulate Web Browser Cookies
# kovacsp@egr.uri.edu
# $Id: cookie-lib.txt,v 0.913 1998/11/20 19:45:36 kovacsp Exp $
#
# Copyright (c) 1998 Peter D. Kovacs
# Unpublished work.
# Permission granted to use and modify this library so long as the
# copyright above is maintained, modifications are documented, and
# credit is given for any use of the library.
#
# Portions of this library are taken, without permission (and much
# appreciated), from the cgi-lib.pl.  You may get that at
# http://cgi-lib.stanford.edu/cgi-lib
#
# For more information, see:
# http://www.egr.uri.edu/~kovacsp/cookie-lib/

# For more information on cookies, go to:
# http://search.netscape.com/newsref/std/cookie_spec.html

=pod

=head1 NAME

Cookie-lib.pl - Read, sets and delete's cookies from World Wide Web Browsers.

=head1 SYNOPSIS

require "cookie-lib.pl"
$cookie{MyCookie} = "MyValue";
&set_cookie($expiration, $domain, $path, $secure);
&get_cookie();
&delete_cookie("MyCookie");

=head1 DESCRIPTION

Cookie-lib.pl routines are useful for setting and reading cookies in users browsers (like
Netscape or Internet Explorer).  This library was built from scratch, but based off the
popular CGI-LIB.PL

=head2 About Cookies

Cookies are small pieces of persistent data which may be kept on the client.  There are a few
restrictions involved with using cookies.  Namely, no cookie may be more than 1K in length, and
no single domain may have more than 20 (?) cookies on a given client at the same time.  Furthermore
the client has a limited total number of cookies.

Because HTTP is a stateless protocol, cookies serve an important purpose in maintaining state between
sessions, possibly even if the user closes his browser.

There are several parts to a cookie.  There is a name=value pair, and expiration, a secure flag, a
domain and a path.  Cookies are sent back to the server under the following algorithm:

The domain and path of the requested document must match (or be a subset) of the cookie.  For example,
you can set a cookie like so:
    &set_cookie(-1, ".domain.com","/my/path",0);
This cookie will be available to any server in the domain.com domain B<(NOTE: There MUST be the preceding ".")>
and any document in the directory hierarch of /my/path.

Secure cookies will only be sent back on secure connections.

=head1 GET_COOKIE

    &get_cookie();

This reads in information from the HTTP_COOKIE environmental variable, splits it up into name=value pairs
and stuffs those into the %cookie hash.  If for some reason you need the cookie-raw data, it's available
inside a script as $ENV{HTTP_COOKIE}.

=cut


sub get_cookie {
  local($chip, $val);
  foreach (split(/; /, $ENV{'HTTP_COOKIE'})) {
    	# split cookie at each ; (cookie format is name=value; name=value; etc...)
    	# Convert plus to space (in case of encoding (not necessary, but recommended)
    s/\+/ /g;
    	# Split into key and value.
    ($chip, $val) = split(/=/,$_,2); # splits on the first =.
    	# Convert %XX from hex numbers to alphanumeric
    $chip =~ s/%([A-Fa-f0-9]{2})/pack("c",hex($1))/ge;
    $val =~ s/%([A-Fa-f0-9]{2})/pack("c",hex($1))/ge;
    	# Associate key and value
    $cookie{$chip} .= "\1" if (defined($cookie{$chip})); # \1 is the multiple separator
    $cookie{$chip} .= $val;
  }
}

=pod

=head1 SET_COOKIE

    &set_cookie($expires, $domain, $path, $secure);

I<$expires> is in unix time format.  If it is not defined, the default is December 31, 1999 (due to year 2000
problems with some browsers, this is the safest long term date to use.)  If it is set to "-1" no expiration
time will be given, making the cookie a session-only cookie (it will go away when the user closes his browser).
For example, to make the cookie expire in 5 minutes you might use:

    &set_cookie(time()+300, ".my.domain.com", "/", 0);

I<$domain> is a string which tells the browser which domains to send the cookie back to.  If the domain is
one of the 7 top level domains then there must be B<at least two> periods in the domain.  Otherwise, there
must be B<at least three> periods in the domain.

I<$path> is similar to domain.  In most cases it can simply be "/", in which case all documents in the domain
will be sent back the cookie.  If the cookie is large, this can be a waste of bandwidth of course.  Otherwise,
set it to the directory containing the documents you wish to receive the cookie.

I<$secure> is either a one or a zero.  Zero means "send and store this cookie in plain text", 1 means "send
and store this cookie encrypted".  A value of 1 has not been tested as I do not have a secure server to test
it on.  If you have done so, let me know.

=head2 NOTES

You B<MUST> set any and all cookies before you send the content type header to the browser.  Also there have
been reports of peculiarities with a certain companies browsers.  If you wish to complain, contact your vendor,
as this library follows the spec.

=cut

sub set_cookie {
  # $expires must be in unix time format, if defined.  If not defined it sets the expiration to December 31, 1999.
  # If you want no expiration date set, set $expires = -1 (this causes the cookie to be deleted when user closes
  # his/her browser).

  local($expires,$domain,$path,$sec) = @_;
    local(@days) = ("Sun","Mon","Tue","Wed","Thu","Fri","Sat");
    local(@months) = ("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec");
  local($seconds,$min,$hour,$mday,$mon,$year,$wday) = gmtime($expires) if ($expires > 0); #get date info if expiration set.
  $seconds = "0" . $seconds if $seconds < 10; # formatting of date variables
  $min = "0" . $min if $min < 10;
  $hour = "0" . $hour if $hour < 10;
  local(@secure) = ("","secure"); # add security to the cookie if defined.  I'm not too sure how this works.
  if (! defined $expires) { $expires = " expires\=Fri, 31-Dec-1999 00:00:00 GMT;"; } # if expiration not set, expire at 12/31/1999
  elsif ($expires == -1) { $expires = "" } # if expiration set to -1, then eliminate expiration of cookie.
  else {
    $year += 1900;
    $expires = "expires\=$days[$wday], $mday-$months[$mon]-$year $hour:$min:$seconds GMT; "; #form expiration from value passed to function.
  }
  if (! defined $domain) { $domain = $ENV{'SERVER_NAME'}; } #set domain of cookie.  Default is current host.
  if (! defined $path) { $path = "/"; } #set default path = "/"
  if (! defined $secure) { $secure = "0"; }
  local($key);
  foreach $key (keys %cookie) {
    $cookie{$key} =~ s/ /+/g; #convert plus to space.
    print "Set-Cookie: $key\=$cookie{$key}; $expires path\=$path; domain\=$domain; $secure[$sec]\n";
	 			#print cookie to browser,
				#this must be done *before*	you print any content type headers.
  }
}

=pod

=head1 DELETE_COOKIE

    &delete_cookie("name1", "name2");

I<delete_cookie> will delete cookies of the given names.  It does so by setting the expiration date in
the past so that the browser will remove the cookie from it's memory.

=cut

sub delete_cookie {
  # to delete a cookie, simply pass delete_cookie the name of the cookie to delete.
  # you may pass delete_cookie more than 1 name at a time.
  local(@to_delete) = @_;
  local($name);
  foreach $name (@to_delete) {
   undef $cookie{$name}; #undefines cookie so if you call set_cookie, it doesn't reset the cookie.
   print "Set-Cookie: $name=deleted; expires=Thu, 01-Jan-1970 00:00:00 GMT;\n";
   			#this also must be done before you print any content type headers.
  }
}

sub split_cookie {
# split_cookie
# Splits a multi-valued parameter into a list of the constituent parameters

  local ($param) = @_;
  local (@params) = split ("\1", $param);
  return (wantarray ? @params : $params[0]);
}

=pod


=head1 BUGS

If you find any bugs please contact the author, Peter Kovacs I<kovacsp@egr.uri.edu>.  There have been reports
that cookies aren't deleted if the path of the cookie is something other than "/".  I'm not sure why this is.

=head1 AUTHOR INFORMATION

Copyright 1998, Peter D. Kovacs.  All rights reserved.  This module may be used and modified
freely, but please keep this copyright attached to the file and document any changes you made.

Send bug reports, comments or questions to:
kovacsp@egr.uri.edu

=cut

1;

