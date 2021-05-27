resource "azurerm_public_ip" "anslp_pip" {
  name                = "ansiblepip"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku = "Standard"
}

resource "azurerm_lb" "web" {
  name                = "anslb"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  sku = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.anslp_pip.id
  }
}


resource "azurerm_lb_backend_address_pool" "web" {
  name            = "BackEndAddressPool"
  resource_group_name   = azurerm_resource_group.main.name
  loadbalancer_id = azurerm_lb.web.id
}

resource "azurerm_lb_probe" "web" {
  resource_group_name = azurerm_resource_group.main.name
  loadbalancer_id     = azurerm_lb.web.id
  name                = "web_running_probe"
  port                = var.application_port
}

resource "azurerm_lb_rule" "web" {
  resource_group_name            = azurerm_resource_group.main.name
  loadbalancer_id                = azurerm_lb.web.id
  name                           = "http"
  protocol                       = "Tcp"
  frontend_port                  = var.application_port
  backend_port                   = var.application_port
  frontend_ip_configuration_name = "PublicIPAddress"       #azurerm_lb /frontend_ip_configuration name 
  probe_id                       = azurerm_lb_probe.web.id
}


/*resource "azurerm_network_interface" "lb" {
  name                = "lb-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.web.id
    private_ip_address_allocation = "Dynamic"
  }
}*/




resource "azurerm_network_interface_backend_address_pool_association" "web" {
  count = var.web_node_count
  network_interface_id    = element(azurerm_network_interface.web.*.id, count.index)  #web nic id's 
  ip_configuration_name   = "configuration-${count.index}"              #web subnet nic ip configuaration name
  backend_address_pool_id = azurerm_lb_backend_address_pool.web.id 

}


