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
		
	
	
	
	default {
		Read-Host "Nuh uh try again (press enter)"
}
}

