#!/usr/bin/env bash
set -euo pipefail

# Garante que o script corre a partir da raiz do projeto onde está localizado
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "1/4 -> A atualizar o submódulo gemini-cli a partir do remote..."
git submodule update --init --remote --merge gemini-cli

echo "2/4 -> A instalar dependências..."
cd gemini-cli
HUSKY=0 npm ci

echo "3/4 -> A compilar o projeto..."
HUSKY=0 npm run build

echo "4/4 -> A empacotar pacotes .tgz para o Docker..."
rm -f packages/core/dist/*.tgz packages/cli/dist/*.tgz
npm pack -w packages/core --pack-destination packages/core/dist/
npm pack -w packages/cli --pack-destination packages/cli/dist/

cd "$SCRIPT_DIR"
echo "Concluído! Os pacotes estão prontos para o Docker Compose."
