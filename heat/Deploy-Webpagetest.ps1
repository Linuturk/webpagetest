#region Deployment of Web Page Test
Function Deploy-WebPagetest(){
    [CmdletBinding()]
    Param(
        [String]$DomainName = "localhost",
        [String]$Logfile = "C:\Windows\Temp\Deploy-WebPageTest.log",
        [String]$wpt_host =  $env:COMPUTERNAME,
        [String]$wpt_user = "wptuser",
        [String]$wpt_password = "Passw0rd",
        [String]$driver_installer_file = "mindinst.exe",
        [String]$driver_installer_cert_file = "WPOFoundation.cer",
        [String]$wpt_agent_dir = "c:\wpt-agent",
        [String]$wpt_www_dir = "c:\wpt-www",
        [String]$wpt_temp_dir = "C:\wpt-temp"
    )
    #region Create Log File
    if (!( Test-Path $Logfile)){
        New-Item -Path "C:\Windows\Temp\Deploy-WebPageTest.log" -ItemType file
    }
    #endregion
    #region Write Log file
    Function WriteLog{
        Param ([string]$logstring)
        Add-content $Logfile -value $logstring
    }
    #endregion
    #region Variables
    $wpt_zip_url =  "https://github.com/WPO-Foundation/webpagetest/releases/download/WebPagetest-2.15/webpagetest_2.15.zip"
    $driver_installer_url = "http://9cecab0681d23f5b71fb-642758a7a3ed7927f3ce8478e9844e11.r45.cf5.rackcdn.com/mindinst.exe"
    $driver_installer_cert_url = "https://github.com/Linuturk/webpagetest/raw/master/webpagetest/powershell/WPOFoundation.cer"
    $wpi_msi_url = "http://download.microsoft.com/download/C/F/F/CFF3A0B8-99D4-41A2-AE1A-496C08BEB904/WebPlatformInstaller_amd64_en-US.msi"
    $vcpp_vc11_url = "http://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x86.exe"
    $apache_bin_url = "http://www.apachelounge.com/download/VC11/binaries/httpd-2.4.10-win32-VC11.zip"
    $php_bin_url = "http://windows.php.net/downloads/releases/php-5.4.32-Win32-VC9-x86.zip"
    $apache_conf_url = "https://raw.githubusercontent.com/Linuturk/webpagetest/master/heat/httpd.conf"
    $php_ini_url = "https://raw.githubusercontent.com/Linuturk/webpagetest/master/heat/php.ini"
    $php_apc_url = "http://9cecab0681d23f5b71fb-642758a7a3ed7927f3ce8478e9844e11.r45.cf5.rackcdn.com/PHP-5.4.8_APC-3.1.13_x86_vc9.zip"
    $ffmeg_bin_url = "http://9cecab0681d23f5b71fb-642758a7a3ed7927f3ce8478e9844e11.r45.cf5.rackcdn.com/ffmpeg-20140829-git-4c92047-win32-static.zip"
    $ffmeg_bin_file = "ffmpeg-20140829-git-4c92047-win32-static.zip"
    $wpt_zip_file = "webpagetest_2.15.zip"
    $wpi_msi_file = "WebPlatformInstaller_amd64_en-US.msi"
    $apache_bin_file = "httpd-2.4.10-win32-VC11.zip"
    $php_bin_file = "php-5.4.32-Win32-VC9-x86.zip"
    $php_apc_file = "PHP-5.4.8_APC-3.1.13_x86_vc9.zip"
    $vcpp_vc11_file = "vcredist_x86.exe"
    $webRoot = '$env:systemdrive\inetpub\wwwroot\'

    $wpt_locations_ini = "https://raw.githubusercontent.com/Linuturk/webpagetest/master/heat/locations.ini"
    $wpt_settings_ini = "https://raw.githubusercontent.com/Linuturk/webpagetest/master/heat/settings.ini"
    $wpt_feeds_inc = "https://raw.githubusercontent.com/Linuturk/webpagetest/master/heat/feeds.inc"
    $wpt_urlBlast_ini = "https://raw.githubusercontent.com/Linuturk/webpagetest/master/heat/urlBlast.ini"
    $wpt_wptdriver_ini = "https://raw.githubusercontent.com/Linuturk/webpagetest/master/heat/wptdriver.ini"

    $webRoot = "$env:systemdrive\inetpub\wwwroot\"
    $webFolder = $webRoot + $DomainName
    $appPoolName = $DomainName
    $siteName = $DomainName
    $ftpName = "ftp_" + $DomainName
    $appPoolIdentity = "IIS AppPool\$appPoolName"
    #endregion
    function Set-WptFolders(){
        $wpt_folders = @($wpt_agent_dir,$wpt_www_dir,$wpt_temp_dir)
        foreach ($wpt_folder in $wpt_folders){
            New-Item $wpt_folder -type directory -Force *>> $Logfile
        }
    }
    function Download-File ($url, $localpath, $filename){
        if(!(Test-Path -Path $localpath)){
            New-Item $localpath -type directory *>> $Logfile
        }
        WriteLog "[$(Get-Date)] Downloading $filename"
        $webclient = New-Object System.Net.WebClient;
        $webclient.DownloadFile($url, $localpath + "\" + $filename)
    }
    function Unzip-File($fileName, $sourcePath, $destinationPath){
        WriteLog "[$(Get-Date)] Unzipping $filename to $destinationPath"
        $shell = new-object -com shell.application
        if (!(Test-Path "$sourcePath\$fileName")){
            throw "$sourcePath\$fileName does not exist"
        }
        New-Item -ItemType Directory -Force -Path $destinationPath -WarningAction SilentlyContinue *>> $Logfile
        $shell.namespace($destinationPath).copyhere($shell.namespace("$sourcePath\$fileName").items()) *>> $Logfile
    }
    function Install-MSI ($MsiPath, $MsiFile){
        $BuildArgs = @{
            FilePath = "msiexec"
            ArgumentList = "/quiet /passive /i " + $MsiPath + "\" + $MsiFile
            Wait = $true
        }
        Try {
            WriteLog "[$(Get-Date)] Installing $MsiFile"
            Start-Process @BuildArgs  *>> $Logfile
        }
        Catch {
            throw "Error installing Web Platform Installer: $_"
        }
    }
    function Replace-String ($filePath, $stringToReplace, $replaceWith){
        (get-content $filePath) | foreach-object {$_ -replace $stringToReplace, $replaceWith} | set-content $filePath *>> $Logfile
    }
    function Set-WebPageTestUser ($Username, $Password){
        $Exists = [ADSI]::Exists("WinNT://./$Username")
        if ($Exists) {
            WriteLog "[$(Get-Date)] $Username user already exists."
        } Else {
            net user /add $Username *>> $Logfile
            net localgroup Administrators /add $Username *>> $Logfile
            $user = [ADSI]("WinNT://./$Username")
            $user.SetPassword($Password)
            $user.SetInfo()
            WriteLog "[$(Get-Date)] $Username created."
        }
    }
    function Set-AutoLogon ($Username, $Password){
        $LogonPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'
        $CurrentVal = Get-ItemProperty -Path $LogonPath -Name AutoAdminLogon
        If ($CurrentVal.AutoAdminLogon -eq 1) {
            $CurrentUser = Get-ItemProperty -Path $LogonPath -Name DefaultUserName
            $CurrentPass = Get-ItemProperty -Path $LogonPath -Name DefaultPassword
            If ($CurrentUser.DefaultUserName -ne $Username -Or $CurrentPass.DefaultPassword -ne $Password) {
                Set-ItemProperty -Path $LogonPath -Name DefaultUserName -Value $Username
                Set-ItemProperty -Path $LogonPath -Name DefaultPassword -Value $Password
                WriteLog "[$(Get-Date)] Credentials Updated."
            }Else {
                WriteLog "[$(Get-Date)] AutoLogon already enabled."
            }
        }Else {
            Set-ItemProperty -Path $LogonPath -Name AutoAdminLogon -Value 1
            New-ItemProperty -Path $LogonPath -Name DefaultUserName -Value $Username
            New-ItemProperty -Path $LogonPath -Name DefaultPassword -Value $Password
            WriteLog "[$(Get-Date)] AutoLogon enabled."
        }
    }
    function Set-DisableServerManager (){
        $CurrentState = Get-ScheduledTask -TaskName "ServerManager"
        If ($CurrentState.State -eq "Ready") {
            Get-ScheduledTask -TaskName "ServerManager" | Disable-ScheduledTask *>> $Logfile
            WriteLog "[$(Get-Date)] Server Manager disabled at logon."
        } Else {
            WriteLog "[$(Get-Date)] Server Manager already disabled at logon."
        }
    }
    function Set-MonitorTimeout (){
        $CurrentVal = POWERCFG /QUERY SCHEME_BALANCED SUB_VIDEO VIDEOIDLE | Select-String -pattern "Current AC Power Setting Index:"
        If ($CurrentVal -like "*0x00000000*") {
            WriteLog "[$(Get-Date)] Display Timeout already set to Never."
        } Else {
            POWERCFG /CHANGE -monitor-timeout-ac 0
            WriteLog "[$(Get-Date)] Display Timeout set to Never."
        }
    }
    function Set-DisableScreensaver (){
        $Path = 'HKCU:\Control Panel\Desktop'
        Try {
          $CurrentVal = Get-ItemProperty -Path $Path -Name ScreenSaveActive
          WriteLog "[$(Get-Date)] $CurrentVal"
        } Catch {
          $CurrentVal = False
        } Finally {
          if ($CurrentVal.ScreenSaveActive -ne 0) {
            Set-ItemProperty -Path $Path -Name ScreenSaveActive -Value 0 *>> $Logfile
            WriteLog "[$(Get-Date)] Screensaver Disabled."
          } Else {
            WriteLog "[$(Get-Date)] Screensaver Already Disabled."
          }
        }
    }
    function Set-DisableUAC (){
        $Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
        $CurrentVal = Get-ItemProperty -Path $Path -Name ConsentPromptBehaviorAdmin
        if ($CurrentVal.ConsentPromptBehaviorAdmin -ne 00000000) {
            Set-ItemProperty -Path $Path -Name "ConsentPromptBehaviorAdmin" -Value 00000000 *>> $Logfile
            WriteLog "[$(Get-Date)] UAC Disabled."
        } Else {
            WriteLog "[$(Get-Date)] UAC Already Disabled."
        }
    }
    function Set-DisableIESecurity (){
        $AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
        $UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
        $CurrentVal = Get-ItemProperty -Path $AdminKey -Name "IsInstalled"
        if ($CurrentVal.IsInstalled -ne 0) {
            Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0 *>> $Logfile
            Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0 *>> $Logfile
            WriteLog "[$(Get-Date)] IE ESC Disabled."
        } Else {
            WriteLog "[$(Get-Date)] IE ESC Already Disabled."
        }
    }
    function Set-StableClock (){
        $useplatformclock = bcdedit | Select-String -pattern "useplatformclock        Yes"
        if ($useplatformclock) {
            WriteLog "[$(Get-Date)] Platform Clock Already Enabled."
        } Else {
            bcdedit /set  useplatformclock true *>> $Logfile
            WriteLog "[$(Get-Date)] Platform Clock Enabled."
        }
    }
    function Set-DisableShutdownTracker (){
        $Path = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Reliability'
        Try {
            $CurrentVal = Get-ItemProperty -Path $Path -Name ShutdownReasonUI
            WriteLog "[$(Get-Date)] $CurrentVal"
        } Catch {
            $CurrentVal = False
        } Finally {
            if ($CurrentVal.ShutdownReasonUI -ne 0) {
                New-ItemProperty -Path $Path -Name ShutdownReasonUI -Value 0
                WriteLog "[$(Get-Date)] Shutdown Tracker Disabled."
            }Else{
                WriteLog "[$(Get-Date)] Shutdown Tracker Already Disabled."
            }
        }
    }
    Function Set-WebPageTestInstall ($tempDir,$AgentDir,$wwwDir){
        Copy-Item -Path $AgentDir\agent\* -Destination C:\wpt-agent -Recurse -Force *>> $Logfile
        Copy-Item -Path $AgentDir\www\* -Destination C:\wpt-www -Recurse -Force *>> $Logfile
    }
    function Set-InstallAviSynth ($InstallDir){
        $Installed = Test-Path "C:\Program Files (x86)\AviSynth 2.5" -pathType container
        If ($Installed) {
            WriteLog "[$(Get-Date)] AviSynth already installed."
        } Else {
            & "$InstallDir\Avisynth_258.exe" /S *>> $Logfile
            WriteLog "[$(Get-Date)] AviSynth installed."
        }
    }
    function Set-InstallDummyNet ($InstallDir){
        Download-File -url $driver_installer_url -localpath $InstallDir -filename $driver_installer_file
        Download-File -url $driver_installer_cert_url -localpath $InstallDir -filename $driver_installer_cert_file
        $testsigning = bcdedit | Select-String -pattern "testsigning Yes"
        if ($testsigning) {
            WriteLog "[$(Get-Date)] Test Signing Already Enabled."
        } Else {
            bcdedit /set TESTSIGNING ON *>> $Logfile
            WriteLog "[$(Get-Date)] Test Signing Enabled."
        }
        $dummynet = Get-NetAdapterBinding -Name public*
        if ($dummynet.ComponentID -eq "ipfw+dummynet"){
            If ($dummynet.Enabled ) {
                WriteLog "[$(Get-Date)] ipfw+dummynet binding is already enabled."
            } Else {
                Enable-NetAdapterBinding -Name public0 -DisplayName ipfw+dummynet *>> $Logfile
                Disable-NetAdapterBinding -Name private0 -DisplayName ipfw+dummynet *>> $Logfile
            }
        }
        else{
            WriteLog "[$(Get-Date)]  $InstallDir\$driver_installer_cert_file"
            Import-Certificate -FilePath C:\wpt-agent\WPOFoundation.cer -CertStoreLocation Cert:\LocalMachine\TrustedPublisher *>> $Logfile
            cd $InstallDir
            .\mindinst.exe C:\wpt-agent\dummynet\64bit\netipfw.inf -i -s *>> $Logfile
            Enable-NetAdapterBinding -Name public0 -DisplayName ipfw+dummynet *>> $Logfile
            Enable-NetAdapterBinding -Name private0 -DisplayName ipfw+dummynet *>> $Logfile
            WriteLog "[$(Get-Date)] Enabled ipfw+dummynet binding."
        }
    }
    function Set-WebPageTestScheduledTask ($ThisHost, $User,$InstallDir){
        $GetTask = Get-ScheduledTask
        if ($GetTask.TaskName -match "wptdriver") {
            WriteLog "[$(Get-Date)] Task (wptdriver) already scheduled."
        } Else {
            $A = New-ScheduledTaskAction -Execute "$InstallDir\wptdriver.exe"
            $T = New-ScheduledTaskTrigger -AtLogon -User $User
            $S = New-ScheduledTaskSettingsSet
            $P = New-ScheduledTaskPrincipal -UserId "$ThisHost\$User" -LogonType ServiceAccount
            Register-ScheduledTask -TaskName "wptdriver" -Action $A -Trigger $T -Setting $S -Principal $P *>> $Logfile
            WriteLog "[$(Get-Date)] Task (wptdriver) scheduled."
        }
        $GetTask = Get-ScheduledTask
        if ($GetTask.TaskName -match "urlBlast") {
            WriteLog "[$(Get-Date)] Task (urlBlast) already scheduled."
        } Else {
            $A = New-ScheduledTaskAction -Execute "$InstallDir\urlBlast.exe"
            $T = New-ScheduledTaskTrigger -AtLogon -User $User
            $S = New-ScheduledTaskSettingsSet
            $P = New-ScheduledTaskPrincipal -UserId "$ThisHost\$User" -LogonType ServiceAccount
            Register-ScheduledTask -TaskName "urlBlast" -Action $A -Trigger $T -Setting $S -Principal $P *>> $Logfile
            WriteLog "[$(Get-Date)] Task (urlBlast) scheduled."
        }
    }
    function Set-ScheduleDefaultUserName ($ThisHost, $User, $Password, $InstallDir) {
            $DefaultUserNameURL = "https://raw.githubusercontent.com/Linuturk/webpagetest/master/heat/Set-AutoLogon.ps1"
            Invoke-WebRequest $DefaultUserNameURL -OutFile "$InstallDir\DefaultUserName.ps1" *>> $Logfile
            Replace-String -filePath "$InstallDir\DefaultUserName.ps1" -stringToReplace "%%USERNAME%%" -replaceWith $User
            $A = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-ExecutionPolicy Bypass -File $InstallDir\DefaultUserName.ps1"
            $T = New-ScheduledTaskTrigger -AtStartup
            $S = New-ScheduledTaskSettingsSet
            $D = New-ScheduledTask -Action $A -Trigger $T -Settings $S
            Register-ScheduledTask -TaskName "DefaultUserName Fix" -InputObject $D -User $User -Password $Password *>> $Logfile
    }

    function Set-AgentUpdaterScheduledTask ($ThisHost, $User, $InstallDir) {
          $AgentUpdaterURL = "https://raw.githubusercontent.com/Linuturk/webpagetest/master/heat/Agent-Updater.ps1"
          Invoke-WebRequest $AgentUpdaterURL -OutFile "$InstallDir\Agent-Updater.ps1"
          $A = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-ExecutionPolicy Bypass -File $InstallDir\Agent-Updater.ps1"
          $T = New-ScheduledTaskTrigger -AtLogon -User $User
          $S = New-ScheduledTaskSettingsSet
          $P = New-ScheduledTaskPrincipal -UserId "$ThisHost\$User" -LogonType ServiceAccount
          Register-ScheduledTask -TaskName "WPT Agent Updater" -Action $A -Trigger $T -Setting $S -Principal $P *>> $Logfile
    }

    function Install-WebPlatformInstaller(){
        WriteLog "[$(Get-Date)] Installing Web Platform Installer."
        Download-File -url $wpi_msi_url -localpath $wpt_temp_dir -filename $wpi_msi_file
        Install-MSI -MsiPath $wpt_temp_dir -MsiFile $wpi_msi_file
    }
    function Install-Apache (){
        WriteLog "[$(Get-Date)] Installing Apache."
        Download-File -url $vcpp_vc11_url -localpath $wpt_temp_dir -filename $vcpp_vc11_file
        Download-File -url $apache_bin_url -localpath $wpt_temp_dir -filename $apache_bin_file
        if ((Get-Service).Name -match "W3SVC"){
            WriteLog "[$(Get-Date)] IIS is present on this Server. Stoping and Disabling the service"
            Set-Service -Name W3SVC -StartupType Manual
            Stop-Service -Name W3SVC -Force *>> $Logfile
            Stop-Service -Name IISADMIN -Force *>> $Logfile
        }else{
            WriteLog "[$(Get-Date)] IIS is not present on this Server."
        }

        if ((Get-Service).Name -match "Apache2.4"){
            WriteLog "[$(Get-Date)] Apache is already installed and the service is configured."
        }else{
            & "$wpt_temp_dir\vcredist_x86.exe" /q /norestart
            Unzip-File -fileName $apache_bin_file -sourcePath $wpt_temp_dir -destinationPath $wpt_temp_dir
            Move-Item "$wpt_temp_dir\Apache24" "C:\Apache24" -Force
            $httpconf_path = 'C:\Apache24\conf\httpd.conf'
            $httpconf_old_servername = '^\#ServerName www\.example\.com\:80$'
            $httpconf_new_servername = "ServerName $($DomainName):80"
            Replace-String -filePath $httpconf_path -stringToReplace $httpconf_old_servername -replaceWith $httpconf_new_servername

            & C:\Apache24\bin\httpd.exe -k install *>> $Logfile
            Start-Service -Name Apache2.4 *>> $Logfile
        }
    }
    function Install-PHP (){
        WriteLog "[$(Get-Date)] Installing PHP53."
        Download-File -url $php_bin_url -localpath $wpt_temp_dir -filename $php_bin_file
        Unzip-File -fileName $php_bin_file -sourcePath $wpt_temp_dir -destinationPath c:\php
        Download-File -url $php_ini_url -localpath $wpt_temp_dir -filename "php.ini"
        Copy-Item -Path $wpt_temp_dir\php.ini -Destination C:\php\ -Force *>> $Logfile
        Download-File -url $apache_conf_url -localpath $wpt_temp_dir -filename "httpd.conf"
        Copy-Item -Path C:\wpt-temp\httpd.conf -Destination C:\Apache24\conf\httpd.conf -Force *>> $Logfile
        Download-File -url $php_apc_url -localpath $wpt_temp_dir -filename $php_apc_file
        Unzip-File -fileName $php_apc_file -sourcePath $wpt_temp_dir -destinationPath  C:\php\ext

        Restart-Service -Name Apache2.4
    }
    function Install-Ffmeg (){
        WriteLog "[$(Get-Date)] Installing Ffmeg."
        Download-File -url $ffmeg_bin_url -localpath $wpt_temp_dir -filename $ffmeg_bin_file
        Unzip-File -fileName $ffmeg_bin_file -sourcePath $wpt_temp_dir -destinationPath c:\ffmpeg

        $ffmpeg_path = ";c:\ffmpeg\bin"
        if (($env:Path).Contains($ffmpeg_path)){
            WriteLog "[$(Get-Date)] ffmpeg path is already in the Env Path"
        }else{
            WriteLog "[$(Get-Date)] Adding the $ffmpeg_path to the Env Path"
            $env:Path += $ffmpeg_path
        }
        Restart-Service -Name Apache2.4 *>> $Logfile
    }
    function Enable-WebServerFirewall(){
       WriteLog "[$(Get-Date)] Enabling port 80"
        netsh advfirewall firewall add rule name="Open Port 80" dir=in action=allow protocol=TCP localport=80 *>> $Logfile
    }
    function Clean-Deployment{
        #region Remove Automation initial firewall rule opener
        if((Test-Path -Path 'C:\Cloud-Automation')){
            Remove-Item -Path 'C:\Cloud-Automation' -Recurse *>> $Logfile
        }
        #endregion
        #region Schedule Task to remove the Psexec firewall rule
        $DeletePsexec = {
            Remove-Item $MyINvocation.InvocationName
            $find_rule = netsh advfirewall firewall show rule "PSexec Port"
            if ($find_rule -notcontains 'No rules match the specified criteria.') {
                Write-Host "Deleting firewall rule"
                netsh advfirewall firewall delete rule name="PSexec Port" *>> $Logfile
            }
        }
        $Cleaner = "C:\Windows\Temp\cleanup.ps1"
        Set-Content $Cleaner $DeletePsexec
        $ST_Username = "autoadmin"
        net user /add $ST_Username $FtpPassword *>> $Logfile
        net localgroup administrators $ST_Username /add *>> $Logfile
        $ST_Exec = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
        $ST_Arg = "-NoLogo -NonInteractive -WindowStyle Hidden -ExecutionPolicy ByPass C:\Windows\Temp\cleanup.ps1"
        $ST_A_Deploy_Cleaner = New-ScheduledTaskAction -Execute $ST_Exec -Argument $ST_Arg
        $ST_T_Deploy_Cleaner = New-ScheduledTaskTrigger -Once -At ((Get-date).AddMinutes(2))
        $ST_S_Deploy_Cleaner = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -WakeToRun -DontStopIfGoingOnBatteries -StartWhenAvailable -MultipleInstances Parallel
        Register-ScheduledTask -TaskName "Clean Automation" -TaskPath \ -RunLevel Highest -Action $ST_A_Deploy_Cleaner -Trigger $ST_T_Deploy_Cleaner -Settings $ST_S_Deploy_Cleaner -User $ST_Username -Password $FtpPassword *>> $Logfile
        #endregion
    }
    function Set-WptConfig (){
        Copy-Item -Path C:\wpt-www\settings\feeds.inc.sample -Destination C:\wpt-www\settings\feeds.inc -Force *>> $Logfile
        Copy-Item -Path C:\wpt-www\settings\locations.ini.sample -Destination C:\wpt-www\settings\locations.ini -Force *>> $Logfile
        Copy-Item -Path C:\wpt-www\settings\settings.ini.sample -Destination C:\wpt-www\settings\settings.ini -Force *>> $Logfile
        Copy-Item -Path C:\wpt-agent\urlBlast.ini.sample -Destination C:\wpt-agent\urlBlast.ini -Force *>> $Logfile
        Copy-Item -Path C:\wpt-agent\wptdriver.ini.sample -Destination C:\wpt-agent\wptdriver.ini -Force *>> $Logfile
    }
    function Set-ClosePort445 (){
        $CurrentVal = Get-NetFirewallRule
        if ($CurrentVal.InstanceID -match "PSexec Port" -and $CurrentVal.Enabled -eq "true") {
            Disable-NetFirewallRule -Name "PSexec Port" *>> $Logfile
            WriteLog "[$(Get-Date)] Port PSexec Port Disabled."
        } Elseif($CurrentVal.InstanceID -match "PSexec Port" -and $CurrentVal.Enabled -eq "false"){
            WriteLog "[$(Get-Date)] Port PSexec Port Already Disabled."
        }Else {
            WriteLog "[$(Get-Date)] Port PSexec Port rules does not exist."
        }
    }

    #region => Main
    Set-WptFolders
    Download-File -url $wpt_zip_url -localpath $wpt_temp_dir -filename $wpt_zip_file
    Download-File -url $driver_installer_url -localpath $wpt_agent_dir -filename $driver_installer_file
    Download-File -url $driver_installer_cert_url -localpath $wpt_temp_dir -filename $driver_installer_cert_file
    Unzip-File -fileName $wpt_zip_file -sourcePath $wpt_temp_dir -destinationPath $wpt_agent_dir
    Set-WebPageTestUser -Username $wpt_user -Password $wpt_password
    Set-AutoLogon -Username $wpt_user -Password $wpt_password
    Set-DisableServerManager
    Set-MonitorTimeout
    Set-DisableScreensaver
    Set-DisableUAC
    Set-DisableIESecurity
    Set-StableClock
    Set-DisableShutdownTracker
    Set-WebPageTestInstall -tempDir $wpt_temp_dir -AgentDir $wpt_agent_dir
    Set-InstallAviSynth -InstallDir $wpt_agent_dir
    Set-InstallDummyNet -InstallDir $wpt_agent_dir
    Set-WebPageTestScheduledTask -ThisHost $wpt_host -User $wpt_user -InstallDir $wpt_agent_dir
    Set-ScheduleDefaultUserName -ThisHost $wpt_host -User $wpt_user -Password $wpt_password -InstallDir $wpt_agent_dir
    Set-AgentUpdaterScheduledTask -ThisHost $wpt_host -User $wpt_user -InstallDir $wpt_agent_dir
    Install-WebPlatformInstaller
    Install-Apache
    Install-PHP
    Install-Ffmeg
    Set-WptConfig
    Enable-WebServerFirewall
    Set-ClosePort445
    #endregion
    Download-File -url $wpt_locations_ini -localpath "$wpt_www_dir\settings" -filename "locations.ini"
    Download-File -url $wpt_settings_ini -localpath "$wpt_www_dir\settings" -filename "settings.ini"
    Download-File -url $wpt_feeds_inc -localpath "$wpt_www_dir\settings" -filename "feeds.inc"
    Download-File -url $wpt_urlBlast_ini -localpath $wpt_agent_dir -filename "urlBlast.ini"
    Download-File -url $wpt_wptdriver_ini -localpath $wpt_agent_dir -filename "wptdriver.ini"
}
#endregion

#region MAIN : Deploy Web Pagge Test
#Delete myself from the filesystem during execution
#Remove-Item $MyINvocation.InvocationName

Deploy-WebPagetest
#Deploy-WebPagetest -DomainName "%wptdomain%" -wpt_user "%wptusername%" -wpt_password "%wptpassword%"
#endregion
