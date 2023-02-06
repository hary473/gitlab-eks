provider "aws" {
  region = "us-west-2"
}

module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name = "gitlab-eks"

  vpc_id = "vpc-0123456789abcdef0"

  subnets = [
    "subnet-0123456789abcdef1",
    "subnet-0123456789abcdef2",
    "subnet-0123456789abcdef3",
  ]

  tags = {
    Terraform   = "true"
    Environment = "development"
  }
}

module "gitlab" {
  source = "gitlab/gitlab-omnibus/aws"

  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_cert_arn  = module.eks.cluster_cert_arn

  gitlab_instance_type = "t3.medium"

  # Add additional GitLab configuration options here
}

module "gitlab-runner" {
  source = "gitlab/gitlab-runner/kubernetes"

  gitlab_url = module.gitlab.gitlab_url

  # Add additional GitLab Runner configuration options here
}

module "grafana" {
  source = "grafana/grafana/kubernetes"

  # Add additional Grafana configuration options here
}    
