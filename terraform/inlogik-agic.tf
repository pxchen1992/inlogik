# # Create the 'agic' namespace
# resource "kubernetes_namespace" "agic" {
#   metadata {
#     name = "agic"
#   }
# }

# resource "helm_release" "agic" {
#   name       = "agic"
#   repository = "https://appgwingress.blob.core.windows.net/ingress-azure-helm-package/"
#   chart      = "ingress-azure"
#   namespace  = "agic"

#   set {
#     name  = "appgw.subscriptionId"
#     value = var.subscriptionId
#   }

#   set {
#     name  = "appgw.resourceGroup"
#     value = azurerm_resource_group.rg.name
#   }

#   set {
#     name  = "appgw.name"
#     value = azurerm_application_gateway.gateway.name
#   }

#   set {
#     name  = "armAuth.secretJSON"
#     value = base64encode(jsonencode({
#       clientId    = var.clientId,
#       clientSecret = var.spSecret,
#       tenantId    = var.tenantId
#     }))
#   }

#   set {
#     name  = "armAuth.type"
#     value = "servicePrincipal"
#   }
# }
