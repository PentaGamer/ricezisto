# 04: Diagnóstico e Validação da Suite CLI

**What to build:** Expandir `scripts/check-status.sh` com a Seção 7 (auditoria de ferramentas CLI, temas e comandos no PATH) e validar em uma subshell interativa do Zsh.

**Blocked by:** 02 (Estilização Catppuccin Mocha para Bat e FZF), 03 (Aliases no Zsh e Inicialização do Zoxide)

**Status:** resolved

- [x] Adicionar auditoria dos utilitários `eza`, `bat`, `fzf`, `zoxide` em `scripts/check-status.sh`.
- [x] Validar execução limpa do `check-status.sh`.
- [x] Testar tempo de carregamento do Zsh interativo (`time zsh -i -c exit`).

## Resolução

1. `scripts/check-status.sh` expandido com a Seção 7 cobrindo `eza`, `bat`, `fzf`, `zoxide` e verificação do tema Catppuccin Mocha compilado no cache do bat.
2. Adicionada a checagem do link `~/.config/bat/config` na Seção 1.
3. Teste de execução com 100% de diagnósticos `[OK]`.
4. Tempo de carregamento do shell mantido veloz (abaixo de 0.7s em subshell limpa).
