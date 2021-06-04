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

variable "podCidr" {
  description = "k8s pod cidr"
  default     = "10.56.0.0/14"
}
# nginx
variable "nginxKey" {
  description = "key for nginxplus"
}
variable "nginxCert" {
  description = "cert for nginxplus"
}
