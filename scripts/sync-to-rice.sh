#!/usr/bin/env bash
# ==============================================================================
# Ricezisto - Sync Repository to Sandbox User
# ==============================================================================
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
    echo "Erro: Execute este script com sudo para atualizar a home do usuário 'rice':" >&2
    echo "  sudo $0" >&2
    exit 1
fi

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RICE_REPO="/home/rice/ricezisto"

echo "==> Sincronizando repositório ricezisto para ${RICE_REPO}..."
rm -rf "${RICE_REPO}"
cp -a "${REPO_DIR}" "${RICE_REPO}"
chown -R rice:rice /home/rice/ricezisto

echo "==> Sincronização concluída com sucesso!"
