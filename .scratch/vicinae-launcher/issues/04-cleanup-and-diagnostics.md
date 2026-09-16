# Issue 04: Limpeza do Rofi Wrapper e Diagnósticos do Vicinae

Status: `resolved`  
Type: `task`  
Iniciativa: `vicinae-launcher`  

## Descrição

Desativar o script de backdrop do Rofi que tentava simular click-to-close com overlays, simplificar o `powermenu.sh` para execução direta nativa, e atualizar o script de diagnósticos `scripts/check-status.sh` para incluir o Vicinae.

## Critérios de Aceite

1. Remover a dependência do `rofi-wrapper.py` no `powermenu.sh`, mantendo o Rofi apenas como seletor rápido para o menu de energia.
2. Adicionar verificações em `scripts/check-status.sh`:
   - Presença do binário `/usr/local/bin/vicinae`.
   - Links simbólicos de `~/.config/vicinae/settings.json` e `~/.local/share/vicinae/themes/catppuccin-mocha-mauve.toml`.
   - Estado ativo do serviço `vicinae.service` no systemd do usuário.
3. Atualizar o `setup.sh` para criar os diretórios e links do módulo `stow/vicinae`.
4. Executar `./setup.sh` e `./scripts/check-status.sh` assegurando diagnóstico 100% `[OK]`.

## Comments

- Com a transição do launcher principal para o Vicinae, eliminamos completamente o problema de foco do Xwayland e o hack de janelas de backdrop.
