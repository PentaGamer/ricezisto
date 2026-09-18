#!/usr/bin/env bash
# ==============================================================================
# Ricezisto - Instalador Unificado (Catppuccin Mocha Mauve para GNOME)
# Uso: ./install.sh [--user-only | --skip-deps]
# ==============================================================================
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="${REPO_DIR}/scripts"

# Flag para pular dependências de sistema com sudo
RUN_DEPS=true
for arg in "$@"; do
    case "${arg}" in
        --user-only|--skip-deps)
            RUN_DEPS=false
            shift
            ;;
        -h|--help)
            echo "Uso: $0 [OPÇÕES]"
            echo ""
            echo "Opções:"
            echo "  --user-only, --skip-deps   Pula a instalação de pacotes de sistema (sudo)"
            echo "                             e aplica apenas os dotfiles e configurações do GNOME."
            echo "  -h, --help                 Exibe esta ajuda."
            exit 0
            ;;
    esac
done

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

# 1. Provisionar dependências de sistema (sudo necessário)
if [ "${RUN_DEPS}" = true ]; then
    echo ""
    echo ">> [Etapa 1/3] Provisionando dependências de sistema (sudo necessário)..."
    
    if [ "$(id -u)" -eq 0 ]; then
        "${SCRIPTS_DIR}/install-deps.sh"
    else
        # Testar se o usuário tem permissão para rodar sudo
        if ! sudo -v 2>/dev/null; then
            echo ""
            echo "🛑 Erro de Permissão: O usuário '${REAL_USER}' não tem permissão no 'sudoers'."
            echo "   Para instalar pacotes globais (apt, fontes e extensões em /usr), é necessário"
            echo "   ter privilégios de administrador (grupo sudo)."
            echo ""
            echo "👉 Como resolver:"
            echo "   1. Em uma conta de administrador (ou como root), execute:"
            echo "        sudo usermod -aG sudo ${REAL_USER}"
            echo "   2. Encerre a sessão (Logout) e faça login novamente para ativar o grupo."
            echo ""
            echo "💡 Alternativa:"
            echo "   Se as dependências já foram instaladas na máquina por outro administrador,"
            echo "   você pode instalar apenas os dotfiles e temas do GNOME no seu usuário (~/.config):"
            echo "     ./install.sh --user-only"
            echo ""
            read -rp "Deseja continuar aplicando apenas os dotfiles no seu usuário agora? (s/N): " CONT_USER
            if [[ "${CONT_USER}" =~ ^[sS]$ ]]; then
                RUN_DEPS=false
            else
                echo "Instalação interrompida."
                exit 1
            fi
        else
            sudo "${SCRIPTS_DIR}/install-deps.sh"
        fi
    fi
else
    echo ""
    echo ">> [Etapa 1/3] Pulando dependências de sistema (--user-only ativo)..."
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
