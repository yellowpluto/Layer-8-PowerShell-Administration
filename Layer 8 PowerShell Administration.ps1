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
		Get-ADUser -Filter * -SearchBase $result | Select-Object -ExpandProperty Name
		
	}

		
	
	
	
	default {
		Read-Host "Relaunch script: Invalid Number (Press Enter)"
}
}
