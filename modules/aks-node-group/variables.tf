variable "cluster_id" {
  description = "AKS cluster ID"
  type        = string
}

variable "node_pool_name" {
  description = "AKS node pool name"
  type        = string
}

variable "vm_size" {
  description = "VM size for worker nodes"
  type        = string
}

variable "node_count" {
  description = "Number of worker nodes"
  type        = number
}

variable "subnet_id" {
  description = "Subnet ID for worker nodes"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
}