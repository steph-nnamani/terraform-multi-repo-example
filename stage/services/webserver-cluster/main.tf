provider "aws" {
  region  = "us-east-1"  
  # profile = "terraform" # We are now using OIDC provider in GitHub Action

  # Tags to apply to all AWS resources by default
  default_tags {
    tags = {
      Owner     = "team-dev"
      ManagedBy = "Terraform"
    }
  }
}

module "webserver_cluster" {
  #source = "C:/Users/xtrah/terraform-up-and-running-by-Yev-Brikman/chpt5-loops-conditionals-deployment/modules/services/webserver-cluster"
  source = "github.com/steph-nnamani/modules//services/webserver-cluster?ref=v4.0.1" 
  # source = "git::ssh://git@github.com/steph-nnamani/modules.git//services/webserver-cluster?ref=v3.1.1"   # Confirm the version
  ami         = "ami-0866a3c8686eaeeba"
  server_text = "Happy Mothers' Sunday!!!"

  cluster_name            = "webservers-prod"
  db_remote_state_bucket  = "zoe-terraform-running-state"
  db_remote_state_key     = "prod/data-stores/mysql/terraform.tfstate"
  server_port             = 8085
  instance_type           = "t2.micro"
  instance_type_alternate = "t2.medium"
  min_size                = 5
  max_size                = 10
  enable_autoscaling      = true

  custom_tags = {
    Owner     = "team-dev"
    ManagedBy = "terraform"
  }
}

