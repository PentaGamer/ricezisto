# Issue 05: Configuração Modular Neovim (Catppuccin Mocha Mauve)

Status: `ready-for-agent`
Type: `task`
Iniciativa: `rice-suite`

## Descrição

Criar pacote GNU Stow `stow/nvim` com configuração Lua limpa, rápida e estilizada para Neovim em Catppuccin Mocha Mauve.

## Critérios de Aceite

1. Criar `stow/nvim/.config/nvim/init.lua` com opções de UI limpas (números relativos, sem wrap, cursor shape).
2. Configurar tema Catppuccin Mocha com `flavour = "mocha"`.
3. Validar carregamento no terminal Kitty sem erros de plugin ou atraso de inicialização.
