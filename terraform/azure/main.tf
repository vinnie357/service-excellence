# Azure Provider
provider "azurerm" {
  // public, usgovernment, german, and china. Defaults to public
  environment = "public"
  features {}
}

# Create Resource Group
resource "azurerm_resource_group" "main" {
  name     = format("%s-rg-%s", var.projectPrefix, random_id.randomString.dec)
  location = var.azureLocation

  tags = {
    Name      = format("%s-rg-%s", var.resourceOwner, random_id.randomString.dec)
    Owner     = var.resourceOwner
    Terraform = "true"
  }
}

# Network Module
module "azure_network" {
  source             = "../../../../../../modules/azure/terraform/network/min/"
  projectPrefix      = var.projectPrefix
  buildSuffix        = random_id.randomString.dec
  resourceOwner      = var.resourceOwner
  azureResourceGroup = azurerm_resource_group.main.name
  azureLocation      = var.azureLocation

  depends_on = [azurerm_resource_group.main]
}

// aks
resource "azurerm_kubernetes_cluster" "k8s" {
  name                = format("%s-aks-%s", var.projectPrefix, random_id.randomString.dec)
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "kubecluster"
  default_node_pool {
    name       = "default"
    node_count = "3"
    vm_size    = "Standard_DS3_v2"
  }
  identity {
    type = "SystemAssigned"
  }
}
// config
resource "local_file" "kube_config" {
  content  = azurerm_kubernetes_cluster.k8s.kube_config_raw
  filename = "${path.module}/aks-cluster-config"
}
resource "local_file" "kube_client_cert" {
  content  = azurerm_kubernetes_cluster.k8s.kube_config.0.client_certificate
  filename = "${path.module}/aks-client-cert"
}
// acr
resource "azurerm_container_registry" "acr" {
  name                     = replace(format("%s-ACR-%s", var.projectPrefix, random_id.randomString.dec), "-", "")
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  sku                      = "Premium"
  admin_enabled            = false
  georeplication_locations = ["East US"]
  tags = {
    Owner = var.resourceOwner
  }
}
// default cert for ingress
resource "tls_private_key" "default" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_self_signed_cert" "default" {
  key_algorithm   = tls_private_key.default.algorithm
  private_key_pem = tls_private_key.default.private_key_pem

  subject {
    common_name  = "kic.example.com"
    organization = "NGINX Examples, Inc"
  }

  validity_period_hours = 24

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
    "client_auth",
  ]
}

// // Nginx
// module "nginx" {
//   source           = "../../../../../modules/azure/terraform/nginx-plus/"
//   resource_group   = azurerm_resource_group.main
//   nginxCert        = var.nginxCert
//   nginxKey         = var.nginxKey
//   buildSuffix      = random_pet.buildSuffix.id
//   subnet           = module.azure_network.subnets["mgmt"]
//   adminPassword    = random_password.password.result
//   adminAccountName = var.adminAccountName
//   sshPublicKey     = var.sshPublicKey
//   #sshPublicKey     = file("/home/user/mykey.pub")
// }
