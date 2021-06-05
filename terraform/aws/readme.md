# aws


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
| aws | n/a |
| random | n/a |
| tls | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| adminAccountName | admin | `string` | `"xadmin"` | no |
| adminSourceCidr | n/a | `string` | `"0.0.0.0/0"` | no |
| awsAz1 | n/a | `any` | `null` | no |
| awsAz2 | n/a | `any` | `null` | no |
| awsRegion | n/a | `string` | `"us-east-2"` | no |
| clusterName | eks cluster name | `string` | `"my-cluster"` | no |
| kubernetes | deploy a kubernetes cluster or not | `bool` | `true` | no |
| projectPrefix | cloud | `string` | `"kic-aws"` | no |
| resourceOwner | tag used to mark instance owner | `string` | `"dcec-kic-user"` | no |
| sshPublicKey | ssh key file to create an ec2 key-pair | `string` | `"ssh-rsa AAAAB3...."` | no |

## Outputs

| Name | Description |
|------|-------------|
| coderAdminPassword | n/a |
| ecrRepositoryURL | n/a |
| jumphostPublicIp | n/a |
| kubernetesClusterName | n/a |
| publicSubnetAZ1 | n/a |
| publicSubnetAZ2 | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- markdownlint-enable no-inline-html -->
