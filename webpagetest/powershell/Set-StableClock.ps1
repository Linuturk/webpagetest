Start-Process -wait bcdedit -ArgumentList "/set {default}, useplatformclock true"
$allthings = bcdedit
Write-Output $allthings
