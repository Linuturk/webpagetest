$testsigning = bcdedit | Select-String -pattern "testsigning             Yes"

if ($testsigning) {
  Write-Output "changed=no comment='Test Signing Already Enabled.'"
} Else {
  bcdedit /set TESTSIGNING ON
  Write-Output "changed=yes comment='Test Signing Enabled.'"
}

$Interface = Get-NetAdapter -Name pub*
$InstallDir = "{{ pillar['webpagetest']['win']['install_dir'] }}"
$dummynet = Get-NetAdapterBinding -Name $Interface.Name -DisplayName ipfw+dummynet

If ($dummynet.Enabled) {
  Write-Output "changed=no comment='ipfw+dummynet binding is already enabled.'"
} Else {
  Import-Certificate -FilePath $InstallDir\WPOFoundation.cer -CertStoreLocation Cert:\LocalMachine\TrustedPublisher
  cd $InstallDir
  .\mindinst.exe $InstallDir\agent\dummynet\64bit\netipfw.inf -i -s
  Enable-NetAdapterBinding -Name $Interface.Name -DisplayName ipfw+dummynet
  Write-Output "changed=yes comment='Enabled ipfw+dummynet binding.'"
}
