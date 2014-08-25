Function Set-Agent-Updater ($UpdateURL, $INIFile, $Destination) {
  Invoke-WebRequest $UpdateURL -OutFile $Destination
  $Shell = New-Object -com shell.application
  $Shell.NameSpace($Destination).copyhere($INIFile)
}

Set-Agent-Updater -UpdateURL "http://www.webpagetest.org/work/update/update.zip" -INIFile "update.ini" -Destination "C:\wpt-www\work\update\update.zip"
Set-Agent-Updater -UpdateURL "http://www.webpagetest.org/work/update/wptupdate.zip" -INIFile "wptupdate.ini" -Destination "C:\wpt-www\work\update\wptdriver.zip"
