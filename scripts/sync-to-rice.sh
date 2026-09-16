#!/usr/bin/env bash
# ==============================================================================
# Ricezisto - Sync Repository & Extensions to Sandbox User
# ==============================================================================
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
    echo "Erro: Execute este script com sudo para atualizar a home do usuário 'rice':" >&2
    echo "  sudo $0" >&2
    exit 1
fi

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RICE_REPO="/home/rice/ricezisto"

echo "==> [1/4] Sincronizando repositório ricezisto para ${RICE_REPO}..."
rm -rf "${RICE_REPO}"
cp -a "${REPO_DIR}" "${RICE_REPO}"

echo "==> [2/4] Disponibilizando Dash to Dock globalmente e para o usuário 'rice'..."
GUSTAVO_DOCK="/home/gustavo/.local/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com"
if [ -d "${GUSTAVO_DOCK}" ]; then
    # Sistema
    mkdir -p "/usr/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com"
    cp -ru "${GUSTAVO_DOCK}"/* "/usr/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/" 2>/dev/null || true
    chmod -R a+rX "/usr/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com" 2>/dev/null || true
    
    # Rice
    mkdir -p "/home/rice/.local/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com"
    cp -ru "${GUSTAVO_DOCK}"/* "/home/rice/.local/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/" 2>/dev/null || true
fi

echo "==> [3/4] Compilando schemas GLib para o usuário 'rice'..."
mkdir -p "/home/rice/.local/share/glib-2.0/schemas"
if [ -d "/usr/share/gnome-shell/extensions/blur-my-shell@aunetx/schemas" ]; then
    cp -ru /usr/share/gnome-shell/extensions/blur-my-shell@aunetx/schemas/*.xml "/home/rice/.local/share/glib-2.0/schemas/" 2>/dev/null || true
fi
if [ -d "${GUSTAVO_DOCK}/schemas" ]; then
    cp -ru "${GUSTAVO_DOCK}/schemas/"*.xml "/home/rice/.local/share/glib-2.0/schemas/" 2>/dev/null || true
fi
glib-compile-schemas "/home/rice/.local/share/glib-2.0/schemas/" 2>/dev/null || true

echo "==> [4/4] Ajustando permissões da pasta /home/rice..."
chown -R rice:rice "/home/rice"

echo ""
echo "=============================================================================="
echo "Sincronização concluída com sucesso! 🎉"
echo "O repositório e as extensões (Dash to Dock + Blur my Shell) estão prontos em:"
echo "  /home/rice/ricezisto"
echo "=============================================================================="
