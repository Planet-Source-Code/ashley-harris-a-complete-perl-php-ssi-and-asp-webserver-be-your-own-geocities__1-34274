<%  
dim all_voters, sql
'on error resume next (Want to see the errors - Ashley)

	'create connection
	set conn = server.CreateObject ("ADODB.Connection")
	conn.Open "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & server.MapPath ("fpdb/poll.mdb")
	'query to select active data...
	sql = "SELECT * FROM title, vote where title.title ='" & Request.QueryString("title") & "' and title.id = " & Request.QueryString("id") & " and title.id = vote.id"
	set rs = server.CreateObject ("ADODB.Recordset")
	rs.Open sql, conn
	
	all_voters = 0
	
	do
		all_voters = all_voters + rs.fields("no_vote")
		rs.movenext
	loop until rs.eof
	
	rs.movefirst	 
%>

<html>

<head>
<title>:::: .EZ.Poll ::::</title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1250">
<link rel="stylesheet" href="vote.css" type="text/css">
</head>

<body text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#FFFFFF">
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
<tr>
<td align="center" valign="middle"> 
<table width="426" border="0" cellspacing="0" cellpadding="0">
<tr> 
<td colspan="3" height="12"><img src="img/res_top.jpg" width="426" height="12"></td>
</tr>
<tr> 
<td background="img/res_lft_tit.jpg" width="12" nowrap>&nbsp;</td>
<td width="400" background="img/tit_center.jpg"><span class="bldtxtvY10">Poll:</span> 
<span class="nortxtv10"> <%=rs.Fields("title")%></span></td>
<td background="img/res_rght_tit.jpg" width="14" nowrap>&nbsp;</td>
</tr>
<tr> 
<td colspan="3" height="16"><img src="img/res_mid.jpg" width="426" height="16"></td>
</tr>
<tr> 
<td background="img/res_mid_lft.jpg">&nbsp;</td>
<td width="400" bgcolor="#FFFFFF" align="left" valign="top"> <%
Dim b, c
do			
	b = Clng(rs.fields("no_vote"))
						
	'if no one vote ....
	if b = "0" then
%> 
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="nortxtvB10">
<tr> 
<td width="30%"><%=rs.Fields("answer")%></td>
<td width="70%"><font color="0000FF">0%(0)</font></td>
</tr>
<tr> 
<td colspan="2"><font color="0000FF">No votes.</font></td>
</tr>
</table>
<% 
 else
 'somebody vote...
 c = Clng(100 / all_voters * b)			
%> 
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="nortxtvB10">
<tr> 
<td width="70%"><%=rs.Fields("answer")%></td>
<td width="30%" align="right"><font color="0000FF"><%= c & "%" & " (" & rs.Fields("no_vote") & ")" %></font></td>
</tr>
<tr> 
<td colspan="2"><img src="img/vote.gif" height="15" width="<%= 4*c %>" alt="<%=rs.Fields("no_vote")%>"></td>
</tr>
</table>
<%	
	end if
%> <%
							
rs.movenext
loop while not rs.eof
%> <br />
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="nortxtvB10">
<tr> 
<td>All voters: <font color="red"><b><%=all_voters%></b></font></td>
</tr>
</table>
</td>
<td background="img/res_mid_rght.jpg">&nbsp;</td>
</tr>
<tr> 
<td colspan="3" height="14"><img src="img/res_bot.jpg" width="426" height="14"></td>
</tr>
</table>
<br>
<a href="javascript:window.close();" class="nortxtvB10"><font color="#0000FF">Close window</font></a><br></br></td>
</tr>
</table>
</body>
</html>

<%
rs.close
set rs = nothing
conn.close
set conn = nothing
%>