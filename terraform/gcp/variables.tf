# project
variable "projectPrefix" {
  description = "prefix for resources"
}
variable "buildSuffix" {
  description = "name suffix for objects"
  default     = "party-unicorns"
}
# GCP
variable "gcpZone" {
  description = "zone where gke is deployed"
}
variable "gcpRegion" {
  description = "region where gke is deployed"
}
variable "gcpProjectId" {
  description = "gcp project id"
}
# admin
variable "adminAccountName" {
  description = "admin account"
  default     = "zadmin"
}
variable "adminPassword" {
  description = "admin password"
}
variable "adminSourceAddress" {
  description = "admin src address in cidr"
  default     = ["0.0.0.0/0"]
}
variable "sshPublicKey" {
  description = "contents of admin ssh public key"
}
# GKE
#https://cloud.google.com/kubernetes-engine/docs/release-notes-regular
#https://cloud.google.com/kubernetes-engine/versioning-and-upgrades
#gcloud container get-server-config --region us-east1
variable "gkeVersion" {
  default = "1.18.18-gke.1700"
}
variable "masterCidr" {
  default     = "172.19.0.0/28"
  description = <<EOD
  The CIDR to assign to master GKE nodes, and must be a /28.
  default is '172.19.0.0/28'
  EOD
}
variable "podCidr" {
  description = "k8s pod cidr"
  default     = "10.56.0.0/14"
}
variable "tags" {
  default     = ["k8s", "development"]
  description = <<EOD
  An optional list of string network tags that will be applied to all taggable
  resouces. Default is an empty list."
  EOD
}
variable "labels" {
  default     = { env = "development" }
  description = <<EOD
  An optional map of string key:value pairs that will be applied to all resources that accept labels.
  Default is an empty map.
  EOD
}
# nginx
variable "nginxKey" {
  description = "key for nginxplus"
}
variable "nginxCert" {
  description = "cert for nginxplus"
}

# matt
// variable "tf_sa_email" {​​​​​​​​
//  type = string
//  description = <<EOD
// The fully-qualified email address of the Terraform service account to use for
// resource creation. E.g.
// tf_sa_email = "terraform@PROJECT_ID.iam.gserviceaccount.com"
// EOD
// }​​​​​​​​
// variable "tf_sa_token_lifetime_secs" {​​​​​​​​
//  type = number
//  default = 1800
//  description = <<EOD
// The expiration duration for the service account token, in seconds. This value
// should be high enough to prevent token timeout issues during resource creation,
// but short enough that the token is useless replayed later. Default value is 1800
// (30 mins) to allow time for GKE node-pool creation and readiness evaluation.
// EOD
// }​​​​​​​​
// variable "project_id" {​​​​​​​​
//  type = string
//  description = <<EOD
// The existing project id that will host the resources. E.g.
// project_id = "example-project-id"
// EOD
// }​​​​​​​​
// variable "prefix" {​​​​​​​​
//  type = string
//  description = <<EOD
// The name of the upstream client network to create; default is 'client'.
// EOD
// }​​​​​​​​
// variable "labels" {​​​​​​​​
//  type = map(string)
//  default = {​​​​​​​​}​​​​​​​​
//  description = <<EOD
// An optional map of string key:value pairs that will be applied to all resources
// that accept labels. Default is an empty map.
// EOD
// }​​​​​​​​
// variable "region" {​​​​​​​​
//  type = string
//  default = "us-west1"
//  description = <<EOD
// The GCE region to use for resources. Default is 'us-west1'.
// EOD
// }​​​​​​​​
// variable "shared_registry_project_id" {​​​​​​​​
//  type = string
//  default = ""
//  description = <<EOD
// The project id for a shared GCR repository hosted in a different project; set
// the value to an empty string (default) for GCR hosted in the same project as
// the cluster.
// EOD
// }​​​​​​​​
// variable "external_cidr" {​​​​​​​​
//  type = string
//  default = "172.16.0.0/16"
//  description = <<EOD
// The CIDR to assign to the 'external' subnet. Default is '172.16.0.0/16'.
// EOD
// }​​​​​​​​
// variable "control_cidr" {​​​​​​​​
//  type = string
//  default = "172.17.0.0/16"
//  description = <<EOD
// The CIDR to assign to the 'control' subnet. Default is '172.17.0.0/16'.
// EOD
// }​​​​​​​​
// variable "internal_cidr" {​​​​​​​​
//  type = string
//  default = "172.18.0.0/16"
//  description = <<EOD
// The CIDR to assign to the instances on the 'internal' subnet. The CIDR has will
// be used for BIG-IP internal address(es) and GKE nodes.
// Default is '172.18.0.0/16'.
// EOD
// }​​​​​​​​
// variable "master_cidr" {​​​​​​​​
//  type = string
//  default = "172.19.0.0/28"
//  description = <<EOD
// The CIDR to assign to master GKE nodes, and must be a /28. Default is
// '172.19.0.0/28'.
// EOD
// }​​​​​​​​
// variable "service_cidr" {​​​​​​​​
//  type = string
//  default = "172.19.1.0/24"
//  description = <<EOD
// The CIDR to assign for services deployed to GKE, implemented as secondary range
// on 'internal' subnet. Default is '172.19.1.0/24'.
// EOD
// }​​​​​​​​
// variable "pod_cidr" {​​​​​​​​
//  type = string
//  default = "172.20.0.0/14"
//  description = <<EOD
// The CIDR to assign for pods deployed to GKE, implemented as secondary range on
// 'internal' subnet. Default is '172.20.0.0/14'.
// EOD
// }​​​​​​​​
// variable "pod_cidr_name" {​​​​​​​​
//  type = string
//  default = "pods"
//  description = <<EOD
// The name of the secondary address range that will be used for GKE pods. Default
// is 'pods'.
// EOD
// }​​​​​​​​
// variable "service_cidr_name" {​​​​​​​​
//  type = string
//  default = "services"
//  description = <<EOD
// The name of the secondary address range that will be used for GKE services.
// Default is 'services'.
// EOD
// }​​​​​​​​
// variable "bastion_access_members" {​​​​​​​​
//  type = list(string)
//  default = []
//  description = <<EOD
// An optional list of users/groups/serviceAccounts that can login to the bastion
// via IAP tunnelling, in addition to any granted at the project level.
// Default is an empty list.
// EOD
// }​​​​​​​​
// variable "install_tinyproxy_url" {​​​​​​​​
//  type = string
//  description = <<EOD
// Contains the URL for tinyproxy RPM to install on bastion host. If this is a URL
// to a GCS API endpoint, then `software_bucket` variable can be used to ensure
// bastion service account access to the bucket containing Tinyproxy RPM.
// EOD
// }​​​​​​​​
// variable "software_bucket" {​​​​​​​​
//  type = string
//  default = ""
//  description = <<EOD
// An optional GCS bucket name to which the bastion service account will be granted
// read-only access. Default is empty string.
// See `install_tinyproxy_url`.
// EOD
// }​​​​​​​​
// variable "bigip_image" {​​​​​​​​
//  type = string
//  #default = "projects/f5-7626-networks-public/global/images/f5-bigip-15-1-0-4-0-0-6-payg-good-25mbps-200618231522"
//  default = "projects/f5-7626-networks-public/global/images/f5-bigip-15-1-2-1-0-0-10-payg-good-25mbps-210115160742"
//  description = <<EOD
// The BIG-IP image to use for instances. Default is a good 25mbps PAYG image.
// EOD
// }​​​​​​​​
// variable "secrets_k8s_ns" {​​​​​​​​
//  type = string
//  default = "external-secrets"
//  description = <<EOD
// The namespace to use for Kubernetes External Secrets; default value is
// 'external-secrets'. Needed to associate the (to-be-created) kubernetes service
// account with a Workload Identity.
// EOD
// }​​​​​​​​
// variable "secrets_k8s_sa" {​​​​​​​​
//  type = string
//  default = "secrets-sa"
//  description = <<EOD
// The name to use for Kubernetes External Secrets service account; default value
// is 'secrets-sa'. Needed to associate the (to-be-created) kubernetes service
// account with a Workload Identity.
// EOD
// }​​​​​​​​
// variable "bigip_health_check_port" {​​​​​​​​
//  type = number
//  default = 26000
//  description = <<EOD
// The TCP port to use for GCP health checks on BIG-IP; default is 26000. An HTTP
// service will be started on this port.
// EOD
// }​​​​​​​​
// variable "bigip_cis_partition" {​​​​​​​​
//  type = string
//  default = "cis"
//  description = <<EOD
// The BIG-IP partition that will be used for CIS management; default is 'cis'.
// EOD
// }​​​​​​​​
// variable "tls_certs" {​​​​​​​​
//  type = object({​​​​​​​​
//  hello-world = object({​​​​​​​​
//  sni = string
//  key = string
//  certificate = string
//  }​​​​​​​​)
//  microservices-demo = object({​​​​​​​​
//  sni = string
//  key = string
//  certificate = string
//  }​​​​​​​​)
//  }​​​​​​​​)
//  description = <<EOD
// A required map of TLS certificate and key pairs to assign to Ingress LBs, and
// SNI details. Default is empty. Each entry will be embedded in Secret Manager
// using `prefix` and key.
// E.g.
// tls_certs = {​​​​​​​​
//  hello-world = {​​​​​​​​
//  sni = "hello.example.com"
//  key = "...Private RSA key..."
//  certificate = "...Public certificate chain..."
//  }​​​​​​​​
//  microservices-demo = {​​​​​​​​
//  sni = "store.example.com"
//  key = "...Private RSA key..."
//  certificate = "...Public certificate chain..."
//  }​​​​​​​​
// }​​​​​​​​
// which will create Secret Manager values with keys "prefix-hello-world-tls" and
// "prefix-microservices-demo-tls", each containing the fields "sni", "key",
// and "certificate", where "prefix-" is the value of `prefix` variable.
// EOD
// }​​​​​​​​
