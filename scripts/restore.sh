#!/usr/bin/env bash
# ==============================================================================
# Ricezisto - Restore Snapshot Utility
# ==============================================================================
set -euo pipefail

BACKUP_ROOT="${HOME}/.rice_backup"

if [ ! -d "${BACKUP_ROOT}" ]; then
    echo "Erro: Nenhum diretório de backup encontrado em ${BACKUP_ROOT}" >&2
    exit 1
fi

TARGET_DIR="${1:-}"

if [ -z "${TARGET_DIR}" ]; then
    if [ -e "${BACKUP_ROOT}/latest" ]; then
        TARGET_DIR=$(readlink -f "${BACKUP_ROOT}/latest")
        echo "==> Utilizando snapshot mais recente: ${TARGET_DIR}"
    else
        echo "Uso: $0 <caminho_do_snapshot>"
        echo "Snapshots disponíveis:"
        ls -d "${BACKUP_ROOT}"/snapshot_* 2>/dev/null || true
        exit 1
    fi
fi

if [ ! -d "${TARGET_DIR}" ]; then
    echo "Erro: Snapshot '${TARGET_DIR}' não existe." >&2
    exit 1
fi

echo "==> [Ricezisto Restore] Restaurando arquivos a partir de: ${TARGET_DIR}"

# 1. Restaurar dconf se presente
if [ -f "${TARGET_DIR}/dconf_backup.ini" ] && command -v dconf >/dev/null 2>&1; then
    echo "  -> Restaurando chaves do dconf/gsettings..."
    dconf load / < "${TARGET_DIR}/dconf_backup.ini" || true
fi

# 2. Restaurar arquivos salvos
FILES=(
    ".zshrc"
    ".bashrc"
    ".config/kitty"
    ".config/starship.toml"
    ".config/fastfetch"
    ".config/gtk-3.0/gtk.css"
    ".config/gtk-4.0/gtk.css"
)

for rel_path in "${FILES[@]}"; do
    backup_file="${TARGET_DIR}/${rel_path}"
    target_dest="${HOME}/${rel_path}"
    if [ -e "${backup_file}" ]; then
        echo "  -> Restaurando ~/${rel_path}"
        mkdir -p "$(dirname "${target_dest}")"
        rm -rf "${target_dest}"
        cp -a "${backup_file}" "${target_dest}"
    fi
done

echo "==> [Ricezisto Restore] Restauração finalizada com sucesso!"
