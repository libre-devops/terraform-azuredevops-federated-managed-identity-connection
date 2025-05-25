terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">=1.0.1"
    }
    time = {
      source = "hashicorp/time"
    }
  }
}
