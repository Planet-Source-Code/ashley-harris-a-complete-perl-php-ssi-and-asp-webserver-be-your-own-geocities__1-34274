VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "aspclassserver"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'asp get's passed this class to use as it's 'server' variable
'ie, calling 'server.createobject' would come to here

Public Function CreateObject(objclass As String) As Object
    Set CreateObject = Interaction.CreateObject(objclass)
End Function

'HELP I don't know ASP! I'm writing these methods as the errors get called!!!


Public Function mappath(filename)
    'GUESS: return path to a file in the same directory with a name of filename?
    mappath = Form1.fso.BuildPath(Form1.fso.GetParentFolderName(Form1.asppath), filename)
End Function

Public Function htmlencode(i)
    'GUESS: Convert all < to &lt;??
    htmlencode = Replace(i, "<", "&lt;")
End Function
