provider "aws" {
  region = var.awsRegion
}

// Network
module "aws_network" {
  source                  = "git::https://github.com/f5devcentral/f5-digital-customer-engagement-center//modules/aws/terraform/network/min"
  projectPrefix           = var.projectPrefix
  awsRegion               = var.awsRegion
  map_public_ip_on_launch = true
}
// ECR
resource "aws_ecr_repository" "ecr" {
  name                 = "${var.clusterName}-ecr-${random_id.randomString.dec}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
resource "aws_ecr_repository_policy" "ecr-policy" {
  depends_on = [
    aws_ecr_repository.ecr,
  ]
  repository = "${var.clusterName}-ecr-${random_id.randomString.dec}"
  policy     = <<EOF
  {
    "Version": "2008-10-17",
    "Statement": [
      {
        "Sid": "adds full ecr access to the demo repository",
        "Effect": "Allow",
        "Principal": "*",
        "Action": [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetLifecyclePolicy",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]
      }
    ]
  }
  EOF
}


// EKS
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}
data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  #load_config_file       = false
}
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "${var.clusterName}-${random_id.randomString.dec}"
  cluster_version = "1.18"
  subnets         = [module.aws_network.subnetsAz2["public"], module.aws_network.subnetsAz1["public"]]
  vpc_id          = module.aws_network.vpcs["main"]
  worker_groups = [
    {
      instance_type    = "t3.xlarge"
      asg_max_size     = 4
      root_volume_type = "standard"
    }
  ]
  create_eks                           = true
  manage_aws_auth                      = true
  write_kubeconfig                     = true
  cluster_endpoint_private_access      = false
  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = [var.adminSourceCidr]
  config_output_path                   = "${path.module}/cluster-config"
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
