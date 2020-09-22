<%
dim cook, poll_id, sql, a
'on error resume next 'I want to see the errors - Ashley

	cook = request.cookies("currpoll")
	poll_id = Request.QueryString("id")
	
	
	'if cookie is the same than poll id..means that user has allready voted 
	'or if no radio button selected...set cookie which expires on end of 
	'session and redirect back to show results...

	if cook = poll_id or Request.Form("votefor") = "" then
		'setting cookies is not supported
		'neither is redirection
		'response.cookies("currpoll") = poll_id
		'Response.Redirect("poll.asp")
		response.write "<HTML><HEAD><META http-equiv=refresh content='1; url=poll.asp'></HEAD></HTML>"
		
	else
		
		'create connection
		set conn = server.CreateObject ("ADODB.Connection")
		conn.Open "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & server.MapPath ("fpdb/poll.mdb")
		'query to open data for input...
		sql = "SELECT * FROM title, vote where vote.answer = '" & Request.form("voteFor") & "' and vote.id = " & poll_id
		set rs = server.CreateObject ("ADODB.Recordset")
		rs.Open sql, conn, 3, 3
		
		
			'set cookie with expiration date (cur. date + expiration - number of days in database)	
			'Setting cookies from ASP is not support at current.
			'response.cookies("currpoll") = rs.Fields("vote.id")
			'Response.Cookies("currpoll").Expires = date + rs.Fields("expiration")
		
			'add one vote...
			a = rs.Fields("no_vote")
			a = int(a) + int(1)
			rs.Fields("no_vote") = a
			'update database..
			rs.Update
		
			'close connection and recordset...
			rs.Close
			set rs = nothing
			conn.Close
			set conn = nothing

			'after update redirect to vote results...
			'we dont support redirect
			'Response.Redirect("poll.asp")
			response.write "<HTML><HEAD><META http-equiv=refresh content='1; url=poll.asp'></HEAD></HTML>"
		
	end if
   
%>

