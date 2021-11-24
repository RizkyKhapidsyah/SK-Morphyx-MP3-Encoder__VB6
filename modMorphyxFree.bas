Attribute VB_Name = "modMorphyxFree"
'************************************************************************
'* MORPHYX FREE ENCODER                                                 *
'* Author: Ultimatum                                                    *
'* Date: 9/26/2000                                                      *
'*                                                                      *
'* Copyright (c) 2000, Freak Elite Software Studios                     *
'* Blindworm Media                                                      *
'************************************************************************
'
'  The purpose of this program is to demonstrate three possible things:
'
'       #1: Encode a WAV file to an MP3 using Visual Basic
'       #2: Using a low-level language for complex calculations
'       #3: Writing a simple DLL in C++
'
'  The encoder uses two engines: Blade and Lame, which are pretty much
' the front runners for free encoding.
'
'   PROJECTS
'
' - Adding a decoder to Morphyx using the front-end XAudio API
' - Adding support for the Xing encoding engine to Morphyx
' - Creating a UNIX-compatible Morphyx Decoder
'
' Comments? Questions? Suggestions?
' Write to ultimatum777@dopplegangers.com
'
' UNFORTUNATELY, I don't remember who wrote the "move a form with no border" code,
' C++ button emulatiuon code, window rounding code, or even the Gradient color class,
' but thanks to whom the thanks belongs =)


' Enum for encoder
Public Enum MP3ENC
    ENC_LAME
    ENC_BLADE
End Enum

'API declarations for encoding wrapper
Public Declare Function SetEncoder Lib "morphyx.dll" (ByVal enc As MP3ENC) As Long
Public Declare Function EncodeMp3 Lib "morphyx.dll" (ByVal lpszWavFile As String, lpCallback As Any) As Long

'Typedef RECT
Public Type RECT
   nLeftRect  As Long ' x-coordinate of the region's upper-left corner
   nTopRect As Long ' y-coordinate of the region's upper-left corner
   nRightRect As Long ' x-coordinate of the region's lower-right corner
   nBottomRect As Long ' y-coordinate of the region's lower-right corner
   nWidthEllipse As Long ' height of ellipse for rounded corners
   nHeightEllipse As Long ' width of ellipse for rounded corners
End Type

'User interface API declarations
Public Declare Sub ReleaseCapture Lib "user32" ()
Public Declare Function SendMessage Lib "user32" Alias "SendMessageA" (ByVal hWnd As Long, ByVal wMsg As Long, ByVal wParam As Long, lParam As Any) As Long
Public Declare Function SetWindowRgn Lib "user32" (ByVal hWnd As Long, ByVal hRgn As Long, ByVal bRedraw As Boolean) As Long
Public Declare Function GetClientRect Lib "user32" (ByVal hWnd As Long, lpRect As RECT) As Long
Public Declare Function CreateRoundRectRgn Lib "gdi32" (ByVal X1 As Long, ByVal Y1 As Long, ByVal X2 As Long, ByVal Y2 As Long, ByVal X3 As Long, ByVal Y3 As Long) As Long

'Used for gradient effect in titlebar
Global clrTitle As New clsGradient

Public Sub FormDrag(TheForm As Object)
    'This function allows you to move the form
    ReleaseCapture
    Call SendMessage(TheForm.hWnd, &HA1, 2, 0&)
    
End Sub

Public Function EnumEncoding(ByVal nStatus As Integer) As Boolean
    
    'This function is called by MORPHYX.DLL during the
    'encoding process. It updates the encoding status.
    
    With frmMorphyxFree
    .lblPercent.Caption = nStatus & "%"
    .pMp3Encode.Value = nStatus
    End With
    DoEvents
    EnumEncoding = True
End Function
