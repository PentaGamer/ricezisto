# Issue 01: Mapeamento de Atalhos Ergonômicos no GNOME (Keybindings)

Status: `ready-for-agent`
Type: `task`
Iniciativa: `rice-suite`

## Descrição

Implementar o mapeamento de atalhos de teclado no GNOME 46 Wayland para garantir produtividade estilo Tiling Window Manager.

## Critérios de Aceite

1. `Super + Return` abre o terminal Kitty.
2. `Super + q` fecha a janela ativa.
3. `Super + e` abre o Nautilus (arquivos).
4. `Super + Space` é reservado para o launcher Rofi.
5. As configurações são integradas de forma idempotente em `scripts/apply-gnome.sh`.
