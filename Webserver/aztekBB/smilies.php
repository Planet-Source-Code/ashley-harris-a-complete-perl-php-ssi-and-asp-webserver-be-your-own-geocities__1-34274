<?php
include("./conf/board.conf.php");
include("./conf/theme.conf.php");
include("./conf/smilies.conf.php");
?>
<html>
<head>
     <title><?php echo $boardTitle; ?></title>
     <?php include("./style.php"); ?>
</head>
<body background="<?php echo $boardBgPic; ?>" bgcolor="<?php echo $boardBgColor; ?>" text="<?php echo $boardTextColor; ?>" link="<?php echo $boardLinkColor; ?>" vlink="<?php echo $boardVLinkColor; ?>" alink="<?php echo $boardALinkColor; ?>">
<center><font size="6">Smiles</font></center><br>
<table border="<?php echo $boardTableBorder; ?>" cellpadding="<?php echo $boardTableCellpadding; ?>" cellspacing="<?php echo $boardTableCellspacing; ?>" align="<?php echo $boardTableAlign; ?>" bgcolor="<?php echo $boardTableBgColor; ?>" bordercolor="<?php echo $boardTableBorderColor; ?>">
<tr bgcolor="<?php echo $boardHeaderBgColor; ?>" background="<?php echo $boardHeaderBgPic; ?>">
   <td></td>
   <td><center><b>Expression</b></center></td>
   <td><center><b>Image</b></center></td>
</tr>
<?php
for($j=0;$j<sizeof($smilies);$j++) {
 $simsrc=$smilies[$j][0];
 $simalt=$smilies[$j][1];
 $simnum=$j+1;
 echo "<tr>";
 echo "   <td><div align=\"right\">$simnum</div></td>";
 echo "   <td><center>$simalt</center></td>";
 echo "   <td><center><img src=\"$simsrc\" border=\"0\" alt=\"$simalt\"></center></d>";
 echo "</tr>";
}
?>
</table>
<br>
<center><a href="javascript:window.close()">Close Window</a></center>
</body>
</html>