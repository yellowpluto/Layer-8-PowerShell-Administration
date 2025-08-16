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
$num = Read-Host "Enter a number"
switch ($num){
	1 {
		
		$listArray = @()
		$numList = 1
		$1a = Get-ADComputer -Filter * | Select-Object -ExpandProperty Name | Sort-Object -desc
		foreach($1 in $1a){
			"(" + $numList.ToString() + ")" + $1
			$numList++
			$listArray += $1
		}
		
		Write-Host "Choose a computer to ping"
		$choose = Read-Host
		$result = $listArray[$choose - 1]
		Test-NetConnection $result
		break
	}
	
	2 {
		$listArray = @()
		$numList = 1
		$2a = Get-ADOrganizationalUnit -Filter * | Select-Object -ExpandProperty DistinguishedName | Sort-Object -desc
		foreach($2 in $2a){
			"(" + $numList.ToString() + ")" + $2
			$numList++
			$listArray += $2
		}
		
		Write-Host "Choose an OU"
		$choose = Read-Host
		$result = $listArray[$choose - 1]
		$users = @(Get-ADUser -Filter * -SearchBase $result | Select-Object -ExpandProperty SamAccountName | Sort-Object -desc)
		$numList = 1
		foreach($user in $users){
			"(" + $numList.ToString() + ")" + $user
			$numList++
			$users += $users
		}
		
		Write-Host "Choose a user"
		$choose = Read-Host
		$result = $users[$choose - 1]
		$if = Read-Host "Change password on next logon? (Y/N)"
		if($if -eq "Y"){
			Set-ADUser -Identity $result -ChangePasswordAtLogon $true
			Set-ADAccountPassword -Identity $result -Reset
		}ElseIf($if -eq "N"){
			Set-ADUser -Identity $result -ChangePasswordAtLogon $false
			Set-ADAccountPassword -Identity $result -Reset
		}Else{
			Write-Host -ForegroundColor Red "Incorrect value proceeding to password reset"
			Set-ADAccountPassword -Identity $result -Reset
		}
			
		break
		
	}
	
	3 {
	
		$condition = Read-Host "GPU and Restart Machines (Y/N)"
			if($condition -eq "Y"){
				Invoke-GPUpdate NPOD1, NPOD2, NPOD3, NPOD4, WPOD1, WPOD2, WPOD3, WPOD4, LPOD1, LPOD2, LPOD3, LPOD4 -Force -Boot
			}ElseIf($condition -eq "N"){
				Invoke-GPUpdate NPOD1, NPOD2, NPOD3, NPOD4, WPOD1, WPOD2, WPOD3, WPOD4, LPOD1, LPOD2, LPOD3, LPOD4 -Force
			}Else{
			Write-Host -ForegroundColor Red "Incorrect value proceeding to regular update"
			Invoke-GPUpdate NPOD1, NPOD2, NPOD3, NPOD4, WPOD1, WPOD2, WPOD3, WPOD4, LPOD1, LPOD2, LPOD3, LPOD4 -Force
		}
		break
	}
		
	4 {
	
		Restart-Computer NPOD1, NPOD2, NPOD3, NPOD4, WPOD1, WPOD2, WPOD3, WPOD4, LPOD1, LPOD2, LPOD3, LPOD4 -Force -Confirm
		break
	}
	
	5 {
	
		$listArray = @()
		$numList = 1
		$5a = Get-ADOrganizationalUnit -Filter * | Select-Object -ExpandProperty DistinguishedName | Sort-Object -desc
		foreach($5 in $5a){
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
		foreach($user in $users){
			Set-ADAccountExpiration -Identity $user -DateTime $date
		}
		
		
	
		break
	}
	
	6 {
		$listArray = @()
		$numList = 1
		$6a = Get-ADUser -Filter * | Select-Object -ExpandProperty SamAccountName | Sort-Object -desc
		foreach($6 in $6a){
			"(" + $numList.ToString() + ")" + $6
			$numList++
			$listArray += $6
		}
		
		$input = Read-Host "Enter numbers"
		$numbers = $input -split ',' | Where-Object { $_ -ne "" } | ForEach-Object { [int]$_ }
		foreach($number in $numbers){
			Clear-ADAccountExpiration -Identity $listArray[$number - 1]
			
		}
		
		break	
	
	}
	
	7 {
	
		Get-ADUser -Filter * | Select-Object -ExpandProperty SamAccountName | ForEach-Object {Set-ADUser -Identity $_ -EMailAddress "$_@AnimeHealth.net"}
		break
	
	}
	
	
	

	#test switch
	999 {
	
		
	}
	
	
	
	default {
		Read-Host "Relaunch script: Invalid Number (Press Enter)"
}
}