terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.67.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

resource "azurerm_resource_group" "RG" {
  name = local.resource_group_name
  location = local.location
}

resource "azurerm_windows_virtual_machine" "Jenkins" {
  name                = "jenkins-vm"
  resource_group_name = local.resource_group_name
  location            = local.location
  size                = "Standard_B2ats_v2"
  admin_username      = "adminuser"
  admin_password      = "Jenkinstest@98"
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}