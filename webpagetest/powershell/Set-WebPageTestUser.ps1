$Username = "{{ pillar['webpagetest']['win_user'] }}"
$Password = "{{ pillar['webpagetest']['win_pass'] }}"

$Exists = [ADSI]::Exists("WinNT://./$Username")
Write-Output $Exists

if ($Exists) {
  Write-Output "changed=no comment='$Username user already exists.'"
} Else {
  net user /add $Username
  net localgroup Administrators /add $Username
  $user = [ADSI]("WinNT://./$Username")
  $user.SetPassword($Password)
  $user.SetInfo()
  Write-Output "changed=yes comment='$Username created.'"
}
