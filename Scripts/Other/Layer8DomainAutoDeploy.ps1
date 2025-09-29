Install-WindowsFeature -name AD-Domain-Services -IncludeManagementTools
Install-ADDSDomainController -DomainName "CSUNLayer8.com" -SafeModeAdministratorPassword (Read-Host -Prompt "DSRM Password" -AsSecureString) -InstallDns
