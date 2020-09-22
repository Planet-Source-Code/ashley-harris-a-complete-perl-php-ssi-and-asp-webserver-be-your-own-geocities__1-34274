#! /usr/bin/perl

require "cookie-lib.pl";

&get_cookie();

if (length($cookie{name})>0)
{
 print "Content-Type: text/html\n\n<HTML><HEAD><META http-equiv=refresh content=15></HEAD><BODY>Your name is <B>$cookie{name}</B></BODY></HTML>";
 exit;
}
if (length($ENV{QUERY_STRING})>0)
{
 $ENV{QUERY_STRING} =~ m/name\=(.*)/;
 $cookie{name} = $1;
 &set_cookie(time()+300,"127.0.0.1","/",0);
 &set_cookie(time()+300,"localhost","/",0);
 &set_cookie(time()+300,$ENV{SERVER_ADDR},"/",0);
 print "Content-Type: text/html\n\n<HTML><HEAD><META http-equiv=refresh content=\"5; url=/theoven.cgi\"></HEAD><BODY>Cookie has been set! (Valid for 5 minutes)</BODY></HTML>";
 exit;
}
print "Content-Type: text/html\n\n<HTML><HEAD><META http-equiv=refresh content=15></HEAD><BODY>Enter your name<FORM action='theoven.cgi' method=GET><INPUT name=name><INPUT type=submit></FORM><P><B>NOTE!</B> cookies are set for localIP and 127.0.0.1 (CAN'T BE SET FOR LOCALHOST), If the url says something that isn't an IP address, this wont work.</BODY></HTML>";

