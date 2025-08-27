Set-ExecutionPolicy -Scope Process Bypass -Force
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

	More info about scripts in 
	CCDC Administration myBox

	NOTE: It may not be up-to-date

#>

<#

	NOTES ABOUT SCRIPT:
		-3 and 4 use static names

#>

try {
$Global:credential = Get-Credential
}
catch {
Write-Host -ForegroundColor Yellow "No initial credential provided. This is fine."
}
powershell -file .\Help.ps1
$start = $true
while ($start -eq $true) {
	$num = Read-Host "Enter a number"
	switch ($num) {
		1a {
		
			powershell -file ".\Scripts\1a"
			break
		}
	
		2a {
				
			powershell -file ".\Scripts\2a"
			break

		}
	
		3a {
	
			powershell -file ".\Scripts\3a"
			break

		}
		
		4a {
	
			powershell -file ".\Scripts\4a"
			break

		}
	
		5a {
	
			powershell -file ".\Scripts\5a"
			break

		}
	
		6a {
			
			powershell -file ".\Scripts\6a"
			break

		}
	
		7a {
	
			powershell -file ".\Scripts\7a"
			break

		}
		
	
	
		<#
		Below are CCDC Scripts
	#>
		
		
		100a {
		
			
		
		}
		
		101a {
			
			powershell -file ".\Scripts\101a"
			break
	
		}


		102a {
			
			powershell -file .\Passphrases\psswrdshfl.ps1
			break

		}
		
		

		#HELP
		? {
	
			powershell -file .\Help.ps1
			break

		}
	
		?? {
		
			Write-Host -ForegroundColor Yellow "Local: Can only be run on computer connected to domain."
			Write-Host -ForegroundColor Yellow "Remote: Can be run on any machine connected to a network (Uses WinRM)"
			Write-Host -ForegroundColor Yellow "(UF): Unfinished"

		}
	
		#exit
	
		quit {
			
			$Global:credential = 0
			$start = $false
			break
			
		}
		
	
	
		#test switch
		999 {
	
			$gpoName = Read-Host "Enter GPO Name"
			New-GPO $gpoName
			New-GPLink -Name $gpoName -Target (Get-ADRootDSE | Select-Object -ExpandProperty rootDomainNamingContext)
			
		}
	
	
	
		default {
			Read-Host "Relaunch script: Invalid Number/Command (Press Enter)"
		}
	}
}