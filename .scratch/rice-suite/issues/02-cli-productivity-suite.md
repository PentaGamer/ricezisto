# Issue 02: Suite de Utilitários CLI Modernos & Zsh Integration

Status: `resolved`
Type: `task`
Iniciativa: `rice-suite`

## Descrição

Configurar e integrar ferramentas de linha de comando modernas com paleta Catppuccin Mocha Mauve ao shell Zsh no terminal Kitty.

## Critérios de Aceite

1. Instalar `eza`, `bat`, `fzf`, `zoxide` nas dependências do sistema.
2. Atualizar o `stow/zsh/.zshrc` com aliases ergonômicos (`ls -> eza`, `cat -> bat`, `cd -> z`).
3. Configurar variáveis `FZF_DEFAULT_OPTS` com paleta Catppuccin Mocha Mauve.
4. Testar funcionamento e velocidade do shell interativo.

## Resolução

Implementado via tickets 01 a 04 sob `.scratch/cli-productivity-suite/issues/`:
- Pacotes `eza`, `bat`, `fzf`, `zoxide` instalados via APT.
- Symlink `/usr/local/bin/bat -> /usr/bin/batcat` ativo e compatível.
- Criado pacote GNU Stow `stow/bat` com o tema oficial `Catppuccin Mocha.tmTheme` e cache compilado.
- Paleta Catppuccin Mocha Mauve configurada em `FZF_DEFAULT_OPTS` e `FZF_CTRL_T_OPTS`.
- Aliases modernos e `zoxide` integrados ao `stow/zsh/.zshrc`.
- Seção 7 de auditoria automatizada adicionada em `scripts/check-status.sh` com 100% de aprovação.
