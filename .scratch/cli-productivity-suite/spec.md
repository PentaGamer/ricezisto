# Especificação: Suite de Utilitários CLI Modernos & Zsh Integration

Status: `ready-for-agent`
Parent: `.scratch/rice-suite/issues/02-cli-productivity-suite.md`

## Problem Statement
O terminal padrão no Zorin OS utiliza ferramentas Unix antigas (`ls`, `cat`, `cd`) que não aproveitam ícones Nerd Font, não possuem realce de sintaxe na visualização de arquivos e não oferecem busca fuzzy inteligente, limitando a ergonomia e a coerência estética com o tema Catppuccin Mocha Mauve.

## Solution
Integrar a suite moderna de ferramentas CLI (`eza`, `bat`, `fzf`, `zoxide`) ao terminal Kitty e ao shell Zsh, estendendo o pacote `stow/zsh` com cores Catppuccin Mocha Mauve e aliases modernos sem comprometer o tempo de inicialização instantâneo do shell.
