resource "azurerm_virtual_network" "web_app" {
  name = "web-app"
  resource_group_name = azurerm_resource_group.web_app.name
  tags = {
    project = "web-app"
    environment = "production"
  }

  subnet {
    name = "web-servers"
    address_prefix = "10.0.0.0/24"
  }

  subnet {
    name = "load-balancer"
    address_prefix = "10.0.1.0/24"
  }
}
