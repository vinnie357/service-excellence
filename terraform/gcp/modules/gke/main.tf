#default
resource "google_service_account" "default" {
  account_id   = "service-account-id"
  display_name = "GKE node service account"
}

module "cluster" {
  source                         = "terraform-google-modules/kubernetes-engine/google//modules/safer-cluster"
  project_id                     = var.gcpProjectId
  name                           = format("%s", var.projectPrefix)
  description                    = format("Application cluster(%s)", var.projectPrefix)
  region                         = var.gcpRegion
  network                        = module.gcp-network.network_name
  network_project_id             = var.gcpProjectId
  subnetwork                     = local.subnet_names[index(module.gcp-network.subnets_names, local.subnet_name)]
  ip_range_pods                  = local.pods_range_name
  ip_range_services              = local.svc_range_name
  compute_engine_service_account = module.gke-sa.email
  grant_registry_access          = true
  cluster_resource_labels        = var.labels
  master_ipv4_cidr_block         = var.masterCidr
  master_authorized_networks = [
    {
      cidr_block   = var.adminSourceAddress[0]
      display_name = format("admin %s", var.projectPrefix)
    },
  ]
  cloudrun                           = false
  config_connector                   = false
  dns_cache                          = false
  enable_intranode_visibility        = false
  enable_network_egress_export       = false
  enable_pod_security_policy         = true
  enable_private_endpoint            = false
  enable_resource_consumption_export = false
  istio                              = false
  http_load_balancing                = false
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
