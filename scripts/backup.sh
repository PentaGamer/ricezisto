#!/usr/bin/env bash
# ==============================================================================
# Ricezisto - Backup Snapshot Utility
# ==============================================================================
set -euo pipefail

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_ROOT="${HOME}/.rice_backup"
SNAPSHOT_DIR="${BACKUP_ROOT}/snapshot_${TIMESTAMP}"
LATEST_LINK="${BACKUP_ROOT}/latest"

echo "==> [Ricezisto Backup] Iniciando snapshot de segurança em: ${SNAPSHOT_DIR}"
mkdir -p "${SNAPSHOT_DIR}"

# 1. Exportar configurações do GNOME (dconf)
if command -v dconf >/dev/null 2>&1; then
    echo "  -> Exportando estado atual do dconf/gsettings..."
    dconf dump / > "${SNAPSHOT_DIR}/dconf_backup.ini" || true
fi

# 2. Salvar arquivos de configuração existentes que possam ser afetados
PATHS_TO_BACKUP=(
    ".zshrc"
    ".bashrc"
    ".config/kitty"
    ".config/starship.toml"
    ".config/fastfetch"
    ".config/gtk-3.0/gtk.css"
    ".config/gtk-4.0/gtk.css"
    ".local/share/gnome-shell/extensions"
)

for rel_path in "${PATHS_TO_BACKUP[@]}"; do
    src_path="${HOME}/${rel_path}"
    if [ -e "${src_path}" ] || [ -L "${src_path}" ]; then
        dest_dir="${SNAPSHOT_DIR}/$(dirname "${rel_path}")"
        mkdir -p "${dest_dir}"
        # Se for link simbólico ou arquivo normal, faz cópia recursiva
        cp -a "${src_path}" "${dest_dir}/"
        echo "  -> Backup: ~/${rel_path}"
    fi
done

# 3. Criar manifesto do snapshot
cat <<EOF > "${SNAPSHOT_DIR}/MANIFEST.txt"
Ricezisto Backup Snapshot
Data: $(date)
Usuário: ${USER}
Host: $(hostname)
Diretório: ${SNAPSHOT_DIR}
EOF

# 4. Atualizar link simbólico 'latest'
rm -f "${LATEST_LINK}"
ln -s "${SNAPSHOT_DIR}" "${LATEST_LINK}"

echo "==> [Ricezisto Backup] Snapshot concluído com sucesso!"
echo "    Localização: ${SNAPSHOT_DIR}"
echo "    Atalho: ${LATEST_LINK}"
