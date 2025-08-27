$passphrase = ""
$randomEndNumber = Get-Random -Max 99999 -Min 10000
$count = 0
# 3 words per passphrase logic
while($count -ne 3){
$txtFile = Get-Random -Max 4 -Min 1
switch($txtFile) {
    1 {
       # We don't want repeats of words
       if($noun -ne $null){
            break
       }
       $noun = Get-Random -InputObject (Get-Content .\Nouns.txt)
       $count++
       $passphrase += $noun + "-"
       Write-Host $noun
    }

    2 {
       if($verb -ne $null){
            break
       } 
       $verb = Get-Random -InputObject (Get-Content .\Verbs.txt)
       $count++
       $passphrase += $verb + "-"
       Write-Host $verb
    }

    3 {
        if($adjective -ne $null){
            break
        }
        $adjective = Get-Random -InputObject (Get-Content .\Adjectives.txt)
        $count++
        $passphrase += $adjective + "-"
        Write-Host $adjective
    }

}
}


#Builds the final passphrase and sets it
$passphrase += $randomEndNumber
Write-Host $passphrase