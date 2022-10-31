# GitOps

## Prerequisites
1. create a AKS resource on Azure(e.g. name:aks-gitops)
2. [Install Flux extension](https://learn.microsoft.com/en-us/azure/azure-arc/kubernetes/tutorial-use-gitops-flux2)

## Deploy Hello on AKS with Argo CD
1. [Install Argo CD on your AKS](https://github.com/blues-yang/Argo-CD)
2. copy **hello/apply-argocd.yml** to azure cloud shell
3. run: `kubectl apply -f apply-argocd.yml`
4. Run: `kubectl patch svc hello-arc -n hello-flux -p '{"spec": {"type": "LoadBalancer"}}'`
5. Login External IP for testing

## Deploy Hello on AKS with Flux
### UI mode
1. Create GitOps on AKS page
2. Stage 1: The namespace should be: **hello-flux** which same with the configure.yml
3. Stage 2: Kustomization path should be: **hello/flux**
4. Run: `kubectl patch svc hello-arc  -n hello-flux -p '{"spec": {"type": "LoadBalancer"}}'`
5. Login External IP for testing

### CLI mode
- create: `az k8s-configuration flux create --resource-group aks-arc --cluster-name aks-gitops --cluster-type managedClusters --name hello --scope cluster --namespace hello-flux --kind git --url https://github.com/blues-yang/GitOps --branch main --kustomization name=kust path=hello/flux`
- read deployment: `az k8s-configuration flux deployed-object list --resource-group aks-arc --cluster-type managedClusters --cluster-name aks-gitops --name hello`
- delete: `az k8s-configuration flux delete --resource-group aks-arc --cluster-name aks-gitops --cluster-type managedClusters --name hello`

## Deploy symphony & voe on AKS with Flux
1. Get value by run: `poss-parameter.sh`
2. Input value in chart/value.yaml file for symphony & voe
3. Open cloud shell and run:
    - `wget -O - https://raw.githubusercontent.com/blues-yang/GitOps/main/aks-p4e-installer.sh | bash /dev/stdin [your_resource_group] [your_cluster_name]`

    - `wget -O - https://raw.githubusercontent.com/blues-yang/GitOps/[your_branch_name]/aks-p4e-installer.sh | bash /dev/stdin [your_resource_group] [your_cluster_name] [your_branch_name]`
4. clear GitOps
    - `az k8s-configuration flux delete --resource-group [your_resource_group] --cluster-name [your_cluster_name] --cluster-type managedClusters --name [your_gitops_name] -y`

## Deploy symphony & voe on AKS ARC with Flux
1. Create your AKS cluster in your local Windows machine
2. Create K8S Arc resource in Azure(e.g. name:aks-iot), and connect with the AKS cluster
3. Input value in chart/value.yaml file for symphony & voe
4. Run PowerShell script on AKS cluster:
    - `$rgName="[your_resource_group]";$clusterName="[your_cluster_name]";iex (New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/blues-yang/GitOps/main/aks-arc-p4e-installer.ps1')`

    - `$rgName="[your_resource_group]";$clusterName="[your_cluster_name]";$branchName="[your_branch_name]";iex (New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/blues-yang/GitOps/[your_branch_name]/aks-arc-p4e-installer.ps1')`

5. clear GitOps
    - `az k8s-configuration flux delete --resource-group [your_resource_group] --cluster-name [your_cluster_name] --cluster-type connectedClusters --name [your_gitops_name] -y`

## Know issue
1. Could not redeploy solution with AKS + Flux v2
A: The namespace has been deleted, and stuck in terminating process.
