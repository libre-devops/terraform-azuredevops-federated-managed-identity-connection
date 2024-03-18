output "service_endpoint_id" {
  description = "The id of the service endpoint"
  value       = azuredevops_serviceendpoint_azurerm.azure_devops_service_endpoint_azurerm.id
}

output "service_endpoint_name" {
  description = "The project name of the service endpoint is made with"
  value       = azuredevops_serviceendpoint_azurerm.azure_devops_service_endpoint_azurerm.service_endpoint_name
}

output "service_endpoint_project_id" {
  description = "The project id of the service endpoint is made with"
  value       = azuredevops_serviceendpoint_azurerm.azure_devops_service_endpoint_azurerm.project_id
}

output "service_endpoint_service_principal_id" {
  description = "The service principal id service endpoint is made with"
  value       = azuredevops_serviceendpoint_azurerm.azure_devops_service_endpoint_azurerm.service_principal_id
}

output "user_assigned_managed_identity_id" {
  description = "The resource id of the managed identity"
  value       = azurerm_user_assigned_identity.uid.id
}

output "user_assigned_managed_identity_object_id" {
  description = "The object id id of the managed identity"
  value       = azurerm_user_assigned_identity.uid.principal_id
}

output "user_assigned_managed_identity_tenant_id" {
  description = "The tenant id of the managed identity"
  value       = azurerm_user_assigned_identity.uid.tenant_id
}

output "workload_identity_federation_issuer" {
  description = "The issuer for the workload issuer"
  value       = azuredevops_serviceendpoint_azurerm.azure_devops_service_endpoint_azurerm.workload_identity_federation_issuer
}

output "workload_identity_federation_subject" {
  description = "The subject for the workload federation"
  value       = azuredevops_serviceendpoint_azurerm.azure_devops_service_endpoint_azurerm.workload_identity_federation_subject
}
