# 🍧 Ricezisto — Zorin OS 18 + GNOME 46 (Catppuccin Mocha Mauve)

Ambiente de customização e modularização estética (**rice**) construído sob medida para o **Zorin OS 18.1 (GNOME 46 no Wayland)** com isolamento em usuário sandbox (`rice`), gerenciamento modular via **GNU Stow** e rotina obrigatória de **Backup Snapshot** preventivo.

---

## 🎨 Especificações Visuais

- **Paleta de Cores**: Catppuccin Mocha (fundo escuro `#1e1e2e`, superfícies `#181825` e `#313244`)
- **Cor de Destaque (Accent)**: *Mauve* (`#cba6f7`)
- **Desktop Shell**: GNOME 46 desacoplado do Zorin Taskbar, utilizando **Floating Pill Dock** (*Dash to Dock*) + **Blur my Shell**
- **Terminal Emulator**: **Kitty** com cantos arredondados, padding suave e transparência com blur
- **Shell**: **Zsh** ultrarrápido com plugins essenciais assíncronos (`autosuggestions` e `syntax-highlighting`)
- **Prompt**: **Starship** com tema Catppuccin Mocha Mauve
- **Fetch CLI**: **Fastfetch** customizado com símbolos Nerd Font
- **Tipografia**: **Inter** (Interface/Desktop) + **JetBrainsMono Nerd Font** (Terminal/Código)
- **Tema de Ícones & Cursor**: **Papirus-Dark** + **Catppuccin Mocha Mauve Cursors**

---

## 📁 Arquitetura do Repositório

```
ricezisto/
├── CONTEXT.md                    # Glossário de termos canônicos do domínio
├── docs/adr/                     # Registros de decisões arquiteturais (ADRs)
│   ├── 0001-sandbox-user-and-stow-with-backups.md
│   └── 0002-catppuccin-mocha-mauve-gnome-composition.md
├── scripts/
│   ├── install-deps.sh           # Instala pacotes do sistema (sudo) e cria usuário 'rice'
│   ├── backup.sh                 # Gera snapshot preventivo em ~/.rice_backup
│   ├── restore.sh                # Restaura um snapshot específico ou o mais recente
│   └── apply-gnome.sh            # Configura extensões, dock, blur e atalhos GNOME
├── stow/                         # Pacotes modulares gerenciados pelo GNU Stow
│   ├── kitty/                    # Configurações do terminal Kitty
│   ├── zsh/                      # .zshrc leve e veloz
│   ├── starship/                 # Prompt Starship
│   ├── fastfetch/                # Configuração do Fastfetch
│   └── gtk/                      # Cores Catppuccin para GTK3 e GTK4/libadwaita
├── wallpapers/                   # Coleção de wallpapers oficiais Catppuccin Mocha
└── setup.sh                      # Entrypoint do usuário (Backup + Stow + GNOME)
```

---

## 🚀 Como Executar

### 1. Provisionar o Sistema e Criar o Usuário de Testes
Como envolve instalação de pacotes `apt`, fontes no sistema e criação da conta de usuário, execute com `sudo`:

```bash
sudo ./scripts/install-deps.sh
```

Esse comando irá:
1. Instalar os pacotes necessários (`stow`, `kitty`, `zsh`, `fonts-inter`, `papirus-icon-theme`, etc.).
2. Instalar **Starship**, **Fastfetch** e a **JetBrainsMono Nerd Font**.
3. Baixar os temas e cursores **Catppuccin Mocha Mauve** e a extensão **Blur my Shell**.
4. Criar o usuário `rice` com senha temporária `rice123` e permissão `sudo`.
5. Clonar o repositório em `/home/rice/ricezisto`.

---

### 2. Aplicar as Configurações no Usuário Sandbox (`rice`)
Você pode rodar o setup imediatamente na conta `rice` via terminal:

```bash
sudo -u rice bash -c "cd /home/rice/ricezisto && ./setup.sh"
```

---

### 3. Testar a Sessão Gráfica
1. Clique no canto superior direito da tela do Zorin OS (menu de energia/status).
2. Selecione **Trocar de Usuário** (ou **Encerrar Sessão**).
3. Selecione o usuário **`rice`** e digite a senha: `rice123`.
4. Você entrará na sessão completa do rice (Floating Dock, Blur my Shell, Kitty terminal, Starship prompt e wallpapers).

---

### 4. Ajustes Dinâmicos

- **Alternar entre Modo Orgânico (com animações sutis do Zorin) e Modo Limpo (vanilla):**
  ```bash
  ./scripts/apply-gnome.sh clean    # Sem efeitos de física
  ./scripts/apply-gnome.sh effects  # Com lâmpada mágica e janelas suaves
  ```

---

### 5. Migrar para o Usuário Principal (`gustavo`)
Assim que você validar que o rice na conta `rice` está 100% do seu agrado:

1. Retorne à sua sessão com o usuário `gustavo`.
2. Execute o `setup.sh` diretamente no seu usuário:
   ```bash
   ./setup.sh
   ```
3. O script criará automaticamente um **Backup Snapshot** completo de todas as suas configurações atuais antes de aplicar qualquer alteração.

---

### 6. Desfazer / Restaurar
Se por qualquer motivo quiser reverter qualquer alteração feita no seu usuário:

```bash
./scripts/restore.sh
```
Ele restaurará instantaneamente os arquivos de configuração e chaves do dconf a partir do último snapshot seguro.
