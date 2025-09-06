#!/usr/bin/env bash

# Helper script for local development of the Nix project
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR"

cd "$PROJECT_ROOT"

usage() {
    cat << EOF
Usage: $0 <command>

Available commands:
    format      - Format Nix code with alejandra
    build       - Build the configuration
    apply       - Apply the configuration (home-manager switch)
    check       - Execute all CI checks locally
    validate    - Validate flake structure
    deadnix     - Check for dead code
    dry-run     - Test activation without applying changes

EOF
}

format() {
    echo "Formatting Nix code..."
    nix run nixpkgs#alejandra -- .
    echo "Formatting completed!"
}

check_format() {
    echo "Checking code formatting..."
    nix run nixpkgs#alejandra -- --check .
    echo "Formatting is correct!"
}

validate_flake() {
    echo "Validating flake structure..."
    nix flake check --impure
    echo "Flake structure is valid!"
}

check_deadnix() {
    echo "Checking for dead code..."
    nix run nixpkgs#deadnix -- --fail .
    echo "No dead code found!"
}

build() {
    echo "Building configuration..."
    nix build .#homeConfigurations.claudio.activationPackage --impure
    echo "Build completed successfully!"
}

dry_run() {
    echo "Testing activation (dry-run)..."
    if [ ! -d "result" ]; then
        echo "Error: 'result' directory not found. Run 'build' first."
        return 1
    fi
    result/activate --dry-run
    echo "Dry-run activation test successful!"
}

apply() {
    echo "Applying configuration..."
    nix run nixpkgs#home-manager -- switch --flake . --impure
    echo "Configuration applied successfully!"
}

check() {
    echo "Running all CI checks locally..."
    
    echo ""
    echo "=== Step 1: Checking code formatting ==="
    check_format
    
    echo ""
    echo "=== Step 2: Validating flake structure ==="
    validate_flake
    
    echo ""
    echo "=== Step 3: Checking for dead code ==="
    check_deadnix
    
    echo ""
    echo "=== Step 4: Building configuration ==="
    build
    
    echo ""
    echo "=== Step 5: Testing activation (dry-run) ==="
    dry_run
    
    echo ""
    echo "All CI checks passed successfully!"
}

if [[ $# -eq 0 ]]; then
    usage
    exit 1
fi

case "$1" in
    format)    format ;;
    build)     build ;;
    apply)     apply ;;
    check)     check ;;
    validate)  validate_flake ;;
    deadnix)   check_deadnix ;;
    dry-run)   dry_run ;;
    *)         usage; exit 1 ;;
esac
