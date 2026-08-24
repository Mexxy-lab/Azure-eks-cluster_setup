variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "tenant_id" {
  description = "Microsoft Entra tenant ID"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "resource_group_name" {
  description = "Resource group for the AKS infrastructure"
  type        = string
  default     = "pumej-aks-rg"
}

variable "tfstate_resource_group_name" {
  description = "Resource group for Terraform state"
  type        = string
  default     = "pumej-terraform-state-rg"
}

variable "terraform_state_storage_account" {
  description = "Globally unique Azure Storage Account name for Terraform state"
  type        = string
}

variable "terraform_state_container" {
  description = "Blob container used for Terraform state"
  type        = string
  default     = "tfstate"
}

variable "vnet_name" {
  description = "Azure VNet name"
  type        = string
  default     = "pumej-aks-vnet"
}

variable "vnet_address_space" {
  description = "VNet CIDR"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "public_subnet_name" {
  description = "Public subnet name"
  type        = string
  default     = "public-subnet"
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_name" {
  description = "Private subnet name for AKS nodes"
  type        = string
  default     = "private-subnet"
}

variable "private_subnet_cidr" {
  description = "Private subnet CIDR"
  type        = string
  default     = "10.0.2.0/24"
}

variable "aks_cluster_name" {
  description = "AKS cluster name"
  type        = string
  default     = "pumej-aks"
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.36"
}

variable "system_node_count" {
  description = "Number of AKS system nodes"
  type        = number
  default     = 1
}

variable "system_vm_size" {
  description = "VM size for AKS system nodes"
  type        = string
  default     = "Standard_B2s"
}

variable "node_pool_name" {
  description = "Name of the AKS worker node pool"
  type        = string
  default     = "worker"
}

variable "worker_vm_size" {
  description = "VM size for worker nodes"
  type        = string
  default     = "Standard_B2s"
}

variable "worker_node_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 1
}