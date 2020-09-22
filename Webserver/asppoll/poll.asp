<%  
dim all_voters, sql, poll_id
'On error resume next '(I want to see whats wrong - Ashley)

	'create connection
	set conn = server.CreateObject ("ADODB.Connection")
	conn.Open "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & server.MapPath ("fpdb/poll.mdb")
	'query to select active data...
	sql = "SELECT * FROM title, vote where title.active = 'y' and title.id = vote.id"
	set rs = server.CreateObject ("ADODB.Recordset")
	rs.Open sql, conn
	
	poll_id = rs.fields("title.id")
	
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

<script language="JavaScript">
<!--
function openWin(URL,Name,butt) 
{
  window.open(URL,Name,butt);
}
-->
</script>

</head>

<body text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#FFFFFF">

<table width="120" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td align="left" valign="top">
	
	<%if rs.eof then 'means that there is no active poll%>
	
			  <table width="120" border="0" cellspacing="0" cellpadding="0">
				<tr> 
				  <td colspan="3" height="9"><img src="img/tit_top.jpg" width="120" height="9"></td>
				</tr>
				<tr> 
				  <td background="img/tit_lft.jpg" width="9" nowrap>&nbsp;</td>
				  
          <td width="102" background="img/tit_center.jpg" class="bldtxtv7" align="center" valign="middle">No 
            active poll !</td>
				  <td background="img/tit_rig.jpg" width="9" nowrap>&nbsp;</td>
				</tr>
				<tr> 
				  <td colspan="3" height="11"><img src="img/tit_bot.jpg" width="120" height="11"></td>
				</tr>
			  </table>
		
	<%else 'if there is active poll%>
	
		<%
		cook = request.cookies("currpoll")
		if cook = Cstr(poll_id)  then 'we check if user has the cookie (means that he had allready voted)
		%>

			  <table width="120" border="0" cellspacing="0" cellpadding="0">
				<tr> 
				  <td colspan="3" height="9"><img src="img/tit_top.jpg" width="120" height="9"></td>
				</tr>
				<tr> 
				  <td background="img/tit_lft.jpg" width="9" nowrap>&nbsp;</td>
				  <td width="102" background="img/tit_center.jpg" class="bldtxtvY7">Poll 
					results:<br />
					<span class="bldtxtv7"><%=rs.Fields("title")%></span></td>
				  <td background="img/tit_rig.jpg" width="9" nowrap>&nbsp;</td>
				</tr>
				<tr> 
				  <td colspan="3" height="11"><img src="img/tit_bot.jpg" width="120" height="11"></td>
				</tr>
			  </table>
			  <table width="120" border="0" cellspacing="0" cellpadding="0">
				<tr> 
				  <td colspan="3" height="9"><img src="img/vot_top.jpg" width="120" height="9"></td>
				</tr>
				<tr> 
				  <td background="img/vot_lft.jpg" width="9">&nbsp;</td>
				  <td width="102" class="nortxtvB7">
				  
					<%
					Dim b, c
					do			
						b = Clng(rs.fields("no_vote"))
						
						'if no one vote ....
						if b = "0" then
					%>
							     
					<b><%=rs.fields("answer")%></b>&nbsp;&nbsp;<font color="0000FF">0%(0)</font><br />
					<font color="0000FF">No votes.</font><br />
					
					<% 
					 else
					 'somebody vote...
					 c = Clng(100 / all_voters * b)			
					%>				  
				  
					<b><%=rs.fields("answer")%></b>&nbsp;&nbsp;<font color="0000FF"><%= c & "%" %></font><br />
					<img src="img/vote.gif" height="6" width="<%= 1*c %>" alt="<%=rs.Fields("no_vote")%>"><br />
					<%	
						end if
					%>  

					<%
							
					rs.movenext
					loop while not rs.eof
					%>
					<br />
					All voters: <font color="red"><b><%=all_voters%></b></font>
					
				  </td>
				  <td background="img/vot_rgh.jpg" width="9">&nbsp;</td>
				</tr>
				<tr> 
				  <td colspan="3" height="11"><img src="img/vot_bot.jpg" width="120" height="11"></td>
				</tr>
			  </table>		
				
		<%else 'no cookie found...vote granted%>
		
			  <table width="120" border="0" cellspacing="0" cellpadding="0">
				<form name="add" method="post" action="addvote.asp?id=<%=poll_id%>&title=<%=rs.fields("title")%>">
				<tr> 
				  <td colspan="3" height="9"><img src="img/tit_top.jpg" width="120" height="9"></td>
				</tr>
				<tr> 
				  <td background="img/tit_lft.jpg" width="9" nowrap>&nbsp;</td>
				  <td width="102" background="img/tit_center.jpg" class="bldtxtvY7">Poll 
					title:<br />
					<span class="bldtxtv7"><%=rs.Fields("title")%></span></td>
				  <td background="img/tit_rig.jpg" width="9" nowrap>&nbsp;</td>
				</tr>
				<tr> 
				  <td colspan="3" height="11"><img src="img/tit_bot.jpg" width="120" height="11"></td>
				</tr>
			  </table>
			  <table width="120" border="0" cellspacing="0" cellpadding="0">
				<tr> 
				  <td colspan="3" height="9"><img src="img/vot_top.jpg" width="120" height="9"></td>
				</tr>
				<tr> 
				  <td background="img/vot_lft.jpg" width="9">&nbsp;</td>
				  <td width="102" class="nortxtvB7">
				  
				  <%do 'create radio buttons with possible answers%>
				  <input type="radio" name="voteFor" value="<%=rs.Fields("answer")%>" />
				  <%=rs.Fields("answer")%><br />
				  <%
				  rs.MoveNext
				  loop until rs.EOF
				  %>
				  
				  </td>
				  <td background="img/vot_rgh.jpg" width="9">&nbsp;</td>
				</tr>
				<tr> 
				  <td colspan="3" height="11"><img src="img/vot_bot.jpg" width="120" height="11"></td>
				</tr>
			  </table>
			  <table width="120" border="0" cellspacing="0" cellpadding="0">
				<tr>
				  <td><input type="image" src="img/submit_dwn.jpg" width="120" height="25" border="0" name="submit" alt="Submit or view results" onMouseOver="src='img/submit_over.jpg'" onMouseOut="src='img/submit_dwn.jpg'"></td>
				</tr>
				</form>	  
			  </table>
		
		<%end if%>			  

	<%end if%>
	
      <table width="120" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td colspan="3" height="9"><img src="img/tit_top.jpg" width="120" height="9"></td>
        </tr>
        <tr> 
          <td background="img/tit_lft.jpg" width="9" nowrap>&nbsp;</td>
          <td width="102" background="img/tit_center.jpg">				

		<%'open recordset with inactive poll data
		dim a
		
		rs.close
		set rs = nothing	
		sql = "SELECT * FROM title where active = 'n'"
		set rs = server.CreateObject ("ADODB.Recordset")
		rs.Open sql, conn,3,3
		rs.movefirst
						
		a=1
		%>
		
		<%
		'there is no inactive poll in database
		if rs.eof then
		%>
		
			<p align="center" class="bldtxtvY7">No previous polls</p>
			
		<%
		else
		'create previous polls menu...
		%>

          <a class=Level1 id=OUT0t>
          <img src="img/plus.gif" width="9" height="9" align="absmiddle" class=LEVEL1 id=OUT0i>&nbsp; 
				Previous polls</a><br>				  
				<div id=OUT0s style="DISPLAY: none">
				<%do 'add titles of previous polls and links%>
				<a href="#" onClick="openWin('prevpoll.asp?id=<%=rs.fields("id")%>&title=<%=rs.fields("title")%>','Poll','scrollbars=yes,width=450,height=300')"><span class="nortxtv7"><%= "<b>" & a & ".</b> " & rs.fields("title")%></span></a><br />
				<%
				rs.movenext
				a = a + 1
				loop until rs.eof
				%>
				</div>
				
		<%end if%>
		
			</td>
          <td background="img/tit_rig.jpg" width="9" nowrap>&nbsp;</td>
        </tr>
        <tr> 
          <td colspan="3" height="11"><img src="img/tit_bot.jpg" width="120" height="11"></td>
        </tr>
      </table>
      
    </td>
  </tr>
</table>

<script language="JavaScript">
<!-- //start hiding for older browsers
//create expand menu for previous polls

	var img1 = new Image();
	img1.src = "img/plus.gif";
	var img2 = new Image();
	img2.src = "img/min.jpg";
					
	function doOutline() {
	  var srcId, srcElement, targetElement;
	  srcElement = window.event.srcElement;
	  if (srcElement.className.toUpperCase() == "LEVEL1" || srcElement.className.toUpperCase() == "FAQ") {
			 srcID = srcElement.id.substr(0, srcElement.id.length-1);
			 targetElement = document.all(srcID + "s");
			 srcElement = document.all(srcID + "i");
					
		if (targetElement.style.display == "none") {			
					 targetElement.style.display = "";
					 if (srcElement.className == "LEVEL1") srcElement.src = img2.src;
			} else {
					 targetElement.style.display = "none";
					 if (srcElement.className == "LEVEL1") srcElement.src = img1.src;
		 }
	  }
	}
					
	document.onclick = doOutline;
-->
</script>

</body>
</html>

<%
rs.close
set rs = nothing
conn.close
set conn = nothing
%>