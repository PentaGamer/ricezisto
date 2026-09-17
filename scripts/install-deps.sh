#!/usr/bin/env bash
# ==============================================================================
# Ricezisto - System Dependencies & Provisioning Script
# Executar com: sudo ./scripts/install-deps.sh [--with-sandbox]
# ==============================================================================
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
    echo "Erro: Este script instala pacotes de sistema e deve ser executado com sudo:" >&2
    echo "  sudo $0" >&2
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "${SCRIPT_DIR}")"

echo "=============================================================================="
echo "         INSTALANDO DEPENDÊNCIAS DO SISTEMA (RICEZISTO - GNOME)               "
echo "=============================================================================="

# 1. Atualizar e instalar pacotes APT essenciais
echo ""
echo "[1/8] Instalando pacotes APT essenciais..."
apt-get update -y
apt-get install -y \
    stow \
    kitty \
    zsh \
    zsh-autosuggestions \
    zsh-syntax-highlighting \
    fonts-inter \
    papirus-icon-theme \
    gnome-shell-extensions \
    curl \
    wget \
    git \
    unzip \
    tar \
    xz-utils \
    libglib2.0-bin \
    bat \
    fzf \
    zoxide \
    eza \
    rofi \
    cava \
    wl-clipboard

# Garantir symlink para invocação do bat
if [ -f "/usr/bin/batcat" ] && [ ! -f "/usr/local/bin/bat" ]; then
    ln -sf /usr/bin/batcat /usr/local/bin/bat
fi

# 2. Instalar Starship Prompt
echo ""
echo "[2/8] Instalando Starship Prompt..."
if ! command -v starship >/dev/null 2>&1; then
    curl -sS https://starship.rs/install.sh | sh -s -- --yes
else
    echo "  -> Starship já instalado."
fi

# 3. Instalar Fastfetch
echo ""
echo "[3/8] Instalando Fastfetch..."
if ! command -v fastfetch >/dev/null 2>&1; then
    TEMP_DIR=$(mktemp -d)
    echo "  -> Baixando pacote DEB do Fastfetch..."
    FASTFETCH_URL=$(curl -sL https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest | grep "browser_download_url.*linux-amd64\.deb" | cut -d '"' -f 4 | head -n 1)
    if [ -n "${FASTFETCH_URL}" ]; then
        curl -sL "${FASTFETCH_URL}" -o "${TEMP_DIR}/fastfetch.deb"
        dpkg -i "${TEMP_DIR}/fastfetch.deb" || apt-get install -f -y
    fi
    rm -rf "${TEMP_DIR}"
else
    echo "  -> Fastfetch já instalado."
fi

# 4. Instalar JetBrainsMono Nerd Font
echo ""
echo "[4/8] Instalando JetBrainsMono Nerd Font..."
FONT_DIR="/usr/local/share/fonts/JetBrainsMono"
if [ ! -d "${FONT_DIR}" ]; then
    mkdir -p "${FONT_DIR}"
    echo "  -> Baixando fontes JetBrainsMono..."
    curl -sL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz" | tar -xJ -C "${FONT_DIR}"
    fc-cache -f
else
    echo "  -> JetBrainsMono Nerd Font já presente."
fi

# 5. Instalar Temas e Cursores Catppuccin
echo ""
echo "[5/8] Instalando temas GTK e Cursores Catppuccin..."
# Cursores
CURSOR_DIR="/usr/share/icons/Catppuccin-Mocha-Mauve-Cursors"
if [ ! -d "${CURSOR_DIR}" ]; then
    TEMP_DIR=$(mktemp -d)
    echo "  -> Baixando cursores Catppuccin Mocha Mauve..."
    curl -sL "https://github.com/catppuccin/cursors/releases/download/v2.0.0/catppuccin-mocha-mauve-cursors.zip" -o "${TEMP_DIR}/cursors.zip"
    unzip -q "${TEMP_DIR}/cursors.zip" -d /usr/share/icons/ || true
    rm -rf "${TEMP_DIR}"
fi

# Tema GTK
THEME_DIR="/usr/share/themes/Catppuccin-Mocha-Standard-Mauve-Dark"
if [ ! -d "${THEME_DIR}" ]; then
    TEMP_DIR=$(mktemp -d)
    echo "  -> Baixando tema GTK Catppuccin Mocha Mauve..."
    curl -sL "https://github.com/catppuccin/gtk/releases/download/v1.0.3/catppuccin-mocha-mauve-standard+default.zip" -o "${TEMP_DIR}/theme.zip"
    unzip -q "${TEMP_DIR}/theme.zip" -d /usr/share/themes/ || true
    rm -rf "${TEMP_DIR}"
fi

# 6. Instalar Extensões GNOME (Blur my Shell e Dash to Dock)
echo ""
echo "[6/8] Instalando extensões GNOME globais..."
BLUR_DIR="/usr/share/gnome-shell/extensions/blur-my-shell@aunetx"
if [ ! -d "${BLUR_DIR}" ]; then
    TEMP_DIR=$(mktemp -d)
    mkdir -p "${BLUR_DIR}"
    echo "  -> Baixando Blur my Shell..."
    curl -sL "https://github.com/aunetx/blur-my-shell/releases/download/v72/blur-my-shell%40aunetx.shell-extension.zip" -o "${TEMP_DIR}/blur.zip"
    unzip -q "${TEMP_DIR}/blur.zip" -d "${BLUR_DIR}" || true
    glib-compile-schemas "${BLUR_DIR}/schemas" 2>/dev/null || true
    rm -rf "${TEMP_DIR}"
else
    echo "  -> Blur my Shell já instalado."
fi

DOCK_DIR="/usr/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com"
if [ ! -d "${DOCK_DIR}" ]; then
    TEMP_DIR=$(mktemp -d)
    mkdir -p "${DOCK_DIR}"
    echo "  -> Baixando Dash to Dock..."
    DOCK_URL=$(curl -sL https://api.github.com/repos/micheleg/dash-to-dock/releases/latest | grep "browser_download_url.*dash-to-dock.*\.zip" | cut -d '"' -f 4 | head -n 1)
    if [ -n "${DOCK_URL}" ]; then
        curl -sL "${DOCK_URL}" -o "${TEMP_DIR}/dock.zip"
        unzip -q "${TEMP_DIR}/dock.zip" -d "${DOCK_DIR}" || true
        glib-compile-schemas "${DOCK_DIR}/schemas" 2>/dev/null || true
    fi
    rm -rf "${TEMP_DIR}"
else
    echo "  -> Dash to Dock já instalado."
fi

# 7. Instalar Vicinae Launcher & Systemd User Service
echo ""
echo "[7/8] Instalando Vicinae Launcher..."
if ! command -v vicinae >/dev/null 2>&1; then
    TEMP_DIR=$(mktemp -d)
    echo "  -> Baixando Vicinae Release do GitHub..."
    VICINAE_URL=$(curl -sL https://api.github.com/repos/vicinaehq/vicinae/releases/latest | grep "browser_download_url.*linux-x86_64.*\.tar\.gz" | cut -d '"' -f 4 | head -n 1)
    if [ -n "${VICINAE_URL}" ]; then
        curl -sL "${VICINAE_URL}" -o "${TEMP_DIR}/vicinae.tar.gz"
        mkdir -p /usr/local/lib/vicinae
        tar -xzf "${TEMP_DIR}/vicinae.tar.gz" -C /usr/local/lib/vicinae/ --strip-components=1
        ln -sf /usr/local/lib/vicinae/bin/vicinae /usr/local/bin/vicinae
        if [ -d "/usr/local/lib/vicinae/share/applications" ]; then
            cp -ru /usr/local/lib/vicinae/share/applications/* /usr/share/applications/ 2>/dev/null || true
        fi
        if [ -d "/usr/local/lib/vicinae/share/icons" ]; then
            cp -ru /usr/local/lib/vicinae/share/icons/* /usr/share/icons/ 2>/dev/null || true
        fi
        echo "  -> Binário Vicinae instalado em /usr/local/bin/vicinae"
    fi
    rm -rf "${TEMP_DIR}"
else
    echo "  -> Vicinae já instalado ($(command -v vicinae))."
fi

# Garantir unidade de serviço do Vicinae
mkdir -p /usr/local/lib/systemd/user
cat << 'EOF' > /usr/local/lib/systemd/user/vicinae.service
[Unit]
Description=Vicinae Launcher Daemon
Documentation=https://docs.vicinae.com
After=graphical-session.target
Requires=dbus.socket
PartOf=graphical-session.target

[Service]
Type=simple
ExecStart=/usr/local/bin/vicinae server --replace
ExecReload=/bin/kill -HUP $MAINPID
Restart=always
RestartSec=60
KillMode=process

[Install]
WantedBy=graphical-session.target
EOF

# 8. Modo Sandbox Opcional (se fornecido --with-sandbox)
echo ""
echo "[8/8] Finalizando provisionamento de dependências..."
if [ "${1:-}" = "--with-sandbox" ]; then
    echo "  -> Provisionando usuário sandbox 'rice'..."
    if ! id "rice" >/dev/null 2>&1; then
        useradd -m -s /bin/zsh -G sudo,video,render rice
        echo "rice:rice123" | chpasswd
        echo "  -> Usuário 'rice' criado com senha: rice123"
    fi
    RICE_HOME="/home/rice"
    RICE_REPO="${RICE_HOME}/ricezisto"
    rm -rf "${RICE_REPO}"
    cp -a "${REPO_DIR}" "${RICE_REPO}"
    chown -R rice:rice "${RICE_HOME}"
    echo "  -> Repositório clonado e ajustado em ${RICE_REPO}"
fi

echo ""
echo "=============================================================================="
echo "          DEPENDÊNCIAS DO SISTEMA INSTALADAS COM SUCESSO! 🎉                  "
echo "=============================================================================="
