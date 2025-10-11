#ADD PSSESIONS

Invoke-Command -ScriptBlock { 
    $SysmonUrl = "https://download.sysinternals.com/files/Sysmon.zip"
    $CUrl = "https://github.com/SwiftOnSecurity/sysmon-config/archive/refs/heads/master.zip"
    $DownloadPath = "$env:TEMP\Sysmon.zip"
    $ExtractPath = "$env:TEMP\Sysmon"
    $CDownloadPath = "$env:TEMP\sysmon-config-master.zip"
    $CExtractPath = "$env:TEMP\sysmon-config-master"

    Invoke-WebRequest -Uri $SysmonUrl -OutFile $DownloadPath
    Expand-Archive -Path $DownloadPath -DestinationPath $ExtractPath -Force
    Invoke-WebRequest -Uri $CUrl -OutFile $CDownloadPath
    Expand-Archive -Path $CDownloadPath -DestinationPath $CExtractPath -force

     
    & "$ExtractPath\Sysmon64.exe" -i "$CExtractPath\sysmon-config-master\sysmonconfig-export.xml"
} -ComputerName "C-01"