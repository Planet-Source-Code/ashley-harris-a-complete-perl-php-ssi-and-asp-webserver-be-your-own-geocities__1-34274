$re = "beee";
sub view {
$pop = new Mail::POP3Client($FORM{'USERNAME'}, $FORM{'POPPASSWORD'}, $mailserver);
    $junk = $pop->Message;
    if (~ $junk =~ /\+OK/i) {
	print "<h3> Sorry your mailbox is busy </h3>";
	$pop->Close;
	exit();
    }
    $temp = $pop->Head($INFO{'number'});
    $pop->Close;
    print "Content-type:text/html\n\n";
    print "<h5>View Your messages header info for message number $INFO{'number'}</h5>";
    $temp =~ s/</&lt;/g;
    $temp =~ s/>/&gt;/g;
    $temp =~ s/\r\n/<br>\r\n/g;
    @temp1 = split(/\n/,$temp);
    @from = grep(/^From:/i,@temp1);
    @date = grep(/^Date:/i,@temp1);
    @subject = grep(/^Subject:/i,@temp1);
    print "<h2> Here is your message header info </h2> <b> @from <br> Sent on @date<br>";
    print "@subject <br> Message size = $INFO{'message_size'} Kilobytes</b> <br> <br> <i>Whole Message Header is: </i> <br> $temp <br> <a href='javascript:history.go(-1)'> Go back to previous screen </a> ";
require "delete_footer.pl";
}




