# permissions:
#   id-token: write
#   contents: read 
# name: kubernetes EKS workflow
# on:
#   push:
#     branches:
#       - main  # release

# jobs:
#   terraform-apply:
#     runs-on: ubuntu-latest

#     steps:
#       - name: Checkout code
#         uses: actions/checkout@v2

#       - name: Authenticate to AWS using OIDC
#         uses: aws-actions/configure-aws-credentials@v1
#         with:
#           # specify the IAM role to assume here
#           role-to-assume: "arn:aws:iam::418272752575:role/github-actions-oidc-example20250511055154010500000001"
#           aws-region: us-east-1

#       - name: Setup Terraform
#         uses: hashicorp/setup-terraform@v1
#         with:
#           terraform_version: 1.1.0  
#           terraform_wrapper: false

#       - name: Terraform init and apply kubernetes-eks
#         working-directory: ./stage/services/kubernetes-eks
#         run: |
#           terraform init
#           terraform apply -auto-approve
#         # This ensures the step is marked as failed if any command fails
#         shell: bash {0}

      
permissions:
  id-token: write
  contents: read 

name: Kubernetes EKS Workflow

on:
  workflow_dispatch:  # Add manual trigger option
  push:
    branches:
      - releases
    paths:
      - 'stage/services/kubernetes-eks/**'  # Only trigger on EKS changes

jobs:
  terraform-apply:
    runs-on: ubuntu-latest
    timeout-minutes: 60  # Increase timeout for EKS creation

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Authenticate to AWS using OIDC
        uses: aws-actions/configure-aws-credentials@v1
        with:
          role-to-assume: "arn:aws:iam::418272752575:role/github-actions-oidc-example20250511055154010500000001"
          aws-region: us-east-1

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v3
        with:
          terraform_version: 1.7.5
          terraform_wrapper: false

      - name: Terraform init and apply kubernetes-eks
        working-directory: ./stage/services/kubernetes-eks
        run: |
          terraform init
          terraform apply -auto-approve
        shell: bash
