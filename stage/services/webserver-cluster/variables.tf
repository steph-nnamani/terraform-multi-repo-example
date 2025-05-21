variable "user_names" {
    description = "Create IAM users with these names"
    type = list(string)
}

variable "give_neo_cloudwatch_full_access" {
    description = "If set to true, gives neo cloudwatch full access"
    type = bool
    default = false
}
