<?php include("./conf/board.conf.php"); ?>
<?php include("./conf/theme.conf.php"); ?>
<html>
<head>
     <title><?php echo $boardTitle; ?></title>
     <?php include("./style.php"); ?>
</head>
<body background="<?php echo $boardBgPic; ?>" bgcolor="<?php echo $boardBgColor; ?>" text="<?php echo $boardTextColor; ?>" link="<?php echo $boardLinkColor; ?>" vlink="<?php echo $boardVLinkColor; ?>" alink="<?php echo $boardALinkColor; ?>">
<?php echo $boardMsg; ?><br><br>
<table cellpadding="<?php echo $boardTableCellpadding; ?>" cellspacing="<?php echo $boardTableCellspacing; ?>" width="<?php echo $boardTableWidth; ?>" height="<?php echo $boardTableHeight; ?>" align="<?php echo $boardTableAlign; ?>">
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
<?php include("./list.php"); ?>
<br><center><a href="<?php echo $boardHostUrl; ?>"><?php echo $boardHostTitle; ?></a></center>
</body>
</html>