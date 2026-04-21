locals {
  resource_group_name = "myrg"
  location = "centralindia"

    virtual_network = {
  name = "jenkins-vnet"
  address_space = "10.0.0.0/16"
}
subnet = {
    name = "subnet1"
    address_prefixes = ["10.0.1.0/24"]
  }
}


  