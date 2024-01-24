
# Managed Prometheus
resource "azurerm_monitor_workspace" "default" {
  name                = "prom-inlogik"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "eastus"
}

# Execute CLI commands to check namespace in your subsciption id
resource "null_resource" "register_monitor_namespace" {
  triggers = {
    workspace_id = azurerm_monitor_workspace.default.id
  }

  provisioner "local-exec" {
    command = <<EOT
      subscription_id="763c36d7-06b2-4e4f-a085-18bce1206962"
      namespace="Microsoft.Monitor"

      # Check if the namespace is registered
      registration_state=$(az provider show --namespace $namespace --subscription $subscription_id --query 'registrationState' --output tsv)

      if [ "$registration_state" != "Registered" ]; then
        echo "Registering $namespace namespace..."
        az provider register --namespace $namespace --subscription $subscription_id
      else
        echo "$namespace namespace is already registered."
      fi
    EOT
  }
}

# Managed Grafana
resource "azurerm_dashboard_grafana" "default" {
  name                              = "graf-inlogik"
  resource_group_name               = azurerm_resource_group.rg.name
  location                          = azurerm_resource_group.rg.location
  api_key_enabled                   = true
  deterministic_outbound_ip_enabled = false
  public_network_access_enabled     = true
  identity {
    type = "SystemAssigned"
  }
  azure_monitor_workspace_integrations {
    resource_id = azurerm_monitor_workspace.default.id
  }

  depends_on = [ null_resource.register_dashboard_namespace ]
}

# checks the registration status of the "Microsoft.Dashboard" namespace and registers it if its not already registered
resource "null_resource" "register_dashboard_namespace" {
  triggers = {
    subscription_id = "763c36d7-06b2-4e4f-a085-18bce1206962"
    namespace      = "Microsoft.Dashboard"
  }

  provisioner "local-exec" {
    command = <<EOT
      subscription_id="763c36d7-06b2-4e4f-a085-18bce1206962"
      namespace="Microsoft.Dashboard"

      # Check if the namespace is registered
      registration_state=$(az provider show --namespace $namespace --subscription $subscription_id --query 'registrationState' --output tsv)

      if [ "$registration_state" != "Registered" ]; then
        echo "Registering $namespace namespace..."
        az provider register --namespace $namespace --subscription $subscription_id
      else
        echo "$namespace namespace is already registered."
      fi
    EOT
  }
}

# Add required role assignment over resource group containing the Azure Monitor Workspace
resource "azurerm_role_assignment" "grafana" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Monitoring Reader"
  principal_id         = azurerm_dashboard_grafana.default.identity[0].principal_id
}

# Add role assignment to Grafana so an admin user can log in
resource "azurerm_role_assignment" "grafana-admin" {
  scope                = azurerm_dashboard_grafana.default.id
  role_definition_name = "Grafana Admin"
  principal_id         = var.admin_group_object_ids[0]
}

resource "azurerm_monitor_data_collection_endpoint" "dce" {
  name                = "MSProm-${azurerm_monitor_workspace.default.location}-${azurerm_kubernetes_cluster.aks.name}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_monitor_workspace.default.location
  kind                = "Linux"
}
 
resource "azurerm_monitor_data_collection_rule" "dcr" {
  name                        = "MSProm-${azurerm_monitor_workspace.default.location}-${azurerm_kubernetes_cluster.aks.name}"
  resource_group_name         = azurerm_resource_group.rg.name
  location                    = azurerm_monitor_workspace.default.location
  data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.dce.id
  kind                        = "Linux"
  destinations {
    monitor_account {
      monitor_account_id = azurerm_monitor_workspace.default.id
      name               = "MonitoringAccount1"
    }
  }
  data_flow {
    streams      = ["Microsoft-PrometheusMetrics"]
    destinations = ["MonitoringAccount1"]
  }
  data_sources {
    prometheus_forwarder {
      streams = ["Microsoft-PrometheusMetrics"]
      name    = "PrometheusDataSource"
    }
  }
  description = "DCR for Azure Monitor Metrics Profile (Managed Prometheus)"
  depends_on = [
    azurerm_monitor_data_collection_endpoint.dce
  ]
}

resource "azurerm_monitor_data_collection_rule_association" "dcra" {
  name                    = "MSProm-${azurerm_monitor_workspace.default.location}-${azurerm_kubernetes_cluster.aks.name}"
  target_resource_id      = azurerm_kubernetes_cluster.aks.id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.dcr.id
  description             = "Association of data collection rule. Deleting this association will break the data collection for this AKS Cluster."
  depends_on = [
    azurerm_monitor_data_collection_rule.dcr
  ]
}