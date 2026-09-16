# 04: Automação e Verificação no Diagnóstico

**What to build:** Script idempotente `scripts/apply-keybindings.sh` acoplado ao `setup.sh` e expansão de `scripts/check-status.sh` para auditar a saúde de todos os atalhos configurados no GNOME.

**Blocked by:** 02 (Atalhos de Produtividade de Janelas e Terminal), 03 (Registro dos Gatilhos de Launcher e Powermenu)

**Status:** resolved

- [x] Criar `scripts/apply-keybindings.sh` com tratamento de idempotência para o usuário sandbox e principal.
- [x] Chamar `scripts/apply-keybindings.sh` a partir de `setup.sh` e `apply-gnome.sh`.
- [x] Adicionar seção de auditoria de atalhos em `scripts/check-status.sh`.
- [x] Validar execução ponta a ponta na sessão do usuário `rice`.

## Resolução

1. Criado `scripts/apply-keybindings.sh` com travas de segurança e configuração de atalhos.
2. Integrado à chamada em `scripts/apply-gnome.sh` e incluído nas permissões do `setup.sh`.
3. Adicionada a Seção 6 de auditoria em `scripts/check-status.sh`, verificando fechamento de janelas (`<Super>q`), arquivos (`<Super>e`), terminal (`<Super>Return`) e launcher (`<Super>space`).
4. Execução validada com 100% dos testes `[OK]`.
