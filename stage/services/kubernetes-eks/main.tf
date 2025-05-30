terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  # profile = "terraform" # Authenticates with OIDC
}

# We need to authenticate to the EKS cluster, but only after it has been created. We accomplish this by using the
# aws_eks_cluster_auth data source and having it depend on an output of the eks-cluster module.

provider "kubernetes" {
  host = module.eks_cluster.cluster_endpoint
  cluster_ca_certificate = base64decode(
    module.eks_cluster.cluster_certificate_authority[0].data
  )
  token = data.aws_eks_cluster_auth.cluster.token
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks_cluster.cluster_name
}

# Create an EKS cluster

module "eks_cluster" {
  # source = "C:/Users/xtrah/terraform-up-and-running-by-Yev-Brikman/chpt4-reusable-infra-with-terraform-modules/module-example/modules/services/eks-cluster"
  source = "github.com/steph-nnamani/modules//services/eks-cluster?ref=v1.2.1-eks-cluster"
  name = var.cluster_name

  min_size     = 1
  max_size     = 2
  desired_size = 1

  # Due to the way EKS works with ENIs, t3.small is the smallest
  # instance type that can be used for worker nodes. If you try
  # something smaller like t2.micro, which only has 4 ENIs,
  # they'll all be used up by system services (e.g., kube-proxy)
  # and you won't be able to deploy your own Pods.
  instance_types = ["t3.small"]
  # Override the Kubernetes version to use a supported version
  kubernetes_version = "1.28"  # Use a currently supported version
}

# Deploy a simple web app into the EKS cluster

module "simple_webapp" {
  # source = "C:/Users/xtrah/terraform-up-and-running-by-Yev-Brikman/chpt4-reusable-infra-with-terraform-modules/module-example/modules/services/K8s-app"
  source = "github.com/steph-nnamani/modules//services/K8s-app?ref=v1.0.1-K8s-app"
  name = var.app_name

  image          = "training/webapp"
  replicas       = 2
  container_port = 5000

  environment_variables = {
    PROVIDER = "Terraform"
  }

  # Only deploy the app after the cluster has been deployed
  depends_on = [module.eks_cluster]
}