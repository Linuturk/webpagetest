$useplatformclock = bcdedit | Select-String -pattern "useplatformclock        Yes"

if ($useplatformclock) {
  Write-Output "changed=no comment='Platform Clock Already Enabled.'"
} Else {
  bcdedit /set  useplatformclock true
  Write-Output "changed=yes comment='Platform Clock Enabled.'"
}
