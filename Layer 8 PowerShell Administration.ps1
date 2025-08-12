$num = Read-Host "Enter a number"
switch ($num){
	1 {
		Write-Host "Enter machine to ping"
		$ping = Read-Host
		ping $ping
	}
		
	
	2 {
		$2a = Get-ADComputer -Filter * | Select-Object -ExpandProperty Name | Out-GridView
		Write-Host $2a
	}
		
	
	
	
	
	
	default {
		Read-Host "Nuh uh try again (press enter)"
}
}
