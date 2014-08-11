$InstallDir = {{ pillar['webpagetest']['win_install_dir'] }}
$URL = {{ pillar['webpagetest']['zipurl'] }}
$ZipFile = "$InstallDir\{{ pillar['webpagetest']['win_zip_file'] }}"

function Expand-ZIPFile($file, $destination) {

  $shell = new-object -com shell.application
  $zip = $shell.NameSpace($file)

  foreach($item in $zip.items()) {
    $shell.Namespace($destination).copyhere($item)
  }
}

$TestDir = "$InstallDir\agent"

If (Test-Path $TestDir -pathType container) {
  Write-Output "changed=no comment='WebPageTest already installed.'"
} Else {
  $WebClient = New-Object System.Net.WebClient
  $WebClient.DownloadFile($URL,$ZipFile)
  Expand-ZIPFile -File $ZipFile -Destination $InstallDir
  Write-Output "changed=yes comment='WebPageTest installed.'"
}
