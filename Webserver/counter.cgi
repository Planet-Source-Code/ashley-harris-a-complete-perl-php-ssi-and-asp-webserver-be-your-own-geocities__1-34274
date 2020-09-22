#! /usr/bin/perl

open COUNT,"count.txt";
$cnt = <COUNT>;
close COUNT;

$cnt++;

print "content-type: text/html\n\ndocument.write(\"$cnt\");";

open COUNT,">count.txt";
print COUNT "$cnt";
close COUNT;

