variable "azdo_org_guid" {
  type        = string
  description = "The guid of the org"
}

variable "azdo_org_name" {
  type        = string
  description = "The org name"
}

variable "azdo_project_name" {
  type        = string
  description = "The project name"
}

variable "env" {
  description = "This is passed as an environment variable, it is for the shorthand environment tag for resource.  For example, production = prod"
  type        = string
  default     = "prd"
}

variable "loc" {
  description = "The shorthand name of the Azure location, for example, for UK South, use uks.  For UK West, use ukw. Normally passed as TF_VAR in pipeline"
  type        = string
  default     = "uks"
}

variable "name" {
  type        = string
  description = "The name of this resource"
  default     = "tst"
}

variable "short" {
  description = "This is passed as an environment variable, it is for a shorthand name for the environment, for example hello-world = hw"
  type        = string
  default     = "lbd"
}
