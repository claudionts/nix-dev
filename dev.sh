#!/usr/bin/env bash

# Script helper para desenvolvimento local do projeto Nix
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR"

cd "$PROJECT_ROOT"

usage() {
    cat << EOF
Uso: $0 <comando>

Comandos disponíveis:
    format      - Formata o código Nix com alejandra
    build       - Builda a configuração
    apply       - Aplica a configuração (home-manager switch)
    check       - Executa formatação + build (como o CI)

EOF
}

format() {
    echo "🎨 Formatando código Nix..."
    nix run nixpkgs#alejandra -- .
    echo "✅ Formatação concluída!"
}

build() {
    echo "🏗️  Buildando configuração..."
    nix build .#homeConfigurations.claudio.activationPackage --impure
    echo "✅ Build concluído com sucesso!"
}

apply() {
    echo "🚀 Aplicando configuração..."
    nix run nixpkgs#home-manager -- switch --flake . --impure
    echo "✅ Configuração aplicada com sucesso!"
}

check() {
    echo " Executando verificações (como CI)..."
    
    echo "🎨 Verificando formatação..."
    nix run nixpkgs#alejandra -- --check .
    
    echo "🏗️  Testando build..."
    build
    
    echo "✅ Todas as verificações passaram!"
}

if [[ $# -eq 0 ]]; then
    usage
    exit 1
fi

case "$1" in
    format)  format ;;
    build)   build ;;
    apply)   apply ;;
    check)   check ;;
    *)       usage; exit 1 ;;
esac
