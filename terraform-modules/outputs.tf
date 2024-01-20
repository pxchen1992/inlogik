output "service_principal_name" {
  value = module.service_principal.service_principal_name
}

output "service_principal_object_id" {
  value = module.service_principal.service_principal_object_id
}

output "service_principal_tenant_id" {
  value = module.service_principal.service_principal_tenant_id
}

output "service_principal_application_id" {
  value = module.service_principal.service_principal_application_id
}

output "client_id" {
  value = module.service_principal.client_id
}

output "client_secret" {
  value = module.service_principal.client_secret
  sensitive = true
}
