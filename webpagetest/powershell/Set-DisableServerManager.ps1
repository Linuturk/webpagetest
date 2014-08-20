$CurrentState = Get-ScheduledTask -TaskName "ServerManager" | Select-String -pattern "Ready"

If ($CurrentState -like "*Ready*") {
  Get-ScheduledTask -TaskName "ServerManager" | Disable-ScheduledTask
  Write-Output "changed=yes comment='Server Manager disabled at logon.'"
} Else {
  Write-Output "changed=no comment='Server Manager already disabled at logon.'"
}
