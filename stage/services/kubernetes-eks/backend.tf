terraform {
    backend "s3" {
        # Replace this with your bucket name!
        bucket = "zoe-terraform-running-state"
        # key    = "stage/services/webserver-cluster/terraform.tfstate"
        key    = "stage/services/kubernetes-eks/terraform.tfstate"
        region = "us-east-1"
        
        # Replace this with your DynamoDB table name!
        dynamodb_table = "zoe_terraform_running_lock"
        encrypt        = true

    }
}