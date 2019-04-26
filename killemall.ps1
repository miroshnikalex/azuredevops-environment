. .\variables.ps1
$subscription = Get-AzureRmSubscription

if ($subscription) {
    Write-Host "Connected to Subscription $subscription"
} 
else {
    Connect-AzureRmAccount -Subscription $az_sub  
}

if (-not (Get-AzureRmResourceGroup -name $rg_name -ErrorAction SilentlyContinue)) {
    Write-Host "Resource group $rg_name does not exist"
}
else {
    Remove-AzureRmResourceGroup -Name $rg_name -Force
}