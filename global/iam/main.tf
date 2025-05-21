provider "aws" {
  region  = "us-east-1"
  profile = "terraform"
}


# resource "aws_iam_user" "example" {
#     name = "Daniel"
# }

# resource "aws_iam_user" "example" {
#     count = length(var.user_names)
#     name = var.user_names[count.index]
# }

# Best practice
resource "aws_iam_user" "example" {
    for_each = toset(var.user_names)
    name = each.value
}

output "all_users" {
    value = aws_iam_user.example
}

output "all_arns" {
    value = values(aws_iam_user.example)[*].arn
}

output "some_arns" {
    value = [
    values(aws_iam_user.example)[0].arn,
    values(aws_iam_user.example)[1].arn
    ]
}

output "single_arn" {
    value = values(aws_iam_user.example)[1].arn # Index 1
}

