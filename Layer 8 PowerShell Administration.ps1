$num = Read-Host "Enter a number"
switch ($num){
	1 {
		
		$list = 1
		$1a = Get-ADComputer -Filter * | Select-Object -ExpandProperty Name
		foreach($1 in $1a){
			$list.ToString() + $1
			$list++
		}
	}
		
	
	
	
	default {
		Read-Host "Nuh uh try again (press enter)"
}
}

