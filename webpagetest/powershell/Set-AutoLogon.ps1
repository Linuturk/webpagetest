$LogonPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'
$Username = "{{ pillar['webpagetest']['win_user'] }}"
$Password = "{{ pillar['webpagetest']['win_pass'] }}"

$CurrentVal = Get-ItemProperty -Path $LogonPath -Name AutoAdminLogon

If ($CurrentVal.AutoAdminLogon -ne 0) {
  Set-ItemProperty -Path $LogonPath -Name AutoAdminLogon -Value 1
  Set-ItemProperty -Path $LogonPath -Name DefaultUserName -Value $Username
  Set-ItemProperty -Path $LogonPath -Name DefaultPassword -Value $Password
  Write-Output "changed=no comment='AutoLogon already enabled.'"
} Else {
  Set-ItemProperty -Path $LogonPath -Name AutoAdminLogon -Value 1
  New-ItemProperty -Path $LogonPath -Name DefaultUserName -Value $Username
  New-ItemProperty -Path $LogonPath -Name DefaultPassword -Value $Password
  Write-Output "changed=yes comment='AutoLogon enabled.'"
}
