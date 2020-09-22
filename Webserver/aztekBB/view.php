<?php
include("./conf/board.conf.php");
include("./conf/theme.conf.php");
include("./conf/smilies.conf.php");
GLOBAL $smilies, $boardSmilies, $boardStripTags;


$msga=file("$boardMsgUrl/list.txt");
for($a=0;$a<sizeof($msga);$a++) {
 $mst=explode("<[{:|:}]>",$msga[$a]);
 if(chop($mst[5])==$message) {
  $ms=explode("<[{:|:}]>",$msga[$a]); 
 }
}
if($message=="") {
 echo "<font color=\"red\">Error: No message requested</font>";
}
if($ms[1]=="") {
 $ms[1]="Anonymous";
} if($ms[2]=="") {
 $e=1;
}
$fh=fopen("$boardMsgUrl/$message.abm","r");
$mi=fread($fh,filesize("$boardMsgUrl/$message.abm"));
if($boardStripTags) {
 $mi=strip_tags($mi,$boardAllowableTags);
}
if($boardSmilie) {
  for($z=0;$z<sizeof($smilies);$z++) {
   $imgpath=$smilies[$z][0];
   $imgalt=$smilies[$z][1];
   $mi=str_replace($imgalt , "<img src=\"$imgpath\" border=\"0\" alt=\"$imgalt\">",$mi);
  }
 }

fclose($fh);
?>
<html>
<head>
     <title><?php echo $boardTitle; ?></title>
     <?php include("./style.php"); ?>
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
<tr bgcolor="<?php echo $boardHeaderBgColor; ?>" background="<?php echo $boardHeaderBgPic; ?>">
   <?php
   if($e==1) { 
    echo "<td><b><font size=\"4\">$ms[0]</font></b><br><font size=\"2\">$ms[1] - $ms[4]@$ms[3]</font></td>\r\n"; 
   } if($e==0) { 
    echo "<td><b><font size=\"4\">$ms[0]</font></b><br><font size=\"2\">Posted by <a href=\"mailto:$ms[2]\">$ms[1]</a> - $ms[4]@$ms[3]</font></td>\r\n"; 
   }
   ?>
</tr>
<tr>
   <td><?php echo $mi; ?></td>
</tr>
</table>
<?php
$rpa=file("$boardMsgUrl/replies.txt");
$rpa=array_reverse($rpa);
for($a=0;$a<sizeof($rpa);$a++) {
 $mst=explode("<[{:|:}]>",$rpa[$a]);
 if(chop($mst[6])==$message) {
  $msw=explode("<[{:|:}]>",$rpa[$a]); 
  if($msw[1]=="") {
   $msw[1]="Anonymous";
  } if($msw[2]=="") {
   $e=1;
  }
  $fh=fopen("$boardMsgUrl/$msw[5].abm","r");
  $mi2=fread($fh,filesize("$boardMsgUrl/$msw[5].abm"));
  if($boardStripTags) {
   $mi2=strip_tags($mi2,$boardAllowableTags);
  }
  fclose($fh);
  ?><br>
  <table border="<?php echo $boardTableBorder; ?>" cellpadding="<?php echo $boardTableCellpadding; ?>" cellspacing="<?php echo $boardTableCellspacing; ?>" width="<?php echo $boardTableWidth; ?>" height="<?php echo $boardTableHeight; ?>" align="<?php echo $boardTableAlign; ?>" bgcolor="<?php echo $boardTableBgColor; ?>" bordercolor="<?php echo $boardTableBorderColor; ?>">
  <tr bgcolor="<?php echo $boardHeaderBgColor; ?>" background="<?php echo $boardHeaderBgPic; ?>">
    <?php
    if($e==1) { 
     echo "<td><b><font size=\"4\">$msw[0]</font></b><br><font size=\"2\">$msw[1] - $msw[4]@$msw[3]</font></td>\r\n"; 
    } if($e==0) { 
     echo "<td><b><font size=\"4\">$msw[0]</font></b><br><font size=\"2\">Posted by <a href=\"mailto:$msw[2]\">$msw[1]</a> - $msw[4]@$msw[3]</font></td>\r\n"; 
    }
    ?>
  </tr>
  <tr>
   <td><?php echo $mi2; ?></td>
  </tr>
  </table>
  <?php
  } else {
  }
 }
?>
<table cellpadding="<?php echo $boardTableCellpadding; ?>" cellspacing="<?php echo $boardTableCellspacing; ?>" width="<?php echo $boardTableWidth; ?>" height="<?php echo $boardTableHeight; ?>" align="<?php echo $boardTableAlign; ?>">
<tr> 
   <td align="right"><?php if($boardReplyButton=="") {
    echo "<a href=\"post.php?action=reply&message=$message\">Post a Reply</a><br>";
   } else {
    echo "<a href=\"post.php?action=reply&message=$message\"><img src=\"$boardReplyButton\" border=\"0\" alt=\"Post a Reply\"></a><br>";
   } if($boardDelButton=="") {
    echo "<a href=\"admin.php?del=$message\">Delete This Post</a><br>";
   } else {
    echo "<a href=\"admin.php?del=$message\"><img src=\"$boardDelButton\" border=\"0\" alt=\"Delete This Post\"></a><br>";
   }

   ?></td>
</tr>
</table>
<br><center><a href="<?php echo $boardHostUrl; ?>"><?php echo $boardHostTitle; ?></a></center>
</body>
</html>