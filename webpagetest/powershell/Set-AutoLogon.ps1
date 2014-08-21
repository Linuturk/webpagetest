$LogonPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'
$LastUser = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Authentication\LogonUI'
$Domain = "{{ grains.host }}"
$Username = "{{ pillar['webpagetest']['win']['user'] }}"
$Password = "{{ pillar['webpagetest']['win']['pass'] }}"

$CurrentVal = Get-ItemProperty -Path $LogonPath -Name AutoAdminLogon

If ($CurrentVal.AutoAdminLogon -eq 1) {
  $CurrentUser = Get-ItemProperty -Path $LogonPath -Name DefaultUserName
  $CurrentPass = Get-ItemProperty -Path $LogonPath -Name DefaultPassword

  If ($CurrentUser.DefaultUserName -ne $Username -Or $CurrentPass.DefaultPassword -ne $Password) {
    Set-ItemProperty -Path $LogonPath -Name DefaultUserName -Value "$Username"
    Set-ItemProperty -Path $LogonPath -Name DefaultPassword -Value "$Password"
    Write-Output "changed=yes comment='Credentials Updated.'"
  } Else {
    Write-Output "changed=no comment='AutoLogon already enabled.'"
  }
} Else {
  Set-ItemProperty -Path $LogonPath -Name AutoAdminLogon -Value 1
  Set-ItemProperty -Path $LogonPath -Name DefaultDomainName -Value "$Domain"
  New-ItemProperty -Path $LogonPath -Name DefaultUserName -Value "$Username"
  New-ItemProperty -Path $LogonPath -Name DefaultPassword -Value "$Password"
  New-ItemProperty -Path $LogonPath -Name DontDisplayLastUserName -Value 1
  Set-ItemProperty -Path $LastUser -Name LastLoggedOnUser -Value "$Username"
  Write-Output "changed=yes comment='AutoLogon enabled.'"
}
