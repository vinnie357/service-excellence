# gcp

- gke
- gcr
- waypoint

## login
```bash
# authenticate
. init.sh && gcloud_auth "myproject"
# run
setup && info

```

## deploy nsm
```bash
. init.sh && install_meshctl
. init.sh && deploy_nsm
```

## deploy kic
```bash
. init.sh && deploy_kic "1.9.0"
```

## configure waypoint

  [waypoint](../../waypoint/readme.md)

## deploy apps


## terraform variables
<!-- markdownlint-disable no-inline-html -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| google | n/a |
| tls | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| adminPassword | admin password | `any` | n/a | yes |
| gcpProjectId | gcp project id | `any` | n/a | yes |
| gcpRegion | region where gke is deployed | `any` | n/a | yes |
| gcpZone | zone where gke is deployed | `any` | n/a | yes |
| nginxCert | cert for nginxplus | `any` | n/a | yes |
| nginxKey | key for nginxplus | `any` | n/a | yes |
| projectPrefix | prefix for resources | `any` | n/a | yes |
| sshPublicKey | contents of admin ssh public key | `any` | n/a | yes |
| adminAccountName | admin account | `string` | `"zadmin"` | no |
| adminSourceAddress | admin src address in cidr | `list` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| buildSuffix | name suffix for objects | `string` | `"party-unicorns"` | no |
| gkeVersion | GKE https://cloud.google.com/kubernetes-engine/docs/release-notes-regular https://cloud.google.com/kubernetes-engine/versioning-and-upgrades gcloud container get-server-config --region us-east1 | `string` | `"1.18.18-gke.1700"` | no |
| podCidr | k8s pod cidr | `string` | `"10.56.0.0/14"` | no |

## Outputs

No output.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- markdownlint-enable no-inline-html -->
