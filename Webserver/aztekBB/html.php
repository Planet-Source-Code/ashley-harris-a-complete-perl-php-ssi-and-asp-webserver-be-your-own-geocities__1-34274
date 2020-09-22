<?php
include("./conf/board.conf.php");
include("./conf/theme.conf.php");
?>
<html>
<head>
     <title><?php echo $boardTitle; ?></title>
     <?php include("./style.php"); ?>
</head>
<body background="<?php echo $boardBgPic; ?>" bgcolor="<?php echo $boardBgColor; ?>" text="<?php echo $boardTextColor; ?>" link="<?php echo $boardLinkColor; ?>" vlink="<?php echo $boardVLinkColor; ?>" alink="<?php echo $boardALinkColor; ?>">
<center><font size="6">Allowable HTML Tags</font></center><br>
<table border="<?php echo $boardTableBorder; ?>" cellpadding="<?php echo $boardTableCellpadding; ?>" cellspacing="<?php echo $boardTableCellspacing; ?>" align="<?php echo $boardTableAlign; ?>" bgcolor="<?php echo $boardTableBgColor; ?>" bordercolor="<?php echo $boardTableBorderColor; ?>">
<tr bgcolor="<?php echo $boardHeaderBgColor; ?>" background="<?php echo $boardHeaderBgPic; ?>">
   <td></td>
   <td><center><b>Tags</b></center></td>
</tr>
<?php
$tags=explode("><",$boardAllowableTags);
for($x=0;$x<sizeof($tags);$x++) {
 $tags[$x]=str_replace("<","",$tags[$x]);
 $tags[$x]=str_replace(">","",$tags[$x]);
}
for($j=0;$j<sizeof($tags);$j++) {
 $simnum=$j+1;
 echo "<tr>";
 echo "   <td><div align=\"right\">$simnum</div></td>";
 echo "   <td><center>&lt;$tags[$j]&gt;</center></td>";
 echo "</tr>";
}
?>
</table>
<br>
<center><a href="javascript:window.close()">Close Window</a></center>
</body>
</html>