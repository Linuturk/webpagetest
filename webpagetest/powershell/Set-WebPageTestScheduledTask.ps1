$ThisHost = "{{ grains.host }}"
$User = "{{ pillar['webpagetest']['win']['user'] }}"
$Password = "{{ pillar['webpagetest']['win']['pass'] }}"
$InstallDir = "{{ pillar['webpagetest']['win']['install_dir'] }}\agent"

$GetTask = Get-ScheduledTask -TaskName "wptdriver"

if ($GetTask) {
  Write-Output "changed=no comment='Task (wptdriver) already scheduled.'"
} Else {
  $A = New-ScheduledTaskAction -Execute "$InstallDir\wptdriver.exe"
  $T = New-ScheduledTaskTrigger -AtLogon -User $User
  $S = New-ScheduledTaskSettingsSet
  $P = New-ScheduledTaskPrincipal -UserId "$ThisHost\$User" -LogonType ServiceAccount
  Register-ScheduledTask -TaskName "wptdriver" -Action $A -Trigger $T -Setting $S -Principal $P
  Write-Output "changed=yes comment='Task (wptdriver) scheduled.'"
}

$GetTask = Get-ScheduledTask -TaskName "urlBlast"

if ($GetTask) {
  Write-Output "changed=no comment='Task (urlBlast) already scheduled.'"
} Else {
  $A = New-ScheduledTaskAction -Execute "$InstallDir\urlBlast.exe"
  $T = New-ScheduledTaskTrigger -AtLogon -User $User
  $S = New-ScheduledTaskSettingsSet
  $P = New-ScheduledTaskPrincipal -UserId "$ThisHost\$User" -LogonType ServiceAccount
  Register-ScheduledTask -TaskName "urlBlast" -Action $A -Trigger $T -Setting $S -Principal $P
  Write-Output "changed=yes comment='Task (urlBlast) scheduled.'"
}
