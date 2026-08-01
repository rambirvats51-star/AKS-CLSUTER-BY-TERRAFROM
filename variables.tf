variable "resource_group_name" {
  type        = string
  default     = "rg-aks-tf-dev"
  description = "Name of the Azure Resource Group"
}

variable "location" {
  type        = string
  default     = "eastus"
  description = "Azure region for resources"
}

variable "cluster_name" {
  type        = string
  default     = "aks-tf-cluster"
  description = "Name of the AKS cluster"
}

variable "node_count" {
  type        = number
  default     = 2
  description = "Number of worker nodes"
}

variable "vm_size" {
  type        = string
  default     = "Standard_D2s_v7"
  description = "VM size for worker nodes"
}

