#!/usr/bin/env bash
# ==============================================================================
# Ricezisto - Vicinae Clipboard History Toggle
# ==============================================================================
set -euo pipefail

# Se a janela do Vicinae já estiver aberta, fecha
if /usr/local/bin/vicinae state open >/dev/null 2>&1; then
    /usr/local/bin/vicinae close
else
    /usr/local/bin/vicinae cmd launch clipboard:history
fi
