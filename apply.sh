#!/usr/bin/env bash
# Alias do script principal (evita confusão com apply-config.sh)
set -euo pipefail
exec "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/apply-config.sh" "$@"
