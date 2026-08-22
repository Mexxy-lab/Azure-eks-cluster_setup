variable "resource_group_name" {
  description = "Resource group containing the Terraform state storage account"
  type        = string
}

variable "storage_account_name" {
  description = "Azure Storage Account name"
  type        = string
}

variable "container_name" {
  description = "Blob container name"
  type        = string
  default     = "tfstate"
}

variable "location" {
  description = "Azure region"
  type        = string
}