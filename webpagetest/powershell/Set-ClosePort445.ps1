$CurrentVal = Get-NetFirewallRule -DisplayName WinRM
Write-Output $CurrentVal

if ($CurrentVal) {
  Disable-NetFirewallRule -DisplayName WinRM
  Write-Output "changed=yes comment='Port 445 Disabled.'"
} Else {
  Write-Output "changed=no comment='Port 445 Already Disabled.'"
}
