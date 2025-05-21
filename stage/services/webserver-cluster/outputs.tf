# output "alb_dns_name" {
#     value = module.webserver_cluster.alb_dns_name 
# }

# output "asg_name" {
#     value = module.webserver_cluster.asg_name
# }

output "all_arns" {
    value = module.users.user_arns
    description = "The ARNs of all created IAM users"
}

output "all_users" {
    value = module.users.user_names
    description = "The names of all created IAM users"
}

output "all_groups" {
    value = module.groups.group_names
    description = "The names of all created IAM groups"
}