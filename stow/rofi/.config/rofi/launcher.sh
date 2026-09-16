#!/usr/bin/env bash
# ==============================================================================
# Ricezisto - Rofi Launcher Entrypoint
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec python3 "${SCRIPT_DIR}/rofi-wrapper.py" rofi -show drun "$@"
