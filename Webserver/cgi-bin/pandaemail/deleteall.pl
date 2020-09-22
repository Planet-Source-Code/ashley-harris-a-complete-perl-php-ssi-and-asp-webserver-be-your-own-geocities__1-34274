$re = "beee";
sub deleteall {
    print "Content-type:text/html\n\n";
    if (!$FORM{'Confirm'}) {
print "<form method=POST> 
<h4> Please confirm Deletion of ALL your messages<br>
This message(s) will be permenantly deleted from your mailbox <br>
No way to recover this message, Click on Confirmed delete to <br>
proceed </h4>
<input type=submit name=Confirm value='Confirmed Delete'> <input type=button name=Cancel  value=Cancel onclick=javascript:history.go(-1)> ";
exit();

    }

    print "<h5>Deleting ALL YOUR MESSAGES</h5>";
$pop = new Mail::POP3Client($FORM{'USERNAME'}, $FORM{'POPPASSWORD'}, $mailserver);
$junk = $pop->Message;
    if (! $junk =~ /\+OK/i) {
	print "<h3> Sorry your mailbox is busy </h3>";
	$pop->Close;
    }
    $temp = "";
    $tempm = "";
    $number = 1;
    $num_messages = $pop->Count;
    while ($number <= $num_messages) {
     $temp = $pop->Delete($number);
    if ($temp =~ /1/) {
	$tempm .= "Message Number $number deleted successfully <br>";
}
     else {  $tempm .= "Message Number $number Not existent so no deleted <br> "; }
     $number++;
 }
    $pop->Close;
    print "<title> Deleting Message </title> <h2> Deleting All your Messages See Log below <br>";
    print "$tempm <br> ";
    print " </h2>";
require "delete_footer.pl";
}



