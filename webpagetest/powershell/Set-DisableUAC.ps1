$Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"

$CurrentVal = Get-ItemProperty -Path $Path -Name ConsentPromptBehaviorAdmin

if ($CurrentVal.ConsentPromptBehaviorAdmin -ne 00000000) {
  Set-ItemProperty -Path $Path -Name "ConsentPromptBehaviorAdmin" -Value 00000000
  Write-Output "changed=yes comment='UAC Disabled.'"
} Else {
  Write-Output "changed=no comment='UAC Already Disabled.'"
}
