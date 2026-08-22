output "node_pool_id" {
  value = azurerm_kubernetes_cluster_node_pool.worker.id
}

output "node_pool_name" {
  value = azurerm_kubernetes_cluster_node_pool.worker.name
}