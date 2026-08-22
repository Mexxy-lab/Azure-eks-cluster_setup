resource "azurerm_kubernetes_cluster_node_pool" "worker" {
  name                  = var.node_pool_name
  kubernetes_cluster_id = var.cluster_id

  vm_size        = var.vm_size
  node_count     = var.node_count
  vnet_subnet_id = var.subnet_id

  mode = "User"

  orchestrator_version = var.kubernetes_version

  os_type = "Linux"

  tags = {
    Environment = "production"
    ManagedBy   = "Terraform"
    NodePool    = "worker"
  }
}