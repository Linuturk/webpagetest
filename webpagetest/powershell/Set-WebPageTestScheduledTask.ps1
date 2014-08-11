$ThisHost = "{{ grains.host }}"
$User = "{{ pillar['webpagetest']['win_user'] }}"
$InstallDir = "{{ pillar['webpagetest']['win_install_dir'] }}\agent"

$GetTask = Get-ScheduledTask -TaskName "wptdriver"

if ($GetTask) {
  Write-Output "changed=no comment='Task already scheduled.'"
} Else {
  $A = New-ScheduledTaskAction -Execute "$InstallDir\wptdriver.exe"
  $T = New-ScheduledTaskTrigger -AtLogon
  $S = New-ScheduledTaskSettingsSet
  $U = "$ThisHost\$User"
  $P = "{{ pillar['webpagetest']['win_pass'] }}"
  $D = New-ScheduledTask -Action $A  -Trigger $T -Settings $S
  Register-ScheduledTask -TaskName "wptdriver" -InputObject $D -User $U -Password $P
  Write-Output "changed=yes comment='Task scheduled.'"
}
