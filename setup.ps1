$ErrorActionPreference="Stop"

. .\variables.ps1

try {
    $subscription = Get-AzSubscription
    Write-Host "Connected to Subscription $subscription"
}
catch {
    Connect-AzAccount -Subscription $az_sub
}

$TemplateRootPath = Join-Path $PSScriptRoot 'templates'

if (Get-AzResourceGroup -name $rg_name -ErrorAction SilentlyContinue) {
    Write-Host "Resource group $rg_name already exists"
}
else {
    New-AzResourceGroup -Name $rg_name -Location $location 
}

if (Get-AzResourceGroup -name $oms_rg_name -ErrorAction SilentlyContinue) {
    Write-Host "Resource group $oms_rg_name already exists"
}
else {
    New-AzResourceGroup -Name $oms_rg_name -Location $location 
}

foreach ($template in `
 (Get-childItem -File -Path $TemplateRootPath | Where-Object {$_.name -like "*-template-*"} | Sort-Object))
{
    New-AzResourceGroupDeployment -ResourceGroupName $rg_name `
        -TemplateFile $template.fullname `
        -TemplateParameterFile ($template.fullname -replace "-template-", "-parameters-") `
        -Name $template.name `
        -Verbose
}