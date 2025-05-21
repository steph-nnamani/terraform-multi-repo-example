terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket = "zoe-terraform-running-state"
    key    = "prod/services/webserver-cluster/terraform.tfstate"
    region = "us-east-1"

    # Replace this with your DynamoDB table name!
    dynamodb_table = "zoe_terraform_running_lock"
    encrypt        = true

  }
}