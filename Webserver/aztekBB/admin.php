<?php
include("./conf/board.conf.php");
include("./conf/theme.conf.php");
include("./conf/moderate.conf.php");


if($login!="" && $pass!="") {
 if ($members[$login]["passwd"]==$pass) {
  if($post!="") {
   delPost($post);
  } else {
  adminForum();
  }
 } else {
  showLogin(0);
 }
} elseif($del!="") {
 showLogin(1);
} else {
 showLogin(0);
}


function delPost($post) {
GLOBAL $boardMsgUrl, $boardBaseUrl;
 $msga=file("$boardMsgUrl/list.txt");
 for($a=0;$a<sizeof($msga);$a++) {
 $mst=explode("<[{:|:}]>",$msga[$a]);
  if(chop($mst[5])==$post) {
   $line_no=$a;
   delReplys($post);
  }
 }
 unlink("$boardMsgUrl/$post.abm");
 $data=file("$boardMsgUrl/list.txt");
 $pipe=fopen("$boardMsgUrl/list.txt","w");
 $size=count($data);
 if($line_no==-1) $skip=$size-1;
 else $skip=$line_no;
 for($line=0;$line<$size;$line++)
 if($line!=$skip)
 fputs($pipe,$data[$line]);
 else
?>
<html>
<head>
	<title>Successfully Deleted</title>
    <meta http-equiv="refresh" content="2;url=<?php echo "$boardBaseUrl/"; ?>">
</head>
<body>
Successfully Deleted<br>
If you are not redirected go to <a href="<?php echo "$boardBaseUrl/"; ?>"><?php echo $boardBaseUrl; ?></a>
</body>
</html>
<?php
}

function delReplys($post) {
GLOBAL $boardMsgUrl;
$rpa=file("$boardMsgUrl/replies.txt");
$rpa=array_reverse($rpa);
for($a=0;$a<sizeof($rpa);$a++) {
 $mst=explode("<[{:|:}]>",$rpa[$a]);
 if(chop($mst[6])==$post) {
  $line_no=$a;
  unlink("$boardMsgUrl/$mst[5].abm");
  $data=file("$boardMsgUrl/replies.txt");
  $pipe=fopen("$boardMsgUrl/replies.txt","w");
  $size=count($data);
  if($line_no==-1) $skip=$size-1;
  else $skip=$line_no;
  for($line=0;$line<$size;$line++)
  if($line!=$skip)
  fputs($pipe,$data[$line]);
  else;
 }
}
}


function adminForum() {
GLOBAL $login, $pass, $boardTitle;
?>
 <html>
 <head>
      <title><?php echo $boardTitle; ?></title>
      <?php include("./style.php"); ?>
 </head>
 <body background="<?php echo $boardBgPic; ?>" bgcolor="<?php echo $boardBgColor; ?>" text="<?php echo $boardTextColor; ?>" link="<?php echo $boardLinkColor; ?>" vlink="<?php echo $boardVLinkColor; ?>" alink="<?php echo $boardALinkColor; ?>">
 <center><font size="6">Forum Admin</font></center><br>
 <form action="admin.php" method="post">
 <input name="login" type="hidden" value="<?php echo $login; ?>">
 <input name="pass" type="hidden" value="<?php echo $pass; ?>">
 The topic number you see in the address bar when you are veiwing the post.<br><br>
 <table border="<?php echo $boardTableBorder; ?>" cellpadding="<?php echo $boardTableCellpadding; ?>" cellspacing="<?php echo $boardTableCellspacing; ?>" align="<?php echo $boardTableAlign; ?>" bgcolor="<?php echo $boardTableBgColor; ?>" bordercolor="<?php echo $boardTableBorderColor; ?>">
 <tr>
	 <td><b>Topic Number:</b></td>
	 <td><input name="post" type="text" class="side"></td>
 </tr>
 <tr>
	 <td colspan="2"><center><input type="submit" value="Delete Post" class="side"></center></td>
 </tr>
 </table>
 </form>
 </body>
 </html>
<?php
}


function showLogin($s) {
GLOBAL $del, $boardTitle;
?>
<html>
<head>
     <title><?php echo $boardTitle; ?></title>
     <?php include("./style.php"); ?>
</head>
<body background="<?php echo $boardBgPic; ?>" bgcolor="<?php echo $boardBgColor; ?>" text="<?php echo $boardTextColor; ?>" link="<?php echo $boardLinkColor; ?>" vlink="<?php echo $boardVLinkColor; ?>" alink="<?php echo $boardALinkColor; ?>">
<center> 
<form action="admin.php" method="post">
<?php if($s=="1") echo "<input name=\"post\" type=\"hidden\" value=\"$del\">\r\n"; ?>
<font size="6">Admin Login</font><br><br>
<table border="<?php echo $boardTableBorder; ?>" cellpadding="<?php echo $boardTableCellpadding; ?>" cellspacing="<?php echo $boardTableCellspacing; ?>" align="<?php echo $boardTableAlign; ?>" bgcolor="<?php echo $boardTableBgColor; ?>" bordercolor="<?php echo $boardTableBorderColor; ?>">
<tr>
	<td><b>Login:</b></td>
	<td><input name="login" type="text"></td>
</tr>
<tr>
	<td><b>Password:</b></td>
	<td><input name="pass" type="password"></td>
</tr>
<tr>
	<td colspan="2"><center><input type="submit" value="Log In"></center></td>
</tr>
</table>
</form>
</center>
</body>
</html>
<?php
}
?>