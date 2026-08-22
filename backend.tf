# terraform {
#   backend "azurerm" {
#     use_cli          = true
#     use_azuread_auth = true

#     tenant_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

#     storage_account_name = "pumejaksstate2026"
#     container_name       = "tfstate"
#     key                  = "aks-cluster/terraform.tfstate"
#   }
# }

terraform {
  backend "local" {}
}