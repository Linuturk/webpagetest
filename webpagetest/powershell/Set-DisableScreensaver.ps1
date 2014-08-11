$Path = 'HKCU:\Control Panel\Desktop'

Try {
  $CurrentVal = Get-ItemProperty -Path $Path -Name ScreenSaveActive
  Write-Output $CurrentVal
} Catch {
  $CurrentVal = False
} Finally {
  if ($CurrentVal.ScreenSaveActive -ne 0) {
    Set-ItemProperty -Path $Path -Name ScreenSaveActive -Value 0
    Write-Output "changed=yes comment='Screensaver Disabled.'"
  } Else {
    Write-Output "changed=no comment='Screensaver Already Disabled.'"
  }
}
