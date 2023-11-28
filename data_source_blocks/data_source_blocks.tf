terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "web_app" {
  name     = "web_app-resources"
  location = "West Europe"
}

data "azurerm_virtual_network" "web_app" {
  name                = var.vnet_name
  resource_group_name = var.vnet_resource_group_name
}

data "azurerm_subnet" "web_app" {
  name                 = "web"
  resource_group_name  = data.azurerm_virtual_network.web_app.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.web_app.name
}

resource "azurerm_network_interface" "web" {
  name                = "web1-nic"
  location            = azurerm_resource_group.web_app.location
  resource_group_name = azurerm_resource_group.web_app.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.web_app
    private_ip_address_allocation = "Dynamic"
  }
}