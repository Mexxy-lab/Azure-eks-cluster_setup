variable "cluster_name" {
  description = "AKS cluster name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group containing the AKS cluster"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID used by AKS nodes"
  type        = string
}

variable "system_node_count" {
  description = "Number of system nodes"
  type        = number
}

variable "system_vm_size" {
  description = "VM size for system nodes"
  type        = string
}