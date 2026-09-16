# Especificação: Ricezisto Suite (Catppuccin Mocha Mauve no GNOME 46 Wayland)

Status: `ready-for-agent`  
Data: 2026-09-15  
Autor: Antigravity + Gustavo  

---

## Problem Statement

O usuário do Zorin OS 18 (GNOME 46 sob Wayland) deseja um ambiente de trabalho altamente customizado, coeso e estético (Rice), mas o sistema operacional por padrão possui acoplamento visual às ferramentas nativas (Zorin Appearance, Zorin Taskbar), atalhos genéricos de desktop tradicional e ferramentas de terminal básicas.

Além disso, a customização direta arrisca corromper o ambiente de trabalho diário do usuário principal (`gustavo`). O ecossistema precisa de componentes modernos (launcher fluído em Wayland, utilitários CLI avançados, mapeamento ágil de janelas e coerência cromática Catppuccin Mocha com acento Mauve), mantendo total modularidade com GNU Stow e isolamento de segurança no Sandbox User (`rice`).

---

## Solution

Criar uma suíte completa e modular de componentes para o Ricezisto, distribuída em módulos independentes gerenciados pelo GNU Stow e provisionada através de rotinas idempotentes de backup e configuração:

1. **Launcher Dedicado Wayland (Rofi-Wayland)**: Menu de busca e inicialização de aplicativos, alternador de janelas ativas e powermenu, desenhados sob medida com bordas arredondadas e paleta Catppuccin Mocha Mauve.
2. **Suite CLI de Alta Produtividade**: Substituição de utilitários Unix clássicos por ferramentas modernas em Rust/Go integradas ao Zsh e ao Kitty: `eza` (substituto do ls com ícones), `bat` (substituto do cat com syntax highlight), `fzf` (buscador fuzzy interativo estilizado) e `zoxide` (navegador inteligente de diretórios).
3. **Mapeamento Ágil de Atalhos de Teclado**: Configuração no GNOME de atalhos ergonômicos inspirados em gerenciadores de janela lado a lado (Tiling WMs): `Super + Return` para Kitty, `Super + Space` para Rofi, `Super + Q` para fechar janelas e `Super + E` para arquivos.
4. **Harmonização de Editores (Neovim & VS Code)**: Configurações modulares de Neovim e extensões/temas do VS Code sincronizados com a tipografia JetBrainsMono Nerd Font e paleta Catppuccin Mocha Mauve.
5. **Multimídia & Visualização no Terminal**: Integração do visualizador de ondas sonoras `cava` no Kitty com gradiente Mauve e controles de reprodução com `playerctl`.

---

## User Stories

1. Como usuário do ambiente, quero um lançador de aplicativos acessível via `Super + Space` com estilo Catppuccin Mocha Mauve, para encontrar e abrir programas instantaneamente sem abrir a visão geral do GNOME.
2. Como usuário do ambiente, quero que o lançador permita alternar entre janelas abertas de maneira rápida pelo teclado, para agilizar a navegação multitarefa.
3. Como usuário do ambiente, quero um menu de energia (powermenu) em tela para suspender, reiniciar, desligar ou bloquear a sessão de forma prática e estilizada.
4. Como desenvolvedor no terminal, quero usar `eza` no lugar de `ls` com suporte automático a ícones Nerd Font, permissões legíveis e exibição em árvore, para visualizar meus arquivos com clareza.
5. Como desenvolvedor no terminal, quero usar `bat` com o tema Catppuccin Mocha embutido ao visualizar arquivos de código, para obter realce de sintaxe sem precisar abrir um editor.
6. Como desenvolvedor no terminal, quero navegar rapidamente pelo histórico e pela árvore de arquivos usando `fzf` com cores coordenadas ao tema do terminal Kitty, para encontrar arquivos e comandos sem digitação repetitiva.
7. Como usuário frequente de linha de comando, quero que o comando `cd` seja aprimorado com `zoxide`, para pular diretamente para diretórios mais acessados com poucas letras.
8. Como usuário com fluxo de trabalho ágil, quero abrir uma nova janela do terminal Kitty instantaneamente através de `Super + Return`, mantendo a fluidez de trabalho sem recorrer ao mouse.
9. Como usuário com fluxo de trabalho ágil, quero fechar janelas ativas com `Super + Q`, para agilizar o encerramento de aplicações de forma consistente.
10. Como programador, quero abrir o Neovim com um arquivo ou projeto e encontrar uma interface elegante com tema Catppuccin Mocha Mauve, barra de status Lualine e suporte a LSP, para editar código com alta legibilidade.
11. Como usuário que escuta música enquanto trabalha, quero executar o `cava` no terminal Kitty com as cores Mauve para ter um visualizador de áudio dinâmico e agradável.
12. Como usuário na conta Sandbox (`rice`), quero que todas essas novas ferramentas sejam testadas e homologadas de forma independente, sem afetar ou alterar arquivos na conta principal (`gustavo`).
13. Como mantenedor do repositório, quero que todas as novas configurações residam em módulos do GNU Stow (`stow/rofi`, `stow/cava`, `stow/nvim`, etc.), para que possam ser instaladas ou desinstaladas modularmente.
14. Como usuário migrando para o perfil principal, quero que o script `./setup.sh` execute um Backup Snapshot completo antes de linkar os novos dotfiles, para que qualquer reversão futura seja imediata e sem riscos.

---

## Implementation Decisions

### 1. Pacote Stow: `stow/rofi`
- **Módulo**: `stow/rofi/.config/rofi/`
- **Componentes**:
  - `config.rasi`: Configuração global de fontes, ícones, dimensões e comportamento do launcher.
  - `catppuccin-mocha.rasi`: Definição estrita das cores Catppuccin Mocha Mauve.
  - `powermenu.sh`: Script de invocação do menu de energia integrado ao Rofi.
- **Binário do Sistema**: Pacote `rofi-wayland` via repositório APT ou compilação local com suporte nativo ao Wayland compositor.

### 2. Pacote Stow: `stow/cli-tools`
- **Módulo**: Complementação do `stow/zsh/.zshrc` e arquivos de apoio em `stow/bat/` e `stow/eza/`.
- **Aliases Definidos**:
  - `ls` -> `eza --icons --group-directories-first`
  - `ll` -> `eza -la --icons --group-directories-first --git`
  - `tree` -> `eza --tree --icons`
  - `cat` -> `batcat --paging=never` (ou `bat`)
  - `cd` -> inicialização do `zoxide` integrado ao Zsh.
- **Cores FZF**: Exportação das variáveis de ambiente `FZF_DEFAULT_OPTS` com paleta Catppuccin Mocha Mauve no `.zshrc`.

### 3. Integração de Atalhos no GNOME Shell
- Script dedicado ou expansão do `scripts/apply-gnome.sh` para registrar atalhos personalizados via `gsettings org.gnome.settings-daemon.plugins.media-keys`:
  - `custom0`: Terminal Kitty (`Super + Return` -> `kitty`)
  - `custom1`: Rofi Launcher (`Super + space` -> `rofi -show drun`)
  - `custom2`: Rofi Powermenu (`Super + BackSpace` -> `~/.config/rofi/powermenu.sh`)
  - Atalho nativo de fechamento: `gsettings set org.gnome.desktop.wm.keybindings close "['<Super>q', '<Alt>F4']"`

### 4. Pacote Stow: `stow/nvim`
- **Módulo**: `stow/nvim/.config/nvim/`
- Estrutura baseada em Lua leve:
  - `init.lua`
  - Tema `catppuccin-mocha` com `flavour = "mocha"`, acento `mauve`.
  - Configurações de indentação, números relativos e fontes Nerd Font.

### 5. Pacote Stow: `stow/cava`
- **Módulo**: `stow/cava/.config/cava/config`
- Gradiente de cores:
  - `gradient_color_1 = '#cba6f7'` (Mauve)
  - `gradient_color_2 = '#b4befe'` (Lavender)
  - `gradient_color_3 = '#89b4fa'` (Blue)
  - `gradient_color_4 = '#74c7ec'` (Sapphire)

---

## Testing Decisions

### Seams de Teste e Validação
1. **Seam de Links Simbólicos e Estrutura**:
   - O script `scripts/check-status.sh` será expandido para verificar a integridade dos links de `rofi`, `cava` e aliases no shell.
2. **Seam de Executáveis e Pacotes**:
   - Verificação determinística da presença dos comandos `rofi`, `eza`, `bat`, `fzf`, `zoxide` e `cava` no PATH do usuário `rice`.
3. **Seam D-Bus / GNOME Keybindings**:
   - Leitura direta via `gsettings get` das chaves de atalhos personalizados criadas para confirmar vinculação às ações esperadas.
4. **Homologação Visual Interativa no Sandbox User**:
   - Teste interativo acionando `Super + Return`, `Super + Space` e executando comandos de terminal dentro da sessão gráfica do usuário `rice`.
