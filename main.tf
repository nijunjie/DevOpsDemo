# Configure the Azure Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.40"
    }
  }
}

provider "azurerm" {
  subscription_id = "a9a0e11a-2ce3-46bd-b791-0b10c084a1e4"
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