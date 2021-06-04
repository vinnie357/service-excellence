// provider
provider "google" {
  project = var.gcpProjectId
  region  = var.gcpRegion
  zone    = var.gcpZone
}

// New Network
module "google_network" {
  source       = "git::https://github.com/f5devcentral/f5-digital-customer-engagement-center//modules/google/terraform/network/min"
  gcpProjectId = var.gcpProjectId
  gcpRegion    = var.gcpRegion
  buildSuffix  = var.buildSuffix
}

// gke cluster
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

resource "google_container_cluster" "primary" {
  name               = "${var.projectPrefix}-gke-cluster-${var.buildSuffix}"
  location           = var.gcpZone
  initial_node_count = 3
  network            = module.google_network.vpcs["public"].id
  subnetwork         = module.google_network.subnets["public"].id
  ip_allocation_policy {}
  node_config {
    preemptible = true
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = module.gke-sa.email
    oauth_scopes = [
      #https://cloud.google.com/container-registry/docs/access-control
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    labels = {
      env = "development"
    }
    tags = ["k8s", "development"]
  }
  timeouts {
    create = "30m"
    update = "40m"
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
