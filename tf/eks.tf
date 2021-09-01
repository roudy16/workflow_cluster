module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "17.4.0"
  cluster_name    = local.cluster_name
  cluster_version = "1.20"
  subnets         = module.dev-vpc.private_subnets

  tags = {
    Environment   = "test"
  }

  vpc_id = module.dev-vpc.vpc_id

  workers_group_defaults = {
    root_volume_type = "gp2"
    key_name         = aws_key_pair.key.key_name
  }

  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = "t3a.medium"
      asg_desired_capacity          = 3
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
    },
    # {
    #   name                          = "worker-group-2"
    #   instance_type                 = "t3a.small"
    #   additional_userdata           = "echo foo bar"
    #   asg_desired_capacity          = 1
    #   additional_security_group_ids = [aws_security_group.worker_group_mgmt_two.id]
    # },
  ]

  worker_additional_security_group_ids = [aws_security_group.all_worker_mgmt.id]
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
