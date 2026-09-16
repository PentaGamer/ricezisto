# 03: Aliases no Zsh e Inicialização do Zoxide

**What to build:** Atualizar o arquivo `.zshrc` no módulo `stow/zsh` com substituições modernas de comandos (`ls` -> `eza`, `cat` -> `bat`), navegação inteligente com `zoxide init zsh` e keybindings do fzf.

**Blocked by:** 01 (Instalação dos Pacotes da Suite CLI)

**Status:** resolved

- [x] Adicionar inicialização do `zoxide` no `.zshrc`.
- [x] Definir aliases de `eza` com ícones e ordenação de pastas (`ls`, `ll`, `la`, `lt`, `tree`).
- [x] Definir alias `cat` para `bat --paging=never`.
- [x] Carregar atalhos e autocompletar do `fzf` no Zsh.

## Resolução

1. `stow/zsh/.zshrc` atualizado com blocos dedicados para `zoxide`, `fzf` e aliases do `eza` / `bat`.
2. Fallbacks elegantes implementados caso algum pacote não esteja presente.
3. Teste de tempo de inicialização do shell interativo mantido abaixo de 0.7s.
