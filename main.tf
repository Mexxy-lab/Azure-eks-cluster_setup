module "terraform_state" {
  source = "./modules/terraform-state"

  resource_group_name  = var.tfstate_resource_group_name
  storage_account_name = var.terraform_state_storage_account
  container_name       = var.terraform_state_container
  location             = var.location
}

module "vnet" {
  source = "./modules/vnet"

  resource_group_name = var.resource_group_name
  location            = var.location

  vnet_name          = var.vnet_name
  vnet_address_space = var.vnet_address_space

  public_subnet_name = var.public_subnet_name
  public_subnet_cidr = var.public_subnet_cidr

  private_subnet_name = var.private_subnet_name
  private_subnet_cidr = var.private_subnet_cidr
}

module "aks_cluster" {
  source = "./modules/aks-cluster"

  cluster_name        = var.aks_cluster_name
  resource_group_name = var.resource_group_name
  location            = var.location

  kubernetes_version = var.kubernetes_version

  subnet_id = module.vnet.private_subnet_id

  system_node_count = var.system_node_count
  system_vm_size    = var.system_vm_size
}

module "aks_node_group" {
  source = "./modules/aks-node-group"

  cluster_id = module.aks_cluster.cluster_id

  subnet_id = module.vnet.private_subnet_id

  node_pool_name     = var.node_pool_name
  vm_size            = var.worker_vm_size
  node_count         = var.worker_node_count
  kubernetes_version = var.kubernetes_version
}