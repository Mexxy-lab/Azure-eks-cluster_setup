subscription_id = "007f175d-86d2-4836-9a1f-f752ee43f8aa"

tenant_id = "c5f78d0a-ecd1-4ca9-8d5e-9b2f5ffbfb59"

location = "East US"

resource_group_name = "pumej-aks-rg"

tfstate_resource_group_name = "pumej-terraform-state-rg"

terraform_state_storage_account = "pumejaksstate2026"

terraform_state_container = "tfstate"

vnet_name = "pumej-aks-vnet"

vnet_address_space = [
  "10.0.0.0/16"
]

public_subnet_name = "public-subnet"

public_subnet_cidr = "10.0.1.0/24"

private_subnet_name = "private-subnet"

private_subnet_cidr = "10.0.2.0/24"

aks_cluster_name = "pumej-aks"

kubernetes_version = "1.33"

system_node_count = 2

system_vm_size = "Standard_D2s_v5"

node_pool_name = "worker"

worker_vm_size = "Standard_D2s_v5"

worker_node_count = 2