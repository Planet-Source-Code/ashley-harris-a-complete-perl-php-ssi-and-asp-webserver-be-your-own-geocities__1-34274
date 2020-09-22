VERSION 5.00
Begin VB.Form Form2 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Setup..."
   ClientHeight    =   1830
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4680
   Icon            =   "Form2.frx":0000
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1830
   ScaleWidth      =   4680
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox Text4 
      Height          =   300
      Left            =   3525
      TabIndex        =   8
      Text            =   "5600"
      Top             =   1080
      Width           =   960
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Save"
      Height          =   345
      Left            =   180
      TabIndex        =   6
      Top             =   1170
      Width           =   1275
   End
   Begin VB.TextBox Text3 
      Height          =   285
      Left            =   1290
      TabIndex        =   4
      Text            =   "/404.html"
      Top             =   660
      Width           =   3285
   End
   Begin VB.TextBox Text2 
      Height          =   285
      Left            =   1290
      TabIndex        =   2
      Text            =   "index.html"
      Top             =   375
      Width           =   3285
   End
   Begin VB.TextBox Text1 
      Height          =   285
      Left            =   1290
      TabIndex        =   0
      Top             =   90
      Width           =   3285
   End
   Begin VB.Label Label5 
      Alignment       =   1  'Right Justify
      Caption         =   "Out Bandwidth (bytes/s):"
      Height          =   255
      Left            =   1545
      TabIndex        =   9
      Top             =   1125
      Width           =   1935
   End
   Begin VB.Label Label4 
      Caption         =   "webserver is currently down, will go up on saving..."
      Height          =   315
      Left            =   330
      TabIndex        =   7
      Top             =   1575
      Width           =   3990
   End
   Begin VB.Label Label3 
      Alignment       =   1  'Right Justify
      Caption         =   "404 page:"
      Height          =   255
      Left            =   -15
      TabIndex        =   5
      Top             =   654
      Width           =   1215
   End
   Begin VB.Label Label2 
      Alignment       =   1  'Right Justify
      Caption         =   "Default:"
      Height          =   255
      Left            =   -15
      TabIndex        =   3
      Top             =   372
      Width           =   1215
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      Caption         =   "Share Directory:"
      Height          =   255
      Left            =   -15
      TabIndex        =   1
      Top             =   90
      Width           =   1215
   End
End
Attribute VB_Name = "Form2"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Command1_Click()
    Text1_LostFocus
    Text2_LostFocus
    Text3_LostFocus
    SaveSetting "webserver", "pref", "dir", Text1
    SaveSetting "webserver", "pref", "default", Text2
    SaveSetting "webserver", "pref", "404", Text3
    SaveSetting "webserver", "pref", "speed", Text4
    Unload Me
    Form1.Show
    Form1.newsettings
End Sub

Private Sub Form_Load()
    Text1 = GetSetting("webserver", "pref", "dir", "")
    Text2 = GetSetting("webserver", "pref", "default", "index.html")
    Text3 = GetSetting("webserver", "pref", "404", "/404.html")
    Text4 = GetSetting("webserver", "pref", "speed", "5600")
    
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
    If UnloadMode = 0 Then Cancel = True
End Sub

Private Sub Text1_LostFocus()
    If Right(Text1, 1) <> "\" Then Text1 = Text1 & "\"
End Sub

Private Sub Text2_LostFocus()
    'If Text2 = "" Then Text2 = "index.html"
End Sub

Private Sub Text3_LostFocus()
    If Strings.Left(Text3, 1) <> "/" Then Text3 = "/" & Text3
End Sub

Private Sub Text4_LostFocus()
    If Val(Text4) < 1 Then
        Text4 = "5600"
    End If
End Sub
