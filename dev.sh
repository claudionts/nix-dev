#!/usr/bin/env bash

# Script helper para desenvolvimento local do projeto Nix
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$PROJECT_ROOT"

usage() {
    cat << EOF
Uso: $0 <comando>

Comandos disponíveis:
    check       - Verifica o flake e configuração
    build       - Builda a configuração
    apply       - Aplica a configuração (home-manager switch)
    format      - Formata o código Nix com alejandra
    update      - Atualiza as dependências do flake
    clean       - Limpa o cache do Nix
    test        - Executa todos os testes localmente
    ci          - Simula o ambiente de CI localmente

EOF
}

check() {
    echo "🔍 Verificando flake..."
    nix flake check --impure
    
    echo "📋 Verificando sintaxe dos arquivos .nix..."
    find . -name "*.nix" -type f -exec nix-instantiate --parse {} \; > /dev/null
    
    echo "✅ Verificação concluída com sucesso!"
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

format() {
    echo "🎨 Formatando código Nix..."
    if ! command -v alejandra &> /dev/null; then
        echo "Instalando alejandra..."
        nix profile install nixpkgs#alejandra
    fi
    alejandra .
    echo "✅ Formatação concluída!"
}

update() {
    echo "📦 Atualizando dependências do flake..."
    nix flake update
    echo "🏗️  Testando build após atualização..."
    build
    echo "✅ Atualização concluída com sucesso!"
}

clean() {
    echo "🧹 Limpando cache do Nix..."
    nix-collect-garbage -d
    echo "✅ Limpeza concluída!"
}

test() {
    echo "🧪 Executando todos os testes..."
    check
    format
    build
    echo "✅ Todos os testes passaram!"
}

ci() {
    echo "🔄 Simulando ambiente de CI..."
    echo "Verificando flake..."
    nix flake check --impure
    
    echo "Verificando formatação..."
    nix run nixpkgs#alejandra -- --check .
    
    echo "Testando build..."
    build
    
    echo "Verificando metadados do flake..."
    nix flake metadata
    nix flake show
    
    echo "✅ Simulação de CI concluída com sucesso!"
}

if [[ $# -eq 0 ]]; then
    usage
    exit 1
fi

case "$1" in
    check)   check ;;
    build)   build ;;
    apply)   apply ;;
    format)  format ;;
    update)  update ;;
    clean)   clean ;;
    test)    test ;;
    ci)      ci ;;
    *)       usage; exit 1 ;;
esac
