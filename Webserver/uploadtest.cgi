#! /usr/bin/perl

require "cgi-lib.pl";

print "Content-Type: text/html\n\n<HTML><BODY>";

if (ReadParse(*in))
{
 print "File uploaded!<P>\n";
}
print "<form enctype=\"multipart/form-data\" method=post action=\"uploadtest.cgi\"><INPUT type=file name=fn><INPUT type=submit></FORM></BODY></HTML>";

