module "azdo_spn" {
  source = "../../"


  rg_name  = "rg-${var.short}-${var.loc}-${var.env}-${random_string.entropy.result}"
  location = local.location
  tags     = local.tags

  azuredevops_organization_guid = var.azdo_org_guid
  azuredevops_organization_name = var.azdo_org_name
  azuredevops_project_name      = var.azdo_project_name
}
