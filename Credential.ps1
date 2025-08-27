try {
$credential = Get-Credential
}
catch {
Write-Host -ForegroundColor Yellow "No initial credential provided. This is fine."
}