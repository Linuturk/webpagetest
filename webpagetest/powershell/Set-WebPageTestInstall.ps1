$InstallDir = {{ pillar['webpagetest']['win_install_dir'] }}
$URL = {{ pillar['webpagetest']['zipurl'] }}
$ZipFile = "$InstallDir\{{ pillar['webpagetest']['win_zip_file'] }}"

$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile($URL,$ZipFile)

function Expand-ZIPFile($file, $destination) {

  $shell = new-object -com shell.application
  $zip = $shell.NameSpace($file)

  foreach($item in $zip.items()) {
    $shell.Namespace($destination).copyhere($item)
  }
}

Expand-ZIPFile -File $ZipFile -Destination $InstallDir
