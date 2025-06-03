terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.0.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "029f2df1-d292-4599-bcf2-03631b90c998"
  client_id = "8479007e-e751-4b6c-8f78-1c3e83ac5d0a"
  client_secret = "9e.8QªGf6DYF2rrIVChGOHpEEGeI5nUjjIBKKdct"
  tenant_id = "83939939-5cc9-410f-a0c3-d5c7ea7c7be7"
  features {}
}

provider "azuread" {}

################################################################################
# 1. Resource Group
################################################################################

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = "westeurope"
  tags = {
    Proyecto = "AVD"
    Entorno  = "Producción"
  }
}

################################################################################
# 2. VNet y Subnet (nombres fijos)
################################################################################

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-avd"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.0.0.0/16"]
  tags                = azurerm_resource_group.rg.tags
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet-avd"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

################################################################################
# 3. Storage Account + Fileshare para FSLogix (oculto al usuario)
################################################################################

resource "random_string" "suffix" {
  length  = 4
  upper   = false
  special = false
}

resource "azurerm_storage_account" "sa" {
  name                     = format("stfsavdpool%s", random_string.suffix.result)
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  tags                     = azurerm_resource_group.rg.tags
}

resource "azurerm_storage_share" "fslogix" {
  name               = "fslogix-profiles"
  storage_account_id = azurerm_storage_account.sa.id
  quota              = 50
}

################################################################################
# 4. Host Pool (siempre Pooled) con AAD Join + Intune Enrollment
################################################################################

resource "azurerm_virtual_desktop_host_pool" "hostpool" {
  name                     = var.host_pool_name
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  friendly_name            = var.host_pool_name
  validate_environment     = false
  custom_rdp_properties    = "targetisaadjoined:i:1;enrollvmwithintune:i:1"
  load_balancer_type       = "DepthFirst"
  type                     = "Pooled"
  maximum_sessions_allowed = 2
  tags                     = azurerm_resource_group.rg.tags
}

################################################################################
# 5. Application Group + Workspace
################################################################################

resource "azurerm_virtual_desktop_application_group" "appgroup" {
  name                = "${var.host_pool_name}-ag"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  host_pool_id        = azurerm_virtual_desktop_host_pool.hostpool.id
  type                = "RemoteApp"
  tags                = azurerm_resource_group.rg.tags
}

resource "azurerm_virtual_desktop_workspace" "workspace" {
  name                = "${var.host_pool_name}-ws"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  friendly_name       = "${var.host_pool_name} Workspace"
  tags                = azurerm_resource_group.rg.tags
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "assoc" {
  application_group_id = azurerm_virtual_desktop_application_group.appgroup.id
  workspace_id         = azurerm_virtual_desktop_workspace.workspace.id
}

################################################################################
# 6. Lookup de UPN ➔ Object ID (para cada UPN o grupo en var.user_upns)
################################################################################

data "azuread_user" "lookup_user" {
  for_each            = toset(var.user_upns)
  user_principal_name = each.value
}

################################################################################
# 7. Asignar rol "Desktop Virtualization User" a cada principal
################################################################################

resource "azurerm_role_assignment" "avd_user_role" {
  for_each             = data.azuread_user.lookup_user
  scope                = azurerm_virtual_desktop_application_group.appgroup.id
  role_definition_name = "Desktop Virtualization User"
  principal_id         = each.value.object_id
}

################################################################################
# 8. Crear NICs para las Session Hosts
################################################################################

resource "azurerm_network_interface" "nic" {
  count               = local.session_hosts_count
  name                = "${var.host_pool_name}-nic-${count.index + 1}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig${count.index + 1}"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = azurerm_resource_group.rg.tags
}

################################################################################
# 9. Password aleatorio para el administrador local (si se quiere usar)
################################################################################

resource "random_password" "admin_pass" {
  length  = 16
  special = true
}

################################################################################
# 10. Sesión Hosts (Windows) con AAD Login y extensión
################################################################################

resource "azurerm_windows_virtual_machine" "session_host" {
  count               = local.session_hosts_count
  name                = "${var.host_pool_name}-host-${count.index + 1}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_D2s_v3"
  network_interface_ids = [
    azurerm_network_interface.nic[count.index].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 127
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "21h2-multisession"
    version   = "latest"
  }

  admin_username = "azureuser"
  admin_password = random_password.admin_pass.result

  identity {
    type = "SystemAssigned"
  }

  tags = azurerm_resource_group.rg.tags
}

resource "azurerm_virtual_machine_extension" "aad_login" {
  count                       = local.session_hosts_count
  name                        = "AADLoginForWindows-${count.index + 1}"
  virtual_machine_id          = azurerm_windows_virtual_machine.session_host[count.index].id
  publisher                   = "Microsoft.Azure.ActiveDirectory"
  type                        = "AADLoginForWindows"
  type_handler_version        = "1.0"
  auto_upgrade_minor_version  = true
}

################################################################################
# 11. Outputs
################################################################################

output "host_pool_id" {
  description = "ID del Host Pool creado"
  value       = azurerm_virtual_desktop_host_pool.hostpool.id
}

output "session_hosts" {
  description = "Lista de nombres de los session hosts"
  value       = [for vm in azurerm_windows_virtual_machine.session_host : vm.name]
}