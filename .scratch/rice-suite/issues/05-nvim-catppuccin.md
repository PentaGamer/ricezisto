# Issue 05: Configuração Modular Neovim (Catppuccin Mocha Mauve)

Status: `resolved`
Type: `task`
Iniciativa: `rice-suite`

## Descrição

Criar pacote GNU Stow `stow/nvim` com configuração Lua limpa, rápida e estilizada para Neovim em Catppuccin Mocha Mauve.

## Critérios de Aceite

1. Instalar `neovim` e `wl-clipboard` no sistema via APT.
2. Criar `stow/nvim/.config/nvim/init.lua` com opções essenciais (números relativos, sem wrap, clipboard Wayland integrado, atalhos de Leader).
3. Paleta Catppuccin Mocha Mauve embutida diretamente em highlight groups sem dependências externas (startup < 15ms).
4. Integrar symlink no `setup.sh` e verificação no `scripts/check-status.sh`.

## Resolução

- Pacotes `neovim` e `wl-clipboard` instalados e adicionados a `scripts/install-deps.sh`.
- Módulo `stow/nvim/.config/nvim/init.lua` criado com statusline elegante, mapeamento de leader (espaço), integração de clipboard Wayland (`unnamedplus`) e tema Catppuccin Mocha com acento Mauve nativo.
- Tempo de inicialização medido em ~11ms sem erros ou dependências externas.
- Testes validados em `scripts/check-status.sh` com 100% `[OK]`.
