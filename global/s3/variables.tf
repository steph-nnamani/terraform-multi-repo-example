variable "aws_s3_bucket" {
  type = object({
    bucket = string
    tags   = map(string)
  })
}
variable "aws_dynamodb_table" {
  type = object({
    name = string
    tags = map(string)
  })
}
