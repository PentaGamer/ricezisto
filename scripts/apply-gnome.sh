#!/usr/bin/env bash
# ==============================================================================
# Ricezisto - GNOME Desktop & Extensões Configurator
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "${SCRIPT_DIR}")"
WALLPAPER_FILE="${REPO_DIR}/wallpapers/catppuccin-clearnight.jpg"

echo "==> [Ricezisto GNOME] Aplicando configurações do ambiente gráfico..."

# 1. Configurar Dark Mode e Esquema de Cores
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Catppuccin-Mocha-Standard-Mauve-Dark' 2>/dev/null || \
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'

# 2. Ícones e Cursores
if [ -d "/usr/share/icons/Papirus-Dark" ] || [ -d "${HOME}/.local/share/icons/Papirus-Dark" ]; then
    gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
fi

if [ -d "/usr/share/icons/Catppuccin-Mocha-Mauve-Cursors" ] || [ -d "${HOME}/.local/share/icons/Catppuccin-Mocha-Mauve-Cursors" ]; then
    gsettings set org.gnome.desktop.interface cursor-theme 'Catppuccin-Mocha-Mauve-Cursors'
fi

# 3. Tipografia Moderna (Inter + JetBrainsMono Nerd Font)
if fc-list : family | grep -iq "Inter"; then
    gsettings set org.gnome.desktop.interface font-name 'Inter 10.5'
    gsettings set org.gnome.desktop.interface document-font-name 'Inter 11'
    gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Inter Bold 10.5'
fi

if fc-list : family | grep -iq "JetBrainsMono"; then
    gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrainsMono Nerd Font 10.5'
fi

# 4. Wallpaper Oficial Catppuccin Mocha
if [ -f "${WALLPAPER_FILE}" ]; then
    echo "  -> Definindo papel de parede: ${WALLPAPER_FILE}"
    gsettings set org.gnome.desktop.background picture-uri "file://${WALLPAPER_FILE}"
    gsettings set org.gnome.desktop.background picture-uri-dark "file://${WALLPAPER_FILE}"
    gsettings set org.gnome.desktop.background picture-options 'zoom'
fi

# 5. Desacoplar Zorin Taskbar e Ativar Dash to Dock Flutuante
if gnome-extensions list | grep -q "zorin-taskbar@zorinos.com"; then
    echo "  -> Desativando barra integrada do Zorin..."
    gnome-extensions disable zorin-taskbar@zorinos.com || true
fi

# Habilitar User Themes
gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com 2>/dev/null || true

# Configurar Dash to Dock (Floating Pill Dock)
if gnome-extensions list | grep -q "dash-to-dock@micxgx.gmail.com"; then
    echo "  -> Habilitando e configurando Floating Dock..."
    gnome-extensions enable dash-to-dock@micxgx.gmail.com || true

    gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM' || true
    gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false || true
    gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false || true
    gsettings set org.gnome.shell.extensions.dash-to-dock autohide true || true
    gsettings set org.gnome.shell.extensions.dash-to-dock intellihide true || true
    gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 44 || true
    gsettings set org.gnome.shell.extensions.dash-to-dock custom-theme-shrink true || true
    gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts false || true
    gsettings set org.gnome.shell.extensions.dash-to-dock show-trash false || true
    gsettings set org.gnome.shell.extensions.dash-to-dock running-indicator-style 'DOTS' || true
    gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode 'DYNAMIC' || true
fi

# 6. Efeitos Visuais & Blur
MODE="${1:-effects}" # 'effects' (Opção B) ou 'clean' (Opção A)

if [ "${MODE}" = "clean" ]; then
    echo "  -> Modo Limpo selecionado: desativando efeitos de janela..."
    gnome-extensions disable zorin-window-move-effect@zorinos.com 2>/dev/null || true
    gnome-extensions disable zorin-magic-lamp-effect@zorinos.com 2>/dev/null || true
else
    echo "  -> Modo Orgânico/Efeitos (Opção B) ativado..."
    gnome-extensions enable zorin-window-move-effect@zorinos.com 2>/dev/null || true
    gnome-extensions enable zorin-magic-lamp-effect@zorinos.com 2>/dev/null || true
fi

# Habilitar e configurar Blur my Shell se instalado
if gnome-extensions list | grep -q "blur-my-shell@aunetx"; then
    echo "  -> Habilitando Blur my Shell..."
    gnome-extensions enable blur-my-shell@aunetx 2>/dev/null || true
    
    # Configurações do Blur
    gsettings set org.gnome.shell.extensions.blur-my-shell.panel blur true 2>/dev/null || true
    gsettings set org.gnome.shell.extensions.blur-my-shell.panel pipeline 'pipeline_default' 2>/dev/null || true
    gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock blur true 2>/dev/null || true
    gsettings set org.gnome.shell.extensions.blur-my-shell.overview blur true 2>/dev/null || true
fi

echo "==> [Ricezisto GNOME] Aplicação visual concluída!"
