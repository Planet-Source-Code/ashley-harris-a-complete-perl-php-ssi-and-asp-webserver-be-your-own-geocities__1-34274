sub sendmail {
    if (!$FORM{'email'}) {
	if($FORM{'reply'}) { $FORM{'reply'} = "\n\n***Message Forwarded*****\n".$FORM{'reply'}; }
print "Content-type: text/html\n\n";
print <<EndHTML; 

<small> <small> <b> <font color=blue> Now you can also send attachments upto 1 Mbytes from Webmail </font> </b> </small> </small>
<form method=POST enctype="multipart/form-data">
<b> <font color=blue> 
If you are using Internet Explorer 5.0 or higher you can send <br>
Html or Rich Text formatted e-mail from this link <input type="submit" Value="SendIEMail" onclick="return sendIEmail()">
<!----  <a href=$cgi?session=$INFO{'session'}&action=sendIEmail> Send IE Mail </a> --->
</font> </b>
<table WIDTH="100%" >
<tr>
<td ALIGN=LEFT>Your name (Your Friendly name) :
<br><input TYPE="text" NAME="name" SIZE="40" MAXLENGTH="40">
    <p>Email To: (For multiple e-mail address seperate e-mail addresses by a Comma ",")
<br>To : <input TYPE="text" SIZE="40" NAME="email" value="$INFO{'email'}">
<br>Cc : <input TYPE="text" SIZE="40" NAME="cc" value="">
<br>Bcc: <input TYPE="text" SIZE="40" NAME="bcc" value="">
<p> Message Subject:
<br><input TYPE="text" MAXLENGTH="40" SIZE="40" NAME="subject" value="$INFO{'subject'}">
<br>Message:
<br><textarea ROWS="20" COLS="80" NAME="comment"> $FORM{'reply'}</textarea>
 <br> Attach File: (limit 1 Mbyte) <br> <input type=file name=attachment size=40>   Click here to browse
<p><input TYPE="submit" VALUE="Send it!"  onclick="return checkemail()">
<p>
<br></td>
</tr>
</table> </form>
<script language="Javascript">  <!---
    function sendIEmail() {
	mylocate = self.location.href;
	mylocate = mylocate.replace("=sendmail","=sendIEmail");
	document.forms[0].action = mylocate;
	document.forms[0].submit();
    }
    function checkemail() {
regexp = /^[^@]/
regexp2 = /^.+@.+\\..{2,3}\$/
    regsplit = /\\s|,|;|:+/g
	fld = document.forms[0].email.value.split(regsplit);
for (i=0;i<fld.length;i++) {
if(!((fld[i].search(regexp2) > -1) & (fld[i].search(regexp) > -1))) {
  alert('Email Address Error, please enter proper e-mail address with \@ domain name like user\@mydomain.com '); 
  return false }
} 
flo = document.forms[0].email.value
document.forms[0].email.value = flo.replace(regsplit,",")
return true
}
//---> </script>


EndHTML

exit();
}
else {
    $smtpserver = 'localhost';
    $domain = $hostname;
$proto = getprotobyname('tcp');
socket(SOCK, AF_INET, SOCK_STREAM, $proto);
$iaddr = gethostbyname($smtpserver);
$port = getservbyname('smtp', 'tcp');
$sin = sockaddr_in($port, $iaddr);
connect(SOCK, $sin);
    $FORM{'email'} =~ s/,+/,/g;
@to = split (/,|\s/, $FORM{'email'});
@cc = split (/,|\s/, $FORM{'cc'});
@bcc = split (/,|\s/, $FORM{'bcc'});
#$date = strftime("%a, %d %b %Y %T %z (%Z)", localtime);
    $date = `date`;
    chomp($date);
    $date =~ s/\s/\-/g;
###########################################################################
# Send message
###########################################################################
$bad = "No";
send SOCK, "HELO $domain\r\n", 0;
recv SOCK, $junk, 512, 0;
if ($junk =~ /^5/) {
 $bad = "Yes";
}
send SOCK, "MAIL From:<$FORM{'USERNAME'}\@$domain>\r\n", 0;
recv SOCK, $junk, 512, 0;
if ($junk =~ /^5/) {
 $bad = "Yes";
}
foreach $line (@to) {
 send SOCK, "RCPT To:<$line>\r\n", 0;
}
foreach $line (@cc) {
 send SOCK, "RCPT To:<$line>\r\n", 0;
}
foreach $line (@bcc) {
 send SOCK, "RCPT To:<$line>\r\n", 0;
}
recv SOCK, $junk, 512, 0;
if ($junk =~ /^5/) {
 $bad = "Yes";
}
send SOCK, "DATA\r\n", 0;
recv SOCK, $junk, 512, 0;
if ($junk =~ /^5/) {
 $bad = "Yes";
}
send SOCK, "From: $FORM{'name'}<$FORM{'USERNAME'}\@$domain \r\n",0;
send SOCK, "To: $FORM{'email'} \r\n", 0;
if ($#cc gt '0') {
 send SOCK, "Cc: @cc\r\n", 0;
}
 send SOCK, "Subject: $FORM{'subject'}\r\n", 0;
 send SOCK, "X-Mailer: Vijays E-mail version 1.7\r\n", 0;
send SOCK, "Date: $date\r\n", 0;
    $FORM{'comment'} .= "\r\n from \n Remote IP address: $ENV{'REMOTE_ADDR'}\n";
if ($attachment) {
 $boundary = "-VIJAYS-ATTACH-BOUNDARY-" . time . "---";
 send SOCK, "MIME-Version: 1.0\r\n", 0;
 send SOCK, "Content-Type: multipart/mixed; ", 0;
 send SOCK, "boundary=\"$boundary\"\r\n", 0;
 send SOCK, "\r\n--$boundary\r\n", 0;
 send SOCK, "Content-type: text/plain\r\n\r\n", 0;
 send SOCK, "$FORM{'comment'}\r\n", 0;
 send SOCK, "\r\n--$boundary\r\n", 0;
 $attachment =~ s!^.*(\\|\/)!!;
 send SOCK, "Content-Type: $type; name=\"$attachment\"\r\n", 0;
 send SOCK, "Content-Transfer-Encoding: BASE64\r\n", 0;
 send SOCK, "Content-Description:\r\n\r\n", 0;
 send SOCK, encode_base64($data), 0;
 send SOCK, "--$boundary--", 0;
 send SOCK, "\r\n.\r\n", 0;
} else {
 send SOCK, "\r\n$FORM{'comment'}\r\n.\r\n", 0;
}
recv SOCK, $junk, 512, 0;
if ($junk =~ /^5/) {
 $bad = "Yes";
}
send SOCK, "QUIT\r\n", 0;
recv SOCK, $junk, 512, 0;
if ($junk =~ /^5/) {
 $bad = "Yes";
}
close SOCK;
    if ($bad ne "Yes") {
    $FORM{'comment'} =~ s/\n/<br>/g;
print "Content-type: text/html\n\n";
print "<html> <head> <title> E-mail Sent </title> </head> </body>
<h2> Mail sent okay </h2> <table width=400><tr> <td> To: $FORM{'email'} <br> Subject:$FORM{'subject'} <br> Message: <br> $FORM{'comment'} </td> </tr></table> ";
    if ($attachment) {	print "Attachment sent was<font color=blue>  $attachment </font> </body> </html>"; }
exit();
} 
    else {
	print "Content-type: text/html\n\n <h2> E-mail Server gave a strane response $junk <br> E-mail NOT SENT</h2>"; exit();
    }
}
}
$ree="bee";

