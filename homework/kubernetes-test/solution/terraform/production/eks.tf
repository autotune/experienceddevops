data "aws_eks_cluster" "default" {
  name = module.badams.cluster_id
}

data "aws_eks_cluster_auth" "default" {
  name = module.badams.cluster_id
}

data "aws_availability_zones" "available" {
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.6"

  name                 = "badams"
  cidr                 = "10.16.0.0/16"
  azs                  = ["us-east-1a", "us-east-1b", "us-east-1d"]
  private_subnets      = ["10.16.8.0/24", "10.16.9.0/24", "10.16.4.0/24"]
  public_subnets       = ["10.16.5.0/24", "10.16.6.0/24", "10.16.7.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/badams-prod" = "shared"
    "kubernetes.io/role/elb"            = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/badams-prod" = "shared"
    "kubernetes.io/role/internal-elb"   = "1"
  }
}

resource "aws_security_group" "badams" {
  name        = "badams-eks-prod"
  description = "badams eks security group"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "ec2_ingress_all" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  security_group_id = aws_security_group.badams.id
  cidr_blocks       = ["10.16.0.0/16"]
}

module "badams" {
  source                                             = "terraform-aws-modules/eks/aws"
  cluster_name                                       = "badams-prod"
  cluster_version                                    = "1.19"
  manage_aws_auth                                    = true
  subnets                                            = module.vpc.public_subnets
  vpc_id                                             = module.vpc.vpc_id
  worker_create_cluster_primary_security_group_rules = true

  worker_groups = [
    {
      instance_type = "t2.large"
      asg_max_size  = 3
    }
  ]

  node_groups_defaults = {
    ami_type  = "AL2_x86_64"
    disk_size = 50
  }

  node_groups = {
    Example = {
      desired_capacity = 1
      max_capacity     = 2
      min_capacity     = 1

      instance_type = "t2.large"
      k8s_labels = {
        Environment = "test"
        GithubRepo  = "terraform-aws-eks"
        GithubOrg   = "terraform-aws-modules"
      }
      additional_tags = {
        Name      = "badams"
        Env       = "Prod"
        Terraform = "True"
      }
    }
  }
  map_users = [
    {
      userarn  = "arn:aws:iam::477962946895:user/badams"
      username = "badams"
      groups   = ["system:masters"]
    }
  ]
}

data "aws_route53_zone" "selected" {
  name = "badams.ninja."
}

resource "aws_route53_record" "app" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "app"
  type    = "CNAME"
  ttl     = "300"
  records = ["a4632470b3b214cb98481e9feded82d5-455007471.us-east-1.elb.amazonaws.com"]
}

resource "aws_route53_record" "rocketchat" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "chat"
  type    = "CNAME"
  ttl     = "300"
  records = ["a420dba0371134bfc8938ef346eba567-1425925386.us-east-1.elb.amazonaws.com"]
}

resource "aws_route53_record" "gitlab" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "gitlab"
  type    = "CNAME"
  ttl     = "300"
  records = ["a92721bc538b14be08ba528ad211ca4f-1661387374.us-east-1.elb.amazonaws.com"]
}
provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

resource "tls_private_key" "platform_domain_administrator" {
  algorithm = "RSA"
}

resource "acme_registration" "platform_domain_administrator" {
  account_key_pem = tls_private_key.platform_domain_administrator.private_key_pem
  email_address   = "b+acme@contrasting.org"
}

resource "tls_private_key" "platform_domain_csr" {
  algorithm = "RSA"
}

resource "tls_cert_request" "platform_domain" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.platform_domain_csr.private_key_pem

  subject {
    common_name = "*.badams.ninja"
  }
}

resource "acme_certificate" "platform_domain" {
  account_key_pem         = acme_registration.platform_domain_administrator.account_key_pem
  certificate_request_pem = tls_cert_request.platform_domain.cert_request_pem

  dns_challenge {
    provider = "route53"
  }
}

resource "aws_acm_certificate" "cert" {
  domain_name       = "badams.ninja"
  validation_method = "DNS"

  tags = {
    Environment = "Prod"
  }
}

resource "aws_db_subnet_group" "badams" {
  name       = "main"
  subnet_ids = module.vpc.private_subnets

  tags = {
    Name = "badams-prod serverless"
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.default.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.default.token
}

resource "local_file" "kubeconfig" {
  sensitive_content = templatefile("${path.module}/kubeconfig.tpl", {
    cluster_name = module.badams.cluster_id,
    clusterca    = data.aws_eks_cluster.default.certificate_authority[0].data,
    endpoint     = data.aws_eks_cluster.default.endpoint,
  })
  filename = "./kubeconfig-${module.badams.cluster_id}"
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "kubernetes_namespace" "badams" {
  metadata {
    name = "badams"
  }
}
