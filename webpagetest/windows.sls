disable-ie-esc:
  cmd.script:
    - source: salt://webpagetest/powershell/Set-DisableIESecurity.ps1
    - shell: powershell

#disable-screensaver:
#  cmd.script:
#    - source: salt://webpagetest/powershell/Set-DisableScreensaver.ps1
#    - shell: powershell
#
#disable-shutdown-tracker:
#  cmd.script:
#    - source: salt://webpagetest/powershell/Set-DisableShutdownTracker.ps1
#    - shell: powershell
#
#disable-uac:
#  cmd.script:
#    - source: salt://webpagetest/powershell/Set-DisableUAC.ps1
#    - shell: powershell
#
#install-desktop-experience:
#  cmd.script:
#    - source: salt://webpagetest/powershell/Set-InstallDesktopExperience.ps1
#    - shell: powershell
#
#set-secure-auto-logon:
#  cmd.script:
#    - source: salt://webpagetest/powershell/Set-SecureAutoLogon.ps1
#    - shell: powershell
#
#stable-clock:
#  cmd.script:
#    - source: salt://webpagetest/powershell/Set-StableClock.ps1
#    - shell: powershell
