resource "azurerm_kubernetes_cluster" "main" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name

  dns_prefix = var.cluster_name

  kubernetes_version = var.kubernetes_version

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name           = "system"
    vm_size        = var.system_vm_size
    node_count     = var.system_node_count
    vnet_subnet_id = var.subnet_id

    type = "VirtualMachineScaleSets"

    temporary_name_for_rotation = "systemtmp"
  }

  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    network_policy      = "azure"

    pod_cidr = "10.244.0.0/16"

    service_cidr   = "10.0.10.0/24"
    dns_service_ip = "10.0.10.10"

    load_balancer_sku = "standard"
  }

  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  tags = {
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}