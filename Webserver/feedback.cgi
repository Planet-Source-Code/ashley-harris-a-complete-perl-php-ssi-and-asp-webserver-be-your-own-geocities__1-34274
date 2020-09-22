#! /usr/bin/perl

require "cgi-lib.pl";

if (ReadParse(*in))
{
 print "Content-type: text/html\n\n";
 print "<HTML><BODY>If the webserver is online, then this message has been sent!</BODY></HTML>";

 open  MAIL, '>C:\\sendmail'; #Observe new sendmail path!
 #Correct, it should be '| /usr/lib/sendmail -t -oi' but, windows doesn't like that pathname
 #everything else is as per linux.
 #I hear you yell "but C:\sendmail doesn't exist!" don't worry, just use it!
 print MAIL "To: $in{to}\nFrom: $in{from}\nSubject: Feedback on Ashleys Webserver\n\n$in{comments}\n";
 close MAIL;

 exit;
}
print "Content-type: text/html\n\n";
print "<HTML><HEAD><TITLE>Send Feedback!</TITLE></HEAD><BODY>";
print "<FORM action=\"feedback.cgi\" method=POST>";
print "<CENTER><TABLE cols=2>";
print "<tr><td align=right><b>To:</b></td><td><Input name=to value=\"ashley___harris\@hotmail.com\" size=40></td></tr>";
print "<tr><td align=right><b>From:</b></td><td><Input name=from size=40></td></tr>";
print "<tr><td align=right><b>Subject:</b></td><td><Input name=subject value=\"Feedback RE your webserver\" size=40></td></tr>";
print "</table>";
print "<TEXTAREA cols=40 rows=6 name=comments>I think your webserver is...</TEXTAREA>";
print "<P><INPUT type=submit value=\"SEND!\"></CENTER>";
print "</FORM>";
print "<P>This demonstrates how MY version of sendmail works, I designed it specificly so that only minimal modification of your cgi scripts is nescicary (You currently need to change 1 line)";
print "<P><B>NOTE</B> This will only work if this computer (webserver) is connected to the internet.";
print "</BODY></HTML>";

