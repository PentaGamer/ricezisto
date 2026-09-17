#!/usr/bin/env bash
# ==============================================================================
# Ricezisto - Instalador Unificado (Catppuccin Mocha Mauve para GNOME)
# Uso: ./install.sh
# ==============================================================================
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="${REPO_DIR}/scripts"

# Determinar o usuário real que está instalando (evita rodar dotfiles como root)
REAL_USER="${SUDO_USER:-${USER}}"
REAL_HOME=$(eval echo "~${REAL_USER}")

echo "=============================================================================="
echo "          RICEZISTO - INSTALAÇÃO DO AMBIENTE GNOME CATPPUCCIN                 "
echo "=============================================================================="
echo "Usuário de Destino: ${REAL_USER}"
echo "Diretório Base:     ${REAL_HOME}"
echo "Repositório:        ${REPO_DIR}"
echo "=============================================================================="

# Validação do ambiente GNOME
if [ -n "${XDG_CURRENT_DESKTOP:-}" ] && ! echo "${XDG_CURRENT_DESKTOP}" | grep -qi "GNOME"; then
    echo "⚠️  Aviso: O ambiente desktop detectado é '${XDG_CURRENT_DESKTOP}'."
    echo "   O Ricezisto foi projetado e calibrado especificamente para GNOME 45/46+ (Wayland)."
    echo ""
    read -rp "Deseja prosseguir mesmo assim? (s/N): " CONFIRM
    if [[ ! "${CONFIRM}" =~ ^[sS]$ ]]; then
        echo "Instalação cancelada pelo usuário."
        exit 0
    fi
fi

# 1. Obter elevação sudo para instalar pacotes de sistema
echo ""
echo ">> [Etapa 1/3] Provisionando dependências de sistema (sudo necessário)..."
if [ "$(id -u)" -eq 0 ]; then
    "${SCRIPTS_DIR}/install-deps.sh"
else
    sudo "${SCRIPTS_DIR}/install-deps.sh"
fi

# 2. Executar setup de dotfiles e GNOME no contexto do usuário real
echo ""
echo ">> [Etapa 2/3] Aplicando dotfiles, temas e atalhos ergonômicos no usuário '${REAL_USER}'..."
if [ "$(id -u)" -eq 0 ] && [ -n "${SUDO_USER:-}" ]; then
    sudo -u "${REAL_USER}" bash -c "cd '${REPO_DIR}' && ./setup.sh"
else
    "${REPO_DIR}/setup.sh"
fi

# 3. Executar diagnóstico de integridade
echo ""
echo ">> [Etapa 3/3] Validando instalação e integridade dos componentes..."
if [ "$(id -u)" -eq 0 ] && [ -n "${SUDO_USER:-}" ]; then
    sudo -u "${REAL_USER}" bash -c "cd '${REPO_DIR}' && ./scripts/check-status.sh"
else
    "${SCRIPTS_DIR}/check-status.sh"
fi

echo ""
echo "=============================================================================="
echo "                 RICEZISTO INSTALADO COM SUCESSO! 🎉                          "
echo "=============================================================================="
echo "👉 Dica de Inicialização:"
echo "   No ambiente GNOME Wayland, encerre a sessão atual (Logout) e faça login"
echo "   novamente para que o GNOME Shell instancie todas as novas extensões e"
echo "   recarregue o tema Catppuccin Mocha Mauve de forma fluida."
echo "=============================================================================="
