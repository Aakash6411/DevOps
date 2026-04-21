resource "azurerm_virtual_network" "vnet1" {
  name                = local.virtual_network.name
  address_space       = [local.virtual_network.address_space]
  location            = local.location
  resource_group_name = local.resource_group_name

  tags = {
    name = "Jenkins"
  }
  depends_on = [ azurerm_resource_group.RG ]
}

resource "azurerm_subnet" "subnetA" {
  name                 = "internal"
  resource_group_name  = local.resource_group_name
  virtual_network_name = local.virtual_network.name
  address_prefixes     = local.subnet.address_prefixes
  depends_on = [ azurerm_virtual_network.vnet1 ]
}

resource "azurerm_network_interface" "nic" {
  name                = "jenkins-nic"
  location            = local.location
  resource_group_name = local.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnetA.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.publicip.id
  }
  depends_on = [ azurerm_subnet.subnetA ]
}

resource "azurerm_public_ip" "publicip" {
  name                = "Jenkins_publicip"
  resource_group_name = local.resource_group_name
  location            = local.location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
  depends_on = [ azurerm_resource_group.RG ]
}


resource "azurerm_network_security_group" "jenkins_SG" {
  name                = "Jenkins-SG"
  location            = local.location
  resource_group_name = local.resource_group_name

  security_rule {
    name                       = "RDPRule"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

   security_rule {
    name                       = "Jenkinsport"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

   security_rule {
    name                       = "AllowSSH"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }
  depends_on = [ azurerm_resource_group.RG ]
}
resource "azurerm_subnet_network_security_group_association" "nsgassociation" {
  subnet_id                 = azurerm_subnet.subnetA.id
  network_security_group_id = azurerm_network_security_group.jenkins_SG.id
}