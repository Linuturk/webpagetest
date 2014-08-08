$Path = 'HKCU:\Control Panel\Desktop'

$CurrentVal = Get-ItemProperty -Path $Path -Name ScreenSaveActive

if ($CurrentVal -ne 0) {
  Set-ItemProperty -Path $Path -Name ScreenSaveActive -Value 0
}
