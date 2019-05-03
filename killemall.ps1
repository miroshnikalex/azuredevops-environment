. .\variables.ps1
$subscription = Get-AzSubscription

if ($subscription) {
    Write-Host "Connected to Subscription $subscription"
} 
else {
    Connect-AzAccount -Subscription $az_sub  
}

if (-not (Get-AzResourceGroup -name $rg_name -ErrorAction SilentlyContinue)) {
    Write-Host "Resource group $rg_name does not exist"
}
else {
    Remove-AzResourceGroup -Name $rg_name -Force `
    -Verbose
}

if (-not (Get-AzResourceGroup -name $oms_rg_name -ErrorAction SilentlyContinue)) {
    Write-Host "Resource group $oms_rg_name does not exist"
}
else {
    Remove-AzResourceGroup -Name $oms_rg_name -Force `
    -Verbose
}
#Disconnect-AzAccount -Username $user_name -Verbose