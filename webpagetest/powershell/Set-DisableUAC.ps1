$Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"

$CurrentVal = Get-ItemProperty -Path $Path -Name ConsentPromptBehaviorAdmin
Write-Output $CurrentVal

if ($CurrentVal.ConsentPromptBehaviorAdmin -ne 00000000) {
  Set-ItemProperty -Path $Path -Name "ConsentPromptBehaviorAdmin" -Value 00000000
  Write-Output "UAC Disabled."
} Else {
  Write-Output "UAC Already Disabled."
}
