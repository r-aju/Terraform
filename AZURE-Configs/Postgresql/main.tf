resource "azurerm_virtual_network" "example" {
  name                = var.azurerm_vnet
  location            = var.azurerm_location
  resource_group_name = var.azurerm_resource_group_name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "internal" {
  name                 = var.azurerm_subnet_name
  resource_group_name  = var.azurerm_resource_group_name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
  service_endpoints    = ["Microsoft.Sql"]
}

resource "azurerm_network_security_group" "terraform-security-group" {

  name                = var.nsg_name
  location            = var.azurerm_location
  resource_group_name = var.azurerm_resource_group_name

  security_rule {
    name                       = "Inbound-rules"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"


  }
  security_rule {
    name                       = "Outbound-rules"
    priority                   = 1007
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"


  }

  tags = {
    environment = "terraform provisioned resource"
    purpose     = "terraform exploration"
  }
}

resource "azurerm_network_interface" "terraform-network-interface" {

  name                = var.network_interface
  location            = var.azurerm_location
  resource_group_name = var.azurerm_resource_group_name

  ip_configuration {
    name                          = "terraform-configuration"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    #   public_ip_address_id          = azurerm_public_ip.terraform-public-ip.id
  }


  tags = {
    environment = "terraform provisioned resource"
    purpose     = "terraform exploration"
  }

}

resource "azurerm_network_interface_security_group_association" "terraform-association" {

  network_interface_id      = azurerm_network_interface.terraform-network-interface.id
  network_security_group_id = azurerm_network_security_group.terraform-security-group.id
}


resource "azurerm_postgresql_server" "test" {
  name                = var.postgresql_server_name
  location            = var.azurerm_location
  resource_group_name = var.azurerm_resource_group_name
  sku_name            = "GP_Gen5_2"


  storage_profile {
    auto_grow             = "Enabled"
    storage_mb            = var.storage
    backup_retention_days = var.backup_retention_days
    geo_redundant_backup  = var.geo_redundant_backup
  }

  threat_detection_policy {
    enabled              = "true"
    email_account_admins = "true"
    email_addresses      = ["kanaka.raju@skit.ai"]

  }

  administrator_login              = var.user_administrator_login
  administrator_login_password     = var.user_administrator_login_password
  version                          = var.postgresql_version
  ssl_enforcement_enabled          = var.ssl_enabled
  ssl_minimal_tls_version_enforced = var.ssl_tls_version


}

resource "azurerm_postgresql_virtual_network_rule" "test" {
  name                                 = var.postgres_rule
  resource_group_name                  = var.azurerm_resource_group_name
  server_name                          = azurerm_postgresql_server.test.name
  subnet_id                            = azurerm_subnet.internal.id
  ignore_missing_vnet_service_endpoint = true
}



resource "azurerm_postgresql_database" "example" {
  name                = var.postgresql_database_name
  resource_group_name = var.azurerm_resource_group_name
  server_name         = azurerm_postgresql_server.test.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}




resource "azurerm_postgresql_server" "read-replica" {
  name                      = var.replica_name
  location                  = var.azurerm_location
  resource_group_name       = var.azurerm_resource_group_name
  creation_source_server_id = azurerm_postgresql_server.test.id
  # creation_source_server_id  = "/subscriptions/95a44708-65f2-45af-9ae7-00e4a22fa911/resourceGroups/terraform-prod-database/providers/Microsoft.DBforPostgreSQL/servers/terraform-postgresql"
  version         = "11"
  sku_name        = "GP_Gen5_2"
  ssl_enforcement = "Disabled"
  create_mode     = "Replica"

}



#------------------------------------------------------------
# extra parameters
# public_network_access_enabled
# threat_detection_policy
# ssl_enforcement_enabled
#  ssl_minimal_tls_version_enforced
#   auto_grow_enabled            = false
