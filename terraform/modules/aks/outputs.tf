# output "config" {
#     value = azurerm_kubernetes_cluster.aks.kube_config_raw
# }

  output "aks_cluster_id" {
    value = azurerm_kubernetes_cluster.aks.id
  }

#   output "aks_cluster_name" {
#   value = azurerm_kubernetes_cluster.aks.name
# }

# output "kube_admin_config" {
#   value = azurerm_kubernetes_cluster.aks.kube_admin_config
# }

# output "kube_config" {
#   value = azurerm_kubernetes_cluster.aks.kube_config
# }