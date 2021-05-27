resource "azurerm_virtual_network" "ansiblevnet" {
  name                = "ansiblevnet"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = ["10.0.0.0/16"]
 #dns_servers         = ["10.0.0.4", "10.0.0.5"]

}


# ansible subnet
resource "azurerm_subnet" "ansible" {
  name                 = "ansible"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.ansiblevnet.name
  address_prefixes     = ["10.0.1.0/24"]


}

#web subnet

resource "azurerm_subnet" "web" {
  name                 = "web"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.ansiblevnet.name
  address_prefixes     = ["10.0.2.0/24"]


}


#db subnet

resource "azurerm_subnet" "db" {
  name                 = "db"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.ansiblevnet.name
  address_prefixes     = ["10.0.3.0/24"]


}

# ansible ubuntu nic & ip address

resource "azurerm_public_ip" "ansible" {
  count = var.ans_node_count
  name                = "${var.prefix}_anspip_${count.index}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"
  sku                 = "Standard"


}

resource "azurerm_network_interface" "ansible" {
  count = var.ans_node_count
  name                = "${var.prefix}_ansnic_${count.index}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.ansible.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = element(azurerm_public_ip.ansible.*.id, count.index)
  }
}

# ansible centos nic & ip address

/*
resource "azurerm_public_ip" "centos" {
  name                = "${var.prefix}_centos_pip"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "centos" {
  name                = "${var.prefix}_centos_nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.ansible.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.centos.id
  }
} 

*/



# nic for web nodes

resource "azurerm_network_interface" "web" {
  count = var.web_node_count
  name                = "${var.prefix}_webnic${count.index}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "configuration-${count.index}"
    subnet_id                     = azurerm_subnet.web.id
    private_ip_address_allocation = "Dynamic"
  }
}


# nic for db nodes

resource "azurerm_network_interface" "db" {
  count = var.db_node_count
  name                = "${var.prefix}_dbnic${count.index}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.db.id
    private_ip_address_allocation = "Dynamic"
  }
}


# win subnet & nic

/*resource "azurerm_subnet" "win" {
  name                 = "win"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.ansiblevnet.name
  address_prefixes     = ["10.0.4.0/24"]
}

resource "azurerm_network_interface" "win" {
  #count = var.win_node_count
  name                = "${var.prefix}_win_nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.win.id
    private_ip_address_allocation = "Dynamic"
    
  }
}  */