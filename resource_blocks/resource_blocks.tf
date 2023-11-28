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
  happy    = "true"
}

resource "azurerm_virtual_network" "web_app" {
  name                = "web-app-network"
  resource_group_name = azurerm_resource_group.web_app.name
  location            = azurerm_resource_group.web_app.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "db" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.web_app.name
  virtual_network_name = azurerm_virtual_network.web_app.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "db" {
  name                = "db-nic"
  location            = azurerm_resource_group.web_app.location
  resource_group_name = azurerm_resource_group.web_app.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.db.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "db" {
  name                  = "db-machine"
  resource_group_name   = azurerm_resource_group.web_app.name
  location              = azurerm_resource_group.web_app.location
  size                  = "Standard_F2"
  admin_username        = "adminuser"
  network_interface_ids = [azurerm_network_interface.db.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_network_security_group" "db" {
  name                = "db-nsg"
  location            = azurerm_resource_group.web_app.location
  resource_group_name = azurerm_resource_group.web_app.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}