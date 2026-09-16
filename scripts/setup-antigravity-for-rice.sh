#!/usr/bin/env bash
# ==============================================================================
# Ricezisto - Enable Antigravity on Sandbox User (rice)
# Executar com: sudo ./scripts/setup-antigravity-for-rice.sh
# ==============================================================================
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
    echo "Erro: Execute este script com sudo para configurar o Antigravity no usuário 'rice':" >&2
    echo "  sudo $0" >&2
    exit 1
fi

echo "=============================================================================="
echo "         CONFIGURANDO ANTIGRAVITY CLI NO USUÁRIO SANDBOX ('rice')             "
echo "=============================================================================="

# 1. Disponibilizar o binário do Antigravity globalmente
echo ""
echo "[1/5] Instalando executável 'agy' em /usr/local/bin..."
if [ -f "/home/gustavo/.local/bin/agy" ]; then
    cp -f "/home/gustavo/.local/bin/agy" /usr/local/bin/agy
    chmod 755 /usr/local/bin/agy
    echo "  -> /usr/local/bin/agy instalado e executável por qualquer usuário."
else
    echo "  -> Binário agy não encontrado em /home/gustavo/.local/bin/agy"
fi

# 2. Copiar configurações, autenticação e plugins para o rice
echo ""
echo "[2/5] Configurando ambiente ~/.gemini e ~/.agents no usuário 'rice'..."
mkdir -p /home/rice/.gemini /home/rice/.local/bin
if [ -d "/home/gustavo/.gemini" ]; then
    cp -a /home/gustavo/.gemini/* /home/rice/.gemini/ 2>/dev/null || true
    echo "  -> Configurações e tokens de autenticação copiados para /home/rice/.gemini"
fi

if [ -d "/home/gustavo/.agents" ]; then
    cp -a /home/gustavo/.agents /home/rice/
    echo "  -> Skills e agentes copiados para /home/rice/.agents"
fi

# 3. Sincronizar o repositório ricezisto
echo ""
echo "[3/5] Sincronizando repositório ricezisto para /home/rice/ricezisto..."
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
rm -rf /home/rice/ricezisto
cp -a "${REPO_DIR}" /home/rice/ricezisto
echo "  -> Repositório atualizado em /home/rice/ricezisto"

# 4. Instalar Dash to Dock e schemas para o rice
echo ""
echo "[4/5] Instalando extensões e schemas para o usuário 'rice'..."
GUSTAVO_DOCK="/home/gustavo/.local/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com"
if [ -d "${GUSTAVO_DOCK}" ]; then
    # Sistema
    mkdir -p "/usr/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com"
    cp -ru "${GUSTAVO_DOCK}"/* "/usr/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/" 2>/dev/null || true
    
    # Usuário rice
    mkdir -p "/home/rice/.local/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com"
    cp -ru "${GUSTAVO_DOCK}"/* "/home/rice/.local/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/" 2>/dev/null || true
    echo "  -> Dash to Dock copiada para o perfil do rice."
fi

mkdir -p /home/rice/.local/share/glib-2.0/schemas
if [ -d "/usr/share/gnome-shell/extensions/blur-my-shell@aunetx/schemas" ]; then
    cp -ru /usr/share/gnome-shell/extensions/blur-my-shell@aunetx/schemas/*.xml /home/rice/.local/share/glib-2.0/schemas/ 2>/dev/null || true
fi
if [ -d "${GUSTAVO_DOCK}/schemas" ]; then
    cp -ru "${GUSTAVO_DOCK}/schemas/"*.xml /home/rice/.local/share/glib-2.0/schemas/ 2>/dev/null || true
fi
glib-compile-schemas /home/rice/.local/share/glib-2.0/schemas/ 2>/dev/null || true

# 5. Ajustar permissões para o rice
echo ""
echo "[5/5] Ajustando permissões de /home/rice para o usuário 'rice'..."
chown -R rice:rice /home/rice

echo ""
echo "=============================================================================="
echo "🎉 TUDO PRONTO! O ANTIGRAVITY AGORA ESTÁ DISPONÍVEL NA CONTA 'rice'!"
echo "=============================================================================="
echo "Passo a passo para usar:"
echo "  1. Faça 'Trocar de Usuário' no Zorin OS e entre na conta 'rice' (senha: rice123)"
echo "  2. Abra o terminal na sessão do 'rice' e execute:"
echo "       cd ~/ricezisto && agy"
echo ""
echo "O Antigravity vai iniciar normalmente e poderá interagir, testar e ajustar o rice"
echo "diretamente de dentro da conta de testes com você acompanhando tudo em tempo real!"
echo "=============================================================================="
