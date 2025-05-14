


if [ -z "$1" ]; then
    echo "Usage: $0 <project-name>"
    echo "Example: $0 01-vpc"
    exit 1
fi

PROJECT_NAME=$1


mkdir -p "${PROJECT_NAME}/environment/dev"
mkdir -p "${PROJECT_NAME}/environment/prod"
mkdir -p "${PROJECT_NAME}/environment/staging"
mkdir -p "${PROJECT_NAME}/.terraform"
mkdir -p "${PROJECT_NAME}/notes"


cat > "${PROJECT_NAME}/main.tf" << 'EOF'

EOF

cat > "${PROJECT_NAME}/variables.tf" << 'EOF'
variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}


EOF

cat > "${PROJECT_NAME}/outputs.tf" << 'EOF'






EOF

cat > "${PROJECT_NAME}/versions.tf" << 'EOF'
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = var.region
}
EOF


for env in dev prod staging; do
    cat > "${PROJECT_NAME}/environment/${env}/backend.tfvars" << EOF
bucket  = "tfstate-studies"
key     = "${PROJECT_NAME}/${env}"
region  = "us-east-1"
profile = "eks-containers"
EOF
done


cat > "${PROJECT_NAME}/Makefile" << 'EOF'
.PHONY: init plan apply destroy

ENV ?= dev
AWS_PROFILE=eks-containers

init:
	AWS_PROFILE=$(AWS_PROFILE) terraform init -backend-config=environment/$(ENV)/backend.tfvars

plan:
	AWS_PROFILE=$(AWS_PROFILE) terraform plan -var-file=environment/$(ENV)/terraform.tfvars

apply:
	AWS_PROFILE=$(AWS_PROFILE) terraform apply -var-file=environment/$(ENV)/terraform.tfvars

destroy:
	AWS_PROFILE=$(AWS_PROFILE) terraform destroy -var-file=environment/$(ENV)/terraform.tfvars

fmt:
	AWS_PROFILE=$(AWS_PROFILE) terraform fmt -recursive

validate:
	AWS_PROFILE=$(AWS_PROFILE) terraform validate
EOF


for env in dev prod staging; do
    cat > "${PROJECT_NAME}/environment/${env}/terraform.tfvars" << EOF
environment  = "${env}"
project_name = "${PROJECT_NAME}"
region       = "us-east-1"
profile      = "eks-containers"
EOF
done


cat > "${PROJECT_NAME}/notes/README.md" << EOF

EOF

echo "Project structure ${PROJECT_NAME} created successfully!"
echo "To get started:"
echo "1. cd ${PROJECT_NAME}"
echo "2. make init ENV=dev"
echo "3. make plan ENV=dev"
echo "4. make apply ENV=dev" 