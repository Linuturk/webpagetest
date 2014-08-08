$allthings = bcdedit | Select-String -pattern "useplatformclock        Yes"
Write-Output $allthings

if ($useplatformclock -eq "useplatformclock        Yes") {
  Write-Output "changed=no comment='Platform Clock Already Enabled.'"
} Else {
  bcdedit /set  useplatformclock true
  Write-Output "changed=yes comment='Platform Clock Enabled.'"
}
