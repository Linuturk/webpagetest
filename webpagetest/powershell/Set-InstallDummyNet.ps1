$testsigning = bcdedit | Select-String -pattern "testsigning             Yes"

if ($testsigning) {
  Write-Output "changed=no comment='Test Signing Already Enabled.'"
} Else {
  bcdedit /set TESTSIGNING ON
  Write-Output "changed=yes comment='Test Signing Enabled.'"
}

$dummynet = Get-NetAdapterBinding -Name private0 -DisplayName ipfw+dummynet

If ($dummynet.Enabled) {
  Write-Output "changed=no comment='ipfw+dummynet binding on the private network adapter is already enabled.'"
} Else {
  cd C:\webpagetest
  .\mindinst.exe c:\webpagetest\agent\dummynet\64bit\netipfw.inf -i -s
  Enable-NetAdapterBinding -Name private0 -DisplayName ipfw+dummynet
  Write-Output "changed=yes comment='Enabled ipfw+dummynet binding on the private network adapter.'"
}
