# azure

## login


## setup


## deploy k8s


## deploy nsm


## deploy kic

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
| azuread | n/a |
| azurerm | n/a |
| local | n/a |
| random | n/a |
| tls | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| azureLocation | location where Azure resources are deployed (abbreviated Azure Region name) | `string` | n/a | yes |
| projectPrefix | prefix for resources | `string` | n/a | yes |
| resourceOwner | name of the person or customer running the solution | `any` | n/a | yes |
| sshPublicKey | contents of admin ssh public key | `any` | n/a | yes |
| adminAccountName | admin account | `string` | `"zadmin"` | no |
| adminSourceAddress | admin source addresses | `list` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| location | n/a | `string` | `"eastus2"` | no |
| nginxCert | cert for nginxplus | `string` | `""` | no |
| nginxKey | key for nginxplus | `string` | `""` | no |
| region | (optional) describe your variable | `string` | `"East US 2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| acr\_login\_url | n/a |
| acr\_name | n/a |
| aks\_name | n/a |
| resource\_group\_name | outputs |
| secret\_id | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- markdownlint-enable no-inline-html -->
