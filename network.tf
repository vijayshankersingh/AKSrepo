# Create a virtual network
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-security-group"
  location            = var.region
  resource_group_name = var.resourcegroup
  depends_on = [
    azurerm_resource_group.rg
  ]
}

resource "azurerm_virtual_network" "vnet" {
  name                = "myTFVnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.region
  resource_group_name = var.resourcegroup
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  depends_on = [
    azurerm_resource_group.rg,
    azurerm_network_security_group.nsg

  ]
}

resource "azurerm_subnet" "subnet" {
  name                 = "aks-subnet"
  resource_group_name = var.resourcegroup
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
  depends_on = [
    azurerm_resource_group.rg,
    azurerm_virtual_network.vnet
  ]
}

resource "azurerm_route_table" "rt" {
  name                = "aks-routetable"
  location            = var.region
  resource_group_name = var.resourcegroup

  route {
    name                   = "example"
    address_prefix         = "10.100.0.0/14"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.10.1.1"
  }
  depends_on = [
    azurerm_resource_group.rg
  ]
}

resource "azurerm_subnet_route_table_association" "akssrt" {
  subnet_id      = azurerm_subnet.subnet.id
  route_table_id = azurerm_route_table.rt.id
  depends_on = [
    azurerm_subnet.subnet,
    azurerm_route_table.rt
  ]
}

resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
  depends_on = [
    azurerm_subnet.subnet,
    azurerm_network_security_group.nsg
  ]
}