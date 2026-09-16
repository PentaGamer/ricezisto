# 04: Integração no Setup e Diagnóstico

**What to build:** Incluir o módulo `stow/rofi` no pipeline do `setup.sh` (com proteção contra directory-folding) e expandir `scripts/check-status.sh` para auditar a saúde da configuração do Rofi.

**Blocked by:** 02 (Tema Catppuccin Mocha Mauve e Lançador de Apps), 03 (Script Powermenu Integrado ao Rofi)

**Status:** resolved

- [x] Incluir vinculação de `stow/rofi` no `setup.sh`.
- [x] Adicionar checagens em `scripts/check-status.sh` para verificar links do `config.rasi` e `powermenu.sh`.
- [x] Executar `setup.sh` e `check-status.sh` com 100% de sucesso.

## Resolução

1. `setup.sh` atualizado com proteção de desdobramento de diretórios para `~/.config/rofi` e criação dos symlinks de `config.rasi`, `catppuccin-mocha.rasi` e `powermenu.sh`.
2. `scripts/check-status.sh` expandido com auditoria dos symlinks do Rofi na Seção 1.
3. Teste ponta a ponta executado com 100% dos diagnósticos `[OK]`.
