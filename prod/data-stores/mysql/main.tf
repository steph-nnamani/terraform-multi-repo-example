provider "aws" {
    region = "us-east-1"
    alias = "primary"
}

provider "aws" {
    region = "us-east-2"
    alias = "replica"
}

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
    source = "github.com/steph-nnamani/modules//data-stores/mysql?ref=v1.1.1-data-stores" 
    # AWS Provider Configuration for this module
    providers = {
        aws = aws.primary
    }
    #identifier_prefix = "${var.rds}-instance"
    db_name = "${var.rds}_database"
    db_username = local.db_creds.username 
    db_password = local.db_creds.password

    # Must be enabled to support replication
    backup_retention_period = 1
}

module "mysql_replica" {
    source = "github.com/steph-nnamani/modules//data-stores/mysql?ref=v1.1.1-data-stores" 
    # AWS Provider Configuration for this module
    providers = {
        aws = aws.replica
    }

    # Make this a replica of the primary
    replicate_source_db = module.mysql_primary.arn
}

