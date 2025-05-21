provider "aws" {
    region = "us-east-1"
    profile = "terraform"

    # Tags to apply to all AWS resources by default
    default_tags {
      tags = {
      Owner = "team-dev"
      ManagedBy = "Terraform"
      }  
    }
}

# module "webserver_cluster" {
# #    source = "../../../modules/services/webserver-cluster"
#     source = "github.com/steph-nnamani/modules///services/webserver-cluster?ref=v0.0.1"   # Confirm the version

#     cluster_name = "webservers-stage"
#     db_remote_state_bucket = "zoe-terraform-running-state"
#     db_remote_state_key = "stage/data-stores/mysql/terraform.tfstate"
#     server_port = 8080
#     instance_type = "t2.micro"
#     min_size = 1
#     max_size = 3
#     enable_autoscaling = false
# }

module "policies" {
  source = "../../../../../modules/landing-zone/iam-policies"
}

module "groups" {
  source = "../../../../../modules/landing-zone/iam-groups"
  
  cloudwatch_full_access_policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
  cloudwatch_read_only_access_policy_arn   = "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
}

module "users" {
  source     = "../../../../../modules/landing-zone/iam-user"
  user_names = var.user_names
}  

# resource "aws_iam_user_group_membership" "user_cloudwatch" {
#   for_each = toset(var.user_names)
#   user     = module.users.user_names[each.value]
#   groups   = [
#     each.value == "neo" && var.give_neo_cloudwatch_full_access ? 
#       module.groups.cloudwatch_full_access_group_name : 
#       module.groups.cloudwatch_read_only_group_name
#   ]
# }

resource "aws_iam_user_group_membership" "user_cloudwatch" {
  for_each = toset(module.users.user_names)
  user     = each.value
  groups   = concat(
    [module.groups.cloudwatch_read_only_group_name],
    each.value == "neo" && var.give_neo_cloudwatch_full_access ? [module.groups.cloudwatch_full_access_group_name] : []
  )
}



#     for_each = toset(var.user_names)
#     user_names = each.value 
#     give_neo_cloudwatch_full_access = true
# }

