close-port-445:
  cmd.script:
    - source: salt://webpagetest/powershell/Set-ClosePort445.ps1
    - shell: powershell
    - stateful: True

disable-ie-esc:
  cmd.script:
    - source: salt://webpagetest/powershell/Set-DisableIESecurity.ps1
    - shell: powershell
    - stateful: True

disable-screensaver:
  cmd.script:
    - source: salt://webpagetest/powershell/Set-DisableScreensaver.ps1
    - shell: powershell
    - stateful: True

disable-monitor-timeout:
  cmd.script:
    - source: salt://webpagetest/powershell/Set-MonitorTimeout.ps1
    - shell: powershell
    - stateful: True

disable-shutdown-tracker:
  cmd.script:
    - source: salt://webpagetest/powershell/Set-DisableShutdownTracker.ps1
    - shell: powershell
    - stateful: True

disable-uac:
  cmd.script:
    - source: salt://webpagetest/powershell/Set-DisableUAC.ps1
    - shell: powershell
    - stateful: True

create-user:
  cmd.script:
    - source: salt://webpagetest/powershell/Set-WebPageTestUser.ps1
    - shell: powershell
    - stateful: True
    - template: jinja

set-auto-logon:
  cmd.script:
    - source: salt://webpagetest/powershell/Set-AutoLogon.ps1
    - shell: powershell
    - stateful: True
    - template: jinja
    - require:
      - cmd: create-user

stable-clock:
  cmd.script:
    - source: salt://webpagetest/powershell/Set-StableClock.ps1
    - shell: powershell
    - stateful: True

manage-temp-dir:
  file.directory:
    - name: {{ pillar['webpagetest']['win']['temp_dir'] }}

manage-install-dir:
  file.directory:
    - name: {{ pillar['webpagetest']['win']['install_dir'] }}

extract-installer:
  cmd.script:
    - source: salt://webpagetest/powershell/Set-WebPageTestInstall.ps1
    - shell: powershell
    - template: jinja
    - stateful: True

install-avisynth:
  cmd.script:
    - source: salt://webpagetest/powershell/Set-InstallAviSynth.ps1
    - shell: powershell
    - template: jinja
    - stateful: True

schedule-drivers:
  cmd.script:
    - source: salt://webpagetest/powershell/Set-WebPageTestScheduledTask.ps1
    - shell: powershell
    - template: jinja
    - stateful: True

'{{ pillar['webpagetest']['win']['install_dir'] }}\agent\wptdriver.ini':
  file.managed:
    - source: salt://webpagetest/files/wptdriver.ini
    - template: jinja

'{{ pillar['webpagetest']['win']['install_dir'] }}\agent\urlBlast.ini':
  file.managed:
    - source: salt://webpagetest/files/urlBlast.ini
    - template: jinja

install-mindinst:
  file.managed:
    - name: {{ pillar['webpagetest']['win']['install_dir'] }}\mindinst.exe
    - source: salt://webpagetest/powershell/mindinst.exe

place-dummynet-cert:
  file.managed:
    - name: {{ pillar['webpagetest']['win']['install_dir'] }}\WPOFoundation.cer
    - source: salt://webpagetest/powershell/WPOFoundation.cer

install-dummynet-binding:
  cmd.script:
    - source: salt://webpagetest/powershell/Set-InstallDummyNet.ps1
    - shell: powershell
    - template: jinja
    - stateful: True
    - require:
      - file: install-mindinst
      - file: place-dummynet-cert
