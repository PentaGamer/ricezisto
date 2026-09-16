#!/usr/bin/env bash
# ==============================================================================
# Ricezisto - Rofi Powermenu (Catppuccin Mocha Mauve)
# ==============================================================================
set -euo pipefail

# Se não estiver envolvido pelo wrapper de backdrop, auto-executar com o wrapper
if [ "${ROFI_WRAPPED:-0}" != "1" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    if [ -f "${SCRIPT_DIR}/rofi-wrapper.py" ]; then
        exec python3 "${SCRIPT_DIR}/rofi-wrapper.py" "$0" "$@"
    fi
fi

# Opções do Menu
LOCK="󰌾  Bloquear"
LOGOUT="󰍃  Encerrar Sessão"
SUSPEND="󰤄  Suspender"
REBOOT="󰑐  Reiniciar"
SHUTDOWN="󰐥  Desligar"

OPTIONS="${LOCK}\n${SUSPEND}\n${LOGOUT}\n${REBOOT}\n${SHUTDOWN}"

CHOSEN="$(echo -e "${OPTIONS}" | rofi -dmenu -i -p "󰐥 Energia" \
    -theme-str 'window {width: 340px; height: 310px; border-radius: 16px;} listview {lines: 5;} inputbar {children: [prompt];}' 2>/dev/null || true)"

case "${CHOSEN}" in
    "${LOCK}")
        loginctl lock-session
        ;;
    "${LOGOUT}")
        gnome-session-quit --logout --no-prompt
        ;;
    "${SUSPEND}")
        systemctl suspend
        ;;
    "${REBOOT}")
        systemctl reboot
        ;;
    "${SHUTDOWN}")
        systemctl poweroff
        ;;
    *)
        exit 0
        ;;
esac
