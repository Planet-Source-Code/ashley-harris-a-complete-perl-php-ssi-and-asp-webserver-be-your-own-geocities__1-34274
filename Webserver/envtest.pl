#! /usr/bin/perl

print "Content-Type: text/html\n\n<HTML><BODY>";

for $a (sort(keys(%ENV)))
{
 print "<B>$a</B>: " . $ENV{$a} . "<BR>\n";
}
print "</BODY></HTML>";
