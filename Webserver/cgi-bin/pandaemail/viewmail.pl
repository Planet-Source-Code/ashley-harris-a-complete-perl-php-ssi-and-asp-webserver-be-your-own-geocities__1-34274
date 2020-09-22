#!/usr/bin/perl
use Socket;
use CGI::Carp qw(fatalsToBrowser);
use Mail::POP3Client;
require "subs.pl";
$cgi='/cgi-bin/pandaemail/viewmail.pl';
$cgimail=$cgi;
$basedir = "./session";
$reply_pl = "$cgimail?action=sendmail";
$imagedir = "/pandaimages";
# This will help delete all session files  older than an hour
$progdelete = "/usr/sbin/tmpwatch 1 "; 
# This will be overridded if a mailserver is submitted by client
$mailserver = 'mail.yahoo.com'; 
# Maximum size of attachment 
$maxsize = "100000"; # 100 K
# If you dont want check-ip feature of this program change this to no
$checkip = "yes"; 


######################################################################
###############TRY NOT TO MONKEY WITH THESE SETTINGS##################
######################################################################

&readform;

if (!$FORM{'POPPASSWORD'}) {
    &Initialize;
    exit();
}
# This sub routine gets rid of unnecessary session files for those 
# who forgot to login change $progdelete = /usr/sbin/tmpreaper for 
# debian Linux or appropriate for other Linux/Unix Distrib
if (-x ($progdelete)) { system("$progdelete ./session"); }

if ($action eq "read") { require "readmail.pl"; &read; exit(); }
if ($action eq "delete") { require "delete.pl"; &delete; exit(); }
if ($action eq "deletemarked") { require "deletemarked.pl"; &deletemarked; exit(); }
if ($action eq "view") { require "view.pl"; &view; exit(); }
if ($action eq "deleteall") { require "deleteall.pl"; &deleteall; exit(); }
if ($action eq "sendmail") { require "sendmail.pl"; &sendmail; exit(); }
if ($action eq "sendIEmail") { require "sendIEmail.pl"; &sendIEmail; exit(); }
if ($action eq "logout") {
    system("rm -f $basedir/$INFO{'session'}");
    print "Content-type: text/html\n\n <center> <img src=$imagedir/pandalogo.gif> </center> <h2> Thank You You have been logged out</h2>
<small> <small> <b>
Programmed and developed by vijay <a href=http://www.ericavijay.net> www.ericavijay.net </a>
</b> </small> </small>
";
    exit();
}

