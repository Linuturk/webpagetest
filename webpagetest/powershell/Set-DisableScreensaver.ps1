$Path = 'HKCU:\Control Panel\Desktop'

$CurrentVal = Get-ItemProperty -Path $Path -Name ScreenSaveActive
Write-Output $CurrentVal

if ($CurrentVal.ScreenSaveActive -ne 0) {
  Set-ItemProperty -Path $Path -Name ScreenSaveActive -Value 0
  Write-Output "changed=yes comment='Screensaver Disabled.'"
} Else {
  Write-Output "changed=no comment='Screensaver Already Disabled.'"
}
