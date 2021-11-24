VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "Comdlg32.ocx"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmMorphyxFree 
   BackColor       =   &H00000000&
   BorderStyle     =   0  'None
   ClientHeight    =   2685
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   6615
   Icon            =   "frmMorphyxFree.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   2685
   ScaleWidth      =   6615
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdAbout 
      Caption         =   "About"
      Height          =   375
      Left            =   5160
      Style           =   1  'Graphical
      TabIndex        =   12
      Top             =   1440
      Width           =   975
   End
   Begin VB.CommandButton cmdExit 
      Caption         =   "Exit"
      Height          =   375
      Left            =   5160
      Style           =   1  'Graphical
      TabIndex        =   10
      Top             =   1920
      Width           =   975
   End
   Begin VB.OptionButton optLame 
      BackColor       =   &H00000000&
      Caption         =   "Lame"
      ForeColor       =   &H00FFFFFF&
      Height          =   255
      Left            =   3360
      TabIndex        =   9
      Top             =   1560
      Width           =   735
   End
   Begin VB.OptionButton optBlade 
      BackColor       =   &H00000000&
      Caption         =   "Blade"
      ForeColor       =   &H00FFFFFF&
      Height          =   255
      Left            =   2160
      TabIndex        =   8
      Top             =   1560
      Value           =   -1  'True
      Width           =   735
   End
   Begin VB.TextBox txtWAV 
      Height          =   285
      Left            =   1320
      TabIndex        =   5
      Top             =   600
      Width           =   3615
   End
   Begin VB.CommandButton cmdBrowse 
      Caption         =   "&Browse..."
      Height          =   375
      Left            =   5160
      Style           =   1  'Graphical
      TabIndex        =   4
      Top             =   600
      Width           =   975
   End
   Begin VB.CommandButton cmdEncode 
      BackColor       =   &H00C0C0C0&
      Caption         =   "Encode to MP3 Format"
      Height          =   375
      Left            =   2160
      Style           =   1  'Graphical
      TabIndex        =   3
      Top             =   960
      Width           =   1935
   End
   Begin VB.PictureBox Picture1 
      AutoSize        =   -1  'True
      BorderStyle     =   0  'None
      Height          =   480
      Left            =   120
      Picture         =   "frmMorphyxFree.frx":000C
      ScaleHeight     =   480
      ScaleWidth      =   480
      TabIndex        =   2
      Top             =   0
      Width           =   480
   End
   Begin VB.PictureBox picTitle 
      AutoRedraw      =   -1  'True
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      Height          =   255
      Left            =   0
      ScaleHeight     =   17
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   441
      TabIndex        =   0
      Top             =   0
      Width           =   6615
      Begin VB.Label Label2 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "MORPHYX FREE ENCODER"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H0000FF00&
         Height          =   195
         Left            =   720
         TabIndex        =   1
         Top             =   0
         Width           =   2430
      End
      Begin VB.Image btnClose 
         Height          =   210
         Left            =   6120
         Picture         =   "frmMorphyxFree.frx":0316
         ToolTipText     =   "Close"
         Top             =   30
         Width           =   240
      End
      Begin VB.Image imgCloseUp 
         Height          =   210
         Left            =   5400
         Picture         =   "frmMorphyxFree.frx":05F8
         Top             =   0
         Visible         =   0   'False
         Width           =   240
      End
      Begin VB.Image imgCloseDown 
         Height          =   210
         Left            =   5160
         Picture         =   "frmMorphyxFree.frx":08DA
         Top             =   0
         Visible         =   0   'False
         Width           =   240
      End
      Begin VB.Image btnMin 
         Height          =   210
         Left            =   5880
         Picture         =   "frmMorphyxFree.frx":0BBC
         ToolTipText     =   "Minimize"
         Top             =   30
         Width           =   240
      End
      Begin VB.Image imgMinDown 
         Height          =   210
         Left            =   4680
         Picture         =   "frmMorphyxFree.frx":0E9E
         Top             =   0
         Visible         =   0   'False
         Width           =   240
      End
      Begin VB.Image imgMinUp 
         Height          =   210
         Left            =   4920
         Picture         =   "frmMorphyxFree.frx":1180
         Top             =   0
         Visible         =   0   'False
         Width           =   240
      End
   End
   Begin MSComDlg.CommonDialog dlgWAV 
      Left            =   5880
      Top             =   2040
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
      CancelError     =   -1  'True
      DialogTitle     =   "Open WAV File"
      Filter          =   "Wave Files (*.wav)|*.wav"
      Flags           =   4108
   End
   Begin MSComctlLib.ProgressBar pMp3Encode 
      Height          =   195
      Left            =   1440
      TabIndex        =   7
      Top             =   2040
      Width           =   3435
      _ExtentX        =   6059
      _ExtentY        =   344
      _Version        =   393216
      BorderStyle     =   1
      Appearance      =   0
      Scrolling       =   1
   End
   Begin VB.Label lblPercent 
      Alignment       =   2  'Center
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "0%"
      ForeColor       =   &H00FFFFFF&
      Height          =   195
      Left            =   3045
      TabIndex        =   11
      Top             =   2280
      Width           =   225
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "WAV File:"
      ForeColor       =   &H00FFFFFF&
      Height          =   195
      Left            =   480
      TabIndex        =   6
      Top             =   600
      Width           =   705
   End
End
Attribute VB_Name = "frmMorphyxFree"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub btnClose_Click()
    Unload Me
    End
    
End Sub

Private Sub btnClose_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    If Button = 1 Then
        If btnClose.Picture <> imgCloseDown.Picture Then
            Set btnClose.Picture = imgCloseDown.Picture
        End If
    ElseIf Button = 0 Then
        If btnClose.Picture <> imgCloseUp.Picture Then
            Set btnClose.Picture = imgCloseUp.Picture
        End If
    End If
    
End Sub

Private Sub btnClose_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Set btnClose.Picture = imgCloseUp.Picture
    
End Sub

Private Sub btnMin_Click()
    Me.WindowState = 1
    
End Sub

Private Sub btnMin_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    If Button = 1 Then
        If btnMin.Picture <> imgMinDown.Picture Then
            Set btnMin.Picture = imgMinDown.Picture
        End If
    ElseIf Button = 0 Then
        If btnClose.Picture <> imgMinUp.Picture Then
            Set btnClose.Picture = imgMinUp.Picture
        End If
    End If
    
End Sub

Private Sub btnMin_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Set btnMin.Picture = imgMinUp.Picture
    
End Sub

Private Sub cmdAbout_Click()
    Load frmSplash
    frmSplash.Show
    
End Sub

Private Sub cmdBrowse_Click()
    On Error Resume Next
    dlgWAV.ShowOpen
    If Err = 0 Then
        txtWAV.Text = dlgWAV.FileName
    End If

End Sub

Private Sub cmdEncode_Click()
    If Dir$(Trim$(txtWAV.Text)) = "" Then
        MsgBox "File """ & txtWAV.Text & """ does not exist.", vbExclamation, App.Title
        Exit Sub
    End If
    
    If Trim$(txtWAV.Text) = "" Then Exit Sub
    cmdEncode.Enabled = False
    cmdBrowse.Enabled = False
    
    pMp3Encode.Value = 0
    If optBlade.Value = True Then
        Call SetEncoder(ENC_BLADE)
    Else
        Call SetEncoder(ENC_LAME)
    End If
    
    nRes = EncodeMp3(txtWAV.Text, AddressOf EnumEncoding)
    If nRes <> -1 Then
        MsgBox "MP3 encoding complete", vbInformation, App.Title
    ElseIf nRes = -2 Then
        MsgBox "Encoding stopped by user", vbExclamation, App.Title
    Else
        MsgBox "Encoding failed", vbExclamation, App.Title
    End If
    
    pMp3Encode.Value = 0
    lblPercent.Caption = "0%"
    cmdEncode.Enabled = True
    cmdBrowse.Enabled = True

End Sub

Private Sub cmdExit_Click()
    Unload Me
    End
    
End Sub

Private Sub Form_Load()
    
    Dim clrTitle As New clsGradient
    Dim RecDimention As Long
    Dim EllipDimention As Long
    Dim lpRect As RECT
    
    'Emulate cool CButton buttons =)
    For Each ctrl In Me.Controls
        If ctrl.Name Like "cmd*" Then
            SendMessage ctrl.hWnd, &HF4&, &H0&, 0&
        End If
    Next
    
    RecDimention = GetClientRect(Me.hWnd, lpRect)
    RecHandle = CreateRoundRectRgn(lpRect.nLeftRect, lpRect.nTopRect, lpRect.nRightRect, lpRect.nBottomRect, 30, 30)
    SetWindowRgn Me.hWnd, RecHandle, True
    
    clrTitle.Color1 = &H0
    clrTitle.Color2 = QBColor(9)
    Call clrTitle.Draw(picTitle)
    
End Sub

Private Sub Label2_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    FormDrag Me
    
End Sub

Private Sub picTitle_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    FormDrag Me
    
End Sub

Private Sub Picture1_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    FormDrag Me
    
End Sub
