terraform {
  required_version = ">= 0.13"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.5.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.15.0"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = true

  client_id     = var.appId
  client_secret = var.password
  tenant_id = var.tenantId
  subscription_id = var.subscriptionId
  features {}
}

# Configure the Azure Active Directory Provider
provider "azuread" {
  client_id     = var.appId
  client_secret = var.password
  tenant_id = var.tenantId
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.project_name}"
  location = "East US"
}

module registry {
  source = "./registry"

  azurerm_resource_group_name = azurerm_resource_group.rg.name
  azurerm_resource_group_location = azurerm_resource_group.rg.location
  project_name = var.project_name
}

module cluster {
  source = "./cluster"

  azurerm_resource_group_name = azurerm_resource_group.rg.name
  azurerm_resource_group_location = azurerm_resource_group.rg.location
  appId = var.appId
  password = var.password
}

data "azuread_service_principal" "aks_principal" {
  application_id = var.appId
}

resource "azurerm_role_assignment" "acrpull_role" {
  scope                            = module.registry.azurerm_container_registry_id
  role_definition_name             = "AcrPull"
  principal_id                     = data.azuread_service_principal.aks_principal.id
  skip_service_principal_aad_check = true
}