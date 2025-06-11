


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


if [ $# -lt 1 ]; then
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
EOF


cat > "$MODULE_DIR/outputs.tf" << EOF




EOF

if [ ! -d "$MODULE_DIR" ]; then
    error "O diretório do módulo '$MODULE_DIR' não foi criado corretamente."
fi


info "Formatando arquivos Terraform..."
cd "$MODULE_DIR" && terraform fmt


if command -v terraform-docs &> /dev/null; then
  info "Gerando documentação com terraform-docs..."
  cd "$MODULE_DIR" && terraform-docs --output-file README.md .
fi

success "Módulo '$MODULE_NAME' criado com sucesso em $MODULE_DIR"
info "Estrutura criada:"
echo -e "${BLUE}$MODULE_DIR/${NC}"
echo -e "  ${BLUE}versions.tf${NC} - Arquivo principal do módulo"
echo -e "  ${BLUE}variables.tf${NC} - Definições de variáveis"
echo -e "  ${BLUE}outputs.tf${NC} - Definições de outputs"
echo -e "  ${BLUE}README.md${NC} - Documentação gerada automaticamente"

info "Para começar a desenvolver seu módulo, edite os arquivos em $MODULE_DIR" 