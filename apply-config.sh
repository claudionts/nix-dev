#!/usr/bin/env bash

# Script super simples - apenas aplica configurações do Nix
# Tudo agora é nativo do Nix!

set -euo pipefail

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Detectar sistema
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="darwin"
else
    OS="linux"
fi

log_info "=== 🚀 Aplicando configuração Nix nativa ==="
log_info "Sistema detectado: $OS"

# Verificar se estamos no diretório correto
if [[ ! -f "flake.nix" ]]; then
    log_error "flake.nix não encontrado. Execute no diretório do projeto."
    exit 1
fi

# Verificar se Nix está instalado
if ! command -v nix &> /dev/null; then
    log_error "Nix não encontrado. Instale primeiro:"
    echo "curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install"
    exit 1
fi

# Aplicar configurações (apenas Home Manager - mais simples!)
if [[ "$OS" == "darwin" ]]; then
    log_info "🏠 Aplicando Home Manager para macOS..."
    home-manager switch --flake .#claudio@darwin
else
    log_info "🏠 Aplicando Home Manager para Linux..."
    home-manager switch --flake .#claudio@linux
fi

log_success "=== ✅ Configuração aplicada! ==="
log_info ""
log_info "🎉 Configuração aplicada com sucesso!"
log_info "  ✅ Fish shell configurado"
log_info "  ✅ Fontes Nerd Font instaladas"  
log_info "  ✅ Tema bobthefish configurado"
log_info "  ✅ Todas as ferramentas instaladas"
log_info ""
log_info "💡 Comandos úteis no Fish:"
log_info "  update-system  # Atualiza configuração"
log_info "  clean-nix      # Limpa cache do Nix"
log_info ""
if [[ "$OS" == "darwin" ]]; then
    log_info "🍎 Para configurações do sistema macOS (opcional):"
    log_info "   - Descomente nix-darwin no flake.nix"
    log_info "   - Execute: darwin-rebuild switch --flake .#claudio"
fi
log_info ""
log_info "🔄 Reinicie o terminal para aplicar mudanças!"