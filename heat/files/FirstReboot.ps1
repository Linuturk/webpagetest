Start-Sleep -s 30

If (Test-Path C:\wpt-temp\firstreboot -pathType leaf) {
  New-Item C:\wpt-temp\firstreboot -type file
  Restart-Computer
}
