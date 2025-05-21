
output "asg_name" {
  value = module.webserver_cluster.asg_name
}

output "alb_dns_name" {
  value       = module.webserver_cluster.alb_dns_name
  description = "The domain name of the load balancer"
}

 