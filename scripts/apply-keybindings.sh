#!/usr/bin/env bash
# ==============================================================================
# Ricezisto - GNOME Keybindings Configurator
# ==============================================================================
set -euo pipefail

# Trava de segurança: impede execução acidental no usuário principal 'gustavo'
if [ "${USER}" = "gustavo" ] && [ "${1:-}" != "--force-apply-to-gustavo" ]; then
    echo "🛑 TRAVA DE SEGURANÇA: Não execute apply-keybindings.sh diretamente no usuário 'gustavo'!"
    echo "   Para aplicar no usuário de teste, faça login como 'rice' e execute de lá."
    exit 1
fi

echo "==> [Ricezisto Keybindings] Aplicando mapeamento ergonômico de atalhos no GNOME..."

# 1. Resolução de Conflitos
gsettings set org.gnome.desktop.wm.keybindings switch-input-source "['<Control>space', 'XF86Keyboard']"
gsettings set org.gnome.desktop.wm.keybindings switch-input-source-backward "['<Shift><Control>space', '<Shift>XF86Keyboard']"
gsettings set org.gnome.shell.keybindings toggle-message-tray "['<Super>v']"

# 2. Gerenciamento de Janelas e Navegação
gsettings set org.gnome.desktop.wm.keybindings close "['<Super>q', '<Alt>F4']"
gsettings set org.gnome.desktop.wm.keybindings toggle-maximized "['<Super>m']"
gsettings set org.gnome.settings-daemon.plugins.media-keys home "['<Super>e']"

# 3. Atalhos Customizados (Terminal, Launcher e Powermenu)
python3 -c "
import subprocess

bindings = [
    ('custom0', 'Terminal Kitty', 'kitty', '<Super>Return'),
    ('custom1', 'Vicinae Launcher', 'vicinae toggle', '<Super>space'),
    ('custom2', 'Vicinae Powermenu', 'bash -c ~/.config/vicinae/powermenu.sh', '<Super>BackSpace')
]

paths = []
for slot, name, cmd, bind in bindings:
    path = f'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/{slot}/'
    schema = f'org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:{path}'
    subprocess.check_call(['gsettings', 'set', schema, 'name', name])
    subprocess.check_call(['gsettings', 'set', schema, 'command', cmd])
    subprocess.check_call(['gsettings', 'set', schema, 'binding', bind])
    paths.append(path)

subprocess.check_call(['gsettings', 'set', 'org.gnome.settings-daemon.plugins.media-keys', 'custom-keybindings', str(paths).replace('\"', '\'')])
"

echo "  -> Super + Return     : Abrir Terminal Kitty"
echo "  -> Super + Q          : Fechar janela ativa"
echo "  -> Super + E          : Abrir Arquivos (Nautilus)"
echo "  -> Super + M          : Alternar Janela Maximizada"
echo "  -> Super + Space      : Lançador de Aplicativos (Vicinae)"
echo "  -> Super + BackSpace  : Menu de Energia (Powermenu)"
echo "==> [Ricezisto Keybindings] Atalhos aplicados com sucesso!"
