aws_s3_bucket = {
  bucket = "zoe-terraform-running-state"
  tags = {
    Name = "TerraformStateBucket"
    Env  = "Dev"
  }
}
aws_dynamodb_table = {
  name = "zoe_terraform_running_lock"
  tags = {
    Name = "TerraformStateLock"
    Env  = "Dev"
  }
}  