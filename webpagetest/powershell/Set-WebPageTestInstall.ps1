$InstallDir = "{{ pillar['webpagetest']['win']['install_dir'] }}"
$TempDir = "{{ pillar['webpagetest']['win']['temp_dir'] }}"
$URL = "{{ pillar['webpagetest']['zipurl'] }}"
$ZipFile = "$TempDir\{{ pillar['webpagetest']['win']['zip_file'] }}"

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
