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
chmod +x "${SCRIPTS_DIR}/backup.sh" "${SCRIPTS_DIR}/restore.sh" "${SCRIPTS_DIR}/apply-gnome.sh" "${SCRIPTS_DIR}/check-status.sh" "${SCRIPTS_DIR}/apply-keybindings.sh"
"${SCRIPTS_DIR}/backup.sh"

# Passo 2: Copiar papel de parede para o espaço do usuário
echo ""
echo "[Passo 2/4] Configurando Wallpaper do Usuário..."
mkdir -p "${HOME}/.local/share/backgrounds"
if [ -f "${REPO_DIR}/wallpapers/catppuccin-clearnight.jpg" ]; then
    cp -u "${REPO_DIR}/wallpapers/catppuccin-clearnight.jpg" "${HOME}/.local/share/backgrounds/"
    echo "  -> Wallpaper disponível em: ${HOME}/.local/share/backgrounds/catppuccin-clearnight.jpg"
fi

# Passo 3: Criar links simbólicos limpos para os Dotfiles
echo ""
echo "[Passo 3/4] Aplicando Dotfiles..."
mkdir -p "${HOME}/.config" "${HOME}/.local/bin"

# Desfazer eventuais symlinks de diretórios inteiros para evitar links circulares
for dir_link in "${HOME}/.config/kitty" "${HOME}/.config/fastfetch" "${HOME}/.config/gtk-3.0" "${HOME}/.config/gtk-4.0"; do
    if [ -L "${dir_link}" ]; then
        rm -f "${dir_link}"
    fi
done

# Kitty
mkdir -p "${HOME}/.config/kitty"
rm -f "${HOME}/.config/kitty/kitty.conf" "${HOME}/.config/kitty/colors-mocha.conf"
ln -sf "${REPO_DIR}/stow/kitty/.config/kitty/kitty.conf" "${HOME}/.config/kitty/kitty.conf"
ln -sf "${REPO_DIR}/stow/kitty/.config/kitty/colors-mocha.conf" "${HOME}/.config/kitty/colors-mocha.conf"
echo "  -> Kitty vinculado em ~/.config/kitty"

# Zsh
rm -f "${HOME}/.zshrc"
ln -sf "${REPO_DIR}/stow/zsh/.zshrc" "${HOME}/.zshrc"
echo "  -> Zsh vinculado em ~/.zshrc"

# Starship
rm -f "${HOME}/.config/starship.toml"
ln -sf "${REPO_DIR}/stow/starship/.config/starship.toml" "${HOME}/.config/starship.toml"
echo "  -> Starship vinculado em ~/.config/starship.toml"

# Fastfetch
mkdir -p "${HOME}/.config/fastfetch"
rm -f "${HOME}/.config/fastfetch/config.jsonc"
ln -sf "${REPO_DIR}/stow/fastfetch/.config/fastfetch/config.jsonc" "${HOME}/.config/fastfetch/config.jsonc"
echo "  -> Fastfetch vinculado em ~/.config/fastfetch"

# GTK CSS (Libadwaita / GTK3 e GTK4)
mkdir -p "${HOME}/.config/gtk-3.0" "${HOME}/.config/gtk-4.0"
rm -f "${HOME}/.config/gtk-3.0/gtk.css" "${HOME}/.config/gtk-4.0/gtk.css"
ln -sf "${REPO_DIR}/stow/gtk/.config/gtk-3.0/gtk.css" "${HOME}/.config/gtk-3.0/gtk.css"
ln -sf "${REPO_DIR}/stow/gtk/.config/gtk-4.0/gtk.css" "${HOME}/.config/gtk-4.0/gtk.css"
echo "  -> GTK3 e GTK4 vinculados em ~/.config/gtk-*"

# Atualizar cache de fontes
fc-cache -f 2>/dev/null || true

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
