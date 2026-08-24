# terraform {
#   backend "azurerm" {
#     use_cli          = true
#     use_azuread_auth = true

#     tenant_id = "c5f78d0a-ecd1-4ca9-8d5e-9b2f5ffbfb59"

#     storage_account_name = "pumejaksstate2026"
#     container_name       = "tfstate"
#     key                  = "aks-cluster/terraform.tfstate"
#   }
# }

terraform {
  backend "local" {}
}