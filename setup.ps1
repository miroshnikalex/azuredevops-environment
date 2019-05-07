$ErrorActionPreference="Stop"

. .\variables.ps1

# Connecting to subscription
try {
    $subscription = Get-AzSubscription
    Write-Host "Connected to Subscription $subscription"
}
catch {
    Connect-AzAccount -Subscription $az_sub
}

$TemplateRootPath = Join-Path $PSScriptRoot 'templates'

# Building parameters hashtable
$allParametersFilePath = Join-Path $TemplateRootPath 'all-parameters.json';
$allParametersObject = Get-Content $allParametersFilePath | `
    ConvertFrom-Json | `
    Select-Object -ExpandProperty 'parameters';
$allParameters = @{}
foreach ($property in $allParametersObject.PSObject.Properties) {
    $allParameters[$property.Name] = $property.value.value
}
# Populating parameters with secrets from the keyvault
$allParameters['servicePrincipalClientId'] = (Get-AzKeyVaultSecret -vaultName $keyVaultName -name "aksappid" ).SecretValueText
$allParameters['servicePrincipalSecret']   = (Get-AzKeyVaultSecret -vaultName $keyVaultName -name "akssecret").SecretValueText
$allParameters['servicePrincipalObjectId'] = (Get-AzKeyVaultSecret -vaultName $keyVaultName -name "aksspid"  ).SecretValueText


# Creating resource groups
foreach ($rgNameKey in ($allParameters.keys | Where-Object {$_ -like '*RGName'})) {
    $rgName = $allParameters[$rgNameKey];
    if (Get-AzResourceGroup -name $rgName -ErrorAction SilentlyContinue) {
        Write-Host "Resource group $rgName already exists"
    }
    else {
        New-AzResourceGroup -Name $rgName -Location $allParameters['location']
    }
}

$templateFiles = Get-childItem -File -Path $TemplateRootPath | `
    Where-Object {$_.name -like "*-template-*"} | `
    Sort-Object;
foreach ($template in $templateFiles)
{
    # Filtering parameters hashtable
    $templateParametersObject = Get-Content $template.FullName | `
        ConvertFrom-Json | `
        Select-Object -ExpandProperty parameters;
    $requiredParamsArray = $templateParametersObject.PSObject.Properties | Select-Object -ExpandProperty Name
    $filteredParams = @{}
    foreach ($param in $allParameters.Keys) {
        if ($param -in $requiredParamsArray) {
            $filteredParams[$param] = $allParameters[$param]
        }
    }

    # Running template deployment
    New-AzResourceGroupDeployment -ResourceGroupName $allParameters['RGName'] `
        -TemplateFile $template.fullname `
        -TemplateParameterObject $filteredParams `
        -Name $template.name `
        -Verbose
}
