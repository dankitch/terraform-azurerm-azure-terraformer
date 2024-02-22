
resource "azurerm_public_ip" "vpn" {

  name                = "pip-vpng-${var.name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"

}

resource "azurerm_point_to_site_vpn_gateway" "p2s_config" {
  name                = "vpng-${var.name}"
  resource_group_name = var.resource_group_name
  location            = var.location

  virtual_hub_id              = var.virtual_hub_id
  vpn_server_configuration_id = azurerm_vpn_server_configuration.p2s_config.id
  scale_unit                  = 1
  connection_configuration {
    name = "${var.name}-gateway-config"

    vpn_client_address_pool {
      address_prefixes = [var.address_space]
    }
  }
}

resource "azurerm_vpn_server_configuration" "p2s_config" {

  name                = "vpng-${var.name}"
  resource_group_name = var.resource_group_name
  location            = var.location

  vpn_authentication_types = ["AAD"]
  vpn_protocols            = ["OpenVPN"]

  azure_active_directory_authentication {
    tenant   = "https://login.microsoftonline.com/${var.tenant_id}/"
    audience = var.audience
    issuer   = "https://sts.windows.net/${var.tenant_id}/"
  }

}