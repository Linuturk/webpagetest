$Username = "{{ pillar['webpagetest']['win']['user'] }}"
$Password = "{{ pillar['webpagetest']['win']['pass'] }}"

$Exists = [ADSI]::Exists("WinNT://./$Username")

if ($Exists) {
  Write-Output "changed=no comment='$Username user already exists.'"
} Else {
  net accounts /maxpwage:unlimited
  net user /add $Username
  net localgroup Administrators /add $Username
  $user = [ADSI]("WinNT://./$Username")
  $user.SetPassword($Password)
  $user.SetInfo()
  Write-Output "changed=yes comment='$Username created.'"
}
