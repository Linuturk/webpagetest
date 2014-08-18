$testsigning = bcdedit | Select-String -pattern "testsigning             Yes"

if ($testsigning) {
  Write-Output "changed=no comment='Test Signing Already Enabled.'"
} Else {
  bcdedit /set TESTSIGNING ON
  Write-Output "changed=yes comment='Test Signing Enabled.'"
}

cd C:\webpagetest

Write-Output "Install ipfw+dummynet drivers on the all interface"
.\mindinst.exe c:\webpagetest\agent\dummynet\64bit\netipfw.inf -i -s

$dummynet = Get-NetAdapterBinding -Name private0 -DisplayName ipfw+dummynet

if ($dummynet.Enabled -eq $false){
    Write-Output "Enabling ipfw+dummynet binding on the private network adapter"
    Enable-NetAdapterBinding -Name private0 -DisplayName ipfw+dummynet

}else{
    Write-Output "ipfw+dummynet binding on the private network adapter is already enabled"
}
