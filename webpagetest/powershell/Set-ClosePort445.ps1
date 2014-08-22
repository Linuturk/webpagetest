$CurrentVal = Get-NetFirewallRule -DisplayName SaltBootstrap

if ($CurrentVal.Enabled -eq "True") {
  Disable-NetFirewallRule -DisplayName SaltBootstrap
  Write-Output "changed=yes comment='Port 445 Disabled.'"
} Else {
  Write-Output "changed=no comment='Port 445 Already Disabled.'"
}
