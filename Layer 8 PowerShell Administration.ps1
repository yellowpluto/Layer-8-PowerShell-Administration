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
		$users = @(Get-ADUser -Filter * -SearchBase $result | Select-Object -ExpandProperty Name)
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
				Invoke-GPUpdate C-01 -Force -Boot
			}ElseIf($condition -eq "N"){
				Invoke-GPUpdate C-01 -Force
			}Else{
			Write-Host -ForegroundColor Red "Incorrect value proceeding to regular update"
			Invoke-GPUpdate C-01 -Force
		}
		break
	}
		
	4 {
	
		Restart-Computer C-01 -Force -Confirm
		break
	}
	
	
	
	default {
		Read-Host "Relaunch script: Invalid Number (Press Enter)"
}
}