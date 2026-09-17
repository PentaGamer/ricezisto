#!/usr/bin/env bash
# ==============================================================================
# Ricezisto - GNOME Desktop & Extensões Configurator
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "${SCRIPT_DIR}")"
WALLPAPER_FILE="${HOME}/.local/share/backgrounds/catppuccin-clearnight.jpg"
if [ ! -f "${WALLPAPER_FILE}" ]; then
    WALLPAPER_FILE="${REPO_DIR}/wallpapers/catppuccin-clearnight.jpg"
fi


echo "==> [Ricezisto GNOME] Aplicando configurações do ambiente gráfico..."

# 0. Atualizar cache de fontes
fc-cache -f 2>/dev/null || true

# 1. Compilar esquemas locais do GLib para suporte nativo a extensões
mkdir -p "${HOME}/.local/share/glib-2.0/schemas/"
for schema_dir in \
    "/usr/share/gnome-shell/extensions/blur-my-shell@aunetx/schemas" \
    "/usr/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/schemas" \
    "${HOME}/.local/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/schemas" \
    "${HOME}/.local/share/gnome-shell/extensions/blur-my-shell@aunetx/schemas"; do
    if [ -d "${schema_dir}" ]; then
        cp -u "${schema_dir}"/*.xml "${HOME}/.local/share/glib-2.0/schemas/" 2>/dev/null || true
    fi
done
glib-compile-schemas "${HOME}/.local/share/glib-2.0/schemas/" 2>/dev/null || true

# 2. Configurar Dark Mode e Esquema de Cores
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Catppuccin-Mocha-Standard-Mauve-Dark' 2>/dev/null || \
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'

# Tema do GNOME Shell (User Themes)
if [ -d "/usr/share/themes/catppuccin-mocha-mauve-standard+default/gnome-shell" ] || [ -d "${HOME}/.themes/catppuccin-mocha-mauve-standard+default/gnome-shell" ] || [ -d "${HOME}/.local/share/themes/catppuccin-mocha-mauve-standard+default/gnome-shell" ]; then
    gsettings set org.gnome.shell.extensions.user-theme name 'catppuccin-mocha-mauve-standard+default'
fi

# 3. Ícones e Cursores
if [ -d "/usr/share/icons/Papirus-Dark" ] || [ -d "${HOME}/.local/share/icons/Papirus-Dark" ]; then
    gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
fi

if [ -d "/usr/share/icons/Catppuccin-Mocha-Mauve-Cursors" ] || [ -d "${HOME}/.local/share/icons/Catppuccin-Mocha-Mauve-Cursors" ]; then
    gsettings set org.gnome.desktop.interface cursor-theme 'Catppuccin-Mocha-Mauve-Cursors'
fi

# 4. Tipografia Moderna (Inter + JetBrainsMono Nerd Font)
if fc-list : family | grep -i "Inter" >/dev/null 2>&1; then
    gsettings set org.gnome.desktop.interface font-name 'Inter 10.5'
    gsettings set org.gnome.desktop.interface document-font-name 'Inter 11'
    gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Inter Bold 10.5'
fi

if fc-list : family | grep -i "JetBrains" >/dev/null 2>&1; then
    gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrainsMono Nerd Font 10.5'
fi

# 5. Wallpaper Oficial Catppuccin Mocha
if [ -f "${WALLPAPER_FILE}" ]; then
    echo "  -> Definindo papel de parede: ${WALLPAPER_FILE}"
    gsettings set org.gnome.desktop.background picture-uri "file://${WALLPAPER_FILE}"
    gsettings set org.gnome.desktop.background picture-uri-dark "file://${WALLPAPER_FILE}"
    gsettings set org.gnome.desktop.background picture-options 'zoom'
fi

# 6. Habilitar Extensões Essenciais via Python D-Bus
echo "  -> Configurando lista de extensões ativas..."
python3 -c "
import subprocess, ast
try:
    out = subprocess.check_output(['gsettings', 'get', 'org.gnome.shell', 'enabled-extensions']).decode('utf-8').strip()
    exts = ast.literal_eval(out)
    modified = False
    for ext in ['dash-to-dock@micxgx.gmail.com', 'blur-my-shell@aunetx', 'user-theme@gnome-shell-extensions.gcampax.github.com']:
        if ext not in exts:
            exts.append(ext)
            modified = True
    if 'zorin-taskbar@zorinos.com' in exts:
        exts.remove('zorin-taskbar@zorinos.com')
        modified = True
    if modified:
        subprocess.check_call(['gsettings', 'set', 'org.gnome.shell', 'enabled-extensions', str(exts).replace('\"', '\'')])
except Exception as e:
    pass
" 2>/dev/null || true

# 7. Configurar Dash to Dock (Floating Pill Dock com Intellihide)
echo "  -> Configurando Floating Dock (Dash to Dock)..."
dconf write /org/gnome/shell/extensions/dash-to-dock/preferred-monitor-by-connector "'primary'"
dconf write /org/gnome/shell/extensions/dash-to-dock/preferred-monitor -1
dconf write /org/gnome/shell/extensions/dash-to-dock/multi-monitor false
dconf write /org/gnome/shell/extensions/dash-to-dock/dock-fixed false
dconf write /org/gnome/shell/extensions/dash-to-dock/autohide true
dconf write /org/gnome/shell/extensions/dash-to-dock/intellihide true
dconf write /org/gnome/shell/extensions/dash-to-dock/require-pressure-to-show false
dconf write /org/gnome/shell/extensions/dash-to-dock/extend-height false
dconf write /org/gnome/shell/extensions/dash-to-dock/dock-position "'BOTTOM'"
dconf write /org/gnome/shell/extensions/dash-to-dock/dash-max-icon-size 40
dconf write /org/gnome/shell/extensions/dash-to-dock/click-action "'focus-minimize-or-previews'"
dconf write /org/gnome/shell/extensions/dash-to-dock/custom-theme-shrink true
dconf write /org/gnome/shell/extensions/dash-to-dock/transparency-mode "'FIXED'"
dconf write /org/gnome/shell/extensions/dash-to-dock/custom-background-color true
dconf write /org/gnome/shell/extensions/dash-to-dock/background-color "'#1e1e2e'"
dconf write /org/gnome/shell/extensions/dash-to-dock/background-opacity 0.82
dconf write /org/gnome/shell/extensions/dash-to-dock/custom-theme-customize-running-dots true
dconf write /org/gnome/shell/extensions/dash-to-dock/custom-theme-running-dots-color "'#cba6f7'"
dconf write /org/gnome/shell/extensions/dash-to-dock/custom-theme-running-dots-border-color "'#cba6f7'"
dconf write /org/gnome/shell/extensions/dash-to-dock/show-show-apps-button true
dconf write /org/gnome/shell/extensions/dash-to-dock/show-mounts true
dconf write /org/gnome/shell/extensions/dash-to-dock/show-trash false
dconf write /org/gnome/shell/extensions/dash-to-dock/running-indicator-style "'DOTS'"

# Aplicativos favoritos fixados na Dock
gsettings set org.gnome.shell favorite-apps "['kitty.desktop', 'brave-browser.desktop', 'org.gnome.Nautilus.desktop', 'com.spotify.Client.desktop']"

# 8. Animações Padrões do Zorin (Sem efeitos de fluidez/gelatina)
echo "  -> Mantendo animações padrões e rápidas do Zorin OS..."
gsettings set org.gnome.desktop.interface enable-animations true
gnome-extensions disable zorin-window-move-effect@zorinos.com 2>/dev/null || true
gnome-extensions disable zorin-magic-lamp-effect@zorinos.com 2>/dev/null || true

# 9. Configurações do Blur my Shell via dconf
dconf write /org/gnome/shell/extensions/blur-my-shell/panel/blur true
dconf write /org/gnome/shell/extensions/blur-my-shell/panel/pipeline "'pipeline_default'"
dconf write /org/gnome/shell/extensions/blur-my-shell/dash-to-dock/blur true
dconf write /org/gnome/shell/extensions/blur-my-shell/overview/blur true
dconf write /org/gnome/shell/extensions/blur-my-shell/lockscreen/blur true

# 10. Mapeamento de Atalhos Ergonômicos
if [ -x "${SCRIPT_DIR}/apply-keybindings.sh" ]; then
    "${SCRIPT_DIR}/apply-keybindings.sh" "${1:-}"
fi

echo "==> [Ricezisto GNOME] Configurações aplicadas com sucesso!"
