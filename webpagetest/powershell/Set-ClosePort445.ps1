netsh advfirewall firewall delete rule name="WinRM" protocol=TCP localport=445

netsh advfirewall firewall add rule name="WinRM" dir=in protocol=TCP localport=445 action=allow

$CurrentVal = Get-NetFirewallRule -Name WinRM
Write-Output $CurrentVal

if ($CurrentVal) {
  Disable-NetFirewallRule -Name WinRM
  Write-Output "changed=yes comment='Port 445 Disabled.'"
} Else {
  Write-Output "changed=no comment='Port 445 Already Disabled.'"
}
