$testsigning = bcdedit | Select-String -pattern "testsigning             Yes"

if ($testsigning) {
  Write-Output "changed=no comment='Test Signing Already Enabled.'"
} Else {
  bcdedit /set TESTSIGNING ON
  Write-Output "changed=yes comment='Test Signing Enabled.'"
}
