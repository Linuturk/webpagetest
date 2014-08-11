$Host = "{{ grains.host }}"
$User = "{{ pillar['webpagetest']['win_user'] }}"
$InstallDir = "{{ pillar['webpagetest']['win_install_dir'] }}\agent"

$GetTask = Get-ScheduledTask -TaskName "wptdriver"
Write-Output $GetTask

if ($GetTask) {
  Write-Output "changed=no comment='Task already scheduled.'"
} Else {
  $A = New-ScheduledTaskAction –Execute "$InstallDir\wptdriver.exe"
  $T = New-ScheduledTaskTrigger -AtLogon
  $P = "$Host\$User"
  $S = New-ScheduledTaskSettingsSet
  $D = New-ScheduledTask -Action $A -Principal $P -Trigger $T -Settings $S
  Register-ScheduledTask -TaskName "wptdriver" -InputObject $D
  Write-Output "changed=yes comment='Task scheduled.'"
}
