close-port-445:
  cmd.script:
    - source: salt://webpagetest/powershell/Set-ClosePort445.ps1
    - shell: powershell
    - stateful: True

disable-ie-esc-admin:
  reg.present:
    - name: 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}\IsInstalled'
    - value: 0

disable-ie-esc-user:
  reg.present:
    - name: 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}\IsInstalled'
    - value: 0

disable-screensaver:
  reg.present:
    - name: 'HKEY_CURRENT_USER\Control Panel\Desktop\ScreenSaveActive'
    - value: 0

disable-monitor-timeout:
  cmd.script:
    - source: salt://webpagetest/powershell/Set-MonitorTimeout.ps1
    - shell: powershell
    - stateful: True

disable-shutdown-tracker:
  reg.present:
    - name: 'HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Reliability\ShutdownReasonUI'
    - value: 0

disable-uac:
  reg.present:
    - name: 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\ConsentPromptBehaviorAdmin'
    - value: 00000000

disable-server-manager:
  cmd.script:
    - source: salt://webpagetest/powershell/Set-DisableServerManager.ps1
    - shell: powershell
    - stateful: True

create-user:
  cmd.script:
    - source: salt://webpagetest/powershell/Set-WebPageTestUser.ps1
    - shell: powershell
    - stateful: True
    - template: jinja

auto-admin-logon:
  reg.present:
    - name: 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\AutoAdminLogon'
    - value: 1

default-domain-name:
  reg.present:
    - name: 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\DefaultDomainName'
    - value: {{ grains.host }}

default-user-name:
  reg.present:
    - name: 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\DefaultUserName'
    - value: {{ salt['pillar.get']('webpagetest:win:user') }}

default-password:
  reg.present:
    - name: 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\DefaultPassword'
    - value: {{ salt['pillar.get']('webpagetest:win:pass') }}

dont-display-last-user:
  reg.present:
    - name: 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\DontDisplayLastUserName'
    - value: 1

last-used-user-name:
  reg.present:
    - name: 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\LastUsedUsername'
    - value: {{ salt['pillar.get']('webpagetest:win:user') }}

last-loggedon-user:
  reg.present:
    - name: 'HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\LastLoggedOnUser'
    - value: {{ salt['pillar.get']('webpagetest:win:user') }}

stable-clock:
  cmd.script:
    - source: salt://webpagetest/powershell/Set-StableClock.ps1
    - shell: powershell
    - stateful: True

manage-temp-dir:
  file.directory:
    - name: {{ salt['pillar.get']('webpagetest:win:temp_dir') }}

manage-install-dir:
  file.directory:
    - name: {{ salt['pillar.get']('webpagetest:win:install_dir') }}

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

'{{ salt['pillar.get']('webpagetest:win:install_dir') }}\agent\wptdriver.ini':
  file.managed:
    - source: salt://webpagetest/files/wptdriver.ini
    - template: jinja

'{{ salt['pillar.get']('webpagetest:win:install_dir') }}\agent\urlBlast.ini':
  file.managed:
    - source: salt://webpagetest/files/urlBlast.ini
    - template: jinja

install-mindinst:
  file.managed:
    - name: {{ salt['pillar.get']('webpagetest:win:install_dir') }}\mindinst.exe
    - source: salt://webpagetest/powershell/mindinst.exe

place-dummynet-cert:
  file.managed:
    - name: {{ salt['pillar.get']('webpagetest:win:install_dir') }}\WPOFoundation.cer
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
