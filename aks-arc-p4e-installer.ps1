if ($branchName -eq $null){
    $branchName="main"
}
#install CRDs
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.9.1/cert-manager.yaml
kubectl wait deployment -n cert-manager cert-manager --for condition=Available --time

#install nginx
helm upgrade --install ingress-nginx ingress-nginx --repo https://kubernetes.github.io/ingress-nginx --namespace ingress-nginx --create-namespace

#install gitops symphony
az k8s-configuration flux create --resource-group $rgName --cluster-name $clusterName --cluster-type connectedClusters --name symphony --scope cluster --namespace default --kind git --url https://github.com/blues-yang/GitOps --branch $branchName --kustomization name=kust path=symphony/flux
kubectl wait deployment -n symphony-k8s-system symphony-k8s-controller-manager --for condition=Available --timeout=10m

#install gitops voe
az k8s-configuration flux create --resource-group $rgName --cluster-name $clusterName --cluster-type connectedClusters --name voe --scope cluster --namespace default --kind git --url https://github.com/blues-yang/GitOps --branch $branchName --kustomization name=kust path=voe/flux
