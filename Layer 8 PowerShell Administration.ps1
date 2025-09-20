if (!(Test-Path -Path "C:\output")) {
		New-Item -ItemType Directory -Path "C:\output"
		Set-Acl -Path "C:\output" -AclObject $PSScriptRoot\Other\outputacl.txt
	} 

#0a
function Unblock-Scripts {
	(Get-ChildItem -Filter * -Path $PSScriptRoot -Recurse).PSPath | ForEach-Object { Unblock-File $_ }
}

<# 

	More info about scripts in 
	CCDC Administration myBox

	NOTE: It probably isn't up-to-date

#>

<#

	NOTES ABOUT SCRIPT:
		- 3 and 4 use static names
		- Make sure you enter your credentials immediately if you launch scripts that require them
		- It's scuffed
		
#>

<#

	Brian Notes:
		- Import-File, Import-Module
		- Create web server with all files needed for comp
		- Secure the psswrdshfl script
		- Change file permissions for output folder

#>

<#

	Import module commands start below

#>

# Will load all modules if you choose yes
$unblockScriptsCond = Read-Host "Unblock all scripts? (Use if you want to load all features) [Y/N]"
if ($unblockScriptsCond -eq "Y") {
	Unblock-Scripts
	$unblockScriptsCond = $true
}
elseif ($unblockScriptsCond -eq "N") {
	Write-Host -ForegroundColor Yellow "Ok"
	$unblockScriptsCond = $false
}
else {
	Write-Host -ForegroundColor Magenta "I'll do it anyways"
	Unblock-Scripts
	$unblockScriptsCond = $true
}

if ($unblockScriptsCond -eq $true) {
	Import-Module -Name "$PSScriptRoot\Private\lib\ImportExcel" -Verbose
}

<#

	Import module commands end above

#>

<#

	Functions for command start below

	NOTES:
		- Comments above functions show which switch statement its linked to

#>

#1a
function Ping-LocalADMachines {
		
	$listArray = @()
	$numList = 1
	$1a = Get-ADComputer -Filter * | Select-Object -ExpandProperty Name | Sort-Object -desc
	foreach ($1 in $1a) {
		"(" + $numList.ToString() + ")" + $1
		$numList++
		$listArray += $1
	}
		
	Write-Host "Choose a computer to ping"
	$choose = Read-Host
	$result = $listArray[$choose - 1]
	Test-NetConnection $result
}

#PingInfoView may not be allowed during comp...will get to later
#1b UNFINISHED SCRIPT
function Use-PingInfoView {
	$writing = $true
	$hostsList = @()
	while ($writing -eq $true) {

		$read = Read-Host "Enter one host at a time"
		$hostsList += "$read`r`n"
		if ($read -eq "") {
			$writing = $false
	
		}

	}

}

#2a
function Reset-LocalADUserPassword {
	$listArray = @()
	$numList = 1
	$2a = Get-ADOrganizationalUnit -Filter * | Select-Object -ExpandProperty DistinguishedName | Sort-Object -desc
	foreach ($2 in $2a) {
		"(" + $numList.ToString() + ")" + $2
		$numList++
		$listArray += $2
	}
		
	Write-Host "Choose an OU"
	$choose = Read-Host
	$result = $listArray[$choose - 1]
	$users = @(Get-ADUser -Filter * -SearchBase $result | Select-Object -ExpandProperty SamAccountName | Sort-Object -desc)
	$numList = 1
	foreach ($user in $users) {
		"(" + $numList.ToString() + ")" + $user
		$numList++
		$users += $users
	}
		
	Write-Host "Choose a user"
	$choose = Read-Host
	$result = $users[$choose - 1]
	$if = Read-Host "Change password on next logon? (Y/N)"
	if ($if -eq "Y") {
		Set-ADUser -Credential $credential -Identity $result -ChangePasswordAtLogon $true
		Set-ADAccountPassword -Credential $credential -Identity $result -Reset
	}
	ElseIf ($if -eq "N") {
		Set-ADUser -Credential $credential -Identity $result -ChangePasswordAtLogon $false
		Set-ADAccountPassword -Credential $credential -Identity $result -Reset
	}
	Else {
		Write-Host -ForegroundColor Red "Incorrect value proceeding to password reset"
		Set-ADAccountPassword -Credential $credential -Identity $result -Reset
	}
}

#3a
function Invoke-PodGPUpdate {
	$condition = Read-Host "GPU and Restart Machines (Y/N)"
	if ($condition -eq "Y") {
		Invoke-GPUpdate NPOD1, NPOD2, NPOD3, NPOD4, WPOD1, WPOD2, WPOD3, WPOD4, LPOD1, LPOD2, LPOD3, LPOD4 -Force -Boot
	}
	ElseIf ($condition -eq "N") {
		Invoke-GPUpdate NPOD1, NPOD2, NPOD3, NPOD4, WPOD1, WPOD2, WPOD3, WPOD4, LPOD1, LPOD2, LPOD3, LPOD4 -Force
	}
	Else {
		Write-Host -ForegroundColor Red "Incorrect value proceeding to regular update"
		Invoke-GPUpdate NPOD1, NPOD2, NPOD3, NPOD4, WPOD1, WPOD2, WPOD3, WPOD4, LPOD1, LPOD2, LPOD3, LPOD4 -Force
	}
}

#4a
function Restart-Pods {
	Restart-Computer NPOD1, NPOD2, NPOD3, NPOD4, WPOD1, WPOD2, WPOD3, WPOD4, LPOD1, LPOD2, LPOD3, LPOD4 -Force -Confirm
}

#5a
function Set-ADUserAccountExpiration {
	$listArray = @()
	$numList = 1
	$5a = Get-ADOrganizationalUnit -Filter * | Select-Object -ExpandProperty DistinguishedName | Sort-Object -desc
	foreach ($5 in $5a) {
		"(" + $numList.ToString() + ")" + $5
		$numList++
		$listArray += $5
	}
		
	Write-Host "Choose an OU"
	$choose = Read-Host
	$result = $listArray[$choose - 1]
	$users = @(Get-ADUser -Filter * -SearchBase $result | Select-Object -ExpandProperty SamAccountName | Sort-Object -desc)
	Write-Host -ForegroundColor Yellow "How powershell reads dates:'6/9/2069'"
	[string]$year = Read-Host "Enter year"
	[string]$month = Read-Host "Enter month (ADD '/' @ END)"
	[string]$day = Read-Host "Enter day(ADD '/' @ END)"
	[string]$date = $month + $day + $year
	foreach ($user in $users) {
		Set-ADAccountExpiration -Credential $credential -Identity $user -DateTime $date
	}
}

#6a
function Remove-ADAccountExpiration {
	$listArray = @()
	$numList = 1
	$6a = Get-ADUser -Filter * | Select-Object -ExpandProperty SamAccountName | Sort-Object -desc
	foreach ($6 in $6a) {
		"(" + $numList.ToString() + ")" + $6
		$numList++
		$listArray += $6
	}
		
	$inp = Read-Host "Enter numbers"
	$numbers = $inp -split ', ' | Where-Object { $_ -ne "" } | ForEach-Object { [int]$_ }
	foreach ($number in $numbers) {
		Clear-ADAccountExpiration -Identity $listArray[$number - 1]
			
	}
		
}

#7a
function Set-ADAccountEmails {
	$listArray = @()
	$numList = 1
	$OUArr = Get-ADOrganizationalUnit -Filter * | Select-Object -ExpandProperty DistinguishedName | Sort-Object -desc
	foreach ($OU in $OUArr) {
		"(" + $numList.ToString() + ")" + $OU
		$numList++
		$listArray += $OU
	}
	$choose = Read-Host "Choose OU"
	$result = $listArray[$choose - 1]
	Write-Host -ForegroundColor Yellow "$result CHOSEN"
	Get-ADUser -Filter * -SearchBase "$result" | Select-Object -ExpandProperty SamAccountName | ForEach-Object { Set-ADUser -Credential $credential -Identity $_ -EMailAddress "$_@AnimeHealth.net" }
}

#8a
#Figuring out regex
#Email Address maybe?
#name logic not working need to fix og method
function New-ADUsers{
#temp
$credential = Get-Credential


Write-Host -ForegroundColor Yellow "Looking for users.txt"
if (!(Test-Path -Path "$PSScriptRoot\users.txt")) {
		Write-Host -ForegroundColor Red "`nPlease insert users.txt"
		Write-Host -ForegroundColor Yellow "`nScript will start automatically once the file is found within the script root"
		while(!(Test-Path -Path "$PSScriptRoot\users.txt")){
		}
	}
	
	$secureStr = ConvertTo-SecureString -AsPlainText 'LayerDank420$'
	$domainName = Get-ADDomain | Select-Object -ExpandProperty DNSRoot
	
	Write-Host -ForegroundColor Cyan "`nFound!"
	$users = Get-Content users.txt
	$dupChkS = $users[0]
	$dupChkS = $dupChkS -split " "
	$dupChkLN = $dupChkS[1]
	$dupChkFI = $dupChkS[0]
	$dupChkFI = $dupChkFI[0]
	$dupChk = ("$dupChkFI" + "$dupChkLN")
	$dupNum = 1
	foreach($user in $users){
		
		$dupFlag = $false
		$build = $user -Split " "
		
		if(!($build.Length -eq 2)){
			Write-Host -ForegroundColor Red "Error occured with formatting. Please check your txt file"
			return
		}
		
		$fName = $build[0]
		$lName = $build[1]
		$fInit = $fName[0]
		$dupUsr = ("$fInit" + "$lName")
		
		if($dupChk -eq $dupUsr){
			$dupNum++
			$dupFlag = $true
		}
		
		if($dupFlag -eq $true){
		New-ADUser -Name "$fName $lName" -AccountPassword $secureStr -ChangePasswordAtLogon $true -Credential $credential -DisplayName "$fName $lName" -Enabled $true -GivenName "$fName" -Surname "$lName" -UserPrincipalName ("$dupUsr" + "0$dupNum" + "@$domainName")
		Write-Host -ForegroundColor Cyan "Great!"
		}else{
		New-ADUser -Name "$fName $lName" -AccountPassword $secureStr -ChangePasswordAtLogon $true -Credential $credential -DisplayName "$fName $lName" -Enabled $true -GivenName "$fName" -Surname "$lName" -UserPrincipalName ("$fInit" + "$lName" + "01" + "@$domainName")
		Write-Host -ForegroundColor Cyan "Great!"
	}
	}
	
}

#100a
function Enable-PSRemotingInDomain {
	$location = (Get-Location).Path
	$distN = Get-ADDomain | Select-Object -ExpandProperty DistinguishedName
	Import-GPO -BackupGpoName 'WinRM' -TargetName 'WinRM' -Path "$location\Group Policy\WinRM" -CreateifNeeded
	New-GPLink -Name "WinRM" -Target "$distN" -LinkEnabled Yes
	gpupdate /force
}

#100b UNFINISHED SCRIPT
function Install-ChocolateyInDomain {
	Invoke-Command {
		Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
	}
}

#101a
function Get-InventoryDomainLocal {
		
	if (!(Test-Path -Path "C:\output")) {
		New-Item -ItemType Directory -Path "C:\output"
	} 
			
	$fileName = Read-Host "Enter filename. File will be outputted to C:\output as .txt"
	$computers = Get-ADComputer -Filter * | Select-Object -ExpandProperty Name
	$output = @()
		
	foreach ($computer in $computers) {
		if ($computer -eq (Get-ComputerInfo | select-Object -ExpandProperty CsName)) {
				
			$ipAddress = Get-NetIPAddress | Select-Object -ExpandProperty IPv4Address | Where-Object { $_ -notlike "127.*" }
			$macAddress = Get-NetAdapter | select-Object -ExpandProperty MacAddress
			$osName = Get-ComputerInfo | Select-Object -ExpandProperty osname
						
		}
		else {
			try {
				$ipAddress = Invoke-Command -ComputerName $computer -ScriptBlock { Get-NetIPAddress | Select-Object -ExpandProperty IPv4Address | Where-Object { $_ -notlike "127.*" } } -ErrorAction Stop 
				$macAddress = Invoke-Command -ComputerName $computer -ScriptBlock { Get-NetAdapter | select-Object -ExpandProperty MacAddress } -ErrorAction Stop 
				$osName = Invoke-Command -ComputerName $computer -ScriptBlock { Get-ComputerInfo | Select-Object -ExpandProperty osname } -ErrorAction Stop 
			}
			catch {
					
				Write-Host -ForegroundColor Red "Something went wrong...is WinRM configured correctly on all machines?"
				break
			}
		}
			
		$output = @($computer + ": " + $macAddress + ", " + $ipAddress + ", " + $osName)
		$output | Out-File -FilePath "C:\output\$fileName.txt" -Append
	}
		
			
}

#102a Is the verb 'Shuffle' ok?
function Set-RandomADPasswords {
	#add random characters
	if (!(Test-Path -Path "C:\output")) {
		New-Item -ItemType Directory -Path "C:\output"
	} 
		
	$t = get-date -format yyyymmdd_HHmm
	$fileName = "pwFile"
		
	if ((Test-Path -Path "C:\output\pwFile.txt") -eq ($true)) {
		Clear-Content -Path "C:\output\pwFile.txt"
	}
		
	$Users = Get-ADUser -Filter * | Select-Object -ExpandProperty SamAccountName
	foreach ($User in $Users) {
		$passphrase = $null
		$randomEndNumber = Get-Random -Max 99999 -Min 10000
		$count = 0
		$noun = $null
		$verb = $null
		$adjective = $null
		# 3 words per passphrase logic
		while ($count -ne 3) {
			$txtFile = Get-Random -Max 4 -Min 1
			switch ($txtFile) {
				1 {
					# We don't want repeats of words
					if ($null -ne $noun) {
						break
					}
					$noun = Get-Random -InputObject (Get-Content "$PSScriptRoot\Passphrases\Nouns.txt")
					$count++
					$passphrase += $noun + "-"
				}

				2 {
					if ($null -ne $verb) {
						break
					} 
					$verb = Get-Random -InputObject (Get-Content "$PSScriptRoot\Passphrases\Verbs.txt")
					$count++
					$passphrase += $verb + "-"
			   
				}

				3 {
					if ($null -ne $adjective) {
						break
					}
					$adjective = Get-Random -InputObject (Get-Content "$PSScriptRoot\Passphrases\Adjectives.txt")
					$count++
					$passphrase += $adjective + "-"
				}

			}
		}
	
		#Builds the final passphrase and sets it
		$passphrase += $randomEndNumber
		$securePassword = ConvertTo-SecureString -String $passphrase -AsPlainText -Force
		Set-ADAccountPassword -Identity $User -NewPassword $securePassword -Credential $credential
		$output = @("$User" + ": " + "$passphrase")
		$dynamicFile += $output
		# Writing current user's PW to the PW file and loop to get the next user.
		$output | Out-File -FilePath "C:\output\$fileName.txt" -Append
		Invoke-Item -Path "C:\output\"
	}

	# Writing out the dynamic file
		
	$fileName = "pwFile_$t"
	$dynamicFile | Out-File -FilePath "C:\output\$fileName.txt"

}

#103a
function Stop-SMBv1 {
	#Turns SMB1 off
	Set-SmbServerConfiguration -EnableSMB1Protocol $false -Force

	#Checks if SMB1 if off
	$test = (Get-SmbServerConfiguration).EnableSMB1Protocol 

	if ($test -eq $false) {
		Write-Host "Success"
	}
	else {
		Write-Host "Failure"
	}

}

<#

	Functions for commands end above

#>

Write-Host -ForegroundColor Red @"
                                                                                
                                       ,,,                                      
                                    ,,,,,,,,,                                   
                               ,,,,,,,,,,,,,,,,,,,                              
                       ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,                      
       ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,         ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,      
       ,,,,,,,,,,,,,,,,,,,,,,,       ,,,,,,.       ,,,,,,,,,,,,,,,,,,,,,,,      
       ,,,,,,,,,,,            ,,,,,,,,,,,,,,,,,,,,,            ,,,,,,,,,,,      
       ,,,,,,,    ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.    ,,,,,,,      
       .,,,,,,  ,,,,,,,,,,,,,,,,,@@@@@@@@@@@@@@@,,,,,,,,,,,,,,,,,  ,,,,,,       
        ,,,,,,  .,,,,,,,,,,,,,%@@@@@@@@@@@@@@@@@@@(,,,,,,,,,,,,,   ,,,,,,       
                 ,,,,,,,,,,,,@@@@@@@@*,,,,,/@@@@@@@@,,,,,,,,,,,,                
         ,,,,,,  ,,,,,,,,,,,,@@@@@@@,,,,,,,,,@@@@@@@,,,,,,,,,,,,  ,,,,,,        
        .,,,,,,   ,,,,,,,,,,,@@@@@@@,,,,,,,,*@@@@@@&,,,,,,,,,,,   ,,,,,,        
         ,,,,,,,  ,,,,,,,,,,,,,@@@@@@@@@@@@@@@@@@@,,,,,,,,,,,,,  ,,,,,,,        
         ,,,,,,,   ,,,,,,,,,,,,,@@@@@@@@@@@@@@@@@,,,,,,,,,,,,,   ,,,,,,.        
          ,,,,,,,  ,,,,,,,,,,@@@@@@@@@@@@@@@@@@@@@@@,,,,,,,,,,  ,,,,,,,         
          .,,,,,,.  ,,,,,,,,@@@@@@@,,,,,,,,,,,@@@@@@@,,,,,,,,  ,,,,,,,          
           ,,,,,,,   ,,,,,,,@@@@@@@,,,,,,,,,,,@@@@@@@,,,,,,,   ,,,,,,,          
            ,,,,,,,   ,,,,,,@@@@@@@@@,,,,,,,@@@@@@@@@,,,,,,   ,,,,,,,           
             ,,,,,,,   ,,,,,,/@@@@@@@@@@@@@@@@@@@@@*,,,,,,   ,,,,,,,            
              ,,,,,,,   ,,,,,,,,/@@@@@@@@@@@@@@@/,,,,,,,,   ,,,,,,,             
               ,,,,,,,,  ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.  ,,,,,,,,              
                .,,,,,,,   ,,,,,,,,,,,,,,,,,,,,,,,,,,,   ,,,,,,,                
                  ,,,,,,,,   ,,,,,,,,,,,,,,,,,,,,,,,   ,,,,,,,,                 
                    ,,,,,,,,   .,,,,,,,,,,,,,,,,,    ,,,,,,,,                   
                     .,,,,,,,,,   ,,,,,,,,,,,,.   ,,,,,,,,,                     
                        ,,,,,,,,,,    ,,,,,    ,,,,,,,,,,                       
                          ,,,,,,,,,,,,     ,,,,,,,,,,,,                         
                             ,,,,,,,,,,,,,,,,,,,,,,,                            
                                 ,,,,,,,,,,,,,,,                                
                                      ,,,,,                                     
"@

<#

	Script execution starts below

#>

try {
	$credential = Get-Credential -Message "Enter Domain Admin credentials"
}
catch {
	Write-Host -ForegroundColor Yellow "No initial credential provided. This is fine."
}
powershell -file Help.ps1 -path $PSScriptRoot
$start = $true
while ($start -eq $true) {
	$num = Read-Host "Enter a command"
	switch ($num) {
		0a {
			
			Unblock-Scripts
			break
			
		}
		
		1a {
		
			Ping-LocalADMachines
			break
		}
	
		2a {
				
			Reset-LocalADUserPassword
			break

		}
	
		3a {
	
			Invoke-PodGPUpdate
			break

		}
		
		4a {
	
			Restart-Pods
			break

		}
	
		5a {
	
			Set-ADUserAccountExpiration
			break

		}
	
		6a {
			
			Remove-ADAccountExpiration
			break

		}
	
		7a {
	
			Set-ADAccountEmails
			break

		}

		8a {
			
			New-ADUsers
			break
		
		}

		#secret government password cracker
		69 {

			if ((Test-Path -Path "C:\HACKING.txt") -eq ($true)) {
				Clear-Content -Path "C:\HACKING.txt"
			}
			else {
				Out-File -FilePath "C:\HACKING.txt"
			}
			
			$count = 0
			$nextPhase = 1
			Write-Host "Attempting to connect with IP: 420.420.420.420"
			Start-Sleep -Seconds 5
			Write-Host "Trying to Connect..."
			Start-Sleep -Seconds 5
			Write-Host "Trying to Connect..."
			Start-Sleep -Seconds 5
			Write-Host "Target Found!: 69.69.69.69"
			Start-Sleep -Seconds 2
			Write-Host "Connected on port 6969"
			Add-Content -Path "C:\HACKING.txt" -Value "<L@YER 8>: WE ARE IN"
			Start-Sleep -Seconds 5
			Invoke-Item "C:\HACKING.txt"

			Write-Host -ForegroundColor Yellow "Initialzing script`n"
			for ($i = 0; $i -lt 50; $i++) {
				Start-Sleep -Milliseconds 100
				Write-Host -ForegroundColor Yellow -NoNewline "."
			}
			Start-Sleep -Seconds 1
			Write-Host -ForegroundColor Red "`nCR@CKING CSUN M@INFR@AM3.ps1 INITI@LIZ3D"
			Start-Sleep -Seconds 1
			Write-Host -ForegroundColor Yellow "INITI@LIZ3ING PH@S3 1"
			Start-Sleep -Milliseconds 500
			while ($true) {
				$characters = @("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
					"n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
					"N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "!", "@", "#", "$", "%" , "^", "&", "*", 
					"(", ")", "-", "_", "=", "+", "[", "]", "{", "}", "\", "|", ";", ":", "'", "\", ",", ".", "/", "<", ">", "?")
				$getRandom = $characters | Get-Random
				Start-Sleep -Milliseconds 10
				Write-Host -NoNewline -ForegroundColor Green "$getRandom"
				$count++
				if ($count -ge 2500) {
					[System.Media.SystemSounds]::Beep.Play()
					$nextPhase++
					Write-Host -ForegroundColor Yellow "`nINITI@LIZ3ING PH@S3 $nextPhase"
					if ($nextPhase -eq 2) {
						Start-Sleep -Second 2
						Add-Content -Path "C:\HACKING.txt" -Value "<xx3XTR3M3H@CKZORxx>: WUT?"
						Invoke-Item "C:\HACKING.txt"
						Start-Sleep -Seconds 2
						Add-Content -Path "C:\HACKING.txt" -Value "<Kevin>: Insane!"
						Invoke-Item "C:\HACKING.txt"

					}
					$count = 0
				}

			}
			
			break
		}
		
		<#
		
		Below are CCDC Scripts
		
		#>
		
		100a {
		
			Enable-PSRemotingInDomain
			break
		
		}

		100b {

			Install-ChocolateyInDomain
			break
		}
		
		101a {
			
			Get-InventoryDomainLocal
			break
	
		}

		102a {
			
			Set-RandomADPasswords
			break

		}
		
		103a {

			Stop-SMBv1
			break

		}

		104a {

			Start-Process -FilePath "powershell" -ArgumentList $PSScriptRoot\Scripts\userPasswordMonitor.ps1
			Start-Process -FilePath "powershell" -ArgumentList $PSScriptRoot\Scripts\userLogonMonitor.ps1
			break

		}

		#Help
		? {
	
			powershell -file Help.ps1 -path $PSScriptRoot
			break

		}
	
		?? {
		
			Write-Host -ForegroundColor Yellow "Local: Can only be run on computer connected to domain."
			Write-Host -ForegroundColor Yellow "Remote: Can be run on any machine connected to a network (Uses WinRM)"
			Write-Host -ForegroundColor Yellow "(UF): Unfinished"
			Write-Host -ForegroundColor Yellow "(NT): Not implemented"

		}

		<#
		??? {
			Get-Content "$PSScriptRoot\Functions.txt"
		}
		#>
		
		#Exit
		quit {
			
			$start = $false
			break

		}
		
		#test switch
		#Function currently working on: 8a
		999 {
	
			$credential = Get-Credential
			$user = "TTest" 
			$count = 1
			while ($count -le 10) {
				New-ADUser -Name ("$user" + "0$count") -SamAccountName ("$user" + "0$count") -PasswordNotRequired $true -Credential $credential -Passthru
				$count++
			}
			
		}
	
		default {
			Read-Host "Relaunch script: Invalid Number/Command (Press Enter)"
		}
	}

	<#

	Script execution ends above

#>

}