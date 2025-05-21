# variable "db_username" {
#   type = string
#   sensitive = true
#   description = "Username for the database"
#   default = "admin"
# }
# variable "db_password" {
#   type = string
#   sensitive = true
#   description = "Password for the database"
#   default = "awsrds123"
# }

variable "rds" {
  type = string
  description = "prefix name to distinguish of the RDS instance env"
  default = "stageawsrds"  # does not accept '-' hyphen
 }

# variable "instance_class" {
#   type = string
#   description = "Instance class for the RDS instance"
#   default = "db.t3.micro"
# }
