
# Terraform Multi-Repo Example

This repository demonstrates a multi-repository approach for managing Terraform code across different environments (prod, stage) and scopes (global, services, data-stores).

## Directory Structure

├── global/
│ ├── iam/
│ └── s3/
├── prod/
│ ├── data-stores/
│ └── services/
├── stage/
│ ├── data-stores/
│ └── services/
├── README.md

## Environments

- **global/**: Common/shared resources (IAM roles, S3 buckets, etc.)
- **prod/**: Production-specific services and resources
- **stage/**: Staging/testing environment resources

## GitHub Actions

Each environment can have its own CI/CD workflow under `.github/workflows`.

## How to Apply Terraform

cd stage/services/webserver-cluster
terraform init
terraform plan
terraform apply
Replace stage with prod as needed.


## GitHub Workflows for Terraform:
We'll define two separate jobs in a single workflow file:

Apply to stage/ on push to main

Apply to prod/ only on manual trigger (workflow_dispatch) and with environment protection (approval step)

Author
GitHub: steph-nnamani

### ✅ 3. **Add, commit, and push the README file**

git add README.md
git commit -m "Updated root README.md with project structure and usage"
git push origin main
Let me know if you’d like me to generate a full README.md content tailored to your current structure and use case.

WORKFLOW
========
# Prod
git add prod/data-stores/
git commit -m "Added new folder prod/data-stores"
git push origin main

git commit -m "Added new folder prod/services"
git push origin main

# Stage
git add stage/data-stores/
git commit -m "Added new folder stage/data-stores"
git push origin main

git add stage/services/
git commit -m "Added new folder stage/services"
git push origin main

## Environments

- **global/**: Common/shared resources (IAM roles, S3 buckets, etc.)
- **prod/**: Production-specific services and resources
- **stage/**: Staging/testing environment resources

## GitHub Actions

Each environment can have its own CI/CD workflow under `.github/workflows`.

## How to Apply Terraform
cd stage/services/webserver-cluster
terraform init
terraform plan
terraform apply

# Destroy Infrastructure
.github/workflows/terraform-destroy.yml
The workflow executes as a manual workflow in GitHub Actions. Here's how it works:

Where you trigger it:

Go to your GitHub repository

Click on the "Actions" tab

In the left sidebar, you'll see "Terraform Destroy" listed under "Workflows"

Click on it, then click the "Run workflow" button

When you're prompted:

After clicking "Run workflow", a form appears with dropdown menus and input fields

You'll see all the inputs defined in the workflow:

Environment (dropdown: stage or prod)

Component (dropdown: all, webserver-cluster, or mysql)

Specific resources (text field for comma-separated resource targets)

Confirm destroy (text field where you must type "destroy")

How selections work:

Environment: Choose which environment to target (stage or prod)

Component: Select which part of the infrastructure to destroy:

all: Destroys both webserver-cluster and MySQL

webserver-cluster: Only destroys the webserver component

mysql: Only destroys the database component

Specific resources: Optionally enter specific Terraform resource addresses to target

Confirm destroy: Type "destroy" to confirm (safety mechanism)

Execution flow:

After filling out the form and clicking "Run workflow"

The workflow runs the safety-check job first

If you selected "prod", you'll need to approve the workflow in the GitHub UI

Then it destroys resources in the correct dependency order

For production environments, there's an additional approval step because the workflow uses the "production" environment which you've configured with protection rules in GitHub.

The workflow is designed to be flexible while maintaining safety guardrails to prevent accidental destruction of resources.