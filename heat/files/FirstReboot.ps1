Start-Sleep -s 30

# Reboot the first time the computer starts after the HEAT automation
If (Test-Path C:\wpt-temp\firstreboot -pathType leaf) {
  New-Item C:\wpt-temp\firstreboot -type file
  Restart-Computer
} Else {
  # Install DummyNET after this first reboot so testsigning is enabled
  $InstallDir = "C:\wpt-agent"
  $dummynet = Get-NetAdapterBinding -Name public*

  If ($dummynet.ComponentID -eq "ipfw+dummynet") {
    Write-Output "Already Enabled."
  } Else {
    Import-Certificate -FilePath C:\wpt-agent\WPOFoundation.cer -CertStoreLocation Cert:\LocalMachine\TrustedPublisher
    cd $InstallDir
    .\mindinst.exe C:\wpt-agent\dummynet\64bit\netipfw.inf -i -s 
    Enable-NetAdapterBinding -Name public0 -DisplayName ipfw+dummynet 
    Enable-NetAdapterBinding -Name private0 -DisplayName ipfw+dummynet
  }
}
