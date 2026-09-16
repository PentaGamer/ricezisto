#!/usr/bin/env bash
# ==============================================================================
# Ricezisto - GNOME Desktop & Extensões Configurator
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "${SCRIPT_DIR}")"
WALLPAPER_FILE="${REPO_DIR}/wallpapers/catppuccin-clearnight.jpg"

echo "==> [Ricezisto GNOME] Aplicando configurações do ambiente gráfico..."

# 0. Compilar esquemas locais do GLib para suporte nativo a extensões
mkdir -p "${HOME}/.local/share/glib-2.0/schemas/"
if [ -d "/usr/share/gnome-shell/extensions/blur-my-shell@aunetx/schemas" ]; then
    cp -u /usr/share/gnome-shell/extensions/blur-my-shell@aunetx/schemas/*.xml "${HOME}/.local/share/glib-2.0/schemas/" 2>/dev/null || true
fi
if [ -d "${HOME}/.local/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/schemas" ]; then
    cp -u "${HOME}/.local/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/schemas/"*.xml "${HOME}/.local/share/glib-2.0/schemas/" 2>/dev/null || true
fi
glib-compile-schemas "${HOME}/.local/share/glib-2.0/schemas/" 2>/dev/null || true

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

# 5. Habilitar Extensão User Themes
gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com 2>/dev/null || true

# 6. Desacoplar Zorin Taskbar e Ativar Dash to Dock Flutuante
if gnome-extensions list | grep -q "zorin-taskbar@zorinos.com"; then
    echo "  -> Desativando barra integrada do Zorin..."
    gnome-extensions disable zorin-taskbar@zorinos.com 2>/dev/null || true
fi

# 7. Configurar Dash to Dock (Floating Pill Dock Visível e Correção de Monitor)
echo "  -> Configurando Floating Dock (Dash to Dock)..."
gnome-extensions enable dash-to-dock@micxgx.gmail.com 2>/dev/null || true

# Escrever configurações diretamente no dconf para evitar falhas de monitor desconectado
dconf write /org/gnome/shell/extensions/dash-to-dock/preferred-monitor-by-connector "'primary'"
dconf write /org/gnome/shell/extensions/dash-to-dock/preferred-monitor -1
dconf write /org/gnome/shell/extensions/dash-to-dock/multi-monitor false
dconf write /org/gnome/shell/extensions/dash-to-dock/dock-fixed true
dconf write /org/gnome/shell/extensions/dash-to-dock/autohide false
dconf write /org/gnome/shell/extensions/dash-to-dock/intellihide false
dconf write /org/gnome/shell/extensions/dash-to-dock/extend-height false
dconf write /org/gnome/shell/extensions/dash-to-dock/dock-position "'BOTTOM'"
dconf write /org/gnome/shell/extensions/dash-to-dock/dash-max-icon-size 48
dconf write /org/gnome/shell/extensions/dash-to-dock/custom-theme-shrink true
dconf write /org/gnome/shell/extensions/dash-to-dock/transparency-mode "'FIXED'"
dconf write /org/gnome/shell/extensions/dash-to-dock/background-opacity 0.82
dconf write /org/gnome/shell/extensions/dash-to-dock/show-show-apps-button true
dconf write /org/gnome/shell/extensions/dash-to-dock/show-mounts false
dconf write /org/gnome/shell/extensions/dash-to-dock/show-trash false
dconf write /org/gnome/shell/extensions/dash-to-dock/running-indicator-style "'DOTS'"

# 8. Animações Padrões do Zorin (Sem efeitos de fluidez/gelatina)
echo "  -> Mantendo animações padrões e rápidas do Zorin OS..."
gsettings set org.gnome.desktop.interface enable-animations true
gnome-extensions disable zorin-window-move-effect@zorinos.com 2>/dev/null || true
gnome-extensions disable zorin-magic-lamp-effect@zorinos.com 2>/dev/null || true

# 9. Configurar e Habilitar Blur my Shell
echo "  -> Registrando Blur my Shell..."
python3 -c "
import subprocess, ast
try:
    out = subprocess.check_output(['gsettings', 'get', 'org.gnome.shell', 'enabled-extensions']).decode('utf-8').strip()
    exts = ast.literal_eval(out)
    if 'blur-my-shell@aunetx' not in exts:
        exts.append('blur-my-shell@aunetx')
        subprocess.check_call(['gsettings', 'set', 'org.gnome.shell', 'enabled-extensions', str(exts).replace('\"', '\'')])
except Exception as e:
    pass
" 2>/dev/null || true

# Configurações do Blur my Shell via dconf
dconf write /org/gnome/shell/extensions/blur-my-shell/panel/blur true
dconf write /org/gnome/shell/extensions/blur-my-shell/panel/pipeline "'pipeline_default'"
dconf write /org/gnome/shell/extensions/blur-my-shell/dash-to-dock/blur true
dconf write /org/gnome/shell/extensions/blur-my-shell/overview/blur true
dconf write /org/gnome/shell/extensions/blur-my-shell/lockscreen/blur true

echo "==> [Ricezisto GNOME] Configurações aplicadas com sucesso!"
