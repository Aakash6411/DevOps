resource "azurerm_managed_disk" "jenkinsdisk" {
  name                 = "jenkins_disk1"
  location             = local.location
  resource_group_name  = local.resource_group_name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10

  depends_on = [ azurerm_resource_group.RG ]
}

resource "azurerm_virtual_machine_data_disk_attachment" "jenkins-vm" {
  managed_disk_id    = azurerm_managed_disk.jenkinsdisk.id
  virtual_machine_id = azurerm_windows_virtual_machine.Jenkins.id
  lun                = "1"
  caching            = "ReadWrite"
}