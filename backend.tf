terraform {
  backend "azurerm" {
    resource_group_name  = "myrg"
    storage_account_name = "siristorageaccount"
    container_name       = "terraformbackend"
    key                  = "ansibletf"
  }
}
