. .\variables.ps1

Import-AzAksCredential -ResourceGroupName $rg_name -Name $rg_name -Force

kubectl get nodes
kubectl apply -f .\k8s_deployments\azure-vote.yaml
kubectl get deployments
kubectl get pods
kubectl get nodes
kubectl get services
kubectl create clusterrolebinding kubernetes-dashboard --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard
az aks browse --resource-group $rg_name --name $rg_name