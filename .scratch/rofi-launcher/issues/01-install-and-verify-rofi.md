# 01: Instalação e Verificação do Rofi

**What to build:** Instalar o pacote `rofi` no sistema operacional e registrar a dependência em `scripts/install-deps.sh` para garantir provisionamento consistente.

**Blocked by:** None (can start immediately)

**Status:** resolved

- [x] Instalar o pacote `rofi` via APT.
- [x] Adicionar `rofi` na lista de pacotes do `scripts/install-deps.sh`.
- [x] Validar execução do binário no terminal.

## Resolução

1. Pacote `rofi` versão 1.7.5 instalado via APT.
2. `scripts/install-deps.sh` atualizado para incluir `rofi`.
3. Binário `/usr/bin/rofi` testado e funcional.
