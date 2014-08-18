$testsigning = bcdedit | Select-String -pattern "testsigning             Yes"

if ($testsigning) {
  Write-Output "changed=no comment='Test Signing Already Enabled.'"
} Else {
  bcdedit /set TESTSIGNING ON
  Write-Output "changed=yes comment='Test Signing Enabled.'"
}

Function download_file ($url, $localpath, $filename){
    if(!(Test-Path -Path $localpath)){
        New-Item $localpath -type directory > $null
    }
    $webclient = New-Object System.Net.WebClient;
    $webclient.DownloadFile($url, $localpath + "\" + $filename)
}

$mindinst_file = "http://9cecab0681d23f5b71fb-642758a7a3ed7927f3ce8478e9844e11.r45.cf5.rackcdn.com/mindinst.exe"
download_file $mindinst_file "C:\webpagetest" "mindinst.exe"
cd C:\webpagetest

Write-Output "Install ipfw+dummynet drivers on the all interface"
.\mindinst.exe c:\webpagetest\netipfw.inf -i -s

$dummynet = Get-NetAdapterBinding -Name private0 -DisplayName ipfw+dummynet

if ($dummynet.Enabled -eq $false){
    Write-Output "Enabling ipfw+dummynet binding on the private network adapter"
    Enable-NetAdapterBinding -Name private0 -DisplayName ipfw+dummynet

}else{
    Write-Output "ipfw+dummynet binding on the private network adapter is already enabled"
}
