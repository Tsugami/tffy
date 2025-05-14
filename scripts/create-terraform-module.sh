


RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' 


error() {
    echo -e "${RED}[ERRO]${NC} $1"
    exit 1
}


success() {
    echo -e "${GREEN}[SUCESSO]${NC} $1"
}


info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}


warning() {
    echo -e "${YELLOW}[AVISO]${NC} $1"
}


if [ $
    error "Uso: $0 <nome-do-modulo> [descrição-do-módulo]"
fi

MODULE_NAME=$1
MODULE_DESCRIPTION=${2:-"Módulo Terraform para $MODULE_NAME"}
MODULE_DIR="00-modules/$MODULE_NAME"


if [ ! -d "00-modules" ]; then
    info "Criando diretório 00-modules..."
    mkdir -p 00-modules
fi


if [ -d "$MODULE_DIR" ]; then
    error "O módulo '$MODULE_NAME' já existe em $MODULE_DIR"
fi


info "Criando diretório do módulo: $MODULE_DIR"
mkdir -p "$MODULE_DIR"


info "Criando arquivos básicos do módulo..."


cat > "$MODULE_DIR/versions.tf" << EOF



terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


EOF


cat > "$MODULE_DIR/variables.tf" << EOF



variable "project_name" {
  type        = string
  description = "Nome do projeto, usado para nomear recursos e tags. Deve ser único dentro da conta AWS."
}

variable "environment" {
  type        = string
  description = "Ambiente (dev, staging, prod, etc)."
  default     = "dev"
}

variable "region" {
  type        = string
  description = "Região AWS onde os recursos serão criados (ex: us-east-1, eu-west-1). Deve ser uma região AWS válida."
}

variable "tags" {
  type        = map(string)
  description = "Tags adicionais para aplicar aos recursos."
  default     = {}
}
EOF


cat > "$MODULE_DIR/outputs.tf" << EOF




EOF


chmod +x "$0"


if ! command -v terraform-docs &> /dev/null; then
    warning "terraform-docs não está instalado. Instalando..."
    if command -v brew &> /dev/null; then
        brew install terraform-docs
    elif command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y terraform-docs
    else
        warning "Não foi possível instalar terraform-docs automaticamente. Por favor, instale manualmente."
    fi
fi


if [ ! -d "$MODULE_DIR" ]; then
    error "O diretório do módulo '$MODULE_DIR' não foi criado corretamente."
fi


info "Formatando arquivos Terraform..."
cd "$MODULE_DIR" && terraform fmt


info "Gerando documentação com terraform-docs..."
cd "$MODULE_DIR" && terraform-docs --output-file README.md .

success "Módulo '$MODULE_NAME' criado com sucesso em $MODULE_DIR"
info "Estrutura criada:"
echo -e "${BLUE}$MODULE_DIR/${NC}"
echo -e "  ${BLUE}versions.tf${NC} - Arquivo principal do módulo"
echo -e "  ${BLUE}variables.tf${NC} - Definições de variáveis"
echo -e "  ${BLUE}outputs.tf${NC} - Definições de outputs"
echo -e "  ${BLUE}README.md${NC} - Documentação gerada automaticamente"

info "Para começar a desenvolver seu módulo, edite os arquivos em $MODULE_DIR" 