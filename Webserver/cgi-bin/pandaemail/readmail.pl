$bogus = "ree";
sub read {
    use MIME::Base64;
    $mailserver='list.omf.net';
    $attachment = $INFO{'attachment'};
    if ($attachment eq "") { $attachment = "NONE"; }
###########################################################################
# Open the socket to the POP server
###########################################################################
 $popu = new Mail::POP3Client($FORM{'USERNAME'}, $FORM{'POPPASSWORD'}, $mailserver);
 $junk = $popu->Message;


###########################################################################
# Just read a message
###########################################################################
 if($attachment eq "NONE"){
#  &print_header;
    print "Content-type:text/html\n\n <HTML> <HEAD> <TITLE> OMF Intl Web E-mail Service </Title> </head> <body> <center>
<IMG SRC=$imagedir/pandalogo.gif ALT='OMF International E-mail Service Logo' BORDER=0></CENTER><HR>

";

 }

###########################################################################
# Get the size of the message
###########################################################################
      $temp = $popu->List($INFO{'number'});
      ($junk, $message_size) = split (/\s/, $temp, 2);
    $message_size = $message_size/1000;

###########################################################################
# It takes some trickery to read the socket right
###########################################################################
  $mess = "";
     $body = $popu->Body($INFO{'number'});
#     $mess=$popu->HeadAndBody($INFO{'number'});
     $mess = $body;
     $header=$popu->Head($INFO{'number'});


###########################################################################
# Clean up the message a bit (remove "+OK" response at beginning and
# "." at end)
###########################################################################

$body =~ s/This is a multi-part message in MIME format\.\r\n/Content is MIME\/HTML See attachment below to open/gi;

###########################################################################
# Some attachment handling
###########################################################################
 $boundary = "THERE_IS_NO_BOUNDARY_SO_NO_ATTACHMENTS";
 $thisisaboundary = 0;
 @lines = split(/\n/, $header);
 foreach $line (@lines){
  if($line =~ /^Content-Type: MULTIPART.*BOUNDARY/i){
   ($junk, $boundary) = split(/BOUNDARY\=/i, $line, 2);
   $thisisaboundary = 0;
   goto MOVEON;
  } elsif($thisisaboundary == 1) { 
   ($junk, $boundary) = split(/BOUNDARY\=/i, $line, 2);
   $thisisaboundary = 0;
   goto MOVEON;
  } elsif($line =~ /^Content-Type: MULTIPART.*/i){
   $thisisaboundary = 1;
  }
 }
MOVEON: $boundary =~ s/\"//g;
  if($boundary ne "THERE_IS_NO_BOUNDARY_SO_NO_ATTACHMENTS"){
      if ($boundary =~ /\+/) {
	  $boundary =~ s/\+/plus/g;
	  $body =~ s/\+/plus/g;
      }
  ($body, @attach) = split(/\-\-$boundary/, $body);
 }
 if ($attach[0] =~ /boundary\=/i) {
     $body .= $attach[0];
     $attach[0] = ""; 
 }
if ($amessage =~ /\d/) {
    $body = $attach[$amessage];
 ($header, $body) = split(/\r\n\r\n/, $mess, 2);
}

###########################################################################
# Play nicely with HTML
###########################################################################
 $mess =~ s/\&/\&amp\;/g;
 $mess =~ s/\"/\&quot\;/g;
 $mess =~ s/</\&lt\;/g;
 $mess =~ s/>/\&gt\;/g;
###########################################################################
# We want this for later
###########################################################################
#    $reply = $mess;
###########################################################################
# Split out the header for displaying short/full header info
###########################################################################
 if ($header =~ /Content-Transfer-Encoding:.*quoted-printable/i) {
     $body = decode_qp($body);
 }
 if ($header =~ /Content-Transfer-Encoding:.*base64/i) {
     $body = decode_base64($body);
 }
 if ($body =~ /boundary\=/i) {
# Here you go crazy outlook e-mail
     @lines = split(/\n/,$body);
     @jlines = grep(/boundary\=/i,@lines);
     ($junk,$jboundary) = split(/boundary\=/i,$jlines[0],2);
	 $jboundary =~ s/"|\&quot\;//g;
($jheader, $jbody) = split(/\r\n\r\n/,$body,2);
($junk,@jattach) = split(/$jboundary/, $jbody);
push(@attach,@jattach);
$body = "<small> <b> This message is outlook formated MIME  mail if 
you cannot see the message below 
try opening the attachments shown </b> </small> <br>";
if ($jattach[0] =~ /Content-Transfer-Encoding: quoted-printable|Content-Transfer-Encoding: 7/i)
{
    $body .= decode_qp($jattach[0]);
}
else { $body .= " Cannot read e-mail in plain/text format"; }
 }

 if (!$headopt) { $headopt = 'short'; }
 if($headopt eq "short") {
  @headlines = split(/\n/, $header);
  foreach $line (@headlines){
   if($line =~ /^From/i){
    $from = "$line\n";
   } elsif ($line =~ /^To/i) {
    $to = "$line\n";
   } elsif ($line =~ /^CC/i) {
    $cc = "$line\n";
   } elsif ($line =~ /^Subject/i) {
    $subject = "$line\n";
   } elsif ($line =~ /^Date/i) {
    $date = "$line\n";
   }  elsif ($line =~ /^Return-Path:|Reply-to:/i) {
    $replyto = "$line\n";
   }
  }
$header_show = $from . $to . $cc . $date . $subject;
 }
$header_show =~ s/<|>//g;
$header_show_reply = $header_show;
$header_show =~ s/([\w|\d|_|\-|\/|\.]*\@[\w|\d|_|\-\.]*)/<A HREF\=\"$reply_pl&session=$INFO{'session'}&email=$1&subject=$subject\">$1<\/A>/g;
$header_show = "<PRE> $header_show </PRE>";
 $mess = "\n\n" . $body;
$replyto =~ s/.*\://g;
$replyto =~ s/\s|<|>//g;

###########################################################################
# Make URL's into hyperlinks
###########################################################################
 $mess =~ s/(http:[\w|\d|_|\-|\/|\.]*)/<A HREF\=\"$1\">$1<\/A>/g;
 $mess =~ s/(ftp:[\w|\d|_|\-|\/|\.]*)/<A HREF\=\"$1\">$1<\/A>/g;
 $mess =~ s/(news:[\w|\d|_|\-|\/|\.]*)/<A HREF\=\"$1\">$1<\/A>/g;
 $mess =~ s/(telnet:[\w|\d|_|\-|\/|\.]*)/<A HREF\=\"$1\">$1<\/A>/g;
 $mess =~ s/([\w|\d|_|\-|\/|\.]*\@[\w|\d|_|\-\.]*)/<A HREF\=\"$reply_pl&session=$INFO{'session'}&email=$1&subject=$subject\">$1<\/A>/g;
 $mess =~ s/\n(From:.*)\n/$1/ig;
 $mess =~ s/\n(Subject:.*)\n/$1/ig;

###########################################################################
# Print the message
###########################################################################
 if($attachment eq "NONE"){
$display_body =  "<PRE> $mess </PRE> <!---- VIJAYS PRE COMMENTED SERVICE --->";
$display_attach = "";
  for($i = 0; $i < @attach; $i++){
   $stuff = $attach[$i];
   $stuff =~ s/^\n*//g;
   ($header, $temp) = split(/\r\n\r\n/, $stuff, 2);
   if($header =~ /BASE64/i) {
       $filename = "Attachment Possible-HTML or Rich-text data";
    @head = split(/\n/, $header);
    foreach (@head){
     if ($_ =~ /name/) {
      $filename = $_;
      ($junk, $filename) = split(/=/, $filename);
      $filename =~ s/\"//g;
     }
 }
       $display_attach .= "<a href=$cgi?session=$INFO{'session'}&action=read&number=$INFO{'number'}&attachment=$i>  <img src=$imagedir/pin.gif border=0 alt=Download_Attachment> $filename </a> <br>";
       $display_attach_reply .= $filename."\n";
   } else {
if ($header=~ /Content-transfer-encoding\: quoted-printable/i) {
    $temp = decode_qp($temp);
}
if ($temp ne "") {    $display_body= "<PRE>$temp</PRE>"; }
   }
}
chop($boundary);
chop($jboundary);
$display_body =~ s/--$jboundary--//g;
$display_body =~ s/--$boundary--//g;
if ($display_attach ne "") {
    $display_attach = "<b> <small> <small> Attachments for this message: <br>  $display_attach </small> </small> </b> ";
    $display_attach_reply = "Other Attachments not included are: \n $display_attach_reply"; }
$reply = "$header_show_reply $display_body \n $display_attach_reply";
$reply =~ s/<.*>//g;
    $reply =~ s/\"|\'//g;
  $display_head =  "<TABLE border=0> <TR> <tr> <td>
<form method=post action=$reply_pl&session=$INFO{'session'}> <input type=image src=$imagedir/compose.gif> </form> </td><td>
  <form method=POST name=replyforward action=$reply_pl&session=$INFO{'session'}&email=$replyto&subject=Re:$subject> <input type=hidden name=reply value=\"$reply\"> 
<input type=image src=$imagedir/reply.gif> 
<input type=image src=$imagedir/forward.gif onclick=\"document.replyforward.action=document.replyforward.action.replace('email=','dummy=')\"></form> </td> 
<td>
<form method=POST action=$cgi?action=delete&number=$INFO{'number'}&message_size=$message_size&session=$INFO{'session'}> <input type=image src=$imagedir/delete.gif alt=Delete> </form> </td> 
<td>
<form action=$cgi?session=$INFO{'session'}&action=read&number=$INFO{'number'}&message_size=$INFO{'message_size'} method=POST> <input type=image src=$imagedir/print.gif onclick=window.print()> </form> </td> <td>
  <form method=POST action=$cgimail?session=$INFO{'session'}&action=logout> 
<input type=image src=$imagedir/Logout.gif alt=Logout>  </form> </td> 
</TR> </TABLE>\n $display_attach <br> $header_show <HR>";
  print " $display_head $display_body $display_attach </body> </html>"; 
 } else {
  $stuff = $attach[$attachment];
  $stuff =~ s/^\n*//g;
  ($header, $temp) = split(/\r\n\r\n/, $stuff, 2);
  @header = split(/\n/, $header);
  for ($i = 0; $i <= $#header; $i++){
      if ($header[$i] =~ /name =|name=/i) { $filename= $header[$i]; }
   if (!($header[$i] =~ /:/)) {
    $header[$i - 1] =~ s/\r//g;
    $header[$i - 1] .= $header[$i];
    $header[$i] = '';
   }
  }
$filename =~ s/name|=|\s|\"|filename//g;
  $header = join("\n", @header);
  $header =~ s/\n\n//g;
  if($header =~ /BASE64/i){
      chop($boundary);
      chop($jboundary);
   $temp =~ s/\-\-$boundary\-\-//g;
   $temp =~ s/\-\-$jboundary\-\-//g;
      $header =~ s/\n$//;
$temp= decode_base64($temp);
      if ($header =~ /Content-type: text\//i) {
	  print "Content-type:text/html\r\n\r\n<PRE>$temp</PRE>";
      }
      elsif($header =~ /Content-disposition/) {
   print "$header\r\n\r\n";
      print "$temp";
      }
      else { 	      
$slen = length($temp);
print "Content-type: application/force-download; 
Content-length: $slen;
Content-disposition: attachment; filename=\"$filename\";

$temp";
	      }
  } elsif ($header =~ /quoted-printable/i){
      chop($boundary);
      chop($jboundary);
   $disp = decode_qp($temp);
   $disp =~ s/\-\-$boundary\-\-//g;
   $disp =~ s/\-\-$jboundary\-\-//g;
      $header =~ s/\&amp\;/\&/g;
      $header =~ s/\&lt\;/</g;
      $header =~ s/\&quot\;/\"/g;
      $header =~ s/\&gt\;/>/g;
      $header =~ s/quoted-printable/text\/html/gi;
      print "Content-type:text/html\r\n\r\n";
      $disp =~ s/\&amp\;/\&/g;
      $disp =~ s/\&lt\;/</g;
      $disp =~ s/\&quot\;/\"/g;
      $disp =~ s/\&gt\;/>/g;
      print "<PRE> $disp </PRE>";
  } else {
   print $stuff;
  }
  $ftr = "no";
 }

###########################################################################
# Get just addresses
###########################################################################
 
###########################################################################
# Close the socket
###########################################################################
if ($folder eq 'POP'){
$popu->Close;
}

###########################################################################
# Done
###########################################################################
}





