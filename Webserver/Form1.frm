VERSION 5.00
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "MSWINSCK.OCX"
Object = "{0E59F1D2-1FBE-11D0-8FF2-00A0D10038BC}#1.0#0"; "MSSCRIPT.OCX"
Begin VB.Form Form1 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Ashley's Web Server"
   ClientHeight    =   3255
   ClientLeft      =   45
   ClientTop       =   285
   ClientWidth     =   2310
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3255
   ScaleWidth      =   2310
   StartUpPosition =   3  'Windows Default
   Begin VB.ListBox stats 
      Height          =   2205
      Left            =   45
      TabIndex        =   6
      Top             =   915
      Width           =   2205
   End
   Begin MSScriptControlCtl.ScriptControl SC 
      Left            =   1230
      Top             =   345
      _ExtentX        =   1005
      _ExtentY        =   1005
      AllowUI         =   -1  'True
   End
   Begin MSWinsockLib.Winsock smtp 
      Left            =   315
      Top             =   270
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
      RemotePort      =   25
   End
   Begin webserver.MX MX1 
      Left            =   105
      Top             =   450
      _ExtentX        =   714
      _ExtentY        =   450
   End
   Begin VB.CheckBox Check1 
      Caption         =   "Pause"
      Height          =   285
      Left            =   1635
      Style           =   1  'Graphical
      TabIndex        =   5
      Top             =   210
      Width           =   660
   End
   Begin VB.CommandButton Command1 
      Caption         =   "config"
      Height          =   315
      Left            =   1650
      TabIndex        =   4
      Top             =   540
      Width           =   660
   End
   Begin VB.FileListBox File1 
      Height          =   285
      Left            =   1200
      TabIndex        =   3
      Top             =   450
      Visible         =   0   'False
      Width           =   885
   End
   Begin VB.Timer Timer2 
      Enabled         =   0   'False
      Interval        =   2000
      Left            =   540
      Top             =   240
   End
   Begin VB.Timer Timer1 
      Interval        =   5000
      Left            =   1545
      Top             =   135
   End
   Begin MSWinsockLib.Winsock ws 
      Index           =   0
      Left            =   1020
      Top             =   30
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
      LocalPort       =   80
   End
   Begin VB.Label Label3 
      Height          =   255
      Left            =   15
      TabIndex        =   2
      Top             =   585
      Width           =   3105
   End
   Begin VB.Label Label2 
      Height          =   255
      Left            =   30
      TabIndex        =   1
      Top             =   315
      Width           =   3105
   End
   Begin VB.Label Label1 
      Caption         =   "Waiting for conections..."
      Height          =   255
      Left            =   30
      TabIndex        =   0
      Top             =   15
      Width           =   3105
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'Ashleys webserver by Ashley Harris (Ashley___harris@hotmail.com)

'FEATURES:
' - Multiple silmultanius connections
' - PERL CGI! (complete implementation)
' - PHP!      (about 90% implemented)
' - ASP!      (GET/POST/read cookies only)
' - FORM POSTING (GET/POST)
' - COOKIES! (Multiple!)
' - Custom 404 pages
' - SERVER SIDE INCLUDES! (ssi)
' - Directory listings
' - RESUME DOWNLOADS!
' - STREAMING SUPPORT! (throttle)
' - REDIRECTION!
' - FILE UPLOADING! (perl only)
' - Ability to pause webserver temporarily for updates (clients are informed (and kept updated))
' - HTML, Flash, Images, Downloads, Realmedia, office, Mp3's, ANYTHING!
' - Logging in access db
' - CGI gets client referer, language, accept, Ip, port, docroot, query string, cookies etc.
' - CGI scripts can send email!

'What it DOESN'T SUPPORT (yet):
    'access control (passwords,etc.) (goes in .htaccess file)
    'my own cgi format (yet, hit some snags)
    'Error pages for other errors (500, 403, etc.) (goes in .htaccess file)
    'half of ASP, 10% of PHP, and the others..., would be helpfull if I knew ASP, PHP, and the rest
    'Prob isn't http/1.1 complient. I just messed around until it worked in internet explorer
    '     and netants(A download manager)
    '.htaccess files. A lot of work, but worth it...

'LEGAL STUFF:
' - You can use royalty free! Yeah, even if you use it to host your trilion dollar business,
'       I demand nothing more then feedback. (donation appreciated, but not nescicary)

' - NO WARENTY! Total payout for damages (or the like) are capped at $0.30US (That's what's in my wallet at current).
'   - This code was created by a 16yr old in his bedroom during school holidays, consider
'     yourself warned!!!!
'   - By using this software, even once, you agree not to sue me.

' - COPYRIGHT Ashley Harris (ashley___harris@hotmail.com). All this is opensource, use it! Please!
'    - MANY portions of this come from other people, check 'thanks to...txt'

'PLEASE PLEASE PLEASE PLEASE USE THIS WEBSERVER TO DO SOMETHING USEFULL! Gathering dust in your
'       downloads folder doesn't count. (please tell me what your using it for! It makes me proud
'       and looks good on a resume!)

'PLEASE PLEASE PLEASE VOTE FOR THIS! There is over 100 hours work here, Just tell me what you think
'       on planetsourcecode, I belive this is worth code of the month!

Private websitedir As String 'would be something like C:\docroot\, blank means app.path
Private default As String 'can put '?a=b' etc. "" means directory listing
Private error404 As String
Private docroot As String
Private bw As Long

Private downstart As Long

Public fso As New FileSystemObject
Dim connections As Long
Dim header As String
Dim sendbackindex As Integer

Dim tempkill As String

Dim sendmailstep As Integer

Dim aspexec As New CAspParser

Public asppath As String

'only one cgi script can be executed at a time, all others are put in a queue (sorta)
Public executingcgi As Boolean

Dim rs As Recordset

Private Sub Check1_Click()
    downstart = Timer
End Sub

Private Sub Command1_Click()
    Form2.Show
    Me.Hide
End Sub

Public Sub newsettings()
    websitedir = GetSetting("webserver", "pref", "dir", "")
    docroot = IIf(websitedir = "" Or websitedir = "/", App.path, websitedir)
    default = GetSetting("webserver", "pref", "default", "index.html")
    error404 = GetSetting("webserver", "pref", "404", "/404.html")
    bw = GetSetting("webserver", "pref", "speed", "100000")
End Sub

Private Sub Form_Load()
    'sets up everything
    ws(0).listen '(If you get an error saying no buffer space, restart.)
                 '(If you get an error saying address in use, quit all other webservers you have running.
    stats.List(0) = "Listening on port " & ws(0).LocalPort
    
    StayOnTop Me, True
    
    For a = 1 To 8
        Load ws(a)
    Next a
    
    newsettings
    
    'Load up the access DB.
    Dim workspace As workspace, db As Database, ta As TableDef
    
    Set workspace = DBEngine.Workspaces(0)
    
    Set db = workspace.OpenDatabase("accesslog.mdb")
    'if you can't find accesslog.mdb, close vb and reload.
    
    Set ta = db.TableDefs("hits")
    Set rs = ta.OpenRecordset
    
    'now, initialize the asp engine
    aspexec.SetScriptControl Me.SC
    aspexec.Initialize
    
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
    'closes the socket
    ws(0).Close
End Sub

Private Sub smtp_DataArrival(ByVal bytesTotal As Long)
    Dim a As String
    On Error Resume Next
    smtp.getdata a
    b = Split(a, vbNewLine)
    For c = LBound(b) To UBound(b)
        If b(c) <> "" Then
            sendmailstep = sendmailstep + 1
            Debug.Print "SMTPIN: " & b(c)
        End If
    Next c
    
End Sub

Private Sub smtp_Error(ByVal number As Integer, Description As String, ByVal Scode As Long, ByVal Source As String, ByVal HelpFile As String, ByVal HelpContext As Long, CancelDisplay As Boolean)
    smtp.Close
End Sub

Private Sub Timer1_Timer()
    For a = 1 To ws.UBound
        Select Case ws(a).State
        Case 0
            stats.List(a) = "Ready"
            rd = rd + 1
        Case 2
            stats.List(a) = "Listening"
        Case 6
            stats.List(a) = "Connecting"
        Case 8
            stats.List(a) = "Ready"
            rd = rd + 1
        Case 9
            stats.List(a) = "Error"
        End Select
    Next a
    If rd = ws.UBound Then executingcgi = False
End Sub

Private Sub Timer2_Timer()
    'return the results from the cgi script to the server
    'give it some time to write the output file.
    'if it's to long, change the timer2.timer property to a lower value
    Dim filedata As String
    Dim shots As Integer
tryagain:
    Open "C:\temp.txt" For Binary Access Read As #1
    filedata = Space$(LOF(1))
    Get #1, , filedata
    Close #1
    
    If filedata = "" Then
        t = Timer + 5
        While t > Timer
            DoEvents
        Wend
        shots = shots + 1
        If shots >= 3 Then
            'raise error 500 - TODO, add custom document.
            filedata = "Content-Type: text/html" & vbNewLine & vbNewLine & "<HTML><BODY>Error 500<P>The script either took too long to execute or an error occured, please contact the server admin imediatly.<P>(The error is most likely caused by either a langauge defined error (ie syntax error, path not found, etc), or you don't have the required software to execute this script.)</BODY></HTML>"
            GoTo screwit
        End If
        GoTo tryagain
    End If
screwit:
    datalength = Len(Mid(filedata, InStr(1, filedata, vbNewLine & vbNewLine) + 4))
    
    'you can get away without stating the content-length if you use these lines (I think?)
    'why dont I state the content length? I dunno. I had a reason...
    'It obv doesn't work now that we're http/1.1 complient
    'so, we now state the data length
    header = header & "Content-Length: " & datalength & vbNewLine
    header = header & "Connection: close" & vbNewLine
    
    On Error Resume Next
    ws(sendbackindex).SendData header & filedata
    ws(sendbackindex).Tag = "safe"
    stats.List(sendbackindex) = "Sending CGI script..."
    On Error GoTo 0
    Timer2 = False
    
    If fso.FileExists("C:\sendmail") Then
        'on the day before release, I added support for sendmail
        'unfortunatly, in perl4linux, the command is:
        'open MAIL, '| /usr/lib/sendmail -t -oi';
        'print MAIL 'To: ashley___harris@hotmail.com\n'
        'print MAIL 'From: webserver@user.com\n'
        'etc. etc.
        '
        'unfortunatly, there is not file on most windows computers called:
        ' "| /usr/lib/sendmail -t -oi"
        'so, you will instead have to open the file:
        ' "C:\sendmail"
        '(the rest of the code remains the same)
        dosendmail
        fso.DeleteFile "C:\sendmail", True
    End If
    
    executingcgi = False
    'if the tag is 'safe' the wscontrol can be closed when the data is sent. (to stop
    'streaming code from closing 1/4second into an mp3, it was a real gotcha for several hours)
    ws(sendbackindex).Tag = "safe"
    On Error Resume Next
    Kill tempkill
    tempkill = ""
    On Error GoTo 0
End Sub

Private Sub ws_ConnectionRequest(Index As Integer, ByVal requestID As Long)
    'whenever someone requests a webpage, move their request to the side, so
    'we can accept more. (Just I've notice IE will request about 10 files at once)
    'The number of silmultanious connections is dependant only on memory for buffer space.
    
    'Is there are free one perchance?
tryagain:
    For a = 1 To ws.UBound
        If ws(a).State = 0 Or ws(a).State = 8 Then
            ws(a).Close
            ws(a).accept requestID
            stats.List(a) = "Accepted " & requestID
            connections = connections + 1
            Exit Sub
        End If
        DoEvents
    Next a
    'This puts a limit on the number of silmultanius connections
    'to remove, comment out the next line
    'GoTo tryagain
    DoEvents
    'guess not, well, make one!
    connections = connections + 1
    num = ws.UBound + 1
    Load ws(num)
    ws(num).accept requestID
End Sub

Private Sub ws_DataArrival(Index As Integer, ByVal bytesTotal As Long)
    'The main sub, handles EVERYTHING
    If docroot = "\" Then docroot = App.path
    
    Dim a As String, filedata As String, headers As Dictionary
    If ws(Index).State <> 7 Then ws(Index).Close: Exit Sub
    ws(Index).getdata a
    Debug.Print a
    
    'ok, the way I've done this is wrong, because, say someone uploads a file via a cgi that's, say 500kb.
    'the browser will split it into packets of (say) 8kb each, and will send them here.
    'which means this function will be called first with the request and the first 7.5kb of the file.
    'then again, with the second chunk of the file, but no headers, which will crash this because theres
    'no headers to parse. I was stuck, and, cause it was 2AM in the morning, I thought of this stupid
    'and unreliable solution. This is a FIXME! (actually, it works rather good)
    If bytesTotal = 8192 Or InStr(1, a, "multipart/form-data", TextCompare) Then
        ws(Index).Tag = ws(Index).Tag & a
        stats.List(Index) = "Incomming File..."
        Exit Sub
    Else
        a = ws(Index).Tag & a
        ws(Index).Tag = ""
    End If
    
    
    If a = "" Then
        ws(Index).Close
        Exit Sub
    End If
    
    otherheaders = Mid(a & vbNewLine, InStr(1, a, vbNewLine) + 2)
    otherheaders = Mid(otherheaders, 1, InStr(1, otherheaders, vbNewLine & vbNewLine) - 1)
    
    Set headers = parseheaders(CStr(otherheaders))
    
    If InStr(1, a, vbNewLine & vbNewLine) > 0 Then postdata = Mid(a, InStr(1, a, vbNewLine & vbNewLine) + 4) Else postdata = ""
    
    If CLng(headers("Content-length")) > Len(postdata) Then
        'ok, there are more packets comming, were executing too early
        'ie5 for mac is the cause of this code
        stats.List(Index) = "Awaiting POST data"
        ws(Index).Tag = ws(Index).Tag & a
        Exit Sub
    End If
    
    If headers("Content-type") = "application/x-www-form-urlencoded" And IsEmpty(headers("Content-length")) Then
        'my mac did this while posting the feedback form. makes no sense, but, it works.
        ' (it splits the request in 2)
        stats.List(Index) = "Awaiting POST data"
        ws(Index).Tag = ws(Index).Tag & a
        Exit Sub
    End If
    
    Label1.Caption = "connections: " & connections
    
    'get the request, and then take the first line of it, then take just the request page
    a = Left(a, InStr(1, a, vbNewLine) - 1)
    a = Mid(a, InStr(1, a, " ") + 1)
    a = Left(a, InStr(1, a, " ") - 1)

    
    While Mid(a, 1, 3) = "/.."
        a = Mid(a, 4)
    Wend
    
    'display what file is being requested
    Label2.Caption = a
    
    'display to whom the file is being send
    Label3.Caption = ws(Index).RemoteHostIP
    
    If Right(a, 1) = "/" Then a = a & default
    
    'seperated the request string into filename and GET data
    If Not CBool(InStr(1, a, "?")) Then
        a = a & "?"
    End If
    cmd = Left(a, InStr(1, a, "?") - 1)
    data = Mid(a, InStr(1, a, "?") + 1)
    cmd = Replace(cmd, "/", "\")
    cmd = Replace(cmd, "%20", " ")
    path = fso.BuildPath(docroot, cmd)
    
    'sometimes if you get flooded, this line crashes
    On Error Resume Next
    stats.List(Index) = cmd & "?" & data
    On Error GoTo 0
    'any request for \awebserverlogo.png will point to a file in the webserver directory.
    '(regardless of settings) (used for directory listings)
    If cmd = "\awebserverlogo.png" Then path = fso.BuildPath(App.path, "logo.png")
    
    'Write the request in the database
    rs.AddNew
    rs("page") = cmd
    rs("requeststring") = IIf(data = "", Null, data)
    rs("time") = Now
    rs("ip address") = ws(Index).RemoteHostIP
    rs.Update
    
    header = "HTTP/1.1 200 OK" & vbNewLine & "Server: A's webserver" & vbNewLine & "Host: " & ws(Index).LocalIP & vbNewLine
    
    If Check1.value <> 0 Then
        'the webserver is paused, inform the client to please hold, their call is important to us, etc.
        
        back = "<HTML><HEAD><META Http-equiv=""refresh"" content=""30""><TITLE>Temporarily Down</TITLE></HEAD><BODY>" & _
        "For the last " & Int(Timer - downstart) & " seconds, this website has been down for servicing, and will be back online within 5 minutes.<P>This page will automaticly load when the webserver is back online."

        header = header & "Connection: close" & vbNewLine & "Content-Length: " & Len(back) & vbNewLine
        header = header & "Content-Type: " & "Text/html" & vbNewLine & vbNewLine
        
        ws(Index).SendData header & back
        ws(Index).Tag = "safe"
        Exit Sub
    End If
    
    If fso.FileExists(path & ".redirect") Then
        '!!!!REDIRECTION!!!!
        'say I want all requests for 'index.html' to go to 'test.html
        'I'd create a file called 'index.html.redirect'
        'and place in there the path of the file to direct to.
        '(I was trying to make it simply a windows shortcut, but, didn't work)
        Set ts = fso.OpenTextFile(path & ".redirect")
        qqq = ts.ReadLine
        header = Replace(header, "200 OK", "302 FOUND")
        ts.Close
        header = header & "Location: " & qqq & vbNewLine & vbNewLine
        stats.List(Index) = "Redirecting to " & qqq
        ws(Index).SendData header
        ws(Index).Tag = "safe"
        Exit Sub
    End If
    
    If default = "" And Right(cmd, 1) = "\" Or (Not fso.FileExists(path) And Right(cmd, 1) = "\") Then
        'do a directory listing
        
        stats.List(Index) = "Directory Listing"
        
        back = dirlisting(CStr(path), Replace(cmd, "\", "/"), CStr(data))
        
        header = header & "Connection: close" & vbNewLine & "Content-Length: " & Len(back) & vbNewLine
        header = header & "Content-Type: " & "Text/html" & vbNewLine & vbNewLine
        
        filedata = header & back
        
        init = Len(filedata)
        'stream the directory listing back to the client.
        On Local Error GoTo outofherenow
        While Len(filedata) > 0
            If ws(Index).State <> 7 Then GoTo outofherenow
            ws(Index).SendData Mid(filedata, 1, Int(bw / 1))
            filedata = Mid(filedata, Int(bw / 1) + 1)
            t = Timer + 1
            While t > Timer
                DoEvents
            Wend
            stats.List(Index) = 100 - Int(Len(filedata) / init * 100) & "%DIRLISTSTREAM"
        Wend
        ws(Index).Close
        Exit Sub
    End If
        
    If Not fso.FileExists(path) Then
        'before we say file not found, check out whether we really have been
        'submitted more data then we bargained for (see $ENV{PATH_INFO))
        
        If Len(parsepathinfo(CStr(path))(0)) > 3 Then
            'take note that the request for:
            '/index.cgi/usefulldata.txt will result in executing the file index.cgi with
            '$ENV{PATH_INFO} = "/usefulldata.txt"
            pathinfo = parsepathinfo(CStr(path))(1)
            path = parsepathinfo(CStr(path))(0)
            GoTo itisthereyoubigstupidwindowsmachine
        End If
        'file doesn't exist, ok, so load 404 page
filenotfound:
        a = error404
        stats.List(Index) = "404 " & cmd
        'reprocess all this
        If Not CBool(InStr(1, a, "?")) Then
            a = a & "?"
        End If
        
        cmd = Left(a, InStr(1, a, "?") - 1)
        data = Mid(a, InStr(1, a, "?") + 1)
        cmd = Replace(cmd, "/", "\")
        path = fso.BuildPath(docroot, cmd)
        
        'should be HTTP/1.0 404 ERROR, but then IE didn't display it, so, just say 200 OK
    End If
    
itisthereyoubigstupidwindowsmachine:
    
    'Is it a cgi script? (extensions in here are executed)
    Select Case Mid(path, InStrRev(path, ".") + 1)
    Case "asp" 'M$'s active server pages
        iscgi = True
    Case "cgi" 'standard perl scripts
        iscgi = True
    Case "pl"
        iscgi = True
    Case "dll" 'my own type of cgi script
        iscgi = True
    Case "php" 'PHP scripts are SEMI supported
        iscgi = True
    Case Else 'something non-cgi (ie html or mp3 etc)
        iscgi = False
    End Select
    
    If Not iscgi Then
        'just a plain file, ok, send it back.
        header = header & "Accept-Ranges-: bytes" & vbNewLine
        On Error GoTo filenotfound
        On Error GoTo 0
        'Asign the extensions to the types.
        'course, if I've forgotten any, just add them
        Select Case LCase(Mid(path, InStrRev(path, ".") + 1))
        Case "html" 'HTML file
            cont = "text/html"
        Case "htm"  'HTML file
            cont = "text/html"
        Case "txt"  'TEXT (notepad) file
            cont = "text/text"
        Case "js"   'Javascript library
            cont = "text/html" 'YES, that is right
        Case "pdf"  'ADOBE ACROBAT PDF file
            cont = "application/pdf"
        Case "sit"  'STUFFIT archive
            cont = "application/x-stuffit"
        Case "avi"  'AUDIO VISUAL video
            cont = "video/avi"
        Case "css"  'CASSCADING STYLE SHEET formating info
            cont = "text/css"
        Case "swf"  'SHOCKWAVE FLASH animation
            cont = "application/futuresplash"
        Case "jpg"  'JOINT PHOTOGROPHERS EXPERT GROUP image
            cont = "image/jpeg"
        Case "xls"  'MICROSOFT EXCEL spreadsheet
            cont = "application/vnd.ms-excel"
        Case "doc"  'MICROSOFT WORD formated text
            cont = "application/vnd.ms-word"
        Case "midi" 'MUSICAL INSTRUMENT DIGITAL INTERFACE music
            cont = "audio/midi"
        Case "mp3"  'MOTION PICTURE EXPERT GROUP LAYER 3 music
            cont = "audio/mpeg"
        Case "rm"   'REAL MEDIA video
            cont = "application/vnd.rn-realmedia"
        Case "rtf"  'MICROSOFT RICHTEXT formatted text
            cont = "application/msword"
        Case "wav"  'WAVE sound
            cont = "audio/wav"
        Case "zip"  'ZIP archive
            cont = "application/x-zip"
        Case "png"  'PORTABLE NETWORK GRAPGHICS image
            cont = "image/png"
        Case "gif"  'COMPUSERVE GRAPHICS INTERGHANGE FORMAT Image
            cont = "image/gif"
        End Select
        
        'We support ranged downloads (resume), parse out the request, and use it.
        If headers("range") <> "" Then
            bytes = Mid(headers("range"), InStr(1, headers("range"), "=") + 1)
            start = Mid(bytes, InStr(1, bytes, "=") + 1)
            finish = Mid(bytes, InStr(1, bytes, "-") + 1)
            start = Replace(start, "-", "")
        End If
        
        'Load up the file
        Open path For Binary Access Read As #1
        filedata = Space$(LOF(1))
        origsize = Len(filedata)
        Get #1, , filedata
        Close #1
        
        filedata = dossi(filedata, fso.GetParentFolderName(path), CStr(path))
        
        
        'if you say finish at nothing, it means finish at the end.
        If finish = "" Then finish = origsize
        
        'sort it out for ranged requests
        If headers("range") <> "" Then
            filedata = Mid(filedata, 1, finish)
            filedata = Mid(filedata, start + 1)
            header = Replace(header, "200 OK", "206 Partial Content")
            'if the next line isn't perfect, resume wont work. Even comercial servers sometimes get this
            'wrong (check out mp3.com, that's the best example I can think of off my head.)
            header = header & "Content-Range: bytes " & start & "-" & finish - 1 & "/" & origsize & vbNewLine
        End If
        
        'Content-length takes into consideration ranged downloads.
        header = header & "Content-Length: " & Len(filedata) & vbNewLine
        
        'Finish the header
        header = header & "Connection: close" & vbNewLine
        header = header & "Content-Type: " & cont & vbNewLine & vbNewLine
        filedata = header & filedata
        
        'Debug.Print filedata
        
        'send the reply, making sure we dont send more data then our bandwidth
        'allows (for viewing websites over modems/ISDN/slow modems, or for beta
        'testing flash movies or the like. Also of use in practicle application
        'only allowing x bandwidth to downloading files, for instance.
        init = Len(filedata)
        On Local Error GoTo 0
        While Len(filedata) > 0
            stats.List(Index) = 100 - Int(Len(filedata) / init * 100) & "% " & cmd
            If ws(Index).State <> 7 Then GoTo outofherenow
            ws(Index).SendData Mid(filedata, 1, Int(bw / 1))
            filedata = Mid(filedata, Int(bw / 1) + 1)
            t = Timer + 1
            While t > Timer
                DoEvents
            Wend
        Wend
outofherenow:
        
        ws(Index).Close
    
    ElseIf Right(path, 4) = ".dll" Then
        'It's my own type of cgi-script! run it
        
        'Not yet!
    ElseIf Right(path, 4) = ".asp" Then
    
        'Yep, we finaly have asp support!!!!!!!!!!!!!!!!
        
        'be polite to other requests.
        While executingcgi
            DoEvents
        Wend
        executingcgi = True
        
        asppath = path
        stats.List(Index) = "Exec ASP:" & cmd
        ChDir Left(path, InStrRev(path, "\"))
        
        'I have these two beutiful functions to do it all for me
        'but I can't get them to work
        'screw it, do it like I did with php!
        'aspexec.ExtractHttpGetParams data
        'aspexec.ExtractHttpPostParams postdata
        
        tmp = "response.write ""Content-Type: text/html"" & vbcrlf & vbcrlf" & vbNewLine
        Dim parseda As New Dictionary
        
        Set parseda = tophpvariables(CStr(data), "", "")
        For q = LBound(parseda.Keys) To UBound(parseda.Keys)
            k = parseda.Keys(q)
            v = parseda(k)
            tmp = tmp & "request.QueryString(""" & k & """) = """ & v & """" & vbNewLine
        Next q
        Set parseda = tophpvariables("", CStr(postdata), "")
        For q = LBound(parseda.Keys) To UBound(parseda.Keys)
            k = parseda.Keys(q)
            v = parseda(k)
            tmp = tmp & "request.Form(""" & k & """) = """ & v & """" & vbNewLine
        Next q
        Set parseda = tophpvariables("", "", CStr(headers("cookie")))
        For q = LBound(parseda.Keys) To UBound(parseda.Keys)
            k = parseda.Keys(q)
            v = parseda(k)
            tmp = tmp & "request.Cookies(""" & k & """) = """ & v & """" & vbNewLine
        Next q
        aspexec.initscript = "request.form.CompareMode = 1" & vbNewLine & "request.QueryString.CompareMode = 1" & vbNewLine & tmp
        aspexec.ParseTextToFile path, "C:\temp.txt"
        
        sendbackindex = Index
        Timer2 = True
        asppath = ""
        
    ElseIf Right(path, 4) = ".php" Then
        'PHP SUPPORT!
        'I have never programed in php in my life, and I've glimpsed php code only once
        'hence why it lacks some of the features (Like what? I just added cookies!) of perl.
        
        'be polite to other requests.
        While executingcgi
            DoEvents
        Wend
        executingcgi = True
        
        stats.List(Index) = "Exec PHP:" & cmd
        
        'go to the directory with the php script in it. (tell windows where '.' is)
        ChDir Left(path, InStrRev(path, "\"))
        
        'Dim parsed As Dictionary
        Dim parsed As Dictionary
        Set parsed = tophpvariables(CStr(data), CStr(postdata), CStr(headers("cookie")))
        
        fn = path & "temp.php" 'create temporary php script
        
        tempkill = fn
        
        tmp = "<?php" & vbNewLine & "echo ""Content-Type: text/html\n\n"";" & vbNewLine
        For q = LBound(parsed.Keys) To UBound(parsed.Keys)
            k = parsed.Keys(q)
            v = parsed(k)
            tmp = tmp & "$" & k & " = """ & v & """;" & vbNewLine
        Next q
        tmp = tmp & "include(""" & path & """);" & vbNewLine & "?>"
        
        Open fn For Output As #5
        Print #5, tmp
        Close #5
        
        On Error Resume Next
        If fso.FileExists("C:\temp.txt") Then Kill "C:\temp.txt"
        On Error GoTo 0
        
        'run the perl script (PHP MUST BE IN YOUR AUTOEXEC PATH VARIABLE)
        Shell "command.com /c php-cli.exe " & fn & " >""C:\temp.txt""", vbHide
        sendbackindex = Index
        Timer2 = True
    Else
        'Run perl CGI scripts, and pipe the result back to the server
        
        'create a temp perl script, calling the script in question, setting the
        'enviroment variables QUERRY_STRING and REMOTE_ADDR, and, anything else
        'I feel like doing. These lines are what seperates us from ALL the other
        'perl-cgi webservers out there (there are at least 4)
        
        'be polite to other requests.
        While executingcgi
            DoEvents
        Wend
        executingcgi = True
        
        stats.List(Index) = "Exec PERL:" & cmd
        
        fn = path & "temp.pl" 'create temporary perl script
        tempkill = fn
        Open fn For Output As #2
        Print #2, "" & _
        "#! /usr/bin/perl" & vbNewLine & _
        "$ENV{QUERY_STRING} = '" & data & "';" & vbNewLine & _
        "$ENV{REMOTE_ADDR} = '" & ws(Index).RemoteHostIP & "';" & vbNewLine & _
        "$ENV{SERVER_SOFTWARE} = '" & "Ashley`s Webserver/1.2 (VB/Windows)" & "';" & vbNewLine & _
        "$ENV{GATEWAY_INTERFACE} = '" & "CGI/1.1" & "';" & vbNewLine & _
        "$ENV{DOCUMENT_ROOT} = '" & Replace(docroot, "\", "\\") & "';" & vbNewLine & _
        "$ENV{SERVER_PROTOCOL} = '" & "HTTP/1.1" & "';" & vbNewLine & _
        "$ENV{REQUEST_METHOD} = '" & IIf(Len(postdata) > 0, "POST", "GET") & "';" & vbNewLine & _
        "$ENV{SERVER_ADDR} = '" & ws(0).LocalIP & "';" & vbNewLine & _
        "$ENV{SCRIPT_FILENAME} = '" & Replace(path, "\", "\\") & "';" & vbNewLine & _
        "$ENV{SCRIPT_NAME} = '" & Replace(cmd, "\", "\\") & "';" & vbNewLine & _
        "$ENV{SERVER_NAME} = '" & ws(0).LocalHostName & "';" & vbNewLine & _
        "$ENV{SERVER_PORT} = '" & ws(0).LocalPort & "';" & vbNewLine & _
        "$ENV{HTTP_USER_AGENT} = '" & headers("user-agent") & "';" & vbNewLine & _
        "$ENV{HTTP_REFERER} = '" & headers("referer") & "';" & vbNewLine & _
        "$ENV{HTTP_ACCEPT_LANGUAGE} = '" & headers("accept-language") & "';" & vbNewLine & _
        "$ENV{HTTP_ACCEPT} = '" & headers("accept") & "';" & vbNewLine & _
        "$ENV{HTTP_COOKIE} = '" & headers("cookie") & "';" & vbNewLine & _
        "$ENV{CONTENT_TYPE} = '" & headers("content-type") & "';" & vbNewLine & _
        "$ENV{CONTENT_LENGTH} = '" & headers("content-length") & "';" & vbNewLine & _
        "$ENV{PATH_INFO} = '" & pathinfo & "';" & vbNewLine & _
        "open STDIN,""C:\\postdata.txt"";" & vbNewLine & _
        "do '" & path & "';" & vbNewLine & _
        "close STDIN;"
        Close #2
        'I don't know how the 3rd to last line of that script worked. it seems like it
        'should crash perl. but, good old opensource comunity pulled through, and we have post support!
        '(I'm using activeperl 5.6.1)
        
        Open "C:\postdata.txt" For Output As #3
        Print #3, postdata
        Close #3
        
        'go to the directory with the cgi script in it. (To avoid a bug in either vb or perl)
        ChDir Left(fn, InStrRev(fn, "\"))
        
        On Error Resume Next
        If fso.FileExists("C:\temp.txt") Then Kill "C:\temp.txt"
        On Error GoTo 0
        
        'run the perl script (PERL MUST BE IN YOUR AUTOEXEC PATH VARIABLE)
        Shell "command.com /c perl " & fso.GetFileName(fn) & " >""C:\temp.txt""", vbHide
        'Debug.Print "perl " & fso.GetFileName(fn) & " >""C:\temp.txt"""
        sendbackindex = Index
        Timer2 = True
        '(now the script runs, and we wont hear from it again until timer2 is called in 5 seconds)
    End If
    
End Sub
    
Private Sub ws_Error(Index As Integer, ByVal number As Integer, Description As String, ByVal Scode As Long, ByVal Source As String, ByVal HelpFile As String, ByVal HelpContext As Long, CancelDisplay As Boolean)
    'something went wrong, abort gracefully
    stats.List(Index) = "ERROR " & Description
    If number = 10054 Then
        stats.List(Index) = "Closed (by client)"
    End If
    ws(Index).Close
    If Index = 0 Then ws(0).listen ' Else Unload ws(index)
End Sub

Private Sub ws_SendComplete(Index As Integer)
    If ws(Index).Tag = "safe" Then
        'close when done
        ws(Index).Close
        ws(Index).Tag = ""
        stats.List(Index) = "closed"
    End If
End Sub


Public Function dirlisting(dir As String, url As String, data As String) As String
    'do a SMART directory listing!
    'DIR = path on computer, ie 'C:\mp3s'
    'URL = url on browser bar at current, ie '/mp3s'
    'data = what follows the ? in the url, ie '' if 'a' then shows only those starting with a
    
    Dim col As String
    If Right(url, 1) <> "/" Then url = url & "/"
    If Right(dir, 1) <> "\" Then dir = dir & "\"
    
    'set the foundations for a nice HTML page
    back = "<HTML><HEAD><TITLE>" & dir & "</TITLE></HEAD><BODY bgcolor=FFFFFF>" & vbNewLine
    
    'damn it. well, tell them were sorry!
    If fso.FileExists(dir) Then
        back = back & "FOLDER: " & dir & " NOT FOUND"
        dirlisting = back
        Exit Function
    End If
    
    'at the top there are the 'show-only' letters, these are them. (the first is show-all)
    back = back & "<CENTER><A HREF=""?"">[*]</A>"
    For q = 1 To 26
        back = back & " <A HREF=""?" & Chr(96 + q) & """>[" & Chr(64 + q) & "]</A> "
    Next q
    back = back & "</CENTER>"
    
    'the column headers
    back = back & "<TABLE cols=3 cellspacing=0><tr><td><B>Name</B></td><td><B>Size (bytes)</B></td><td><B>Date</B></td></tr></table>"
    
    'read in an array of subdirectorys below the 'dir' folder
    Dim x() As String
    x() = GetSubFolders(dir)
    On Error GoTo nosubdirs
    
    'now, print them out, rather nicely
    For a = 0 To UBound(x())
        fname = x(a)
        fsize = "-"
        fdate = "-"
        If LCase(Mid(fname, 1, 1)) = LCase(data) Or data = "" Or Len(data) > 1 Then
            If col = "FFFFFF" Then col = "CCCCCC" Else col = "FFFFFF" 'alternate gray line
            'why do I create an individual table for each row? to allow streaming of the directory list!
            back = back & "<TABLE cols=3 cellspacing=0><tr bgcolor=" & col & "><td width=300><A HREF=""" & url & fname & "\""><NOBR>" & Mid(fname, 1, 32) & IIf(Len(fname) > 32, "...", "")
            back = back & "</NOBR></A></td><td width=150>" & fsize & "</td><td width=150><NOBR>" & fdate
            back = back & "</NOBR></td></tr></TABLE>" & vbNewLine
        End If
    Next a
    On Error GoTo 0
nosubdirs:
    'now, do all that for files:
    File1.path = dir
    For a = 0 To File1.ListCount - 1
        fname = File1.List(a)
        If LCase(Mid(fname, 1, 1)) = LCase(data) Or data = "" Or Len(data) > 1 Then
            If col = "FFFFFF" Then col = "CCCCCC" Else col = "FFFFFF" 'alternate gray lines
            fsize = FileLen(dir & fname)
            fdate = FileDateTime(dir & fname)
            back = back & "<TABLE cols=3 cellspacing=0><tr bgcolor=" & col & "><td width=300><A HREF=""" & url & fname & """><NOBR>" & Mid(fname, 1, 32) & IIf(Len(fname) > 32, "...", "")
            back = back & "</NOBR></A></td><td width=150>" & fsize & "</td><td width=150><NOBR>" & fdate
            back = back & "</NOBR></td></tr></TABLE>" & vbNewLine
        End If
    Next a
    'put my logo on the bottom. (note '/awebserverlogo.png' is an exception, see ws_dataarival for what I mean)
    back = back & "</TABLE><P><CENTER><IMG src=""/awebserverlogo.png"" width=128 height=128></CENTER></BODY></HTML>"
    dirlisting = back
End Function

Function GetSubFolders(folder) As Variant
    Dim fnames() As String
    
   If Right(folder, 1) <> "\" Then folder = folder & "\"
   fd = dir(folder, vbDirectory)
   While fd <> ""
    If (GetAttr(folder & fd) And vbDirectory) = vbDirectory Then
        push fnames(), fd
    End If
    fd = dir()
   Wend
   GetSubFolders = fnames()
End Function

Private Sub push(ary, value) 'this modifies parent ary object
    On Error GoTo init
    If value = "." Then Exit Sub
    x = UBound(ary) '<-throws Error If Not initalized
    ReDim Preserve ary(UBound(ary) + 1)
    ary(UBound(ary)) = value
    Exit Sub
init: ReDim ary(0): ary(0) = value
End Sub

Private Function parseheaders(h As String) As Dictionary
    'turn
    'cookie: name=ashley
    'referer: www.pornrus.com
    'accept: all the stuff that goes here.
    'langauge: en-au
    'etc.
    'into a datadictonary.
    Dim k As String, v As String
    Set p = New Dictionary
    p.CompareMode = TextCompare
    h = h & vbNewLine
    h = Replace(h, ": ", ":")
    While h <> vbNewLine And h <> ""
        k = LCase(Mid(h, 1, InStr(1, h, ":") - 1))
        h = Mid(h, Len(k) + 2)
        v = Mid(h, 1, InStr(1, h, vbNewLine) - 1)

        h = Mid(h, Len(v) + 3)
        p(k) = v
    Wend
    Set parseheaders = p
End Function

Public Function dossi(html As String, curdir As String, filepath As String) As String
    'this function evaluates BASIC ssi (server side includes)
    'basicly you can include a line in your html file saying '<!--#include file="header.txt"-->',
    'header.txt will be loaded, and it's contents inserted where the tag was. Nice idea,
    'never used it before (I've used javascript previously), but, it's a rather easy feature to implement
    'so, why not put it in (I'm building support for this from a beginers guide to it, so, it may lack some
    'advanced features. (hey, I'm a beginer at ssi :-) lol
    Dim tmphtml As String, ssitag As String, ssitype As String, ssivalue As String, fp As String, ts As TextStream
    tmphtml = html
    While InStr(1, tmphtml, "<!--#") > 0
        tmphtml = Mid(tmphtml, InStr(1, tmphtml, "<!--#"))
        ssitag = Mid(tmphtml, 1, InStr(1, tmphtml, "-->") + 2)
        tmphtml = Mid(tmphtml, 3)
        ssitype = Mid(ssitag, 6)
        ssitype = Mid(ssitype, 1, InStr(1, ssitype, " ") - 1)
        ssivalue = Mid(ssitag, InStr(1, ssitag, """") + 1)
        ssivalue = Mid(ssivalue, 1, InStr(1, ssivalue, """") - 1)
        Select Case LCase(ssitype)
        Case "include" '  THIS IS THE MOST IMPORTANT ONE!
            fp = fso.BuildPath(curdir, ssivalue)
            If fso.FileExists(fp) Then
                Set ts = fso.OpenTextFile(fp)
                html = Replace(html, ssitag, ts.ReadAll)
                ts.Close
            End If
        Case "echo"
            Select Case LCase(ssivalue)
            Case "date_local"
                html = Replace(html, ssitag, Now)
            Case "date_gmt"
                html = Replace(html, ssitag, Now - gmtoffset)
            Case "document_name"
                html = Replace(html, ssitag, fso.GetFileName(filepath))
            Case "last_modified"
                html = Replace(html, ssitag, FileDateTime(filepath))
            End Select
        Case "exec" 'I said BASIC!
        Case "fsize" 'BASIC!
        End Select
    Wend
    dossi = html
End Function

Public Function tophpvariables(getdata As String, postdata As String, cookiedata As String) As Dictionary
    'takes the get data (?message=1), the post data (Feedback=Hi%2E+Im+Ashley etc), and cookies (session=1414)
    'and converts it all to one nice data dictonary
    Dim back As New Dictionary
    getdata = getdata & "&" & postdata
    Keys = Split(getdata, "&")
    For a = 0 To UBound(Keys)
        If InStr(1, Keys(a), "=") = 0 Then Keys(a) = Keys(a) & "="
        k = Mid(Keys(a), 1, InStr(1, Keys(a), "=") - 1)
        v = Mid(Keys(a), InStr(1, Keys(a), "=") + 1)
        k = fromhttpstringtostring(CStr(k))
        v = fromhttpstringtostring(CStr(v))
        If k <> "" Then back(k) = v
    Next a
    Set tophpvariables = back
End Function

Public Function fromhttpstringtostring(httpstring As String) As String
    'turns 'This%20is%20cool' into 'This is cool'
    httpstring = Replace(httpstring, "+", " ")
    While InStr(1, httpstring, "%")
        fromhttpstringtostring = fromhttpstringtostring & Mid(httpstring, 1, InStr(1, httpstring, "%") - 1)
        httpstring = Mid(httpstring, InStr(1, httpstring, "%"))
        esc = Mid(httpstring, 1, 3)
        ch = Chr(hexdiget(Mid(esc, 2, 1)) * 16 + hexdiget(Mid(esc, 3, 1)))
        httpstring = Replace(httpstring, esc, ch)
    Wend
    fromhttpstringtostring = fromhttpstringtostring & httpstring
End Function

Public Function hexdiget(d) As Integer
    'converts a number from 0-15 into a hexeqiverlant (ie a=10)
    If d = Val(CStr(d)) Then hexdiget = d: Exit Function
    Select Case LCase(d)
    Case "a"
        hexdiget = 10
    Case "b"
        hexdiget = 11
    Case "c"
        hexdiget = 12
    Case "d"
        hexdiget = 13
    Case "e"
        hexdiget = 14
    Case "f"
        hexdiget = 15
    End Select
End Function

Public Function parsepathinfo(path As String)
    Dim tmp(1) As String
    'there is a rather nice feature of apache that this webserver falls short off.
    'PATH_INFO! Yes, on apache, you can request a page like so:
    'http://127.0.0.1/cgi-bin/myscript.pl/subfolder/etc.txt (with /subfolder/etc.txt apearing as $env{PATH_INFO};
    'so, we basicly have a 404 error for a file called:
    'C:\docroot\browse.cgi\development\webserver\info.html
    '(note, this can be used in conjuction with QUERY_STRING)
    sourcepath = path
    While Not fso.FileExists(sourcepath) And Len(sourcepath) > 3
        sourcepath = fso.GetParentFolderName(sourcepath)
    Wend
    
    tmp(0) = sourcepath
    tmp(1) = Mid(path, Len(sourcepath) + 1)
    parsepathinfo = tmp
End Function

Public Sub dosendmail()
    'read in the file ("C:\sendmail") and execute it
    '(Perl thinks that it should be talking to an app, it's talking to
    ' a file in this case)
    'mail is formatted preaty similar to http, when you think about it.
    
    Dim ts As TextStream, h As Dictionary
    Set ts = fso.OpenTextFile("C:\sendmail")
    a = ts.ReadAll
    ts.Close
    'note,  because they're so similar, I'm using the http header parser on the
    'email headers. LETS HEAR IT FOR LAZY PEOPLE!
    Set h = parseheaders(Mid(a, 1, InStr(1, a, vbNewLine & vbNewLine) - 1))
    h("X-Mailer") = "Ashleys Webserver 1.2"
    
    'perform an mx lookup on that email address
    '(ie "ashley___harris@hotmail.com" = "mx01.hotmail.com")
    MX1.Domain = Mid(h("to"), InStr(1, h("to"), "@") + 1)
    
    smtpserver = MX1.GetMX
    
    If smtpserver = "" Then
        Debug.Print "sendmail aborted, cant resolve " & MX1.Domain
        Exit Sub
    End If
tryagain:
    smtpserver = MX1.GetMX
    smtp.Close
    sendmailstep = 0
    smtp.RemoteHost = smtpserver
    smtp.RemotePort = 25
    smtp.LocalPort = 0
    
    On Error GoTo tryagain
    
    smtp.Close
    smtp.connect
    sendmailstep = 0
    While smtp.State <> 7
        DoEvents
    Wend
    
    smtpwait 1
    
    smtp.SendData "HELO from.ashleyswebserver.1.2.com" & vbNewLine
    Debug.Print "SMTPOUT: HELO from.ashleyswebserver.1.2.com"
    smtpwait 2
    
    smtp.SendData "MAIL FROM: " & h("from") & vbNewLine
    Debug.Print "SMTPOUT: MAIL FROM: " & h("from")
    smtpwait 3
    
    smtp.SendData "RCPT TO: " & h("to") & vbNewLine
    Debug.Print "SMTPOUT: RCPT TO: " & h("to")
    smtpwait 4
    
    smtp.SendData "DATA" & vbNewLine
    Debug.Print "SMTPOUT: DATA"
    smtpwait 5
    
    For q = LBound(h.Keys) To UBound(h.Keys)
        smtp.SendData h.Keys(q) & ": " & h(h.Keys(q)) & vbNewLine
        Debug.Print "SMTPOUT: " & h.Keys(q) & ": " & h(h.Keys(q))
    Next q
    smtp.SendData vbNewLine & Mid(a, InStr(1, a, vbNewLine & vbNewLine) + 3)
    Debug.Print "SMTPOUT: " & Mid(a, InStr(1, a, vbNewLine & vbNewLine) + 3)
    smtp.SendData vbNewLine & "." & vbNewLine
    Debug.Print "SMTPOUT: ."
    smtpwait 6
    
    smtp.SendData "QUIT"
    Debug.Print "SMTPOUT: QUIT"
    'smtpwait 7
    
    smtp.Close
    Debug.Print "MAIL SUCCESSFULLY SENT!"
End Sub

Public Sub smtpwait(waittill As Integer)
    t = Timer + 20
    While sendmailstep < waittill And t > Timer And smtp.State = 7
        DoEvents
    Wend
    sendmailstep = waittill
End Sub
