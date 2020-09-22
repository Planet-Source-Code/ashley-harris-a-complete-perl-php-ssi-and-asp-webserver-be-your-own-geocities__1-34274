VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CAspParser"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'This code is copyrighted to Mike Doonan
'He gave it to me.

'I have modified it slightly in unacnowledged places


' Internal variables
Private m_objResponse As Object
Private m_objRequest As Object
Private m_objFSO As Object
Private m_objserver As Object
Private m_objScriptCtl As ScriptControl

Public initscript As String

' API
Private Declare Function PathIsRelative Lib "shlwapi.dll" Alias "PathIsRelativeA" (ByVal strPath As String) As Boolean

' Constants
Private Const ASP_INITCODE = "<%"
Private Const ASP_ENDCODE = "%>"


' SetScriptControl : Receive and store the instance
'                  : of the ScriptControl to work with
'-------------------------------------------------------------
Public Sub SetScriptControl(ByVal oSC As ScriptControl)
    Set m_objScriptCtl = oSC
End Sub


' Initialize : Manage to make the class ready for parsing
'            : the ASP script code blocks
'-------------------------------------------------------------
Public Function Initialize() As Boolean
    If m_objScriptCtl Is Nothing Then
        Exit Function
    End If

    ' Initialize the Script Control
    m_objScriptCtl.Language = "VBScript"
    
    ' Populate the script's namespace with fake ASP objects
    Set m_objResponse = CreateObject("MyASP.Response")
    m_objScriptCtl.AddObject "Response", m_objResponse

    Set m_objRequest = New aspclassrequest
    m_objScriptCtl.AddObject "Request", m_objRequest
    
    Set m_objserver = New aspclassserver
    m_objScriptCtl.AddObject "Server", m_objserver
    
    Set m_objFSO = CreateObject("Scripting.FileSystemObject")
    m_objScriptCtl.AddObject "FileSystem", m_objFSO
    
    m_objScriptCtl.AddCode "X_OFFLINE = True"
    
    
End Function


' ParseTextToFile : Extract the <%..%> code blocks and process
'                 : them separately through the Script Control
'-------------------------------------------------------------
Public Function ParseTextToFile(ByVal aspFile As String, ByVal strFile As String) As Boolean

    Dim fso As Object, f As Object
    Dim strBuf As String
    Dim strParams As String
    Dim nPos As Integer
    
    ' Strip off any cmd line param: ?var1=v1&var2=v2
    nPos = InStr(1, aspFile, "?", vbTextCompare)
    If nPos > 0 Then
        strParams = Right(aspFile, Len(aspFile) - nPos)
        ExtractHttpGetParams strParams
        
        ' Truncates the URL
        aspFile = Left(aspFile, nPos - 1)
    End If
    
    ' Check against the ASP extension
    If Not CheckInputFile(aspFile) Then
        ParseTextToFile = False
        Exit Function
    End If
        
    ' Read the ASP file into memory
    Set fso = CreateObject("Scripting.FileSystemObject")
    Set f = fso.OpenTextFile(aspFile)
    strBuf = f.ReadAll()
    f.Close
  
    ' Clear the Response's buffer
    m_objResponse.Clear
    
    ' Walk through the text and isolate the code blocks
    
    script = initscript & vbNewLine
    
    'Err.Raise 23452 '(to get my attention -ashley)
    Do
        ' Search for the opening tag "<%"
        Dim nStartPos As Integer, nEndPos As Integer
        nStartPos = InStr(1, strBuf, ASP_INITCODE, vbTextCompare)
        
        ' If no tag is found, then output the remaining text
        If nStartPos = 0 Then
            script = script & vbNewLine & "response.write """ & VBise(strBuf) & """"
            Exit Do
        End If
        
        ' If <% has been found, output the preceeding text through Response
        script = script & vbNewLine & "response.write """ & VBise(Left(strBuf, nStartPos - 1)) & """"
        
        ' Move the pointer forward by the length of "<%"
        nStartPos = nStartPos + Len(ASP_INITCODE)
        
        ' Search for the closing tag "%>"
        nEndPos = InStr(nStartPos, strBuf, ASP_ENDCODE, vbTextCompare)
        
        ' If no tag is found, then error
        If nEndPos = 0 Then
            ParseTextToFile = False
            Exit Function
        End If
        
        ' Grab the script text
        Dim strScript As String
        strScript = Mid(strBuf, nStartPos, nEndPos - nStartPos)
        
        ' Resolve possible ambiguities
        strScript = ResolveAmbiguity(strScript)
        
        script = script & vbNewLine & strScript
        
        ' Execute the script (to many probs, why the hell would we execute it here -ashley)
        'm_objScriptCtl.ExecuteStatement strScript
        
        ' In case you called Response.End...
        If m_objResponse.CanContinue = False Then
            Exit Do
        End If
        
        ' Move the pointer forward by the length of "%>"
        strBuf = Mid(strBuf, nEndPos + Len(ASP_ENDCODE))
    Loop
        
        
    'NOW we execute the script (ashley)
    Err.Clear
    On Error Resume Next
    m_objScriptCtl.ExecuteStatement script
    If Len(Err.Description) > 0 Then
        m_objResponse.Write "<HTML><BODY>An error has occured in <PRE>" & aspFile & "</PRE><P>" & Err.Description & "<P>Please be warned that this is only a partitial implementation of ASP, if you get the error object not found for a well known existing object, or if you get method not found for an existing method, you may need to write it yourself. See 'aspclassserver' for examples.</BODY></HTML>"
        
    End If
    
    
    ' Save to file
    Set f = fso.CreateTextFile(strFile)
    f.Write m_objResponse.ResponseBuffer
    f.Close
    Set f = Nothing
    Set fso = Nothing

    ParseTextToFile = True
End Function


' ResolveAmbiguity : Modify the script code before execution to
'                  : avoid possible misunderstandings. For
'                  : example, <%=x%>. Here x becomes Response
'-------------------------------------------------------------
Private Function ResolveAmbiguity(ByVal strScript As String) As String
    ' If the string begins with = it is translated to
    ' Response.Write
    
    ResolveAmbiguity = strScript
    If Left(strScript, 1) = "=" Then
        ResolveAmbiguity = "Response.Write " & Trim(Mid(strScript, 2))
    End If
End Function



' CheckInputFile : Verify whether the specified file is
'                : an ASP file
'-------------------------------------------------------------
Private Function CheckInputFile(ByVal aspFile As String) As Boolean
    
    ' Verify it is an ASP file
    CheckInputFile = True
    If InStr(1, aspFile, ".asp", vbTextCompare) = 0 Then
        CheckInputFile = False
        Exit Function
    End If
    
End Function

Private Sub Class_Initialize()
    Set m_objScriptCtl = Nothing
End Sub


' ==============================================
'   Fills the QueryString collection
' ==============================================
Public Sub ExtractHttpGetParams(ByVal strParams As String)
    Dim a() As String
    Dim e As Variant
    
    ' QueryString is an instance of Scripting.Dictionary
    ' Such an object supports a RemoveAll method
    m_objRequest.Querystring.RemoveAll
    
    a = Split(strParams, "&")
    For Each e In a
            Dim v() As String
            v = Split(e, "=")
            m_objRequest.Querystring(v(0)) = Form1.fromhttpstringtostring(v(1))
    Next
End Sub


' ==============================================
'   Fills the Form collection
' ==============================================
Public Sub ExtractHttpPostParams(ByVal strParams As String)
    Dim a() As String
    Dim e As Variant
    
    ' Form is an instance of Scripting.Dictionary
    ' Such an object supports a RemoveAll method
    m_objRequest.Form.RemoveAll
    
    a = Split(strParams, "&")
    For Each e In a
            Dim v() As String
            v = Split(e, "=")
            m_objRequest.Form(v(0)) = Form1.fromhttpstringtostring(v(1))
    Next
End Sub


' ==============================================
'   Fills the ServerVariables collection
' ==============================================
Public Sub FillServerVariables(ByVal strParams As String)
    Dim a() As String
    Dim e As Variant
    
    ' Form is an instance of Scripting.Dictionary
    ' Such an object supports a RemoveAll method
    m_objRequest.ServerVariables.RemoveAll
    
    a = Split(strParams, "&")
    For Each e In a
            Dim v() As String
            v = Split(e, "=")
            m_objRequest.AddToServerVariables v(0), v(1)
    Next
End Sub

Public Function VBise(s As String) As String
    VBise = Replace(s, """", """" & """")
    VBise = Replace(VBise, vbNewLine, """ & vbnewline & """)
    
End Function
