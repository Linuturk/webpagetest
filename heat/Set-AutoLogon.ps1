$LogonPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'
$Username = "webpagetest"

$CurrentUser = Get-ItemProperty -Path $LogonPath -Name DefaultUserName

If ($CurrentUser.DefaultUserName -ne $Username) {
  Set-ItemProperty -Path $LogonPath -Name DefaultUserName -Value "$Username"
}
