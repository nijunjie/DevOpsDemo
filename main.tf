# Configure the Azure Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.40"
    }
  }

  backend "azurerm" {
    resource_group_name  = "NestedRG"
    storage_account_name = "nestedstorageaccount"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# Create resource group
resource "azurerm_resource_group" "default" {
  name     = "NestedTest"
  location = "westus2"
}

# Create container instance
resource "azurerm_container_group" "default" {
  name                = "weatherapi"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name

  ip_address_type = "public"
  dns_name_label  = "weatherapi"
  os_type         = "Linux"

  container {
    name   = "weatherapi"
    image  = "nijunjie/weatherapi"
    cpu    = "1"
    memory = "1"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }
}