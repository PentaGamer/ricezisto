# Issue 05: Configuração Modular Neovim (Catppuccin Mocha Mauve)

Status: `wontfix`
Type: `task`
Iniciativa: `rice-suite`

## Descrição

Criar pacote GNU Stow `stow/nvim` com configuração Lua limpa, rápida e estilizada para Neovim em Catppuccin Mocha Mauve.

## Critérios de Aceite

1. Instalar `neovim` e `wl-clipboard` no sistema via APT.
2. Criar `stow/nvim/.config/nvim/init.lua` com opções essenciais (números relativos, sem wrap, clipboard Wayland integrado, atalhos de Leader).
3. Paleta Catppuccin Mocha Mauve embutida diretamente em highlight groups sem dependências externas (startup < 15ms).
4. Integrar symlink no `setup.sh` e verificação no `scripts/check-status.sh`.

## Comments

- A pedido do usuário, o Neovim foi completamente desinstalado do sistema e o módulo `stow/nvim` removido do repositório para evitar ferramentas não utilizadas no dia a dia.
- O utilitário `wl-clipboard` foi mantido para integração de área de transferência no Wayland.
