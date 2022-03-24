#--------------------------------------------------------------------------------------------------#
# resource "azurerm_resource_group" "terraform-rg" {

#   name     = var.resource-group
#   location = var.location

#   tags = {
#     environment = "terraform provisioned resource"
#     purpose     = "terraform exploration"
#   }

# }
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group
#--------------------------------------------------------------------------------------------------#

resource "azurerm_network_ddos_protection_plan" "example" {
  name                = "ddospplan1"
  location            = var.location
  resource_group_name = "Terraform-resources"
}


resource "azurerm_virtual_network" "example" {
  name                = "terraform-vnet"
  location            = var.location
  resource_group_name = "Terraform-resources"
  address_space       = ["10.0.0.0/16"]

  ddos_protection_plan {
    id     = azurerm_network_ddos_protection_plan.example.id
    enable = true
  }
}



# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network

#--------------------------------------------------------------------------------------------------#


resource "azurerm_subnet" "example" {
  name                 = var.subnet-name
  resource_group_name  = "Terraform-resources"
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet

#--------------------------------------------------------------------------------------------------#



resource "azurerm_public_ip" "terraform-public-ip" {

  name                = var.public-ip
  location            = var.location
  resource_group_name = "Terraform-resources"
  allocation_method   = "Dynamic"

  tags = {
    environment = "terraform provisioned resource"
    purpose     = "terraform exploration"
  }
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip
#--------------------------------------------------------------------------------------------------#


resource "azurerm_network_security_group" "terraform-security-group" {

  name                = var.security-group
  location            = var.location
  resource_group_name = "Terraform-resources"

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"


  }
  tags = {
    environment = "terraform provisioned resource"
    purpose     = "terraform exploration"
  }
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group

#--------------------------------------------------------------------------------------------------#

resource "azurerm_network_interface" "terraform-network-interface" {

  name                = "Terraform-network-interface"
  location            = var.location
  resource_group_name = "Terraform-resources"

  ip_configuration {
    name                          = "terraform-configuration"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.terraform-public-ip.id
  }


  tags = {
    environment = "terraform provisioned resource"
    purpose     = "terraform exploration"
  }

}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface

#--------------------------------------------------------------------------------------------------#



resource "azurerm_network_interface_security_group_association" "terraform-association" {

  network_interface_id      = azurerm_network_interface.terraform-network-interface.id
  network_security_group_id = azurerm_network_security_group.terraform-security-group.id
}

#--------------------------------------------------------------------------------------------------#

resource "azurerm_storage_account" "terraform-storage" {

  name                     = var.storage_account
  resource_group_name      = "Terraform-resources"
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"



  tags = {
    environment = "terraform provisioned resource"
    purpose     = "terraform exploration"
  }
}

#storage account not required.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account
#--------------------------------------------------------------------------------------------------#


resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits  = 2098
}
output "tls_private_key" {
  value     = tls_private_key.example_ssh.private_key_pem
  sensitive = true
}


resource "azurerm_linux_virtual_machine" "terraform-machine" {

  name                  = "Terraform-database"
  location              = var.location
  resource_group_name   = "Terraform-resources"
  network_interface_ids = [azurerm_network_interface.terraform-network-interface.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "Terraform-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  computer_name                   = "myvm"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.example_ssh.public_key_openssh
  }

  #  os_profile {
  #     computer_name = "Terraform-VM"
  #     admin_username = "testuser"
  #     admin_password = "Password123"
  # }

  source_image_reference {
    publisher = "Canonical"
    offer     = "Ubuntuserver"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  # admin_ssh_key {
  #   username   = "kanakaraju"
  #   public_key = file("terraform-key.pem")
  #  }

  # computer_name = "Terraform-VM"
  # admin_username = "admin-kanaka"
  # disable_password_authentication = false
  # admin_password = "Adminkanaka@123"

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.terraform-storage.primary_blob_endpoint
  }

  tags = {
    environment = "terraform provisioned resource"
    purpose     = "terraform exploration"
  }
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine





