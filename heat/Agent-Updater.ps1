Function Set-Agent-Updater ($UpdateURL, $Destination, $FileName) {
  Invoke-WebRequest $UpdateURL -OutFile "$Destination\$FileName.zip"
  $Shell = New-Object -com shell.application
  $Shell.NameSpace($Destination).copyhere("$Destination\$FileName.zip\$FileName.ini")
}

Set-Agent-Updater -UpdateURL "http://www.webpagetest.org/work/update/update.zip" -Destination "C:\wpt-www\work\update\" -FileName "update"
Set-Agent-Updater -UpdateURL "http://www.webpagetest.org/work/update/wptupdate.zip" -Destination "C:\wpt-www\work\update\" -FileName "wptupdate"
