/*data template_file cloudinit_web {

  template = file("${path.module}/Templates/cloudinit_web.tpl")
} */


resource "azurerm_virtual_machine" "web" {
  count = var.web_node_count
  #name                  = "${var.prefix}_web_${count.index+1}"
  name                  = "${var.prefix}-wbvm${count.index}"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [element(azurerm_network_interface.web.*.id, count.index)]
  vm_size               = "Standard_B1s"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.prefix}_wbos${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "${var.prefix}wbosvm${count.index}"
    admin_username = var.username
    #admin_password = var.password
    #custom_data = data.template_file.cloudinit_web.rendered
  }
  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      key_data = data.template_file.key_data.rendered
      path     = var.destination_ssh_key_path
    }
  }

}