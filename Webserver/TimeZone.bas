Attribute VB_Name = "TimeZone"
'strait of PSC.

Type SYSTEMTIME ' 16 Bytes
    wYear As Integer
    wMonth As Integer
    wDayOfWeek As Integer
    wDay As Integer
    wHour As Integer
    wMinute As Integer
    wSecond As Integer
    wMilliseconds As Integer
End Type

Type TIME_ZONE_INFORMATION
    Bias As Long
    StandardName(31) As Integer
    StandardDate As SYSTEMTIME
    StandardBias As Long
    DaylightName(31) As Integer
    DaylightDate As SYSTEMTIME
    DaylightBias As Long
End Type

Declare Function GetTimeZoneInformation Lib "kernel32" (lpTimeZoneInformation _
    As TIME_ZONE_INFORMATION) As Long
            
Public Function gmtoffset() As Double
    Dim tz As TIME_ZONE_INFORMATION
    GetTimeZoneInformation tz
    gmtoffset = 0 - (tz.Bias / 1440)
End Function

