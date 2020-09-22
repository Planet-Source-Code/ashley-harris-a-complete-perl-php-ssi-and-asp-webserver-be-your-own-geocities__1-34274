VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "aspclassrequest"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'this becomes the 'request' object in asp
'ie in asp:
'response.write request.querystring("message")
'will get the 'message' value from this dictionary

Public Form As New Dictionary
Public Querystring As New Dictionary
Public cookies As New Dictionary

''HELPP!!!! I'm an ASP newbie whose never coded in ASP!!!!
'What other methods/propertys go here?
