$re = "beee";
sub deletemarked {
    print "Content-type:text/html\n\n";
    if (!$FORM{'Confirm'}) {
print "<form method=POST> 
<h4> Please confirm Deletion of message $INFO{'number'}<br>
This message(s) will be permenantly deleted from your mailbox <br>
No way to recover this message, Click on Confirmed delete to <br>
proceed </h4>
<input type=submit name=Confirm value='Confirmed Delete'> <input type=button name=Cancel  value=Cancel onclick=javascript:history.go(-1)> ";
exit();

    }

    print "<h5>Deleting Message Number $INFO{'numbers'}</h5>";
$pop = new Mail::POP3Client($FORM{'USERNAME'}, $FORM{'POPPASSWORD'}, $mailserver);
$junk = $pop->Message;
    if (! $junk =~ /\+OK/i) {
	print "<h3> Sorry your mailbox is busy </h3>";
	$pop->Close;
    }
    $temp = "";
    $tempm = "";
    @numbers = split(/,/,$INFO{'numbers'});
    foreach $number(@numbers) {
     $temp = $pop->Delete($number);
    if ($temp =~ /1/) {
	$tempm .= "Message Number $number deleted successfully <br>";
}
     else {  $tempm .= "Message Number $number Not existent so no deleted <br> "; }

 }
    $pop->Close;
    print "<title> Deleting Message </title> <h2> Deleting Message Number $INFO{'numbers'}";
    print "$tempm <br> ";
require "delete_footer.pl";
}



