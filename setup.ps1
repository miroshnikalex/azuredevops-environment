. .\variables.ps1
$subscription = Get-AzureRmSubscription
$TemplateRootPath = Join-Path $PSScriptRoot 'templates'

if ($subscription) {
    Write-Host "Connected to Subscription $subscription"
} 
else {
    Connect-AzureRmAccount -Subscription $az_sub  
}

if (Get-AzureRmResourceGroup -name $rg_name -ErrorAction SilentlyContinue) {
    Write-Host "Resource group $rg_name already exists"
}
else {
    New-AzureRmResourceGroup -Name $rg_name -Location $location 
}

foreach ($template in `
 (Get-childItem -File -Path $TemplateRootPath | Where-Object {$_.name -like "*-template-*"} | Sort-Object))
{
    New-AzureRmResourceGroupDeployment -ResourceGroupName $rg_name `
        -TemplateFile $template.fullname `
        -TemplateParameterFile ($template.fullname -replace "-template-", "-parameters-") `
        -Name $template.name
}