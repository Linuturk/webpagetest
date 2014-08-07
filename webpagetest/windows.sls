close-port-445:
  cmd.script:
    - source: salt://webpagetest/powershell/Set-ClosePort445.ps1
    - shell: powershell

disable-ie-esc:
  cmd.script:
    - source: salt://webpagetest/powershell/Set-DisableIESecurity.ps1
    - shell: powershell

disable-screensaver:
  cmd.script:
    - source: salt://webpagetest/powershell/Set-DisableScreensaver.ps1
    - shell: powershell

disable-shutdown-tracker:
  cmd.script:
    - source: salt://webpagetest/powershell/Set-DisableShutdownTracker.ps1
    - shell: powershell

disable-uac:
  cmd.script:
    - source: salt://webpagetest/powershell/Set-DisableUAC.ps1
    - shell: powershell

set-auto-logon:
  cmd.script:
    - source: salt://webpagetest/powershell/Set-AutoLogon.ps1
    - shell: powershell

stable-clock:
  cmd.script:
    - source: salt://webpagetest/powershell/Set-StableClock.ps1
    - shell: powershell

'C:\webpagetest':
  archive.extracted:
    - source: pillar['webpagetest']['zipurl']
    - source_hash: pillar['webpagetest']['zipsha']
    - archive_format: zip
    - if_missing: 'C:\webpagetest\agent'
