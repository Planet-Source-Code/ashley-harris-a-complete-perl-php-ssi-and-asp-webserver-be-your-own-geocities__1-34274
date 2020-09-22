#1 /usr/bin/perl

require "cgi-lib.pl";
require "cookie-lib.pl";
&get_cookie;

print "Content-type: text/html\n\n";

if (ReadParse(*in))
{
 print "<html><BODY>$in{txt}</BODY></HTML>";
}
else
{
 print "<HTML><BODY><FORM action=\"posttest.cgi\" method=POST><TEXTAREA name=txt cols=50 rows=7>$cookie{name}</TEXTAREA><INPUT type=submit></FORM></BODY></HTML>";
}
