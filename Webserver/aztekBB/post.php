<?php
include("./conf/board.conf.php");
include("./conf/theme.conf.php");

if($post=="1") {
 $fh=fopen("$boardMsgUrl/list.txt","r");
 $fc=fread($fh,filesize("$boardMsgUrl/list.txt"));
 fclose($fh);
 $fh=fopen("$boardMsgUrl/list.txt","w");
 $fw=stripslashes(chop($subj)) . "<[{:|:}]>" . stripslashes(chop($name)) . "<[{:|:}]>" . stripslashes(chop($email)) . "<[{:|:}]>" . stripslashes(chop($time)) . "<[{:|:}]>" . stripslashes(chop($date)) . "<[{:|:}]>" . stripslashes(chop($num)) . "\r\n$fc";
 fwrite($fh,$fw);
 fclose($fh);
 $fh=fopen("$boardMsgUrl/$num.abm","w");
 $msg=nl2br($msg);
 $fw=stripslashes($msg);
 fwrite($fh,$fw);
 fclose($fh);
 ?>
<html>
<head>
	<title>Post Successfully Added</title>
    <meta http-equiv="refresh" content="0;url=<?php echo "$boardBaseUrl/" ?>">
</head>
<body>
Post Successfully Added<br>
If you are not redirected go to <a href="<?php echo "$boardBaseUrl/" ?>"><?php echo $boardBaseUrl; ?></a>
</body>
</html>
 <?php
} elseif($post=="2") {
 $fh=fopen("$boardMsgUrl/replies.txt","r");
 $fc=fread($fh,filesize("$boardMsgUrl/replies.txt"));
 fclose($fh);
 $fh=fopen("$boardMsgUrl/replies.txt","w");
 $fw=stripslashes(chop($subj)) . "<[{:|:}]>" . stripslashes(chop($name)) . "<[{:|:}]>" . stripslashes(chop($email)) . "<[{:|:}]>" . stripslashes(chop($time)) . "<[{:|:}]>" . stripslashes(chop($date)) . "<[{:|:}]>" . stripslashes(chop($num)) . "<[{:|:}]>" . $reply . "\r\n$fc";
 fwrite($fh,$fw);
 fclose($fh);
 $fh=fopen("$boardMsgUrl/$num.abm","w");
 $msg=nl2br($msg);
 $fw=stripslashes($msg);
 fwrite($fh,$fw);
 fclose($fh);
 ?>
<html>
<head>
	<title>Reply Successfully Added</title>
    <meta http-equiv="refresh" content="0;url=<?php echo "$boardBaseUrl/"; ?>">
	
</head>
<body>
Reply Successfully Added<br>
If you are not redirected go to <a href="<?php echo "$boardBaseUrl/"; ?>"><?php echo $boardBaseUrl; ?></a>
</body>
</html>
 <?php
} else {
$msga=file("$boardMsgUrl/list.txt");
$mq2=explode("<[{:|:}]>",$msga[0]);
$mq=$mq2[5];
$rpa=file("$boardMsgUrl/replies.txt");
$rq2=explode("<[{:|:}]>",$rpa[0]);
$rq=$rq2[5];
if($mq>$rq && $mq!=$rq) {
 $num=$mq+1;
} else {
 $num=$rq+1;
}
?>
<html>
<head>
     <title><?php echo $boardTitle; ?></title>
     <?php include("./style.php"); ?>
     <script language="JavaScript">
     function openSmilies(winopen, sizex, sizey) {
      window.open(winopen,'',"width="+sizex+",height="+sizey+",scrollbars")
     }
	 function openHtml(winopen, sizex, sizey) {
      window.open(winopen,'',"width="+sizex+",height="+sizey)
     }
     </script>
</head>
<body background="<?php echo $boardBgPic; ?>" bgcolor="<?php echo $boardBgColor; ?>" text="<?php echo $boardTextColor; ?>" link="<?php echo $boardLinkColor; ?>" vlink="<?php echo $boardVLinkColor; ?>" alink="<?php echo $boardALinkColor; ?>">
<?php echo $boardMsg; ?><table cellpadding="<?php echo $boardTableCellpadding; ?>" cellspacing="<?php echo $boardTableCellspacing; ?>" width="<?php echo $boardTableWidth; ?>" height="<?php echo $boardTableHeight; ?>" align="<?php echo $boardTableAlign; ?>">
<tr> 
   <td align="right"><?php if($boardPostButton=="") {
    echo "<a href=\"post.php?action=new\">Post a New Topic</a><br>";
   } else {
    echo "<a href=\"post.php?action=new\"><img src=\"$boardPostButton\" border=\"0\" alt=\"Post a New Topic\"></a><br>";
   } if($boardSearchButton=="") {
    echo "<a href=\"search.php\">Search the Topics</a><br>";
   } else {
    echo "<a href=\"search.php\"><img src=\"$boardSearchButton\" border=\"0\" alt=\"Search the Topics\"></a><br>";
   } if($boardFaqButton=="") {
    echo "<a href=\"faq.php\">Frequently Asked Questions</a><br>";
   } else {
    echo "<a href=\"faq.php\"><img src=\"$boardFaqButton\" border=\"0\" alt=\"Frequently Asked Questions\"></a><br>";
   } ?></td>
</tr>
</table>
<table border="<?php echo $boardTableBorder; ?>" cellpadding="<?php echo $boardTableCellpadding; ?>" cellspacing="<?php echo $boardTableCellspacing; ?>" width="<?php echo $boardTableWidth; ?>" height="<?php echo $boardTableHeight; ?>" align="<?php echo $boardTableAlign; ?>" bgcolor="<?php echo $boardTableBgColor; ?>" bordercolor="<?php echo $boardTableBorderColor; ?>">
<tr>
<?php
if($action=="new") {
?>
   <td><form action="post.php" method="post">
   <input name="post" type="hidden" value="1">
   <input name="date" type="hidden" value="<?php echo date("F j, Y"); ?>">
   <input name="time" type="hidden" value="<?php echo date("G:i"); ?>">
   <input name="num" type="hidden" value="<?php echo $num; ?>">
   Name:</td>
   <td><input name="name" type="text" value=""></td>
</tr>
<tr>
   <td>E-mail:</td>
   <td><input name="email" type="text" value=""></td>
</tr>
<tr>
   <td>Subject:</td>
   <td><input name="subj" type="text" value=""></td>
</tr>
<tr>
   <td valign="top">Message:<?php
    echo "<br><br><a href=\"javascript:openSmilies('smilies.php','220','520')\">Smiles Enabled</a>";
    echo "<br><br><a href=\"javascript:openHtml('html.php','220','520')\">HTML Enabled</a></td>";
   ?></td>
   <td><textarea name="msg" rows="12" cols="50"></textarea></td>
</tr>
<tr>
   <td colspan="2"><center><input type="submit" value="Post">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="reset" value="Clear"></center></td>
</tr>
<?php
} elseif($action=="reply") {
?>
   <td><form action="post.php" method="post">
   <input name="post" type="hidden" value="2">
   <input name="reply" type="hidden" value="<?php echo $message; ?>">
   <input name="date" type="hidden" value="<?php echo date("F j, Y"); ?>">
   <input name="time" type="hidden" value="<?php echo date("G:i"); ?>">
   <input name="num" type="hidden" value="<?php echo $num; ?>">   
   Name:</td>
   <td><input name="name" type="text" value=""></td>
</tr>
<tr>
   <td>E-mail:</td>
   <td><input name="email" type="text" value=""></td>
</tr>
<tr>
   <td>Subject:</td>
   <td><input name="subj" type="text" value="<?php
   for($a=0;$a<sizeof($msga);$a++) {
    $mst=explode("<[{:|:}]>",$msga[$a]);
    if(chop($mst[5])==$message) {
     $ms=explode("<[{:|:}]>",$msga[$a]); 
    }
   }
   echo "Re: " . $ms[0];
   ?>"></td>
</tr>
<tr>
   <td valign="top">Message:</td>
   <td><textarea name="msg" rows="12" cols="50"></textarea></td>
</tr>
<tr>
   <td colspan="2"><center><input type="submit" value="Post">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="reset" value="Clear"></center></td>
</tr>
<?php
}
}
?>