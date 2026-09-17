# 🍧 Ricezisto — GNOME Desktop Rice (Catppuccin Mocha Mauve)

Um ambiente de trabalho refinado, minimalista e ergonômico construído para **GNOME 45/46+ no Wayland** (compatível com Zorin OS 18, Ubuntu 24.04+, Pop!_OS e distribuições baseadas em Debian/Ubuntu).

Baseado na paleta de cores oficial **Catppuccin Mocha** com acento **Mauve** (`#cba6f7`), gerenciamento modular via **GNU Stow**, inicialização nativa em background de ferramentas modernas (Vicinae Daemon) e rotina automática de **Backup Snapshot Preventivo** antes de qualquer alteração.

---

## ✨ Recursos e Especificações

- **Paleta de Cores**: Catppuccin Mocha (Base escura `#1e1e2e`, Superfícies `#181825` e `#313244`, Texto `#cdd6f4`).
- **Acento (Accent)**: *Mauve* (`#cba6f7`).
- **Dock Flutuante**: Dash to Dock configurada como *Floating Pill* no rodapé com *Intellihide* dinâmico, ícones em 40px, previews de múltiplas instâncias e fundo blindado translúcido com blur.
- **Efeito de Desfoque**: Blur my Shell ativo no painel superior, na dock e na visão geral de janelas (*Overview*).
- **Lançador & Menu de Energia**: **Vicinae** nativo em C++/Wayland operando com tempo de resposta imediato (daemon systemd de usuário), navegação contínua por setas, busca de arquivos/apps e menu de desligamento integrado via `vicinae dmenu`.
- **Área de Transferência**: Histórico visual do Clipboard integrado ao Vicinae via atalho direto.
- **Terminal Emulator**: **Kitty** com cantos arredondados, margens confortáveis, fonte Nerd Font e paleta Catppuccin Mocha Mauve.
- **Shell**: **Zsh** otimizado com `autosuggestions` e `syntax-highlighting` assíncronos.
- **Prompt**: **Starship** informativo, ágil e minimalista.
- **Visualizador de Áudio**: **Cava** integrado ao terminal com gradiente Catppuccin Mocha Mauve.
- **Utilitários Modernos**: `eza` (substituto moderno do `ls`), `bat` (cat com sintaxe colorida Catppuccin), `zoxide` (navegação inteligente `cd`), `fzf` e `fastfetch`.
- **Tipografia**: **Inter** (Desktop e interface) + **JetBrainsMono Nerd Font** (Terminal e editores).
- **Ícones e Cursores**: **Papirus-Dark** + **Catppuccin Mocha Mauve Cursors**.

---

## ⌨️ Atalhos de Teclado Ergonômicos

| Atalho | Ação | Componente |
| :--- | :--- | :--- |
| <kbd>Super</kbd> + <kbd>Space</kbd> | Alternar Lançador de Aplicativos | Vicinae Launcher |
| <kbd>Super</kbd> + <kbd>BackSpace</kbd> | Menu de Energia (Desligar, Reiniciar, Bloquear) | Vicinae Powermenu |
| <kbd>Super</kbd> + <kbd>V</kbd> | Histórico da Área de Transferência | Vicinae Clipboard |
| <kbd>Super</kbd> + <kbd>Return</kbd> | Abrir Terminal | Kitty |
| <kbd>Super</kbd> + <kbd>Q</kbd> | Fechar Janela em Foco | GNOME Window Manager |
| <kbd>Super</kbd> + <kbd>E</kbd> | Abrir Gerenciador de Arquivos | Nautilus |
| <kbd>Super</kbd> + <kbd>M</kbd> | Alternar Maximizar / Restaurar Janela | GNOME Window Manager |

---

## 🚀 Como Instalar em Qualquer Computador com GNOME

### Pré-requisitos
- Distribuição baseada em **Debian / Ubuntu** (Zorin OS 18, Ubuntu 24.04 LTS, Pop!_OS, Linux Mint Debian Edition, Debian 12+).
- Ambiente gráfico **GNOME 45 ou 46+** rodando em sessão **Wayland** (ou X11).
- Conexão com a internet para download de pacotes e temas.

### Instalação em 1 Passo

Abra o terminal em qualquer pasta e execute:

```bash
git clone https://github.com/<SEU_USUARIO>/ricezisto.git ~/.config/ricezisto
cd ~/.config/ricezisto
./install.sh
```

### O que o instalador unificado (`./install.sh`) faz automaticamente:
1. **Provisiona Dependências de Sistema (`sudo`)**:
   - Atualiza listas do APT e instala ferramentas essenciais (`kitty`, `zsh`, `stow`, `cava`, `eza`, `bat`, `fzf`, `zoxide`, `fonts-inter`, `papirus-icon-theme`, `wl-clipboard`, etc.).
   - Baixa e instala a fonte **JetBrainsMono Nerd Font**, o prompt **Starship** e o **Fastfetch**.
   - Baixa e instala temas GTK e cursores **Catppuccin Mocha Mauve**.
   - Baixa e registra globalmente as extensões GNOME **Dash to Dock** e **Blur my Shell**, compilando seus esquemas do GLib.
   - Baixa a release oficial do **Vicinae Launcher**, instala o binário no sistema e registra o daemon `vicinae.service` de usuário.
2. **Aplica Dotfiles e Configurações no seu Usuário**:
   - Cria um **Backup Snapshot Preventivo** em `~/.rice_backup/` de todos os arquivos existentes antes de tocar em qualquer configuração.
   - Cria links simbólicos limpos para as configurações em `~/.config/` via módulos modulares GNU Stow.
   - Habilita e inicializa o serviço `vicinae.service` no systemd do usuário.
   - Aplica os temas GTK, ícones, cursores, wallpapers e mapeamento ergonômico de atalhos no GNOME.
3. **Executa Diagnóstico Completo**:
   - Roda a suíte de verificação `scripts/check-status.sh` para garantir 100% de conformidade.

> **💡 Dica pós-instalação**: No Wayland, faça **Logout** (Encerrar Sessão) e entre novamente para que o GNOME Shell instancie todas as novas extensões e renderize o desfoque perfeitamente.

---

## 🛠️ Diagnóstico e Manutenção

O Ricezisto inclui ferramentas dedicadas para manutenção, auditoria e segurança:

### 1. Diagnóstico de Integridade
Para checar se todas as extensões, links simbólicos, daemons e atalhos continuam operando normalmente:
```bash
./scripts/check-status.sh
```

### 2. Desfazer / Restaurar Backup
Antes de aplicar qualquer modificação, o Ricezisto gera um snapshot completo do estado dos seus dotfiles e da árvore do dconf/gsettings. Se desejar reverter para o estado original:
```bash
./scripts/restore.sh
```
O script permite selecionar qualquer snapshot salvo em `~/.rice_backup/` ou restaurar automaticamente o mais recente (`latest`).

### 3. Reaplicar Configurações sem Reinstalar Dependências
Se você editar algum dotfile ou quiser reaplicar apenas a camada de usuário:
```bash
./setup.sh
```

---

## 📁 Estrutura do Repositório

```
ricezisto/
├── install.sh                  # Entrypoint principal: provisiona dependências e aplica o rice
├── setup.sh                    # Entrypoint do usuário: backup preventivo + symlinks + temas
├── stow/                       # Dotfiles modulares (GNU Stow)
│   ├── bat/                    # Configurações e tema Catppuccin para o bat
│   ├── cava/                   # Visualizador de áudio cava com gradiente mauve
│   ├── fastfetch/              # Configuração do fetch de sistema
│   ├── gtk/                    # Folha de estilo CSS (GTK3 e GTK4/libadwaita)
│   ├── kitty/                  # Configurações do terminal Kitty
│   ├── rofi/                   # Fallback powermenu legado
│   ├── starship/               # Configuração do prompt Starship
│   ├── vicinae/                # Lançador, Powermenu, Clipboard e tema Catppuccin
│   └── zsh/                    # .zshrc enxuto e de alta velocidade
├── scripts/
│   ├── install-deps.sh         # Script de instalação de dependências globais (sudo)
│   ├── apply-gnome.sh          # Configurações de extensões, wallpaper e dconf do GNOME
│   ├── apply-keybindings.sh    # Atalhos ergonômicos do teclado no GNOME
│   ├── backup.sh               # Rotina de backup snapshot preventivo
│   ├── restore.sh              # Ferramenta de restauração de backups
│   └── check-status.sh         # Diagnóstico completo de integridade
├── wallpapers/                 # Wallpapers oficiais Catppuccin Mocha
└── docs/                       # Especificações e Registros de Decisões Arquiteturais (ADRs)
```

---

## 📄 Licença
Distribuído sob a licença MIT. Sinta-se à vontade para clonar, customizar e utilizar em quantos computadores desejar!
