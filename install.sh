#!/usr/bin/env bash

set -euo pipefail

echo "🔍 Localizando o caminho do fish shell..."
FISH_PATH=$(which fish)

if [ ! -x "$FISH_PATH" ]; then
  echo "❌ Erro: fish shell não encontrado ou não executável em: $FISH_PATH"
  exit 1
fi

echo "✅ Fish encontrado em: $FISH_PATH"

# Adiciona fish em /etc/shells se necessário
if ! grep -Fxq "$FISH_PATH" /etc/shells; then
  echo "📝 Adicionando $FISH_PATH ao /etc/shells (requer sudo)"
  echo "$FISH_PATH" | sudo tee -a /etc/shells > /dev/null
fi

# Troca o shell padrão
echo "🔧 Alterando shell padrão para: $FISH_PATH"
chsh -s "$FISH_PATH"

# Instala Fisher e bobthefish
echo "🐟 Instalando Fisher e bobthefish..."

$FISH_PATH -c '
  if not functions -q fisher
    echo "→ Instalando Fisher..."
    curl -sL https://git.io/fisher | source
    fisher install jorgebucaran/fisher
  end

  if not functions -q bobthefish
    echo "🎨 Instalando tema bobthefish..."
    fisher install oh-my-fish/theme-bobthefish
  end
'

echo "🔤 Instalando FiraCode Nerd Font via pacote oficial..."

FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

TMP_ZIP="/tmp/FiraCode.zip"
FIRACODE_ZIP_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraCode.zip"

echo "⬇️  Baixando FiraCode Nerd Font..."
curl -fLo "$TMP_ZIP" "$FIRACODE_ZIP_URL"

echo "📦 Extraindo para: $FONT_DIR"
unzip -o "$TMP_ZIP" -d "$FONT_DIR"
rm "$TMP_ZIP"

echo "🔄 Atualizando cache de fontes..."
fc-cache -fv "$FONT_DIR"

echo "✅ FiraCode Nerd Font instalada com sucesso!"
