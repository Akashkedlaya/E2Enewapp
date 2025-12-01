module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "4.0.2"

  name = "${var.cluster_name}-vpc"
  cidr = "10.0.0.0/16"

  azs             = slice(data.aws_availability_zones.available.names, 0, 2)
  private_subnets = ["10.0.1.0/24","10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24","10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
}

data "aws_availability_zones" "available" {}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.0.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.27"
  subnets         = module.vpc.private_subnets #what is wrong here? 
  vpc_id          = module.vpc.vpc_id

  node_groups = {
    ${var.node_group_name} = { #how to fix this error
      desired_capacity = var.node_desired_capacity
      max_capacity     = 3
      min_capacity     = 1
      instance_types   = [var.node_instance_type]
    }
  }
}

resource "aws_ecr_repository" "backend" {
  name = "calculator-backend"
}

resource "aws_ecr_repository" "frontend" {
  name = "calculator-frontend"
}

output "cluster_name" {
  value = module.eks.cluster_id
}
output "kubeconfig" {
  value = module.eks.kubeconfig
  sensitive = true
}
output "frontend_ecr" { value = aws_ecr_repository.frontend.repository_url }
output "backend_ecr"  { value = aws_ecr_repository.backend.repository_url }
