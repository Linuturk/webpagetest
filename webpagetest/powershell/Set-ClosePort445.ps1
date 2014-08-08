$CurrentVal = Get-NetFirewallRule -DisplayName WinRM
Write-Output $CurrentVal

if ($CurrentVal.Enabled -eq True) {
  Disable-NetFirewallRule -DisplayName WinRM
  Write-Output "changed=yes comment='Port 445 Disabled.'"
} Else {
  Write-Output "changed=no comment='Port 445 Already Disabled.'"
}
