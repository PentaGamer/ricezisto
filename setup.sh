#!/usr/bin/env bash
# ==============================================================================
# Ricezisto - Main User Setup Entrypoint
# ==============================================================================
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="${REPO_DIR}/scripts"

# Trava de segurança: impede execução acidental no usuário 'gustavo'
if [ "${USER}" = "gustavo" ] && [ "${1:-}" != "--force-apply-to-gustavo" ]; then
    echo "=============================================================================="
    echo "🛑 TRAVA DE SEGURANÇA ATIVA!"
    echo "Você está no usuário principal 'gustavo'. Para proteger a integridade do seu"
    echo "ambiente diário, este rice deve ser executado exclusivamente no usuário 'rice'."
    echo ""
    echo "👉 Como prosseguir com segurança:"
    echo "  1. Encerre a sessão ou clique em 'Trocar de Usuário' no menu do Zorin OS"
    echo "  2. Entre na conta 'rice' (senha: rice123)"
    echo "  3. Abra o terminal na conta 'rice' e execute:"
    echo "       cd ~/ricezisto && ./setup.sh"
    echo ""
    echo "Caso futuramente deseje aplicar intencionalmente no usuário principal, use:"
    echo "  ./setup.sh --force-apply-to-gustavo"
    echo "=============================================================================="
    exit 1
fi

echo "=============================================================================="
echo "                   RICEZISTO - CATPPUCCIN MOCHA MAUVE SETUP                   "
echo "=============================================================================="
echo "Usuário em execução: ${USER}"
echo "Diretório do Rice:   ${REPO_DIR}"
echo "=============================================================================="

# Passo 1: Executar snapshot preventivo de segurança
echo ""
echo "[Passo 1/4] Executando Backup Snapshot Preventivo..."
chmod +x "${SCRIPTS_DIR}/backup.sh" "${SCRIPTS_DIR}/restore.sh" "${SCRIPTS_DIR}/apply-gnome.sh"
"${SCRIPTS_DIR}/backup.sh"

# Passo 2: Copiar papel de parede para o espaço do usuário
echo ""
echo "[Passo 2/4] Configurando Wallpaper do Usuário..."
mkdir -p "${HOME}/.local/share/backgrounds"
if [ -f "${REPO_DIR}/wallpapers/catppuccin-clearnight.jpg" ]; then
    cp -u "${REPO_DIR}/wallpapers/catppuccin-clearnight.jpg" "${HOME}/.local/share/backgrounds/"
    echo "  -> Wallpaper copiado para: ${HOME}/.local/share/backgrounds/catppuccin-clearnight.jpg"
fi

# Passo 3: Aplicar Dotfiles via GNU Stow (com limpeza prévia de conflitos)
echo ""
echo "[Passo 3/4] Aplicando Dotfiles via GNU Stow..."
mkdir -p "${HOME}/.config" "${HOME}/.local/bin"

if command -v stow >/dev/null 2>&1; then
    echo "  -> Utilizando GNU Stow para criar symlinks modulares..."
    cd "${REPO_DIR}/stow"
    for pkg in kitty zsh starship fastfetch gtk; do
        if [ -d "${pkg}" ]; then
            echo "     * Módulo: ${pkg}"
            # Resolver conflitos: remover arquivos regulares pré-existentes que já foram salvos no backup
            find "${pkg}" -type f | while read -r src_file; do
                rel_file="${src_file#${pkg}/}"
                target_file="${HOME}/${rel_file}"
                if [ -e "${target_file}" ] && [ ! -L "${target_file}" ]; then
                    rm -rf "${target_file}"
                fi
            done
            stow -v -R -d "${REPO_DIR}/stow" -t "${HOME}" "${pkg}" || {
                echo "     ! Aviso: stow encontrou pendência em ${pkg}, aplicando link direto..."
            }
        fi
    done
    cd "${REPO_DIR}"
else
    echo "  -> GNU Stow não detectado. Criando links diretos..."
    mkdir -p "${HOME}/.config/kitty" "${HOME}/.config/fastfetch" "${HOME}/.config/gtk-3.0" "${HOME}/.config/gtk-4.0"
    ln -sf "${REPO_DIR}/stow/kitty/.config/kitty/kitty.conf" "${HOME}/.config/kitty/kitty.conf"
    ln -sf "${REPO_DIR}/stow/kitty/.config/kitty/colors-mocha.conf" "${HOME}/.config/kitty/colors-mocha.conf"
    ln -sf "${REPO_DIR}/stow/zsh/.zshrc" "${HOME}/.zshrc"
    ln -sf "${REPO_DIR}/stow/starship/.config/starship.toml" "${HOME}/.config/starship.toml"
    ln -sf "${REPO_DIR}/stow/fastfetch/.config/fastfetch/config.jsonc" "${HOME}/.config/fastfetch/config.jsonc"
    ln -sf "${REPO_DIR}/stow/gtk/.config/gtk-3.0/gtk.css" "${HOME}/.config/gtk-3.0/gtk.css"
    ln -sf "${REPO_DIR}/stow/gtk/.config/gtk-4.0/gtk.css" "${HOME}/.config/gtk-4.0/gtk.css"
fi

# Passo 4: Configurar GNOME Shell e Extensões
echo ""
echo "[Passo 4/4] Configurando GNOME Desktop & Extensões..."
"${SCRIPTS_DIR}/apply-gnome.sh" "${1:-}"

echo ""
echo "=============================================================================="
echo "                 RICEZISTO APLICADO COM SUCESSO! 🎉                           "
echo "=============================================================================="
echo "Status:"
echo "  - Dotfiles: Kitty, Zsh, Starship, Fastfetch e GTK vinculados em ~/.config"
echo "  - Dock: Dash to Dock configurada como Floating Pill no monitor primário"
echo "  - Blur: Blur my Shell ativado no painel, dock e visão geral"
echo "  - Animações: Padrões nativas do Zorin OS (rápidas, sem efeitos elásticos)"
echo ""
echo "Dica:"
echo "  - Para validar o status completo a qualquer momento:"
echo "      ${SCRIPTS_DIR}/check-status.sh"
echo "=============================================================================="
