$Path = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Reliability'

Try {
  $CurrentVal = Get-ItemProperty -Path $Path -Name ShutdownReasonUI
  Write-Output $CurrentVal
} Catch {
  $CurrentVal = False
} Finally {
  if ($CurrentVal.ShutdownReasonUI -ne 0) {
    New-ItemProperty -Path $Path -Name ShutdownReasonUI -Value 0
    Write-Output "changed=yes comment='Shutdown Tracker Disabled.'"
  } Else {
    Write-Output "changed=no comment='Shutdown Tracker Already Disabled.'"
  }
}
