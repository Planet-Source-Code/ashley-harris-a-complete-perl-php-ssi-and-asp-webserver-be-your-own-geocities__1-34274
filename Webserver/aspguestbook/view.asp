<HTML>
<HEAD>
<TITLE>PURE SPEED GUESTBOOK CONTENTS</TITLE>
</HEAD>
<BODY bgcolor="#040023" background="images/backgrnd.jpg" text="#FDFAC4" link="#003366" vlink="#FDAB00">
<STYLE>
<!--
A:hover {color:#007fff;}
-->
</STYLE>


<DIV STYLE="font-family:Arial; font-weight:bold" align="center">
	The Current Contents of the Pure Speed Guestbook
	<BR>
		<A href="index.asp">
			<FONT size="2" face="arial">Sign guestbook</FONT></A>
</DIV>

<BR>

<HR COLOR="#f0f0f0" WIDTH="640">
<BR>
	<% 'start ASP code'
	file = server.mappath("guestbook.txt")
	Set fs = server.CreateObject("Scripting.FileSystemObject") 	
	Set htmlfile = fs.OpenTextFile(file, 1, 0, 0)	
	hf = htmlfile.ReadAll
	
	IF INSTR (hf, "<!-- ## GBDATA ## --><!-- Begin record -->") = 0 THEN
		Response.write "<DIV align='center' style='font-family:Arial; font-weight:bold '>" & VbCrlf
		Response.write "	There are no contents in the Pure Speed Guestbook" & VbCrlf
		Response.write "</DIV>" & VbCrlf
		Response.write "<HR COLOR='#f0f0f0' WIDTH='640'>" & VbCrlf
		set htmlfile = nothing
		set fs = nothing
	
	ELSE 
		Response.write hf		'writing the HTML file onto the page
		htmlfile.close			'closing the HTML file
		set htmlfile = nothing	'setting the HTML file variable to nothing so we won't get errors ^_^
		set fs = nothing		'same as above but for the Scripting.FileSystemObject
	
	END IF'closing 1st IF statement
	'end of ASP code
	%>
</BODY>
</HTML>
