<%
'Choose the Colors that you Want the Guestbook to look like'
HeadingCellBgColor="#003366"
HeadingCellTextColor="#FFFFFF"
CellBgColor="#B8D9FE"
CellTextColor="#000066"
%>
<HTML>
<HEAD>
<TITLE>Sign The Pure Speed Guestbook!</TITLE>
</HEAD>
<BODY bgcolor="#040023" background="images/backgrnd.jpg" text="#FDFAC4" link="#FDFAC4" vlink="#FDAB00">
<%

'the data requested and stuff

Flag = Request.form("Flag")
IF Flag = 1 THEN
Name = Request.form("Name")
Email = Request.form("Email")
Url = Request.form("Url")
Comment = Request.form("Comment")
Comment = server.HTMLencode(Comment) 'Don't allow HTML
Comment = REPLACE(Comment,VbCrlf,"<br>") 'Place a break for every new line in the Comment

'fun stuff! error validation
'Here's what's required: Name and the Comment
'The email address is not required, but if the user puts in one, the error routine checks to see if it's a valid one

errmsg="<UL>"
IF NOT REPLACE(Email," ","") = "" THEN
   IF INSTR(Email,"@")=0 THEN
	   errmsg = errmsg & "<li>Email address is invalid. Please check it and try again</li>"
	   ELSEIF INSTR(Email,".") = 0 THEN
		  errmsg = errmsg & "<li>Email address is invalid. Please check it and try again</li>"
   END IF
END IF

IF REPLACE(Comment," ","") = "" THEN errmsg = errmsg & "<LI>Comment is missing</LI>"
errmsg = errmsg & "</UL>"
IF NOT errmsg ="<UL></UL>" THEN
%>

<DIV style="font-family:Arial; color:red; font-weight:bold" align="center">
	The Following Errors Were Detected:
</DIV>

<BR>
<%= errmsg %>

<UL>
	<LI><I>
			Please click the back button on your browser, 
				<A href="javascript:history.go(-1)">or click here</A> 
			and fix these errors.
		</I></LI>
</UL>
</BODY>
</HTML>
<%
	Response.end 
END IF
'end of error routine

Newrecord = "<!-- ## GBDATA ## -->"	'Begin of Guestbook Entries
Newrecord = Newrecord & "<!-- Begin record -->"

Newrecord = Newrecord & "<!--Name:" & name & " -->" & VbCrlf
Newrecord = Newrecord & "<TABLE BORDER='0' ALIGN='CENTER' WIDTH='600' CELLPADDING='0'>" & VbCrlf
Newrecord = Newrecord & "	<TR>" & VbCrlf 
Newrecord = Newrecord & "		<TD WIDTH='70' BGCOLOR='" & HeadingCellBgColor & "'>" & VbCrlf 
Newrecord = Newrecord & "			<FONT SIZE=2 FACE='ARIAL' COLOR='" & HeadingCellTextColor & "'>" & VbCrlf 
Newrecord = Newrecord & "				<B>Date:</B>" & VbCrlf
Newrecord = Newrecord & "			</FONT>" & VbCrlf
Newrecord = Newrecord & "		</TD>" & VbCrlf
Newrecord = Newrecord & "	<TD BGCOLOR='" & CellBgColor & "'>" & VbCrlf
Newrecord = Newrecord & "		<FONT SIZE=2 FACE='ARIAL' COLOR='" & CellTextColor & "'>" & now & "</FONT>" & VbCrlf
Newrecord = Newrecord & "	</TD>" & VbCrlf
Newrecord = Newrecord & "	</TR>" & VbCrlf

Newrecord = Newrecord & VbCrlf 'Just a new line to make the output look cleaner

If NOT Name = "" THEN	'If the Name was not left blank, then do the stuff below
	Newrecord = Newrecord & "	<TR>" & Vbcrlf 
	Newrecord = Newrecord & "		<TD WIDTH='70' BGCOLOR='" & HeadingCellBgColor & "'>" & VbCrlf
	Newrecord = Newrecord & "			<FONT SIZE=2 FACE='ARIAL' COLOR='" & HeadingCellTextColor & "'>" & VbCrlf
	Newrecord = Newrecord & "				<B>Name:</B>" & VbCrlf
	Newrecord = Newrecord & "			</FONT>" & VbCrlf
	Newrecord = Newrecord & "		</TD>" & VbCrlf
	Newrecord = Newrecord & "	<TD BGCOLOR='" & CellBgColor & "'>" & VbCrlf
	Newrecord = Newrecord & "		<FONT SIZE=2 FACE='ARIAL' COLOR='" & CellTextColor & "'>" & Name & "</FONT>" & VbCrlf
	Newrecord = Newrecord & "	</TD>" & VbCrlf
	Newrecord = Newrecord & "	</TR>" & VbCrlf
ELSE 'If the name was left blank, make sure to leave the Name as Anonymous
	Newrecord = Newrecord & "	<TR>" & Vbcrlf 
	Newrecord = Newrecord & "		<TD WIDTH='70' BGCOLOR='" & HeadingCellBgColor & "'>" & VbCrlf
	Newrecord = Newrecord & "			<FONT SIZE=2 FACE='ARIAL' COLOR='" & HeadingCellTextColor & "'>" & VbCrlf
	Newrecord = Newrecord & "				<B>Name:</B>" & VbCrlf
	Newrecord = Newrecord & "			</FONT>" & VbCrlf
	Newrecord = Newrecord & "		</TD>" & VbCrlf
	Newrecord = Newrecord & "	<TD BGCOLOR='" & CellBgColor & "'>" & VbCrlf
	Newrecord = Newrecord & "		<FONT SIZE=2 FACE='ARIAL' COLOR='" & CellTextColor & "'>Anonymous</FONT>" & VbCrlf
	Newrecord = Newrecord & "	</TD>" & VbCrlf
	Newrecord = Newrecord & "	</TR>" & VbCrlf
END IF

Newrecord = Newrecord & VbCrlf 'Just a new line to make the output look cleaner

IF NOT Email = "" THEN 	'If the Email address was not left blank, then do the stuff below

Newrecord = Newrecord & "	<TR>" & VbCrlf 
Newrecord = Newrecord & "		<TD WIDTH='70' BGCOLOR='" & HeadingCellBgColor & "'>" & VbCrlf
Newrecord = Newrecord & "			<FONT SIZE=2 FACE='ARIAL' COLOR='" & HeadingCellTextColor & "'>" & VbCrlf
Newrecord = Newrecord & "				<B>Email:</B>" & VbCrlf
Newrecord = Newrecord & "			</FONT>" & VbCrlf
Newrecord = Newrecord & "		</TD>" & VbCrlf
Newrecord = Newrecord & "		<TD BGCOLOR='" & CellBgColor & "'>" & VbCrlf
Newrecord = Newrecord & "			<A HREF='mailto:" & Email & "'>" & VbCrlf
Newrecord = Newrecord & "				<FONT SIZE=2 FACE='ARIAL'>" & Email & "</FONT>" & VbCrlf
Newrecord = Newrecord & "			</A>" & VbCrlf
Newrecord = Newrecord & "		</TD>" & VbCrlf
Newrecord = Newrecord & "	</TR>" & VbCrlf
END IF

Newrecord = Newrecord & VbCrlf 'Just a new line to make the output look cleaner

IF NOT Url = "" THEN 'If the URL that user put in is not left blank in the sign-in page then do the stuff below.

Newrecord = Newrecord & "	<TR>" & VbCrlf 
Newrecord = Newrecord & "		<TD WIDTH='70' BGCOLOR='" & HeadingCellBgColor & "'>" & VbCrlf
Newrecord = Newrecord & "			<FONT SIZE=2 FACE='ARIAL' COLOR='" & HeadingCellTextColor & "'>" & VbCrlf
Newrecord = Newrecord & "				<B>Own Url:</B>" & VbCrlf
Newrecord = Newrecord & "			</FONT>" & VbCrlf
Newrecord = Newrecord & "		</TD>" & VbCrlf
Newrecord = Newrecord & "		<TD BGCOLOR='" & CellBgColor & "'>" & VbCrlf
Newrecord = Newrecord & "			<A HREF='http://" & Url &"'>" & VbCrlf
Newrecord = Newrecord & "				<FONT SIZE='2' FACE='ARIAL'>" & Url & "</FONT>" & VbCrlf
Newrecord = Newrecord & "			</A>" & VbCrlf
Newrecord = Newrecord & "		</TD>" & VbCrlf
Newrecord = Newrecord & "	</TR>" & VbCrlf
END IF

Newrecord = Newrecord & "	<TR>" & VbCrlf
Newrecord = Newrecord & "		<TD COLSPAN=2 BGCOLOR='" & HeadingCellBgColor & "'>" & VbCrlf
Newrecord = Newrecord & "			<DIV align='center'>" & VbCrlf
Newrecord = Newrecord & "				<FONT SIZE='2' FACE='ARIAL' COLOR='" & HeadingCellTextColor & "'>" & VbCrlf
Newrecord = Newrecord & "					<B>Comments:</B>" & VbCrlf
Newrecord = Newrecord & "				</FONT>" & VbCrlf
Newrecord = Newrecord & "			</DIV>" & VbCrlf
Newrecord = Newrecord & "		</TD>" & VbCrlf
Newrecord = Newrecord & "	</TR>" & VbCrlf

Newrecord = Newrecord & "	<TR>" & VbCrlf 
Newrecord = Newrecord & "		<TD COLSPAN=2 BGCOLOR='" & CellBgColor & "'>" & VbCrlf
Newrecord = Newrecord & "			<FONT SIZE='2' FACE='ARIAL' COLOR='" & CellTextColor & "'>" & Comment & "</FONT>" & VbCrlf
Newrecord = Newrecord & "		</TD>" & VbCrlf
Newrecord = Newrecord & "	</TR>" & VbCrlf
Newrecord = Newrecord & "</TABLE>" & VbCrlf

Newrecord = Newrecord & "<BR>" & VbCrlf
Newrecord = Newrecord & "<!-- End record. name:" & name & " -->" & VbCrlf 
Newrecord = Newrecord & "<HR COLOR='#f0f0f0' width='640'>" & VbCrlf

IF INSTR(Newrecord,"<!-- ## GBDATA ## -->") = 0 then
Newrecord = Newrecord & "<!-- ## GBDATA ## -->"
END IF

'Edit the guestbook.txt file
fn = server.mappath("guestbook.txt")			    		'Find guestbook.txt on server
SET fs = CREATEOBJECT("Scripting.FileSystemObject") 		'Creating the FileSystem object
SET htmlfile = fs.OPENTEXTFILE(fn, 1, 0, 0)	    			'Opening guestbook.txt
code = htmlfile.READALL				    					'Reading the contents of the file
htmlfile.CLOSE					    						'Close guestbook.txt
SET htmlfile = nothing				

code = REPLACE(Code, "<!-- ## GBDATA ## -->", Newrecord) 	'Add the new record

SET htmlfile = fs.CREATETEXTFILE(fn)		    			'Re-create guestbook.txt
htmlfile.WRITE code				    						'Write contents to the file
htmlfile.CLOSE 					    						'Close guestbook.txt
SET htmlfile = nothing
SET fs = nothing				    						'Close FileSystem object

'End of the ASP CODE
%>

<!-- Thank you message -->
<DIV ALIGN="CENTER" STYLE="font-family:Arial; font-weight:bold">
	Thank you for signing the Pure Speed Guestbook
	<BR>
	<BR>
		<A href="view.asp">
			View Guestbook
		</A>
</DIV>

<P>
<DIV ALIGN="CENTER" STYLE="font-family:Arial; font-weight:bold">
	I appreciate your feedback and your interest in my site. ^_^
</DIV>

<BR>

<!-- End of thank you message -->
<%
Else
%>

<DIV align="center" style="FONT-WEIGHT: bold; FONT-FAMILY: Arial">
	Sign the Pure Speed Guestbook
</DIV>

<BR>

<DIV align="center">
	<IMG height="37" alt="PURE SPEED GUESTBOOK" src="images/guestbook.jpg" width="353" border="0">
</DIV>

<!-- Begin of Sign Form -->
<FORM action="index.asp" method="POST">
	<TABLE border="0" align="center" width="349">
		<TR>
			<TD bgcolor="<%= HeadingCellBgColor %>"><FONT size="2" face="arial" color="<%= HeadingCellTextColor %>">
					<B>Name:</B>
				</FONT>
			</TD>
			<TD bgcolor="<%= CellBgColor %>">
				<INPUT name="name" maxlength="30" width="50" style="WIDTH: 268px; HEIGHT: 22px" size="38">
			</TD>
		</TR>
		<TR>
			<TD bgcolor="<%= HeadingCellBgColor %>"><FONT size="2" face="arial" color="<%= HeadingCellTextColor %>">
					<B>Email:</B>
				</FONT>
			</TD>
			<TD bgcolor="<%= CellBgColor %>">
				<INPUT name="email" maxlength="30" style="WIDTH: 268px; HEIGHT: 22px" size="38">
			</TD>
		</TR>
		<TR>
			<TD bgcolor="<%= HeadingCellBgColor %>"><FONT size="2" face="arial" color="<%= HeadingCellTextColor %>">
					<B> Url:</B> 
      <STRONG>http://</STRONG>
				</FONT>
			</TD>
			<TD bgcolor="<%= CellBgColor %>">
				<INPUT name="url" maxlength="50" style="WIDTH: 268px; HEIGHT: 22px" size="30">
			</TD>
		</TR>
		<TR>
			<TD colspan="2" bgcolor="<%= HeadingCellBgColor %>">
				<DIV align="center"><FONT size="2" face="arial" color="<%= HeadingCellTextColor %>">
						<B>Comments:</B>
					</FONT>
				</DIV>
			</TD>
		</TR>
		<TR>
			<TD colspan="2" bgcolor="<%= CellBgColor %>">
				<TEXTAREA style="WIDTH: 344px; HEIGHT: 86px" name="Comment" rows="5" cols="43"></TEXTAREA>
			</TD>
		</TR>
		<TR>
			<TD>&nbsp;
			</TD>
			<TD>
				<INPUT type="hidden" name="flag" value="1">&nbsp;
			</TD>
		</TR>
	</TABLE><BR>
	<DIV align="center">
		<INPUT type="submit" value="submit">
	</DIV>
</FORM><!-- End of sign form -->

<PRE>


</PRE>
<DIV align="center"><A href="view.asp">View Guestbook</A>
</DIV>
<%
END IF
%>
</BODY>
</HTML>
