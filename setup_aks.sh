#!/usr/bin/env bash
# ==============================================================================
# Automatic Azure AKS Cluster Deployment Script
# Designed for VS Code, GitHub Codespaces, Linux, macOS, and WSL/Git Bash
# ==============================================================================

set -e

# Default configurations (Customize if needed)
RESOURCE_GROUP=${RESOURCE_GROUP:-"rg-aks-dev"}
LOCATION=${LOCATION:-"eastus"}
CLUSTER_NAME=${CLUSTER_NAME:-"aks-dev-cluster"}
NODE_COUNT=${NODE_COUNT:-2}
NODE_SIZE=${NODE_SIZE:-"Standard_D2s_v7"} # Standard dev VM size

echo "=========================================="
echo " Azure AKS Setup Script for VS Code / Codespaces"
echo "=========================================="

# 1. Check Azure CLI
if ! command -v az &> /dev/null; then
    echo "⚠️ Azure CLI ('az') is not installed."
    echo "Installing Azure CLI..."
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash || pip install azure-cli
fi

# 2. Check Kubectl
if ! command -v kubectl &> /dev/null; then
    echo "⚠️ 'kubectl' is not installed. Installing via Azure CLI..."
    sudo az aks install-cli || az aks install-cli
fi

# 3. Authenticate with Azure
echo ""
echo "🔍 Checking Azure Login status..."
if ! az account show &> /dev/null; then
    echo "🔑 Not logged into Azure. Initiating login..."
    # Check if running inside GitHub Codespaces or SSH session without web browser
    if [ -n "$CODESPACES" ] || [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
        echo "🌐 Headless environment detected (Codespaces/SSH). Using device code login..."
        az login --use-device-code
    else
        az login
    fi
else
    echo "✅ Successfully authenticated with Azure!"
fi

# Show current subscription
CURRENT_SUB=$(az account show --query name -o tsv)
CURRENT_SUB_ID=$(az account show --query id -o tsv)
echo "📌 Connected Subscription: $CURRENT_SUB ($CURRENT_SUB_ID)"

# 4. Create Resource Group
echo ""
echo "🚀 Creating Resource Group '$RESOURCE_GROUP' in '$LOCATION'..."
az group create --name "$RESOURCE_GROUP" --location "$LOCATION" --output table

# 5. Create AKS Cluster
echo ""
echo "⚡ Creating AKS Cluster '$CLUSTER_NAME' (this may take 4-7 minutes)..."
az aks create \
    --resource-group "$RESOURCE_GROUP" \
    --name "$CLUSTER_NAME" \
    --node-count "$NODE_COUNT" \
    --node-vm-size "$NODE_SIZE" \
    --enable-managed-identity \
    --generate-ssh-keys \
    --output table

# 6. Connect Cluster with Local / Codespace Kubectl & VS Code
echo ""
echo "🔗 Fetching cluster credentials and configuring kubeconfig..."
az aks get-credentials --resource-group "$RESOURCE_GROUP" --name "$CLUSTER_NAME" --overwrite-existing

# 7. Verification
echo ""
echo "=========================================="
echo "🎉 AKS Cluster successfully installed & connected!"
echo "=========================================="
echo "📊 Checking Cluster Nodes:"
kubectl get nodes

echo ""
echo "💡 To use in VS Code & Codespaces:"
echo " 1. Install 'Kubernetes' extension (ms-kubernetes-tools.vscode-kubernetes-tools)"
echo " 2. Your kubeconfig is saved at ~/.kube/config"
echo " 3. Run 'kubectl get pods -A' to view system pods."
