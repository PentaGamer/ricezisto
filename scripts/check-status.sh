#!/usr/bin/env bash
# ==============================================================================
# Ricezisto - Status & Diagnostics Check
# ==============================================================================
set -euo pipefail

echo "=============================================================================="
echo "                   RICEZISTO - DIAGNÓSTICO DO AMBIENTE                        "
echo "=============================================================================="
echo "Usuário Atual:      ${USER} (UID: $(id -u))"
echo "Sessão Gráfica:     ${XDG_SESSION_TYPE:-desconhecida}"
echo "Desktop:            ${XDG_CURRENT_DESKTOP:-desconhecido}"
echo "=============================================================================="

pass() { echo -e "  [\033[0;32mOK\033[0m] $1"; }
warn() { echo -e "  [\033[0;33mAVISO\033[0m] $1"; }
fail() { echo -e "  [\033[0;31mFALHA\033[0m] $1"; }

echo ""
echo "1. Verificação de Dotfiles (~/.config):"
check_link() {
    local target="$1"
    local desc="$2"
    if [ -L "${target}" ]; then
        local dest
        dest="$(readlink -f "${target}" 2>/dev/null || readlink "${target}")"
        pass "${desc}: Link simbólico ativo -> ${dest}"
    elif [ -f "${target}" ]; then
        warn "${desc}: Arquivo regular presente (não é link simbólico)"
    else
        fail "${desc}: Arquivo inexistente (${target})"
    fi
}

check_link "${HOME}/.config/kitty/kitty.conf" "Kitty Config"
check_link "${HOME}/.zshrc" "Zsh RC"
check_link "${HOME}/.config/starship.toml" "Starship Config"
check_link "${HOME}/.config/fastfetch/config.jsonc" "Fastfetch Config"
check_link "${HOME}/.config/gtk-4.0/gtk.css" "GTK4 / Libadwaita CSS"
check_link "${HOME}/.config/bat/config" "Bat Config"
check_link "${HOME}/.config/rofi/config.rasi" "Rofi Config"
check_link "${HOME}/.config/rofi/powermenu.sh" "Rofi Powermenu"
check_link "${HOME}/.config/vicinae/settings.json" "Vicinae Settings"
check_link "${HOME}/.config/vicinae/powermenu.sh" "Vicinae Powermenu"
check_link "${HOME}/.config/vicinae/clipboard.sh" "Vicinae Clipboard Toggle"
check_link "${HOME}/.config/cava/config" "Cava Config"
check_link "${HOME}/.local/share/vicinae/themes/catppuccin-mocha-mauve.toml" "Vicinae Theme (Catppuccin)"

echo ""
echo "2. Verificação de Extensões GNOME:"
if command -v gnome-extensions >/dev/null 2>&1; then
    ENABLED_EXTS=$(gnome-extensions list --enabled 2>/dev/null || true)
    
    if echo "${ENABLED_EXTS}" | grep -q "dash-to-dock"; then
        pass "Dash to Dock: Habilitada"
    elif gsettings get org.gnome.shell enabled-extensions 2>/dev/null | grep -q "dash-to-dock"; then
        warn "Dash to Dock: Ativada nas configurações, mas aguardando novo login para ser instanciada pelo GNOME Shell Wayland"
    else
        warn "Dash to Dock: Desabilitada"
    fi

    if echo "${ENABLED_EXTS}" | grep -q "blur-my-shell"; then
        pass "Blur my Shell: Habilitada"
    else
        warn "Blur my Shell: Não ativa na sessão atual (necessário logout/login para Wayland)"
    fi

    if echo "${ENABLED_EXTS}" | grep -q "zorin-taskbar"; then
        warn "Zorin Taskbar: Habilitada (pode conflitar com a Floating Dock)"
    else
        pass "Zorin Taskbar: Desabilitada (liberando a Floating Dock)"
    fi

    if echo "${ENABLED_EXTS}" | grep -q "user-theme"; then
        pass "User Themes: Habilitada"
    else
        warn "User Themes: Desabilitada"
    fi
else
    fail "gnome-extensions: comando não disponível"
fi

echo ""
echo "3. Configurações da Dock (dconf / gsettings):"
if command -v dconf >/dev/null 2>&1; then
    MONITOR=$(dconf read /org/gnome/shell/extensions/dash-to-dock/preferred-monitor-by-connector 2>/dev/null || echo "não configurado")
    AUTOHIDE=$(dconf read /org/gnome/shell/extensions/dash-to-dock/autohide 2>/dev/null || echo "não configurado")
    INTELLIHIDE=$(dconf read /org/gnome/shell/extensions/dash-to-dock/intellihide 2>/dev/null || echo "não configurado")
    FIXED=$(dconf read /org/gnome/shell/extensions/dash-to-dock/dock-fixed 2>/dev/null || echo "não configurado")
    POS=$(dconf read /org/gnome/shell/extensions/dash-to-dock/dock-position 2>/dev/null || echo "não configurado")
    ICON_SIZE=$(dconf read /org/gnome/shell/extensions/dash-to-dock/dash-max-icon-size 2>/dev/null || echo "não configurado")
    CLICK_ACTION=$(dconf read /org/gnome/shell/extensions/dash-to-dock/click-action 2>/dev/null || echo "não configurado")
    
    echo "  -> Monitor Preferencial: ${MONITOR}"
    echo "  -> Posição da Dock:      ${POS}"
    echo "  -> Dock Fixa:            ${FIXED}"
    echo "  -> Autohide:             ${AUTOHIDE}"
    echo "  -> Intellihide:          ${INTELLIHIDE}"
    echo "  -> Tamanho dos Ícones:   ${ICON_SIZE}px"
    echo "  -> Ação de Clique:       ${CLICK_ACTION}"
    
    if [ "${MONITOR}" = "'primary'" ] || [ "${MONITOR}" = "'DP-1'" ]; then
        pass "Dock apontando para monitor ativo principal"
    elif [ "${MONITOR}" = "'DP-3'" ]; then
        fail "Dock apontando para monitor desconectado (DP-3)!"
    fi

    if [ "${INTELLIHIDE}" = "true" ] && [ "${AUTOHIDE}" = "true" ]; then
        pass "Intellihide ativo (ocultamento dinâmico sobre janelas)"
    else
        warn "Intellihide não está ativo"
    fi

    if [ "${ICON_SIZE}" = "40" ]; then
        pass "Escala de ícones: 40px"
    fi

    FAVORITES=$(gsettings get org.gnome.shell favorite-apps 2>/dev/null || echo "")
    if echo "${FAVORITES}" | grep -q "kitty" && echo "${FAVORITES}" | grep -q "brave" && echo "${FAVORITES}" | grep -q "spotify"; then
        pass "Favoritos da Dock: Kitty, Brave, Nautilus e Spotify configurados"
    fi
fi

echo ""
echo "4. Papel de Parede e Temas:"
BG_URI=$(gsettings get org.gnome.desktop.background picture-uri 2>/dev/null || echo "desconhecido")
echo "  -> Wallpaper URI: ${BG_URI}"
GTK_TH=$(gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null || echo "desconhecido")
echo "  -> Tema GTK:      ${GTK_TH}"
IC_TH=$(gsettings get org.gnome.desktop.interface icon-theme 2>/dev/null || echo "desconhecido")
echo "  -> Tema de Ícones: ${IC_TH}"

echo ""
echo "5. Fontes:"
if fc-list : family | grep -i "JetBrains" >/dev/null 2>&1; then
    pass "JetBrainsMono Nerd Font: Instalada"
else
    warn "JetBrainsMono Nerd Font: Não encontrada no cache de fontes"
fi

if fc-list : family | grep -i "Inter" >/dev/null 2>&1; then
    pass "Inter: Instalada"
else
    warn "Inter: Não encontrada no cache de fontes"
fi

echo ""
echo "6. Atalhos do GNOME (Keybindings):"
CLOSE_BIND=$(gsettings get org.gnome.desktop.wm.keybindings close 2>/dev/null || echo "")
if echo "${CLOSE_BIND}" | grep -q "<Super>q"; then
    pass "Fechar Janela (<Super>q): Configurado"
else
    warn "Fechar Janela (<Super>q): Não configurado (${CLOSE_BIND})"
fi

HOME_BIND=$(gsettings get org.gnome.settings-daemon.plugins.media-keys home 2>/dev/null || echo "")
if echo "${HOME_BIND}" | grep -q "<Super>e"; then
    pass "Gerenciador de Arquivos (<Super>e): Configurado"
else
    warn "Gerenciador de Arquivos (<Super>e): Não configurado (${HOME_BIND})"
fi

CUSTOM_BINDS=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings 2>/dev/null || echo "")
if echo "${CUSTOM_BINDS}" | grep -q "custom0"; then
    KITTY_BIND=$(gsettings get org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding 2>/dev/null || echo "")
    pass "Terminal Kitty (${KITTY_BIND}): Ativo em custom0"
else
    warn "Terminal Kitty: Atalho customizado ausente"
fi

if echo "${CUSTOM_BINDS}" | grep -q "custom1"; then
    LAUNCHER_BIND=$(gsettings get org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding 2>/dev/null || echo "")
    LAUNCHER_CMD=$(gsettings get org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command 2>/dev/null || echo "")
    pass "Launcher Vicinae (${LAUNCHER_BIND}): Ativo em custom1 (${LAUNCHER_CMD})"
else
    warn "Launcher Vicinae: Atalho customizado ausente"
fi

if echo "${CUSTOM_BINDS}" | grep -q "custom2"; then
    POWER_BIND=$(gsettings get org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ binding 2>/dev/null || echo "")
    POWER_CMD=$(gsettings get org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ command 2>/dev/null || echo "")
    pass "Powermenu Vicinae (${POWER_BIND}): Ativo em custom2 (${POWER_CMD})"
else
    warn "Powermenu Vicinae: Atalho customizado ausente"
fi

if echo "${CUSTOM_BINDS}" | grep -q "custom3"; then
    CLIP_BIND=$(gsettings get org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ binding 2>/dev/null || echo "")
    CLIP_CMD=$(gsettings get org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ command 2>/dev/null || echo "")
    pass "Clipboard Vicinae (${CLIP_BIND}): Ativo em custom3 (${CLIP_CMD})"
else
    warn "Clipboard Vicinae: Atalho customizado ausente"
fi

echo ""
echo "7. Suite CLI Moderna (eza, bat, fzf, zoxide):"
for cli_tool in eza bat fzf zoxide cava; do
    if command -v "${cli_tool}" >/dev/null 2>&1; then
        pass "Utilitário ${cli_tool}: Instalado ($(command -v "${cli_tool}"))"
    else
        warn "Utilitário ${cli_tool}: Não encontrado no PATH"
    fi
done

if command -v bat >/dev/null 2>&1 && bat --list-themes 2>/dev/null | grep -i "Catppuccin Mocha" >/dev/null 2>&1; then
    pass "Bat Theme: Catppuccin Mocha compilado no cache"
else
    warn "Bat Theme: Catppuccin Mocha não detectado no cache"
fi

echo ""
echo "8. Status do Vicinae Daemon (vicinae.service):"
if command -v vicinae >/dev/null 2>&1; then
    pass "Binário Vicinae: Instalado ($(command -v vicinae))"
else
    fail "Binário Vicinae: Não encontrado no PATH"
fi

if systemctl --user is-active vicinae.service >/dev/null 2>&1; then
    pass "Vicinae Daemon: Ativo e em execução (systemd --user)"
else
    warn "Vicinae Daemon: Inativo (execute 'systemctl --user start vicinae.service')"
fi

echo ""
echo "=============================================================================="
echo "Diagnóstico concluído!"
echo "=============================================================================="
