provider "azurerm" {
  subscription_id = var.subscription_id
  features {
  }
}

################################################################################
# Storage resources
################################################################################

resource "azurerm_resource_group" "website" {
  name                     = var.storage_account_name
  location                 = "westeurope"
}

resource "azurerm_storage_account" "website" {
  name                     = azurerm_resource_group.website.name
  resource_group_name      = azurerm_resource_group.website.name
  location                 = azurerm_resource_group.website.location    
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # Enable static website that serves files from the blob storage container '$web'
  static_website {
    index_document         = "index.html"
  }
}
