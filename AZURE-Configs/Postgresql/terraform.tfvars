azurerm_location            = "centralindia"
azurerm_resource_group_name = "test-resources"
azurerm_vnet                = "test-database"
azurerm_subnet_name         = "test-db-subnetss"
nsg_name          = "test-database"
network_interface = "test-network-interface"
postgresql_server_name = "test-postgresql"
storage                = 5120 #MB
backup_retention_days  = 7
geo_redundant_backup   = "Enabled"
user_administrator_login          = "psqladminun"
user_administrator_login_password = "psqlgauadmin@123"
postgresql_version                = "11"
ssl_enabled                       = "true"
ssl_tls_version                   = "TLS1_2"
postgres_rule = "test-vnet-rule"
postgresql_database_name = "exampledb"
replica_name = "test-server-replica"