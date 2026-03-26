#!/usr/bin/env bash

# Script completo para instalação e configuração do ambiente Nix
# Instala automaticamente Nix, Home Manager e configura flakes

set -euo pipefail

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

# Detectar sistema
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="darwin"
else
    OS="linux"
fi

log_info "=== 🚀 Configurador automático do ambiente Nix ==="
log_info "Sistema detectado: $OS"

# Verificar se estamos no diretório correto
if [[ ! -f "flake.nix" ]]; then
    log_error "flake.nix não encontrado. Execute no diretório do projeto."
    exit 1
fi

# Função para instalar Nix
install_nix() {
    log_info "🔧 Instalando Nix..."
    
    # Usar o instalador Determinate Systems (mais confiável)
    if curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install; then
        log_success "Nix instalado com sucesso!"
        
        # Recarregar o shell para que o Nix fique disponível
        if [[ "$OS" == "darwin" ]]; then
            source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        else
            source ~/.nix-profile/etc/profile.d/nix.sh
        fi
    else
        log_error "Falha ao instalar o Nix"
        exit 1
    fi
}

# Função para configurar flakes
enable_flakes() {
    local nix_conf_dir="$HOME/.config/nix"
    local nix_conf_file="$nix_conf_dir/nix.conf"
    
    # Criar diretório se não existir
    mkdir -p "$nix_conf_dir"
    
    # Verificar se flakes já estão habilitados
    if [[ -f "$nix_conf_file" ]] && grep -q "experimental-features.*flakes" "$nix_conf_file"; then
        log_info "✅ Flakes já estão habilitados"
        return 0
    fi
    
    log_info "🔧 Habilitando flakes e otimizações..."
    
    # Configuração completa para acelerar builds
    cat >> "$nix_conf_file" << EOF
experimental-features = nix-command flakes
substituters = https://cache.nixos.org https://nix-community.cachix.org
trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=
builders-use-substitutes = true
max-jobs = auto
EOF
    
    log_success "Flakes e otimizações habilitados!"
}

# Função para instalar Home Manager
install_home_manager() {
    log_info "🏠 Configurando Home Manager..."
    
    # Tentar usar Home Manager via flake primeiro (método moderno)
    if nix run home-manager/master -- --version &> /dev/null; then
        log_info "✅ Home Manager disponível via flake"
        return 0
    fi
    
    # Se não funcionar, instalar via nix-env
    log_info "📦 Instalando Home Manager via nix-env..."
    
    # Adicionar canal do Home Manager
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --update
    
    # Instalar Home Manager
    nix-shell '<home-manager>' -A install
    
    log_success "Home Manager instalado!"
}

# Verificar se Nix está instalado
if ! command -v nix &> /dev/null; then
    log_warn "Nix não encontrado. Instalando automaticamente..."
    install_nix
else
    log_info "✅ Nix já está instalado"
fi

# Habilitar flakes se necessário
enable_flakes

# Verificar/instalar Home Manager
if ! command -v home-manager &> /dev/null; then
    log_warn "Home Manager não encontrado. Instalando..."
    install_home_manager
else
    log_info "✅ Home Manager já está disponível"
fi

# Função para configurar asdf (binário vem do Nix via Home Manager; dados em ~/.asdf)
setup_asdf() {
    log_info "🐟 Configurando plugins Elixir/Erlang no asdf..."

    export PATH="$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH"
    export ASDF_DATA_DIR="${ASDF_DATA_DIR:-$HOME/.asdf}"
    mkdir -p "$ASDF_DATA_DIR"

    if ! command -v asdf &> /dev/null; then
        log_error "Comando asdf não encontrado após home-manager switch."
        log_warn "Confirme que o flake inclui asdf-vm em home.packages, rode de novo e abra um novo terminal."
        return 1
    fi

    # Idempotência: já tem Elixir + Erlang nas versões desejadas
    local have_erlang=0 have_elixir=0
    if [[ "$OS" == "darwin" ]]; then
        asdf list erlang-prebuilt-macos 2>/dev/null | grep -q '27.1.2' && have_erlang=1
    else
        asdf list erlang 2>/dev/null | grep -q '27.1.2' && have_erlang=1
    fi
    asdf list elixir 2>/dev/null | grep -q '1.17.3-otp-27' && have_elixir=1
    if [[ "$have_erlang" -eq 1 && "$have_elixir" -eq 1 ]]; then
        log_info "✅ Elixir e Erlang já estão instalados via asdf"
        return 0
    fi

    log_info "📦 Instalando plugins e runtimes asdf (dados em \$ASDF_DATA_DIR)..."

    # Instalar plugins necessários
    log_info "🔌 Instalando plugins do asdf..."
    
    # Plugin do Erlang pré-compilado para macOS
    if [[ "$OS" == "darwin" ]]; then
        asdf plugin add erlang-prebuilt-macos https://github.com/michallepicki/asdf-erlang-prebuilt-macos.git 2>/dev/null || true
    else
        asdf plugin add erlang 2>/dev/null || true
    fi
    
    # Plugin do Elixir
    asdf plugin add elixir 2>/dev/null || true
    
    # Instalar versões
    log_info "📦 Instalando Erlang e Elixir..."
    
    if [[ "$OS" == "darwin" ]]; then
        # macOS: usar Erlang pré-compilado
        asdf install erlang-prebuilt-macos 27.1.2
        asdf global erlang-prebuilt-macos 27.1.2
    else
        # Linux: usar Erlang compilado
        asdf install erlang 27.1.2
        asdf global erlang 27.1.2
    fi
    
    asdf install elixir 1.17.3-otp-27
    asdf global elixir 1.17.3-otp-27
    
    log_success "✅ asdf configurado com Elixir/Erlang!"
}

# Aplicar configurações
apply_configuration() {
    local config_name
    if [[ "$OS" == "darwin" ]]; then
        # Detectar arquitetura do Mac
        local arch=$(uname -m)
        if [[ "$arch" == "arm64" ]]; then
            config_name="claudio@darwin"
            log_info "🍎 Aplicando configuração para macOS (Apple Silicon)..."
        else
            config_name="claudio@darwin-intel"  
            log_info "🍎 Aplicando configuração para macOS (Intel)..."
        fi
    else
        config_name="claudio@linux"
        log_info "🐧 Aplicando configuração para Linux..."
    fi
    
    # Tentar usar home-manager primeiro
    if command -v home-manager &> /dev/null; then
        log_info "📋 Usando comando home-manager..."
        home-manager switch --flake ".#$config_name"
    else
        # Fallback: usar nix run
        log_info "📋 Usando nix run como fallback..."
        nix run home-manager/master -- switch --flake ".#$config_name"
    fi
}

log_info "🚀 Iniciando aplicação da configuração..."
apply_configuration

# Configurar asdf após aplicar as configurações
setup_asdf

log_success "=== ✅ Ambiente Nix configurado com sucesso! ==="
log_info ""
log_success "🎉 Instalação e configuração completadas!"
log_info "  ✅ Nix instalado e configurado"
log_info "  ✅ Flakes habilitados"
log_info "  ✅ Home Manager configurado"
log_info "  ✅ Fish shell com tema bobthefish"
log_info "  ✅ Fontes Nerd Font instaladas"
log_info "  ✅ Neovim com CodeCompanion"
log_info "  ✅ asdf configurado com Elixir/Erlang"
log_info ""
log_info "💡 Comandos úteis no Fish:"
log_info "  update-system  # Atualiza configuração"
log_info "  clean-nix      # Limpa cache do Nix"
log_info ""
log_info "🧪 Comandos Elixir/Erlang:"
log_info "  elixir --version  # Verificar versão do Elixir"
log_info "  asdf list elixir  # Listar versões instaladas"
log_info "  asdf list erlang-prebuilt-macos  # (macOS) ou 'asdf list erlang' (Linux)"
log_info ""
log_info "🔧 Para reaplicar a configuração:"
log_info "  ./apply-config.sh"
log_info ""
if [[ "$OS" == "darwin" ]]; then
    log_info "🍎 Sistema macOS detectado:"
    log_info "   - Configuração aplicada"
    log_success "   - Fish será configurado automaticamente como shell padrão"
    log_info "   - Se não funcionar, execute: setup-fish-shell"
else
    log_info "🐧 Sistema Linux detectado:"
    log_info "   - Configuração aplicada para claudio@linux"
fi
log_info ""
log_warn "🔄 IMPORTANTE: Feche e abra novamente o terminal/Ghostty!"
log_info "💡 Verifique com: echo \$SHELL (deve mostrar fish)"