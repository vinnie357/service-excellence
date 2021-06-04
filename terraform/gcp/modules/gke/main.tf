#default
resource "google_service_account" "default" {
  account_id   = "service-account-id"
  display_name = "GKE node service account"
}

module "cluster" {
  source                         = "terraform-google-modules/kubernetes-engine/google//modules/safer-cluster"
  project_id                     = var.project_id
  name                           = format("%s", var.prefix)
  description                    = format("Application cluster(%s)", var.prefix)
  region                         = var.region
  network                        = module.internal_vpc.network_name
  network_project_id             = var.project_id
  subnetwork                     = lookup(lookup(module.internal_vpc.subnets, format("%s/internal", var.region), {}), "name", "")
  ip_range_pods                  = var.pod_cidr_name
  ip_range_services              = var.service_cidr_name
  compute_engine_service_account = local.gke_sa
  grant_registry_access          = false
  cluster_resource_labels        = var.labels
  master_ipv4_cidr_block         = var.master_cidr
  master_authorized_networks = [
    {
      cidr_block   = format("%s/32", module.bastion.ip_address)
      display_name = format("Bastion for %s", var.prefix)
    },
  ]
  cloudrun                           = false
  config_connector                   = false
  dns_cache                          = false
  enable_intranode_visibility        = false
  enable_network_egress_export       = false
  enable_pod_security_policy         = true
  enable_private_endpoint            = true
  enable_resource_consumption_export = false
  istio                              = false
  http_load_balancing                = false
  node_pools = [
    {
      name          = format("%s-pool", var.prefix)
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
