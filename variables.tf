variable "attempt_assign_role_to_spn" {
  type        = bool
  description = "Whether or not to attempt to assign a role to the SPN to the subscription.  This is actually needed, so defaults to true"
  default     = true
}

variable "azuredevops_organization_guid" {
  type        = string
  description = "The unique ID of your Azure DevOps organisation"
}

variable "azuredevops_organization_name" {
  type        = string
  description = "The name of your Azure DevOps organization"
}

variable "azuredevops_project_name" {
  type        = string
  description = "The name of your Azure DevOps project you want to configure the federated cred for"
}

variable "federated_credential_audiences" {
  type        = list(string)
  description = "The audience for the credential, set to the default for Azure DevOps"
  default     = ["api://AzureADTokenExchange"]
}

variable "federated_credential_display_name" {
  type        = string
  description = "The display name of your federated credential in AzureAD/Entra for ID"
  default     = null
}

variable "location" {
  description = "The location for this resource to be put in"
  type        = string
  default     = "uksouth"
}

variable "managed_identity_description" {
  type        = string
  description = "The description of the service principal"
  default     = null
}

variable "managed_identity_name" {
  type        = string
  description = "The name of the service principal"
  default     = null
}

variable "rg_id" {
  type        = string
  description = "The id of a resource group, supplying this value stops the module from creating a resource group, defaults to null as created a resource group is the default behaviour"
  default     = null
}

variable "rg_name" {
  description = "The name of the resource group, this module creates a resource group for you, so please supply a unique name"
  type        = string
  default     = null
}

variable "role_definition_name_to_assign" {
  type        = string
  description = "The role definition needed to setup SPN, for security reasons, defautls to Reader"
  default     = "Reader"
}

variable "tags" {
  type        = map(string)
  description = "A map of the tags to use on the resources that are deployed with this module."
  default     = {}
}
