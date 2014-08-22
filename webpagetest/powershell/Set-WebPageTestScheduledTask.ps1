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
  $U = "$ThisHost\$User"
  $P = $Password
  $D = New-ScheduledTask -Action $A  -Trigger $T -Settings $S
  Register-ScheduledTask -TaskName "wptdriver" -InputObject $D -User $U -Password $P
  $Principal = New-ScheduledTaskPrincipal -UserId "$ThisHost\$User" -LogonType ServiceAccount
  Register-ScheduledTask -TaskName "wptdriver2" -Action $A -Trigger $T -Setting $S -Principal $Principal
  Write-Output "changed=yes comment='Task (wptdriver) scheduled.'"
}

$GetTask = Get-ScheduledTask -TaskName "urlBlast"

if ($GetTask) {
  Write-Output "changed=no comment='Task (urlBlast) already scheduled.'"
} Else {
  $A = New-ScheduledTaskAction -Execute "$InstallDir\urlBlast.exe"
  $T = New-ScheduledTaskTrigger -AtLogon -User $User
  $S = New-ScheduledTaskSettingsSet
  $U = "$ThisHost\$User"
  $P = $Password
  $D = New-ScheduledTask -Action $A  -Trigger $T -Settings $S
  Register-ScheduledTask -TaskName "urlBlast" -InputObject $D -User $U -Password $P
  Write-Output "changed=yes comment='Task (urlBlast) scheduled.'"
}
