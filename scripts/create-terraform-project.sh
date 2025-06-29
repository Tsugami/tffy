


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
variable "region" {
  type        = string
}

variable "profile" {
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

  backend "s3" {}
}

provider "aws" {
  region  = var.region
  profile = var.profile
}
EOF


for env in prod; do
    cat > "${PROJECT_NAME}/environment/${env}/backend.tfvars" << EOF
bucket  = "${PROJECT_NAME}-bucket"
key     = "${PROJECT_NAME}/${env}"
region  = "us-east-1"
profile = ${PROJECT_NAME}"
EOF
done


cat > "${PROJECT_NAME}/Makefile" << 'EOF'
.PHONY: init plan apply destroy

init:
	terraform init -backend-config=environment/$(ENV)/backend.tfvars

plan:
	terraform plan -var-file=environment/$(ENV)/terraform.tfvars

apply:
	terraform apply -var-file=environment/$(ENV)/terraform.tfvars

destroy:
	terraform destroy -var-file=environment/$(ENV)/terraform.tfvars

fmt:
	terraform fmt -recursive

validate:
	terraform validate
EOF


for env in dev; do
    cat > "${PROJECT_NAME}/environment/${env}/terraform.tfvars" << EOF
environment  = "${env}"
project_name = "${PROJECT_NAME}"
region       = "us-east-1"
profile      = "${PROJECT_NAME}"
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