# 02: Estilização Catppuccin Mocha para Bat e FZF

**What to build:** Configurar as cores e temas oficiais Catppuccin Mocha para o `bat` e para o `fzf`, garantindo que realces de código e buscas interativas no terminal reflitam perfeitamente a identidade visual do rice.

**Blocked by:** 01 (Instalação dos Pacotes da Suite CLI)

**Status:** resolved

- [x] Instalar o tema oficial Catppuccin Mocha para o `bat` e compilar o cache do bat (`bat cache --build`).
- [x] Configurar variáveis `FZF_DEFAULT_OPTS` com paleta Catppuccin Mocha Mauve.
- [x] Configurar visualizador padrão com preview usando `bat` no `fzf`.

## Resolução

1. Criado módulo `stow/bat/.config/bat/` com `themes/Catppuccin Mocha.tmTheme` e arquivo `config`.
2. Cache do `bat` compilado com sucesso, reconhecendo o tema Catppuccin Mocha nativamente.
3. Paleta completa Catppuccin Mocha Mauve configurada em `FZF_DEFAULT_OPTS` e `FZF_CTRL_T_OPTS` no `.zshrc`.
