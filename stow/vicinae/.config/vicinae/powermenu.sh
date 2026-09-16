#!/usr/bin/env bash
# ==============================================================================
# Ricezisto - Vicinae Powermenu (Catppuccin Mocha Mauve)
# ==============================================================================
set -euo pipefail

# Toggle: se o menu de energia já estiver aberto, fecha e sai
if pgrep -f "vicinae dmenu" >/dev/null 2>&1; then
    pkill -f "vicinae dmenu"
    exit 0
fi

# Opções com ícones Nerd Font
LOCK="󰌾  Bloquear"
SUSPEND="󰤄  Suspender"
LOGOUT="󰍃  Encerrar Sessão"
REBOOT="󰑐  Reiniciar"
SHUTDOWN="󰐥  Desligar"

# Invoca o vicinae dmenu utilizando a paleta e configurações do Vicinae
CHOSEN="$(printf "%s\n" \
    "${LOCK}" \
    "${SUSPEND}" \
    "${LOGOUT}" \
    "${REBOOT}" \
    "${SHUTDOWN}" | vicinae dmenu \
        -n "Energia" \
        -p "Ações de Energia..." \
        -W 450 \
        -H 280 \
        --no-section \
        --no-footer \
        2>/dev/null || true)"

case "${CHOSEN}" in
    *"Bloquear"*)
        loginctl lock-session
        ;;
    *"Suspender"*)
        systemctl suspend
        ;;
    *"Encerrar"*)
        gnome-session-quit --logout --no-prompt
        ;;
    *"Reiniciar"*)
        systemctl reboot
        ;;
    *"Desligar"*)
        systemctl poweroff
        ;;
    *)
        exit 0
        ;;
esac
