Install-WindowsFeature -name AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName "CSUNLayer8.com" -SafeModeAdministratorPassword (Read-Host -Prompt "DSRM Password" -AsSecureString) -InstallDns
