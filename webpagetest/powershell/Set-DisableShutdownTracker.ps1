$Path = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Reliability'

$CurrentVal = Get-ItemProperty -Path $Path -Name ShutdownReasonUI
Write-Output $CurrentVal

if ($CurrentVal.ShutdownReasonUI -ne 0) {
  Set-ItemProperty -Path $Path -Name ShutdownReasonUI -Value 0
  Write-Output "Shutdown Tracker Disabled."
} Else {
  Write-Output "Shutdown Tracker Already Disabled."
}
