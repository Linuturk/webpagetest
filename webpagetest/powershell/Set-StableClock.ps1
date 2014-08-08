Start-Process -wait bcdedit -ArgumentList "/set {default}, useplatformclock true"
$allthings = bcdedit | Select-String -pattern "useplatformclock        Yes"
Write-Output $allthings
