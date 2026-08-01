# ==============================================================================
# Automatic Azure AKS Cluster Deployment Script (PowerShell)
# Designed for VS Code on Windows / PowerShell
# ==============================================================================

$ErrorActionPreference = "Stop"

# Configuration variables
$ResourceGroup = if ($env:RESOURCE_GROUP) { $env:RESOURCE_GROUP } else { "rg-aks-dev" }
$Location      = if ($env:LOCATION) { $env:LOCATION } else { "eastus" }
$ClusterName   = if ($env:CLUSTER_NAME) { $env:CLUSTER_NAME } else { "aks-dev-cluster" }
$NodeCount     = if ($env:NODE_COUNT) { $env:NODE_COUNT } else { 2 }
$NodeSize      = if ($env:NODE_SIZE) { $env:NODE_SIZE } else { "Standard_D2s_v7" }

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host " Azure AKS Setup Script for VS Code (PowerShell)" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# 1. Check Azure CLI
if (-not (Get-Command az -ErrorAction SilentlyContinue)) {
    Write-Error "Azure CLI ('az') is not installed. Please install it from https://aka.ms/installazurecliwindows and rerun."
}

# 2. Check Kubectl
if (-not (Get-Command kubectl -ErrorAction SilentlyContinue)) {
    Write-Host "Installing 'kubectl' via Azure CLI..." -ForegroundColor Yellow
    az aks install-cli
}

# 3. Authenticate with Azure
Write-Host "`nChecking Azure Login status..." -ForegroundColor Yellow
try {
    $accountRaw = az account show 2>$null
    if ($accountRaw) {
        $account = $accountRaw | ConvertFrom-Json
    } else {
        Write-Host "Logging into Azure..." -ForegroundColor Yellow
        az login
        $account = az account show | ConvertFrom-Json
    }
    Write-Host "Connected Subscription: $($account.name) ($($account.id))" -ForegroundColor Green
} catch {
    Write-Host "Logging into Azure..." -ForegroundColor Yellow
    az login
    $account = az account show | ConvertFrom-Json
    Write-Host "Connected Subscription: $($account.name) ($($account.id))" -ForegroundColor Green
}

# 4. Create Resource Group
Write-Host "`nCreating Resource Group '$ResourceGroup' in '$Location'..." -ForegroundColor Yellow
az group create --name $ResourceGroup --location $Location --output table

# 5. Create AKS Cluster
Write-Host "`nCreating AKS Cluster '$ClusterName' with size '$NodeSize' (this may take 4-7 minutes)..." -ForegroundColor Yellow
az aks create `
    --resource-group $ResourceGroup `
    --name $ClusterName `
    --node-count $NodeCount `
    --node-vm-size $NodeSize `
    --enable-managed-identity `
    --generate-ssh-keys `
    --output table

if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to create AKS Cluster. Please check the error above."
    exit $LASTEXITCODE
}

# 6. Get Credentials & Connect Cluster
Write-Host "`nFetching cluster credentials and configuring kubeconfig..." -ForegroundColor Yellow
az aks get-credentials --resource-group $ResourceGroup --name $ClusterName --overwrite-existing

# 7. Verify Cluster Connection
Write-Host "`n==========================================" -ForegroundColor Green
Write-Host "AKS Cluster successfully installed and connected!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host "Cluster Nodes:" -ForegroundColor Cyan
kubectl get nodes

Write-Host "`nUse in VS Code and Codespaces:" -ForegroundColor Yellow
Write-Host " - Install VS Code 'Kubernetes' Extension"
Write-Host " - Run 'kubectl get pods -A' in terminal to interact with the cluster."
