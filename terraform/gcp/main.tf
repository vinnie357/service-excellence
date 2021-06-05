// provider
provider "google" {
  project = var.gcpProjectId
  region  = var.gcpRegion
  zone    = var.gcpZone
}
provider "google-beta" {
}

// New Network
module "gcp-network" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 2.5"
  project_id   = var.gcpProjectId
  network_name = local.network_name

  subnets = [
    {
      subnet_name   = local.subnet_name
      subnet_ip     = "10.0.0.0/17"
      subnet_region = var.gcpRegion
    },
    {
      subnet_name   = local.master_auth_subnetwork
      subnet_ip     = "10.60.0.0/17"
      subnet_region = var.gcpRegion
    },
  ]

  secondary_ranges = {
    (local.subnet_name) = [
      {
        range_name    = local.pods_range_name
        ip_cidr_range = "192.168.0.0/18"
      },
      {
        range_name    = local.svc_range_name
        ip_cidr_range = "192.168.64.0/18"
      },
    ]
  }
}
// gke cluster
#https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/blob/master/examples/safer_cluster/main.tf
locals {
  cluster_type           = "safer-cluster"
  network_name           = "${var.projectPrefix}-safer-cluster-network-${var.buildSuffix}"
  subnet_name            = "${var.projectPrefix}-safer-cluster-subnet-${var.buildSuffix}"
  master_auth_subnetwork = "${var.projectPrefix}-safer-cluster-master-subnet-${var.buildSuffix}"
  pods_range_name        = "${var.projectPrefix}-ip-range-pods-${var.buildSuffix}"
  svc_range_name         = "${var.projectPrefix}-ip-range-svc-${var.buildSuffix}"
  subnet_names           = [for subnet_self_link in module.gcp-network.subnets_self_links : split("/", subnet_self_link)[length(split("/", subnet_self_link)) - 1]]
}
module "gke-sa" {
  source       = "terraform-google-modules/service-accounts/google"
  version      = "3.0.1"
  project_id   = var.gcpProjectId
  prefix       = var.projectPrefix
  names        = ["gke"]
  display_name = "GKE node service account"
  project_roles = [
    "${var.gcpProjectId}=>roles/logging.logWriter",
    "${var.gcpProjectId}=>roles/monitoring.metricWriter",
    "${var.gcpProjectId}=>roles/monitoring.viewer",
    "${var.gcpProjectId}=>roles/storage.objectViewer"
    # GCR access requires storage.objectViewer on the project containing the registry
    #"${coalesce(var.shared_registry_project_id, var.project_id)}=>roles/storage.objectViewer"
  ]
  generate_keys = false
}
data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google//modules/safer-cluster"
  project_id                 = var.gcpProjectId
  name                       = format("%s-cluster-%s", var.projectPrefix, var.buildSuffix)
  description                = format("Application cluster(%s)", var.projectPrefix)
  regional                   = true
  region                     = var.gcpRegion
  network                    = module.gcp-network.network_name
  subnetwork                 = local.subnet_names[index(module.gcp-network.subnets_names, local.subnet_name)]
  ip_range_pods              = local.pods_range_name
  ip_range_services          = local.svc_range_name
  master_ipv4_cidr_block     = var.masterCidr
  cluster_resource_labels    = var.labels
  add_cluster_firewall_rules = false
  firewall_inbound_ports     = ["9443", "15017"]
  master_authorized_networks = [
    {
      cidr_block   = "10.60.0.0/17"
      display_name = "VPC"
    },
    {
      cidr_block   = var.adminSourceAddress[0]
      display_name = format("admin %s", var.projectPrefix)
    },
  ]
  grant_registry_access              = true
  istio                              = false
  cloudrun                           = false
  config_connector                   = false
  dns_cache                          = false
  enable_intranode_visibility        = false
  enable_private_endpoint            = false
  enable_resource_consumption_export = false
  notification_config_topic          = google_pubsub_topic.updates.id
  # nodes
  compute_engine_service_account = module.gke-sa.email
  node_pools = [
    {
      name          = format("%s-pool", var.projectPrefix)
      min_count     = 1
      max_count     = 3
      auto_upgrade  = true
      node_metadata = "GKE_METADATA_SERVER"
    }
  ]
  node_pools_labels = {
    all = var.labels
  }
  node_pools_tags = {
    all = var.tags
  }
}

resource "google_pubsub_topic" "updates" {
  name    = "cluster-updates-${var.buildSuffix}"
  project = var.gcpProjectId
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
