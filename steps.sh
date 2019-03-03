# 1. Create AAD server and client apps

# First we need to have an Azure subscription 
# which have an Azure Active Directory.
# Then, we need to create a server and client apps, 
# those will be used to authenticate the users connecting to AKS through AAD.
# This means the user should be first created in AAD to have access to the cluster.
# This is the authentication part.
# For the authorisation part, it will be managed by Role and RoleBinding k8s objects.

# Please follow the steps described in this link here: 
# https://docs.microsoft.com/en-us/azure/aks/aad-integration

# 2. Create AKS cluster with RBAC configured with AAD

# 2.1 Create Resource Group

az group create \
  --name aks-aad-rg-1 \
  --location westeurope \
  --subscription "Microsoft Azure Sponsorship"

# 2.2 Create the kubernetes managed cluster

az aks create \
  --resource-group aks-aad-rg-1 \
  --name aks-aad \
  --generate-ssh-keys \
  --aad-server-app-id cbb2efcb-9b3c-4441-b58f-9c6cca37d03b \
  --aad-server-app-secret VBnbw1gEhxtRVfKTv8dYD+MyraLF5jnTDzt145PUt5k= \
  --aad-client-app-id 4c2a05a5-7ed1-4a2c-b4aa-b78bc43b4d41 \
  --aad-tenant-id 72f988bf-0000-0000-0000-2d7cd011db47 \
  --subscription "Microsoft Azure Sponsorship" # optional if you have only 1 Azure subscription

# 3. Connect to AKS cluster

az aks get-credentials \
  --resource-group aks-aad-rg-1 \
  --name aks-aad \
  --admin \
  --subscription "Microsoft Azure Sponsorship"

kubectl config current-context

# 4. Create the Role and RoleBinding

kubectl apply -f role.yaml

kubectl get roles

kubectl apply -f role-binding.yaml

kubectl get rolebindings

# 5. Test

# from another machine

az aks get-credentials \
  -resource-group aks-aad-rg \
  -name aks-aad

kubectl get pods
# open browser to login

kubectl get deployments
# Error from server (Forbidden)

kubectl get pods --all-namespaces
# Error from server (Forbidden)