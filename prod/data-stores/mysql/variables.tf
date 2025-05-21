variable "rds" {
  type = string
  description = "prefix name to distinguish of the RDS instance env"
  default = "prodawsrds"  # does not accept '-' hyphen
 }

