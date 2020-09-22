sub sendIEmail {
    use Socket;
    if (!$FORM{'email'} || $FORM{'comment'}) {
	if($FORM{'comment'}) { $FORM{'reply'} = "<br> $FORM{'comment'}"; }
print "Content-type: text/html\n\n";
if (!($ENV{'HTTP_USER_AGENT'} =~ /MSIE/)) {
    print "<h2> Sorry only for IE users this will work </h2>";
    exit();
}
	$FORM{'reply'} =~ s/\n|\r/<br>/gi;
print <<EndHTML;
<body onload="javascript:EditTextbox.document.body.innerHTML=unescape('%3Ch1%3EFormatted Text is entered here%3C%2Fh1%3E%0D%0A%0D%0AHere you can italize bold  underline and play with text %2C  %2E Or use Just plain old simple text %2E%0D%0A $FORM{'reply'}')">
<form method=POST name=form1 onsubmit="return checkemail()" enctype="multipart/form-data">
<small> <small> <b> <font color=blue> Now you can also send attachments upto 1 Mbytes from Webmail </font> </b> </small> </small>
<table WIDTH="100%" >
<tr>
<td ALIGN=LEFT>Your name (Friendly name) :
<br><input TYPE="text" NAME="name" SIZE="40" MAXLENGTH="30">
    <p>Email To: (For multiple e-mail address seperate e-mail addresses by a Comma ",")
<br>To : <input TYPE="text" SIZE="40" NAME="email" value="$INFO{'email'}">
<br>Cc : <input TYPE="text" SIZE="40" NAME="cc" value="">
<br>Bcc: <input TYPE="text" SIZE="40" NAME="bcc" value="">
<p> Message Subject:
<br><input TYPE="text" MAXLENGTH="40" SIZE="40" NAME="subject">
<br>Message:
<br>

<table BORDER="0" CELLPADDING="4">

<tr VALIGN="TOP">
		<td BGCOLOR="yellow">
			
			<a href="javascript:alert('okay')"><img src=$imagedir/bold.jpg height=20 width=20></a> 
			<a href="javascript:Underline()"> <img src=$imagedir/underline.jpg height=20 width=20></a> 
			<A href="javascript:makeItalic()"> <img src=$imagedirx/italic.jpg height=20 width=20></a>
			<input type=button value="Send It" name=send onclick=submitter()>
</font>
			<br>
			
			<iframe WIDTH="500" HEIGHT="400" ID="EditTextbox"></iframe>
		</td>
<input type=hidden name=commenthtml value=""> </tr> <tr> <td> 
 <br> Attach File: (limit 1 Mbyte) <br> <input type=file name=attachment size=40>   Click here to browse
</td> </tr> </form>
</table>


<script language="Javascript"> <!---
//-- Putting browser info into global variables in the head of a page
//-- gives access to those variables to all scripts within the page.
var browserName = navigator.appName
var browserVersion = navigator.appVersion
var browserVersionNum = parseFloat(browserVersion)
var codeName=navigator.appCodeName
var userAgent=navigator.userAgent
  function makeBold() {
    var tr = frames.EditTextbox.document.selection.createRange()
    tr.execCommand("Bold")
    tr.select()
    frames.EditTextbox.focus()
  }
  function makeItalic() {
    var tr = frames.EditTextbox.document.selection.createRange()
    tr.execCommand("Italic")
    tr.select()
    frames.EditTextbox.focus()
  }
  function Underline() {
    var tr = frames.EditTextbox.document.selection.createRange()
    tr.execCommand("Underline")
    tr.select()
    frames.EditTextbox.focus()
  }
  function StrikeThrough() {
    var tr = frames.EditTextbox.document.selection.createRange()
    tr.execCommand("StrikeThrough")
    tr.select()
    frames.EditTextbox.focus()
  }
  function SuperScript() {
    var tr = frames.EditTextbox.document.selection.createRange()
    tr.execCommand("SuperScript")
    tr.select()
    frames.EditTextbox.focus()
  }
  function SubScript() {
    var tr = frames.EditTextbox.document.selection.createRange()
    tr.execCommand("SubScript")
    tr.select()
    frames.EditTextbox.focus()
  }
   function InsertOrderedList() {
    var tr = frames.EditTextbox.document.selection.createRange()
    tr.execCommand("InsertOrderedList")
    tr.select()
    frames.EditTextbox.focus()
  }
   function InsertUnOrderedList() {
    var tr = frames.EditTextbox.document.selection.createRange()
    tr.execCommand("InsertUnOrderedList")
    tr.select()
    frames.EditTextbox.focus()
  }
  function Outdent() {
    var tr = frames.EditTextbox.document.selection.createRange()
    tr.execCommand("Outdent")
    tr.select()
    frames.EditTextbox.focus()
  }
   function Indent() {
    var tr = frames.EditTextbox.document.selection.createRange()
    tr.execCommand("Indent")
    tr.select()
    frames.EditTextbox.focus()
  }
   function JustifyLeft() {
    var tr = frames.EditTextbox.document.selection.createRange()
    tr.execCommand("JustifyLeft")
    tr.select()
    frames.EditTextbox.focus()
  }
  function JustifyCenter() {
    var tr = frames.EditTextbox.document.selection.createRange()
    tr.execCommand("JustifyCenter")
    tr.select()
    frames.EditTextbox.focus()
  }
  function JustifyRight() {
    var tr = frames.EditTextbox.document.selection.createRange()
    tr.execCommand("JustifyRight")
    tr.select()
    frames.EditTextbox.focus()
  }
   function Cut() {
    var tr = frames.EditTextbox.document.selection.createRange()
    tr.execCommand("Cut")
    tr.select()
    frames.EditTextbox.focus()
  }
   function Copy() {
    var tr = frames.EditTextbox.document.selection.createRange()
    tr.execCommand("Copy")
    tr.select()
    frames.EditTextbox.focus()
  }
  function Paste() {
    var tr = frames.EditTextbox.document.selection.createRange()
    tr.execCommand("Paste")
    tr.select()
    frames.EditTextbox.focus()
  }

  function submitter() {

	document.form1.commenthtml.value = EditTextbox.document.body.innerHTML
//	alert(document.form1.commenthtml.value);
	checkmeout = checkemail();
	if (checkmeout) { 
    document.form1.submit()
    }
  }
  frames.EditTextbox.document.designMode = "On"
//EditTextbox.document.designMode = "0n"
//---> </script>


<br></td>
</tr>
</table> </form>
<script language="Javascript">  <!---
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
    chomp($date);
    $date =~ s/\s/\-/g;
    send SOCK, "Subject: $FORM{'subject'}\r\n",0;
    $FORM{'commenthtml'} .= "\r\n Sent from \n Remote IP address: $ENV{'REMOTE_ADDR'}\n";
    $messaget = $FORM{'commenthtml'};
    $messaget =~ s/\n/<br>/g;
 $boundary = "-VIJAYS-ATTACH-BOUNDARY-$date---";
 send SOCK, "MIME-Version: 1.0\r\n", 0;
 send SOCK, "Content-Type: multipart/mixed; ", 0;
 send SOCK, "boundary=\"$boundary\"\r\n", 0;
 send SOCK, "\r\n--$boundary\r\n", 0;
 send SOCK, "Content-type: text/html\r\n\r\n", 0;
 send SOCK, "$messaget\r\n",0;
if ($attachment) {
 $type = $query->uploadInfo($attachment)->{"Content-Type"};
 send SOCK, "\r\n--$boundary\r\n", 0;
 $attachment =~ s!^.*(\\|\/)!!;
 send SOCK, "Content-Type: $type; name=\"$attachment\"\r\n", 0;
 send SOCK, "Content-Transfer-Encoding: BASE64\r\n", 0;
 send SOCK, "Content-Description:\r\n\r\n", 0;
 send SOCK, encode_base64($data), 0;
 send SOCK, "--$boundary--", 0;
 send SOCK, "\r\n.\r\n", 0;
} else {
 send SOCK, "\r\n--$boundary\r\n", 0;    
 send SOCK, ".\r\n", 0;
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
print "Content-type: text/html\n\n";
print "<html> <head> <title> E-mail Sent </title> </head> </body>
<h2> Mail sent okay </h2> <table width=400><tr> <td> To: $FORM{'email'} <br> Subject:$FORM{'subject'} <br> Message: <br> $FORM{'commenthtml'} </td> </tr></table> ";
    if ($attachment) {	print "Attachment sent was<font color=blue>  $attachment </font> </body> </html>"; }
exit();
}
    else {
	print "Content-type: text/html\n\n <h2> Server gave a strange response $junk<br> E-mail NOT SENT </h2>"; exit();
    }
}
}
$ree="bee";

