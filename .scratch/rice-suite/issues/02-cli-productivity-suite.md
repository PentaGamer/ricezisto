# Issue 02: Suite de Utilitários CLI Modernos & Zsh Integration

Status: `ready-for-agent`
Type: `task`
Iniciativa: `rice-suite`

## Descrição

Configurar e integrar ferramentas de linha de comando modernas com paleta Catppuccin Mocha Mauve ao shell Zsh no terminal Kitty.

## Critérios de Aceite

1. Instalar `eza`, `bat`, `fzf`, `zoxide` nas dependências do sistema.
2. Atualizar o `stow/zsh/.zshrc` com aliases ergonômicos (`ls -> eza`, `cat -> bat`, `cd -> z`).
3. Configurar variáveis `FZF_DEFAULT_OPTS` com paleta Catppuccin Mocha Mauve.
4. Testar funcionamento e velocidade do shell interativo.
