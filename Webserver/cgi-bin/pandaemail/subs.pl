$re = "beee";
	    $hostname = ` hostname `;
	    chop($hostname);
sub readform {

	@vars = split(/&/, $ENV{QUERY_STRING});
	foreach $var (@vars) {
	        ($v,$i) = split(/=/, $var);
	        $v =~ tr/+/ /;
	        $v =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
	        $i =~ tr/+/ /;
	        $i =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
	        $i =~ s/<!--(.|\n)*-->//g;
	        $INFO{$v} = $i;
	}
# Somebody trying to connect to a remote server
	$action = $INFO{'action'};
    
	if ($action =~ /send/) {
# THIS ACTION REQUIRES USE OF SENDING MAIL WITH CGI SCRIPTING
use CGI;
$query = new CGI;
$data = "";
if ($ENV{'CONTENT_LENGTH'} > $maxsize) { &fatal_error; }
$attachment = $query->param("attachment");
if ($attachment) { 
$type = $query->uploadInfo($attachment)->{'Content-Type'};
while (read($attachment,$i,1024)) {
    $data .= $i;
}
	       }

$FORM{'email'} = $query->param("email");
$FORM{'reply'} = $query->param("reply");
$FORM{'name'} = $query->param("name");
$FORM{'comment'} = $query->param("comment");
$FORM{'commenthtml'} = $query->param("commenthtml");
$FORM{'subject'} = $query->param("subject");
$FORM{'cc'} = $query->param("cc");
$FORM{'bcc'} = $query->param("bcc");

	}
	else {

	read(STDIN, $input, $ENV{'CONTENT_LENGTH'});
	@pairs = split(/&/, $input);
	foreach $pair (@pairs) {

	        ($name, $value) = split(/=/, $pair);
	        $name =~ tr/+/ /;
	        $name =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
	        $value =~ tr/+/ /;
	        $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
	        $FORM{$name} = $value;
	    }
    }

	if ($FORM{'mailserver'}) { $mailserver = $FORM{'mailserver'}; }
# if POPPASSWORD IS SENT USERS FIRST LOGIN CREATE A SESSION
	if ($FORM{'POPPASSWORD'}) {
	    &createsession; &getinfo;
	}
	elsif ($INFO{'session'}) {
	if(-e("$basedir/$INFO{'session'}")) {
	    open(FILE,"$basedir/$INFO{'session'}")|| die "I cant do this";
	    $info = <FILE>;
	    close(FILE); 
		$infou = unpack("u*",$info); 
($FORM{'USERNAME'}, $FORM{'POPPASSWORD'},$mailserver, $myip) =  split(/\|/,$infou);
($junk,$myip) = split(/vWq/,$INFO{'session'});
$myip =~ s/lt/\./g;
# This area is to check that every connection comming is from the correct IP 
if ($checkip eq "yes") {
	    if ($myip ne $ENV{'REMOTE_ADDR'}) {
		print "Content-type: text/html\n\n <center> <img src=$imagedir/yeek.gif> <h2> Sorry Cannot Verify your connection</h2> <!---- $myip -$ENV{'REMOTE_ADDR'} ----> </center> </h2> ";
		exit();
	    }
	}
if ($action eq "") { 
# Now this is just a refresh of his mailbox
&getinfo; }
}
	else {
	    print "Content-type: text/html\n\n";
	    print "<h2> Your session  has ended you are logged out </h2>";
	    exit();
	}
    }
($FORM{'USERNAME'},$domain) = split(/\@/,$FORM{'USERNAME'});

    }

sub get_date {

	($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

	$mon_num = $mon+1;
	$savehour = $hour;
	$hour = "0$hour" if ($hour < 10);
	$min = "0$min" if ($min < 10);
	$sec = "0$sec" if ($sec < 10);
	$saveyear = ($year % 100);
	$year = 1900 + $year;

	$mon_num = "0$mon_num" if ($mon_num < 10);
	$mday = "0$mday" if ($mday < 10);
	$saveyear = "0$saveyear" if ($saveyear < 10);
	$date = "$mon_num/$mday/$saveyear $txt{'107'} $hour\:$min\:$sec";
}

sub Initialize {
    print "Content-type:text/html \n\n";
    print "<html> <head> <title> Log in </title> </head> 
<body> <Center> <img src=$imagedir/pandalogo.gif> </center> <hr> 
<table border=1> <tr> <td> <form method=POST action=$cgi>
User e-mail address User\@domain.name: </td> <td> 
<input type=text name=USERNAME> </td> </tr> <tr> <td> Password </td> <td>
<input type=password name=POPPASSWORD> </td> </tr> <tr> <td> Mailserver (or Default) </td> <td>
<input type=text name=mailserver></td> </tr> <tr> <td colspan=2 align=center>
<input type=submit name=submit value=Login> </td> </tr> </table> <small>
<!--- For Test purposes you may use user e-mail: test\@omf.net password: tester mailserver: conf.omf.net  -->
<small>
";
	exit();
}

sub fatal_error {
   print "Content-type:text/html \n\n";
   print "<h2> File Size to upload is too big only 1 Mbyte maximum attachment is allowed from this site </h2> <a href=javascript:history.go(-1)> Click Here </a> To return";
   exit();

}

sub createsession {
# Make usre you can login 
($username,$domain) = split(/\@/,$FORM{'USERNAME'});
if ($domain eq "") {
    print "Content-type: text/html\n\n <h2> Please enter your full e-mail address as as in username\@domain.name"; exit();
}
$pop = new Mail::POP3Client($username, $FORM{'POPPASSWORD'}, $mailserver);
$junk = $pop->Message;
if ($junk =~ /-ERR/) {
    &passfail; exit();
}
if ($junk =~ /\+OK/) {
    $a = time;
    srand($a);
    $data = "$FORM{'USERNAME'}|$FORM{'POPPASSWORD'}|$mailserver|$ENV{'REMOTE_ADDR'}";
    $cryptdata = pack("u*",$data);  
    $one = int(rand($a)) +2;
    $two = int(rand($a)) +11;
    $remoteip = $ENV{'REMOTE_ADDR'};
    $remoteip =~ s/\./lt/g;
	       $salt = $one.$two."vWq".$remoteip;
	       open(FILE,">$basedir/$salt")|| die "I cant do this ($basedir/$salt)";
    print FILE $cryptdata;
	       close(FILE);
    $INFO{'session'} = $salt; }
else { 
    print "Content-type:text/html\n\n <h2> $mailserver is down </h2>";
    $pop->Close;
    exit();
}
    $pop->Close; 
}

sub getinfo {
($username,$domain) = split(/\@/,$FORM{'USERNAME'});
if ($domain eq "") {
    print "Content-type: text/html\n\n <h2> Please enter your full e-mail address as as in username\@domain.name"; exit();
}
$pop = new Mail::POP3Client($username, $FORM{'POPPASSWORD'}, $mailserver);
$junk = $pop->Message;
if ($junk =~ /-ERR/) {
    &passfail; exit();
}
if ($junk =~ /\+OK/) {
$num_messages = $pop->Count;
$ky = time;
srand($ky);
$ky = int(rand($ky));
print "Content-type: text/html\n\n";
print "<title> Logged in </title> <h5> You have  $num_messages messages in your <img src=$imagedir/inbox.gif> Inbox </h5> <form method=POST name=form1> \n";
    print "<a href=$cgi?session=$INFO{'session'}&action=sendmail> 
<img src=$imagedir/compose.gif alt=New_Message border=0> </a> 
<a href=$cgi?session=$INFO{'session'}&key=$ky>
<img src=$imagedir/refresh.gif alt=Refresh_Messages border=0> </a>
<a href=$cgi?session=$INFO{'session'}&action=deleteall>
<img src=$imagedir/deleteall.gif alt=Delete_All_Messages border=0> </a>
<a href=\"Javascript:delete_marked()\">
<img src=$imagedir/deletemarked.gif alt=Delete_Selected_Messages border=0> </a>
<a href=$cgi?session=$INFO{'session'}&action=logout>
<img src=$imagedir/Logout.gif alt=Logout border=0> </a>

";
if ($num_messages > 0) {

print"<table border> <tr bgcolor=#EOEOFF> <td width=5%> No. </TD> <td width=18%> From </td> <td width=18%> Subject (Read Message)</td> <td width=23%> Date <image src=$imagedir/tool-weekview.gif> </td> <td width=5%> Size in Kbytes</td> <td width=5%>View<br>Header</td><td width=10%> Delete<br>This<br>Message</td> </tr> ";
  for($i = 1; $i <= $num_messages; $i++){
      $temp = $pop->List($i);
      ($junk, $message_size) = split (/\s/, $temp, 2);
    $message_size = $message_size/1000;
      foreach ($pop->Head($i)) {
	  /^From:/i and $from = $_;
	  /^Subject:/i and $subject = $_;
	  /^Date:/i and $date = $_;
      }
      $from =~ s/^From://i;
      $from =~ s/<|>//g;
      $subject =~ s/^Subject://i;
      $date =~ s/^Date://i;
      print " <tr bgcolor=#F8CD94> <td width=5%> <input type=checkbox name=C$i>$i </td> <td width=23%> $from </td>
<td width=23%> <a href=$cgi?session=$INFO{'session'}&action=read&number=$i&message_size=$message_size> <img src=$imagedir/tool-refresh.gif border=0 alt=Read>  $subject
</a>

 </td> <td width=23%> $date </td>
 <td width=5%>$message_size </td>  
<td width=10%> 
<a href=$cgi?session=$INFO{'session'}&action=view&number=$i&message_size=$message_size> <img src=$imagedir/header.gif border=0 alt=View> <small> <small> Header </small> </small> </a> 


 </td>
<td width=10%>
<!---- <input type=button name=delete$i value='Delete $i' onclick='javascript:deleteit($i)'>--->  
<a href=$cgi?session=$INFO{'session'}&action=delete&number=$i&message_size=$message_size> <img src=$imagedir/delete.gif border=0 alt=Delete>
<small> <small> Delete </small> </small>
 </a> 

</td>
 ";



}
print " </table>
<script language=JavaScript> <!---
function viewit(number,message_size) {
document.forms[0].action='$cgi?action=view&session=$INFO{'session'}&number='+number+'&message_size='+message_size
document.forms[0].submit()
}
function deleteit(number) {
document.forms[0].action='$cgi?session=$INFO{'session'}&action=delete&number='+number
document.forms[0].submit()
}
function delete_all(num_messages) {
if (!confirm('Are you sure you want to delete all messages')) return;
document.forms[0].action='$cgi?session=$INFO{'session'}&action=deleteall&num_messages='+num_messages
document.forms[0].submit()
}
function delete_marked() {
//alert('Feature not built-in yet '+document.form1.C1.checked);
testt = ''
for (i=1;i<=$num_messages;i++) {
var temp = eval('document.form1.C'+i+'.checked');
if (temp) {
testt += ','+i
}
}
if (testt == '') return;
testt = testt.substring(1)
document.forms[0].action='$cgi?session=$INFO{'session'}&action=deletemarked&numbers='+testt
if (confirm('Do you want to delete messages '+testt)) { document.forms[0].submit(); }
}

//---> </script>
</form>
";


}
}
else { 
    print "Content-type:text/html\n\n <h2> $mailserver is down </h2>";
    $pop->Close;
    exit();
}
$pop->Close;
}

###########################################################################
# MIME code below used from the CPAN module MIME::Base64 for handling
# MIME attachments
# The following copyright notice appears in the file Base64.pm, from which
# this code is derived:
#
# Copyright 1995-1998 Gisle Aas.
# 
# This library is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
# 
###########################################################################

sub encode_base64 ($;$)
{
    my $res = "";
    my $eol = $_[1];
    $eol = "\n" unless defined $eol;
    pos($_[0]) = 0;                          # ensure start at the beginning
    while ($_[0] =~ /(.{1,45})/gs) {
        $res .= substr(pack('u', $1), 1);
        chop($res);
    }
    $res =~ tr|` -_|AA-Za-z0-9+/|;               # `# help emacs
    # fix padding at the end
    my $padding = (3 - length($_[0]) % 3) % 3;
    $res =~ s/.{$padding}$/'=' x $padding/e if $padding;
    # break encoded string into lines of no more than 76 characters each
    if (length $eol) {
        $res =~ s/(.{1,76})/$1$eol/g;
    }
    $res;
}

sub decode_base64 ($)
{
    local($^W) = 0; # unpack("u",...) gives bogus warning in 5.00[123]

    my $str = shift;
    my $res = "";

    $str =~ tr|A-Za-z0-9+=/||cd;            # remove non-base64 chars
    $str =~ s/=+$//;                        # remove padding
    $str =~ tr|A-Za-z0-9+/| -_|;            # convert to uuencoded format
    while ($str =~ /(.{1,60})/gs) {
        my $len = chr(32 + length($1)*3/4); # compute length byte
        $res .= unpack("u", $len . $1 );    # uudecode
    }
    $res;
}

sub decode_qp ($)
{
    my $res = shift;
    $res =~ s/[ \t]+?(\r?\n)/$1/g;  # rule #3 (trailing space must be deleted)
    $res =~ s/=\r?\n//g;            # rule #5 (soft line breaks)
    $res =~ s/=([\da-fA-F]{2})/pack("C", hex($1))/ge;
    $res;
}

sub passfail {
    print "Content-type:text/html\n\n";
    print "<title> Server/Password Failure </title> <h2> Server/Password Failure </h2> 
<h5> Server's response was : $junk<br>
If Password failure 
 <a href='javascript:history.go(-1)'> Click Here </a> to go back and re-enter your username + password </h5><br>";
  
}

1;
