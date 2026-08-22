output "resource_group_name" {
  value = var.resource_group_name
}

output "vnet_id" {
  value = module.vnet.vnet_id
}

output "vnet_name" {
  value = module.vnet.vnet_name
}

output "aks_cluster_name" {
  value = module.aks_cluster.cluster_name
}

output "aks_cluster_id" {
  value = module.aks_cluster.cluster_id
}

output "kubernetes_version" {
  value = module.aks_cluster.kubernetes_version
}

output "aks_oidc_issuer_url" {
  value = module.aks_cluster.oidc_issuer_url
}

output "terraform_state_storage_account" {
  value = module.terraform_state.storage_account_name
}

output "terraform_state_container" {
  value = module.terraform_state.container_name
}

output "aks_kube_config" {
  value     = module.aks_cluster.kube_config
  sensitive = true
}