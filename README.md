```hcl
data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

data "azuredevops_project" "project_id" {
  name = var.azuredevops_project_name
}

locals {
  default_managed_identity_name             = var.managed_identity_name != null ? var.managed_identity_name : "msi-azdo-${var.azuredevops_project_name}-${var.azuredevops_organization_guid}"
  default_managed_identity_description      = var.managed_identity_description != null ? var.managed_identity_description : "This managed identity is for the federated credential of Azure DevOps of the project ${var.azuredevops_project_name}, in the organization ${var.azuredevops_organization_name} with guid ${var.azuredevops_organization_guid}"
  default_federated_credential_display_name = var.federated_credential_display_name != null ? var.federated_credential_display_name : "oidc-wlfid-${local.default_managed_identity_name}"
}

module "rg" {
  source = "libre-devops/rg/azurerm"

  count = var.rg_id == null ? 1 : 0

  rg_name  = var.rg_name
  location = var.location
  tags     = var.tags
}

locals {
  rg_parts           = var.rg_id != null ? split("/", var.rg_id) : null
  rg_name            = local.rg_parts != null ? local.rg_parts[4] : null
  rg_subscription_id = local.rg_parts != null ? local.rg_parts[2] : null
}

resource "azurerm_user_assigned_identity" "uid" {
  name                = local.default_managed_identity_name
  resource_group_name = local.rg_name != null ? local.rg_name : module.rg[0].rg_name
  location            = var.location
  tags                = var.tags
}

resource "azuredevops_serviceendpoint_azurerm" "azure_devops_service_endpoint_azurerm" {
  depends_on                             = [azurerm_role_assignment.assign_spn_to_subscription[0]]
  project_id                             = data.azuredevops_project.project_id.id
  service_endpoint_name                  = var.managed_identity_name != null ? var.managed_identity_name : local.default_managed_identity_name
  description                            = var.managed_identity_description
  service_endpoint_authentication_scheme = "WorkloadIdentityFederation"

  credentials {
    serviceprincipalid = azurerm_user_assigned_identity.uid.principal_id
  }

  azurerm_spn_tenantid      = data.azurerm_client_config.current.tenant_id
  azurerm_subscription_id   = data.azurerm_subscription.current.subscription_id
  azurerm_subscription_name = data.azurerm_subscription.current.display_name
}

resource "azurerm_role_assignment" "assign_spn_to_subscription" {
  count                = var.attempt_assign_role_to_spn == true ? 1 : 0
  principal_id         = azurerm_user_assigned_identity.uid.principal_id
  scope                = data.azurerm_subscription.current.id
  role_definition_name = var.role_definition_name_to_assign
}

resource "azurerm_federated_identity_credential" "federated_credential" {
  name                = local.default_federated_credential_display_name
  resource_group_name = azurerm_user_assigned_identity.uid.resource_group_name
  parent_id           = azurerm_user_assigned_identity.uid.id
  audience            = var.federated_credential_audiences
  issuer              = azuredevops_serviceendpoint_azurerm.azure_devops_service_endpoint_azurerm.workload_identity_federation_issuer
  subject             = azuredevops_serviceendpoint_azurerm.azure_devops_service_endpoint_azurerm.workload_identity_federation_subject
}
```
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuredevops"></a> [azuredevops](#requirement\_azuredevops) | ~>0.11.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuredevops"></a> [azuredevops](#provider\_azuredevops) | ~>0.11.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_rg"></a> [rg](#module\_rg) | libre-devops/rg/azurerm | n/a |

## Resources

| Name | Type |
|------|------|
| [azuredevops_serviceendpoint_azurerm.azure_devops_service_endpoint_azurerm](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/serviceendpoint_azurerm) | resource |
| [azurerm_federated_identity_credential.federated_credential](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/federated_identity_credential) | resource |
| [azurerm_role_assignment.assign_spn_to_subscription](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_user_assigned_identity.uid](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azuredevops_project.project_id](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/project) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attempt_assign_role_to_spn"></a> [attempt\_assign\_role\_to\_spn](#input\_attempt\_assign\_role\_to\_spn) | Whether or not to attempt to assign a role to the SPN to the subscription.  This is actually needed, so defaults to true | `bool` | `true` | no |
| <a name="input_azuredevops_organization_guid"></a> [azuredevops\_organization\_guid](#input\_azuredevops\_organization\_guid) | The unique ID of your Azure DevOps organisation | `string` | n/a | yes |
| <a name="input_azuredevops_organization_name"></a> [azuredevops\_organization\_name](#input\_azuredevops\_organization\_name) | The name of your Azure DevOps organization | `string` | n/a | yes |
| <a name="input_azuredevops_project_name"></a> [azuredevops\_project\_name](#input\_azuredevops\_project\_name) | The name of your Azure DevOps project you want to configure the federated cred for | `string` | n/a | yes |
| <a name="input_federated_credential_audiences"></a> [federated\_credential\_audiences](#input\_federated\_credential\_audiences) | The audience for the credential, set to the default for Azure DevOps | `list(string)` | <pre>[<br>  "api://AzureADTokenExchange"<br>]</pre> | no |
| <a name="input_federated_credential_display_name"></a> [federated\_credential\_display\_name](#input\_federated\_credential\_display\_name) | The display name of your federated credential in AzureAD/Entra for ID | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | The location for this resource to be put in | `string` | `"uksouth"` | no |
| <a name="input_managed_identity_description"></a> [managed\_identity\_description](#input\_managed\_identity\_description) | The description of the service principal | `string` | `null` | no |
| <a name="input_managed_identity_name"></a> [managed\_identity\_name](#input\_managed\_identity\_name) | The name of the service principal | `string` | `null` | no |
| <a name="input_rg_id"></a> [rg\_id](#input\_rg\_id) | The id of a resource group, supplying this value stops the module from creating a resource group, defaults to null as created a resource group is the default behaviour | `string` | `null` | no |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | The name of the resource group, this module creates a resource group for you, so please supply a unique name | `string` | `null` | no |
| <a name="input_role_definition_name_to_assign"></a> [role\_definition\_name\_to\_assign](#input\_role\_definition\_name\_to\_assign) | The role definition needed to setup SPN, for security reasons, defautls to Reader | `string` | `"Reader"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of the tags to use on the resources that are deployed with this module. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_service_endpoint_id"></a> [service\_endpoint\_id](#output\_service\_endpoint\_id) | The id of the service endpoint |
| <a name="output_service_endpoint_name"></a> [service\_endpoint\_name](#output\_service\_endpoint\_name) | The project name of the service endpoint is made with |
| <a name="output_service_endpoint_project_id"></a> [service\_endpoint\_project\_id](#output\_service\_endpoint\_project\_id) | The project id of the service endpoint is made with |
| <a name="output_service_endpoint_service_principal_id"></a> [service\_endpoint\_service\_principal\_id](#output\_service\_endpoint\_service\_principal\_id) | The service principal id service endpoint is made with |
| <a name="output_workload_identity_federation_issuer"></a> [workload\_identity\_federation\_issuer](#output\_workload\_identity\_federation\_issuer) | The issuer for the workload issuer |
| <a name="output_workload_identity_federation_subject"></a> [workload\_identity\_federation\_subject](#output\_workload\_identity\_federation\_subject) | The subject for the workload federation |
