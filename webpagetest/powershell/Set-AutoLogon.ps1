$LogonPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'
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
  New-ItemProperty -Path $LogonPath -Name DefaultUserName -Value "$Username"
  New-ItemProperty -Path $LogonPath -Name DefaultPassword -Value "$Password"
  New-ItemProperty -Path $LogonPath -Name DontDisplayLastUserName -Value 1
  Write-Output "changed=yes comment='AutoLogon enabled.'"
}
