# Issue 01: Aplicação das Configurações da Floating Dock

Status: `resolved`  
Type: `task`  
Iniciativa: `dock-customization`  

## Descrição

Aplicar as customizações mapeadas na entrevista para a Dash to Dock:
- Ocultamento inteligente (intellihide ativado, autohide ativado, dock fixa desativada).
- Escala de ícones ajustada para 40px com estilo de indicadores em pontos (DOTS).
- Ação de clique multitarefa (`focus-minimize-or-previews`).
- Exibição de pendrives montados habilitada (`show-mounts: true`).
- Lista de favoritos atualizada com Kitty, Brave, Nautilus e Spotify.
- Script de diagnósticos atualizado para validar os novos parâmetros da dock.

## Critérios de Aceite

1. `scripts/apply-gnome.sh` atualizado com as chaves dconf e gsettings correspondentes.
2. `scripts/check-status.sh` atualizado para verificar intellihide, tamanho 40px, click-action e status dos favoritos.
3. Execução idempotente de `scripts/apply-gnome.sh` e verificação com `scripts/check-status.sh` reportando `[OK]`.
