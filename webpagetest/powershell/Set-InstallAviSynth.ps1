$InstallDir = "{{ pillar['webpagetest']['win_install_dir'] }}"

$Installed = Test-Path "C:\Program Files (x86)\AviSynth 2.5" -pathType container

If ($Installed) {
  Write-Output "changed=no comment='AviSynth already installed.'"
} Else {
  $InstallDir\agent\Avisynth_258.exe /S
  Write-Output "changed=yes comment='AviSynth installed.'"
}
