$allthings = bcdedit | Select-String -pattern "useplatformclock        Yes"
Write-Output $allthings

if ($useplatformclock) {
  Write-Output "changed=no comment='Platform Clock Already Enabled.'"
} Else {
  Start-Process -wait bcdedit -ArgumentList "/set {default}, useplatformclock true"
  Write-Output "changed=yes comment='Platform Clock Enabled.'"
}
