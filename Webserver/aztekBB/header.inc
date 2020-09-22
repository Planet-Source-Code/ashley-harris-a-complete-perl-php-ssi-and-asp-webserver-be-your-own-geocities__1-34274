<html>
<head>
	<title>-=+|  CaFFeiNaTeD DaTa PhReAkZ  |+=-</title>
	<link rel="StyleSheet" type="text/css" href="../style.css">
</head>
<body bgcolor="#374D5B" text="#FFFFFF" link="99CCFF" vlink="99CCFF" alink="99CCFF" topmargin="0" leftmargin="0" rightmargin="0" bottommargin="0">
<center><img src="../gfx/logo.gif" width="700" height="60" border="0" alt="Caffineated Data Phreaks" align="center"></center>
<table border="0" cellpadding="10" cellspacing="2" width="20%" align="left">
<tr valign="top">
   <td>
   <table border="1" cellpadding="6" cellspacing="0" width="100%" align="center" bgcolor="#374D5B" bordercolor="#435e70">
   <tr bgcolor="#304350">
      <td><font size="4"><center><b>Main Menu</b></center></font></td>
   </tr>
   <tr>
      <td>
	  <li><a href="../index.php">Home</a></li>
	  <li><a href="../members.php">Members</a></li>
	  <li><a href="../tuts/index.php">Tutorials</a></li>
	  <li><a href="../humor/index.php">Humor</a></li>
	  <li><a href="../links.php">Links</a></li>
	  <li><a href="../cdpBB/index.php">Forum</a></li>
	  </td>
   </tr>
   </table>
   </td>
</tr>
<tr valign="top">
   <td>
   <table border="1" cellpadding="6" cellspacing="0" width="100%" align="center" bgcolor="#374D5B" bordercolor="#435e70">
   <tr bgcolor="#304350">
      <td><font size="4"><center><b>Links</b></center></font></td>
   </tr>
   <tr>
      <td><center><a href="http://blacksun.box.sk"><img src="../gfx/buttons/bsrf.gif" width="88" height="32" border="0" alt="Blacksun Research Facility" align="center"></a><br><br>
      <a href="http://www.securitywriters.org"><img src="../gfx/buttons/swg.gif" width="88" height="32" border="0" alt="Security Writers Guild" align="center"></a><br><br>
      <a href="links.php">More Links...</a></center>
      </td>
   </tr>
   </table>
   </td>
</tr>
<tr valign="top">
   <td>
   <table border="1" cellpadding="6" cellspacing="0" width="100%" align="center" bgcolor="#374D5B" bordercolor="#435e70">
   <tr bgcolor="#304350">
      <td><font size="4"><center><b>IRC Channel</b></center></font></td>
   </tr>
   <tr>
      <td>
      Channal: #cdp<br>
	  Server: <a href="http://irc.box.sk">irc.box.sk</a><br><br>
	  Please read both our <a href="../up.php">Use Policy</a> and <a href="http://irc.box.sk/aup/">Box's</a>
	  </td>
   </tr>
   </table>
   </td>
</tr>
<tr valign="top">
   <td>
   <table border="1" cellpadding="6" cellspacing="0" width="100%" align="center" bgcolor="#374D5B" bordercolor="#435e70">
   <tr bgcolor="#304350">
      <td><font size="4"><center><b>Member Login</b></center></font></td>
   </tr>
   <tr>
      <td>
      <form action="../controlpanel.php" method="post">
	  Username:<br>
	  <center><input name="login" type="text" value="" size="12" class="side"></center>
	  Password:<br>
	  <center><input name="pass" type="password" value="" size="12" class="side"></center><br>
	  <center><input type="submit" value="Login" class="side"></center>
	  </form>
	  </td>
   </tr>
   </table>
   </td>
</tr>
</table>


<table border="0" cellpadding="10" cellspacing="2" width="20%" height="100%" align="right">
<tr valign="top">
   <td>
   <table border="1" cellpadding="6" cellspacing="0" width="100%" align="center" bgcolor="#374D5B" bordercolor="#435e70">
   <tr bgcolor="#304350">
      <td><font size="4"><center><b>Poll</b></center></font></td>
   </tr>
   <tr>
      <td>
      <?php include("../poll/showpoll.php"); ?>
	  </td>
   </tr>
   </table>
   </td>
</tr>
<?php
$lw=file("../link.txt");
?>
<tr valign="top">
   <td>
   <table border="1" cellpadding="6" cellspacing="0" width="100%" align="center" bgcolor="#374D5B" bordercolor="#435e70">
   <tr bgcolor="#304350">
      <td><font size="4"><center><b>Link of the Week</b></center></font></td>
   </tr>
   <tr>
      <td>
      <a href="<?php echo $lw[0]; ?>"><?php echo $lw[1]; ?></a> - <?php echo $lw[2]; ?>
	  </td>
   </tr>
   </table>
   </td>
</tr>
<tr valign="top">
   <td>
   <table border="1" cellpadding="6" cellspacing="0" width="100%" align="center" bgcolor="#374D5B" bordercolor="#435e70">
   <tr bgcolor="#304350">
      <td><font size="4"><center><b>Articals</b></center></font></td>
   </tr>
   <tr>
      <td>
      <i>Comming soon</i>
	  </td>
   </tr>
   </table>
   </td>
</tr>
</table>

<table border="0" cellpadding="0" cellspacing="0" align="center">
<tr><td><br>