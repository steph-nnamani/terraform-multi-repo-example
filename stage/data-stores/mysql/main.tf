# provider "aws" {
#     region = "us-east-1"
# #    profile = "terraform"
# }

provider "aws" {
    region = "us-east-1"
    alias = "primary"
}

# provider "aws" {
#     region = "us-east-2"
#     alias = "replica"
# }

# You can use aws_secretsmanager_secret_version data source to 
# read the db-creds secret from AWS Secret Manager.

data "aws_secretsmanager_secret_version" "creds" {
    secret_id = "db-creds"
}

# Since the secrets is stored in JSON, you can use the jsondecode function 
# to parse the JSON into the local variable db_creds:
locals {
    db_creds = jsondecode(data.aws_secretsmanager_secret_version.creds.secret_string)
}

module "mysql_primary" {
    # source = "../../../../../staging/modules/data-stores/mysql"
    #source = "C:/Users/xtrah/staging/modules/data-stores/mysql"
    source = "github.com/steph-nnamani/modules//data-stores/mysql?ref=v1.1.1-data-stores" 
    # AWS Provider Configuration for this module
    providers = {
        aws = aws.primary
    }
    #identifier_prefix = "${var.rds}-instance"
    db_name = "${var.rds}_database"
    # db_name = "prod_db"
    # db_username = var.db_username
    # db_password = var.db_password
    db_username = local.db_creds.username 
    db_password = local.db_creds.password

    # Must be enabled to support replication
    backup_retention_period = 1
}

# module "mysql_replica" {
#     # source = "../../../../../staging/modules/data-stores/mysql"
#     #source = "C:/Users/xtrah/staging/modules/data-stores/mysql"
#     source = "github.com/steph-nnamani/modules//data-stores/mysql?ref=v1.1.1-data-stores" 
#     # AWS Provider Configuration for this module
#     providers = {
#         aws = aws.replica
#     }

#     # Make this a replica of the primary
#     replicate_source_db = module.mysql_primary.arn
# }


# # You can now use the local variable db_creds to access the username and passwor
# resource "aws_db_instance" "example" {
#     identifier_prefix = "${var.rds}-instance"
#     engine = "mysql"
#     engine_version = "8.0"
#     allocated_storage = 10
#     instance_class = var.instance_class
#     skip_final_snapshot = true
#     db_name = "${var.rds}_database"

#     # disable backups to create DB faster
#     backup_retention_period = 0

#     # db attribute names
#     username = local.db_creds.username 
#     password = local.db_creds.password
# }