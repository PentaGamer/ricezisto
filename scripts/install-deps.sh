#!/usr/bin/env bash
# ==============================================================================
# Ricezisto - System Dependencies & Sandbox Provisioning Script
# Executar com: sudo ./scripts/install-deps.sh
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
echo "          INSTALANDO DEPENDÊNCIAS DO SISTEMA E PROVISIONANDO SANDBOX          "
echo "=============================================================================="

# 1. Atualizar e instalar pacotes APT essenciais
echo ""
echo "[1/7] Instalando pacotes APT..."
apt-get update -y
apt-get install -y \
    stow \
    kitty \
    zsh \
    zsh-autosuggestions \
    zsh-syntax-highlighting \
    fonts-inter \
    papirus-icon-theme \
    curl \
    wget \
    git \
    unzip \
    tar \
    xz-utils \
    libglib2.0-bin

# 2. Instalar Starship Prompt
echo ""
echo "[2/7] Instalando Starship Prompt..."
if ! command -v starship >/dev/null 2>&1; then
    curl -sS https://starship.rs/install.sh | sh -s -- --yes
else
    echo "  -> Starship já instalado."
fi

# 3. Instalar Fastfetch
echo ""
echo "[3/7] Instalando Fastfetch..."
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
echo "[4/7] Instalando JetBrainsMono Nerd Font..."
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
echo "[5/7] Instalando temas GTK e Cursores Catppuccin..."
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

# 6. Instalar Extensão Blur my Shell globalmente
echo ""
echo "[6/7] Instalando extensão Blur my Shell..."
EXT_DIR="/usr/share/gnome-shell/extensions/blur-my-shell@aunetx"
if [ ! -d "${EXT_DIR}" ]; then
    TEMP_DIR=$(mktemp -d)
    mkdir -p "${EXT_DIR}"
    curl -sL "https://github.com/aunetx/blur-my-shell/releases/download/v72/blur-my-shell%40aunetx.shell-extension.zip" -o "${TEMP_DIR}/blur.zip"
    unzip -q "${TEMP_DIR}/blur.zip" -d "${EXT_DIR}" || true
    glib-compile-schemas "${EXT_DIR}/schemas" 2>/dev/null || true
    rm -rf "${TEMP_DIR}"
fi

# 7. Criar e Provisionar o Usuário Sandbox 'rice'
echo ""
echo "[7/7] Configurando usuário sandbox 'rice'..."
if ! id "rice" >/dev/null 2>&1; then
    echo "  -> Criando usuário 'rice'..."
    useradd -m -s /bin/zsh -G sudo,video,render rice
    echo "rice:rice123" | chpasswd
    echo "  -> Usuário 'rice' criado com senha inicial: rice123"
else
    echo "  -> Usuário 'rice' já existe."
fi

# Garantir acesso ao repositório dentro da home do rice
RICE_HOME="/home/rice"
RICE_REPO="${RICE_HOME}/ricezisto"

echo "  -> Sincronizando repositório ricezisto em ${RICE_REPO}..."
rm -rf "${RICE_REPO}"
cp -a "${REPO_DIR}" "${RICE_REPO}"
chown -R rice:rice "${RICE_HOME}"

echo ""
echo "=============================================================================="
echo "          PROVISIONAMENTO DO SISTEMA CONCLUÍDO COM SUCESSO! 🎉                "
echo "=============================================================================="
echo "Próximos passos:"
echo "  1. Para rodar o setup na conta rice imediatamente via terminal:"
echo "       sudo -u rice bash -c 'cd /home/rice/ricezisto && ./setup.sh'"
echo "  2. Para testar o ambiente visual completo:"
echo "       Faça 'Trocar Usuário' no Zorin OS e entre na conta 'rice' (senha: rice123)"
echo "=============================================================================="
