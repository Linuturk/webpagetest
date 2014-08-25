Function Set-Update-Agents ($UpdateURL, $INIFile, $ZipFile, $Destination) {
  Invoke-WebRequest $UpdateURL -OutFile $Destination

  $Shell = New-Object -com shell.application
  $Zip = $Shell.NameSpace("$Destination\$ZipFile")
  $Shell.NameSpace($Destination).copyhere($INIFile)
}

Set-Update-Agents -UpdateURL "http://www.webpagetest.org/work/update/update.zip" -INIFile "update.ini" -ZipFile "update.zip" -Destination "C:\wpt-www\work\update\"
Set-Update-Agents -UpdateURL "http://www.webpagetest.org/work/update/wptupdate.zip" -INIFile "wptupdate.ini" -ZipFile "wptupdate.zip" -Destination "C:\wpt-www\work\update\"
