# 🚀 Ready-made Azure AKS Cluster Deployment

This repository provides lightweight, cost-effective, and fully automated deployment templates (Terraform & PowerShell/Bash scripts) to provision a ready-to-use **Azure Kubernetes Service (AKS)** cluster and connect it instantly to VS Code.

> **Optimized Defaults**: Uses `Standard_B2s` VM nodes and `2` worker nodes to ensure seamless deployment on **Azure Free Trial**, **Student Subscriptions**, and corporate subscriptions without hitting vCPU quota limits.

---

## ⚡ Quick Start: Deploy Ready-made Cluster

### 1. Authenticate & Select Subscription
Run in PowerShell or Terminal:
```powershell
# 1. Login to Azure
az login

# 2. Check active subscription (Make sure your account has Contributor/Owner access)
az account list --output table

# 3. If you have multiple subscriptions, select your active one:
az account set --subscription "<YOUR_SUBSCRIPTION_ID_OR_NAME>"
```

---

## 🛠️ Deployment Options

### Option A: PowerShell Script (Windows / VS Code)
Run the automated script to provision the cluster and link `kubectl` automatically:
```powershell
.\setup_aks.ps1
```

### Option B: Bash Script (Linux / macOS / WSL / GitHub Codespaces)
```bash
chmod +x setup_aks.sh
./setup_aks.sh
```

### Option C: Infrastructure as Code with Terraform
```bash
terraform init
terraform apply -auto-approve
```

---

## 📊 Verification & Connection

Once the deployment finishes, the cluster credentials will automatically be saved to your local `~/.kube/config`.

Test your cluster:
```powershell
# Get status of worker nodes
kubectl get nodes

# Get all system pods
kubectl get pods -A
```

---

## 📁 Repository Structure

- [variables.tf](file:///C:/Users/motap/OneDrive/Desktop/AKS/variables.tf) — Defaults configured to `Standard_B2s` (fits free quotas)
- [main.tf](file:///C:/Users/motap/OneDrive/Desktop/AKS/main.tf) — Azure Resource Group, AKS cluster definition & auto-kubeconfig provisioner
- [setup_aks.ps1](file:///C:/Users/motap/OneDrive/Desktop/AKS/setup_aks.ps1) — Ready-to-run 1-click PowerShell deployment script
- [setup_aks.sh](file:///C:/Users/motap/OneDrive/Desktop/AKS/setup_aks.sh) — 1-click Bash deployment script
- [azuredeploy.json](file:///C:/Users/motap/OneDrive/Desktop/AKS/azuredeploy.json) — ARM template for Azure Portal deployment
- [outputs.tf](file:///C:/Users/motap/OneDrive/Desktop/AKS/outputs.tf) — Terraform outputs (Cluster name, Resource group, FQDN)
- [.devcontainer/devcontainer.json](file:///C:/Users/motap/OneDrive/Desktop/AKS/.devcontainer/devcontainer.json) — VS Code & GitHub Codespaces container setup
