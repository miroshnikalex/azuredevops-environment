# azuredevops-environment
underlying infrastructure for azure devops setup

# Notes:

* make sure you allowed access to the keyvault for ARM. https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-manager-keyvault-parameter
* do not use httpApplicationRouting https://stackoverflow.com/questions/53713341/deploying-aks-cluster-with-arm-template-sporadically-fails-with-putnetworksecuri
* make sure the Az module is installed (perhaps you want to replase RM with Az to avoid any confusion) https://docs.microsoft.com/en-us/powershell/azure/migrate-from-azurerm-to-az?view=azps-1.8.0

# Versions:
* 1.0.0 - basic setup which includes: CR, VNET, WEBAPP, K8S Cluster
* 2.0.0 - Monitoring (OMS) has been added
* 3.0.0 - Replaced AzureRm with AzureAz
* 3.1.0 - added dirty hack by creating "DefaultResourceGroup-WEU" using PShell
* 3.1.1 - skeleton for k8s management script has been added (no logic around)