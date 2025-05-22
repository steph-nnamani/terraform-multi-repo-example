permissions:
  id-token: write
  contents: read 

name: Terraform Destroy

on:
  workflow_dispatch:
    inputs:
      environment:
        description: 'Environment to destroy'
        required: true
        default: 'stage'
        type: choice
        options:
          - stage
          - prod
      component:
        description: 'Component to destroy'
        required: true
        default: 'all'
        type: choice
        options:
          - all
          - webserver-cluster
          - mysql
      specific_resources:
        description: 'Comma-separated list of specific resources to destroy (optional)'
        required: false
      confirm_destroy:
        description: 'Type "destroy" to confirm'
        required: true

jobs:
  safety-check:
    runs-on: ubuntu-latest
    steps:
      - name: Check confirmation
        if: github.event.inputs.confirm_destroy != 'destroy'
        run: |
          echo "Error: You must type 'destroy' to confirm destruction"
          exit 1
      
      - name: Production safety check
        if: github.event.inputs.environment == 'prod'
        run: |
          echo "⚠️ WARNING: You are about to destroy PRODUCTION resources!"
          echo "Please double-check your inputs:"
          echo "  - Environment: ${{ github.event.inputs.environment }}"
          echo "  - Component: ${{ github.event.inputs.component }}"
          echo "  - Resources: ${{ github.event.inputs.specific_resources || 'all' }}"
          
  terraform-destroy:
    needs: safety-check
    runs-on: ubuntu-latest
    environment: ${{ github.event.inputs.environment == 'prod' && 'production' || 'stage' }}
    
    steps:
      - name: Checkout Code
        uses: actions/checkout@v3
        with:
          fetch-depth: 0

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

      # Destroy webserver-cluster first (if selected)
      - name: Destroy Webserver Cluster
        id: destroy-webserver
        if: github.event.inputs.component == 'webserver-cluster' || github.event.inputs.component == 'all'
        working-directory: ${{ github.event.inputs.environment }}/services/webserver-cluster
        run: |
          echo "Destroying webserver-cluster in ${{ github.event.inputs.environment }}..."
          terraform init
          
          if [ -n "${{ github.event.inputs.specific_resources }}" ]; then
            echo "Destroying specific resources: ${{ github.event.inputs.specific_resources }}"
            IFS=',' read -ra TARGETS <<< "${{ github.event.inputs.specific_resources }}"
            for target in "${TARGETS[@]}"; do
              echo "Destroying target: $target"
              terraform destroy -target="$target" -auto-approve
            done
          else
            echo "Destroying all webserver-cluster resources..."
            # First destroy resources with dependencies
            terraform destroy -target=aws_autoscaling_group.example -auto-approve || true
            terraform destroy -target=aws_lb.example -auto-approve || true
            terraform destroy -target=aws_lb_listener.http -auto-approve || true
            # Then destroy everything else
            terraform destroy -auto-approve
          fi

      # Then destroy MySQL (if selected)
      - name: Destroy MySQL
        if: (github.event.inputs.component == 'mysql' || github.event.inputs.component == 'all') && (github.event.inputs.component != 'webserver-cluster' || steps.destroy-webserver.outcome == 'success')
        id: destroy-mysql
        working-directory: ${{ github.event.inputs.environment }}/data-stores/mysql
        run: |
          echo "Destroying MySQL in ${{ github.event.inputs.environment }}..."
          terraform init
          
          if [ -n "${{ github.event.inputs.specific_resources }}" ] && [ "${{ github.event.inputs.component }}" == "mysql" ]; then
            echo "Destroying specific resources: ${{ github.event.inputs.specific_resources }}"
            IFS=',' read -ra TARGETS <<< "${{ github.event.inputs.specific_resources }}"
            for target in "${TARGETS[@]}"; do
              echo "Destroying target: $target"
              terraform destroy -target="$target" -auto-approve
            done
          else
            echo "Destroying all MySQL resources..."
            terraform destroy -auto-approve
          fi

      - name: Destruction Summary
        run: |
          echo "✅ Destruction complete"
          echo "Environment: ${{ github.event.inputs.environment }}"
          echo "Component(s) destroyed: ${{ github.event.inputs.component }}"
          if [ -n "${{ github.event.inputs.specific_resources }}" ]; then
            echo "Specific resources: ${{ github.event.inputs.specific_resources }}"
          fi