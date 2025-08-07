terraform {
  required_version = "~> 1.10.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.81"

    }
    helm = {
      source  = "hashicorp/helm"
      version = "~>2.16"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>2.35"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}


provider "kubernetes" {
  host                   = data.aws_eks_cluster.demo.endpoint
  token                  = data.aws_eks_cluster_auth.demo.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.demo.certificate_authority[0].data)
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"  # Make sure this points to your current kubeconfig
  }
}