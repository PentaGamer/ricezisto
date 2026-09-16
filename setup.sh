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
for dir_link in "${HOME}/.config/kitty" "${HOME}/.config/fastfetch" "${HOME}/.config/gtk-3.0" "${HOME}/.config/gtk-4.0" "${HOME}/.config/bat" "${HOME}/.config/rofi" "${HOME}/.config/vicinae" "${HOME}/.config/cava"; do
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

# Bat (Catppuccin Mocha)
mkdir -p "${HOME}/.config/bat/themes"
rm -f "${HOME}/.config/bat/config"
ln -sf "${REPO_DIR}/stow/bat/.config/bat/config" "${HOME}/.config/bat/config"
if [ -f "${REPO_DIR}/stow/bat/.config/bat/themes/Catppuccin Mocha.tmTheme" ]; then
    cp -u "${REPO_DIR}/stow/bat/.config/bat/themes/Catppuccin Mocha.tmTheme" "${HOME}/.config/bat/themes/"
    bat cache --build >/dev/null 2>&1 || true
fi
echo "  -> Bat vinculado em ~/.config/bat"

# GTK CSS (Libadwaita / GTK3 e GTK4)
mkdir -p "${HOME}/.config/gtk-3.0" "${HOME}/.config/gtk-4.0"
rm -f "${HOME}/.config/gtk-3.0/gtk.css" "${HOME}/.config/gtk-4.0/gtk.css"
ln -sf "${REPO_DIR}/stow/gtk/.config/gtk-3.0/gtk.css" "${HOME}/.config/gtk-3.0/gtk.css"
ln -sf "${REPO_DIR}/stow/gtk/.config/gtk-4.0/gtk.css" "${HOME}/.config/gtk-4.0/gtk.css"
echo "  -> GTK3 e GTK4 vinculados em ~/.config/gtk-*"

# Rofi (Powermenu)
mkdir -p "${HOME}/.config/rofi"
rm -f "${HOME}/.config/rofi/config.rasi" "${HOME}/.config/rofi/catppuccin-mocha.rasi" "${HOME}/.config/rofi/powermenu.sh" "${HOME}/.config/rofi/launcher.sh" "${HOME}/.config/rofi/rofi-wrapper.py"
ln -sf "${REPO_DIR}/stow/rofi/.config/rofi/config.rasi" "${HOME}/.config/rofi/config.rasi"
ln -sf "${REPO_DIR}/stow/rofi/.config/rofi/catppuccin-mocha.rasi" "${HOME}/.config/rofi/catppuccin-mocha.rasi"
ln -sf "${REPO_DIR}/stow/rofi/.config/rofi/powermenu.sh" "${HOME}/.config/rofi/powermenu.sh"
chmod +x "${REPO_DIR}/stow/rofi/.config/rofi/powermenu.sh"
echo "  -> Rofi (Legado) vinculado em ~/.config/rofi"

# Vicinae (Launcher, Powermenu & Clipboard Nativo Wayland com tema Catppuccin Mocha Mauve)
mkdir -p "${HOME}/.config/vicinae" "${HOME}/.local/share/vicinae/themes"
rm -f "${HOME}/.config/vicinae/settings.json" "${HOME}/.config/vicinae/powermenu.sh" "${HOME}/.config/vicinae/clipboard.sh"
rm -f "${HOME}/.local/share/vicinae/themes/catppuccin-mocha-mauve.toml"
ln -sf "${REPO_DIR}/stow/vicinae/.config/vicinae/settings.json" "${HOME}/.config/vicinae/settings.json"
ln -sf "${REPO_DIR}/stow/vicinae/.config/vicinae/powermenu.sh" "${HOME}/.config/vicinae/powermenu.sh"
ln -sf "${REPO_DIR}/stow/vicinae/.config/vicinae/clipboard.sh" "${HOME}/.config/vicinae/clipboard.sh"
ln -sf "${REPO_DIR}/stow/vicinae/.local/share/vicinae/themes/catppuccin-mocha-mauve.toml" "${HOME}/.local/share/vicinae/themes/catppuccin-mocha-mauve.toml"
chmod +x "${REPO_DIR}/stow/vicinae/.config/vicinae/powermenu.sh" "${REPO_DIR}/stow/vicinae/.config/vicinae/clipboard.sh"
echo "  -> Vicinae (Launcher, Powermenu & Clipboard) vinculado em ~/.config/vicinae e ~/.local/share/vicinae"

# Cava (Visualizador de Áudio Catppuccin Mocha Mauve)
mkdir -p "${HOME}/.config/cava"
rm -f "${HOME}/.config/cava/config"
ln -sf "${REPO_DIR}/stow/cava/.config/cava/config" "${HOME}/.config/cava/config"
echo "  -> Cava vinculado em ~/.config/cava"

# Ativar daemon do Vicinae via systemd user
if command -v systemctl >/dev/null 2>&1 && [ -f "/usr/local/lib/systemd/user/vicinae.service" ]; then
    systemctl --user daemon-reload 2>/dev/null || true
    systemctl --user enable --now vicinae.service 2>/dev/null || true
    echo "  -> Serviço vicinae.service ativo no systemd de usuário"
fi

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
