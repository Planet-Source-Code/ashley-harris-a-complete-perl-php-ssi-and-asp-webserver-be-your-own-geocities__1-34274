<?php
include("./conf/board.conf.php");
include("./conf/theme.conf.php");
$msga=file("$boardMsgUrl/list.txt");
$rpa=file("$boardMsgUrl/replies.txt");
$size=sizeof($msga);
if($size>40) $size=40;
$str="";
for($i=0;$i<sizeof($rpa);$i++) {
 $rp=explode("<[{:|:}]>",$rpa[$i]);
 $rp[6]=chop($rp[6]);
 $str=$str . "<$rp[6]>";
}
?>
<table border="<?php echo $boardTableBorder; ?>" cellpadding="<?php echo $boardTableCellpadding; ?>" cellspacing="<?php echo $boardTableCellspacing; ?>" width="<?php echo $boardTableWidth; ?>" height="<?php echo $boardTableHeight; ?>" align="<?php echo $boardTableAlign; ?>" bgcolor="<?php echo $boardTableBgColor; ?>" bordercolor="<?php echo $boardTableBorderColor; ?>">
<tr bgcolor="<?php echo $boardHeaderBgColor; ?>" background="<?php echo $boardHeaderBgPic; ?>">
   <td><center><font color="<?php echo $boardHeaderTextColor; ?>"><b>Subject</b></font></center></td>
   <td><center><font color="<?php echo $boardHeaderTextColor; ?>"><b>Author</b></font></center></td>
   <td><center><font color="<?php echo $boardHeaderTextColor; ?>"><b>Replies</b></font></center></td>
   <td><center><font color="<?php echo $boardHeaderTextColor; ?>"><b>Time</b></font></center></td>
   <td><center><font color="<?php echo $boardHeaderTextColor; ?>"><b>Date</b></font></center></td>
</tr>
<?php
GLOBAL $size;
for($m=0;$m<$size;$m++) {
 $e=0;
 $msg=explode("<[{:|:}]>",$msga[$m]);
 $msg[5]=chop($msg[5]);
 $msg[6]=substr_count($str,"<$msg[5]>");
 if(chop($msg[5])!="") {
  if(chop($msg[1])=="") {
   $msg[1]="Anonymous";
  } if(chop($msg[2])=="") {
   $e=1;
  }
  echo "<tr>\r\n";
  echo "   <td><a class=\"tbl\" href=\"./view.php?message=$msg[5]\">$msg[0]</a></td>\r\n";
  if($e==1) {
   echo "   <td>$msg[1]</td>\r\n";
  } elseif($e==0) {
   echo "   <td><a class=\"tbl\" href=\"mailto:$msg[2]\">$msg[1]</a></td>\r\n";
  }
  echo "   <td>$msg[6]</td>\r\n";
  echo "   <td>$msg[3]</td>\r\n";
  echo "   <td>$msg[4]</td>\r\n";
  echo "</tr>\r\n";
 }
}
?>
</table>