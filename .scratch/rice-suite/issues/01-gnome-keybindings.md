# Issue 01: Mapeamento de Atalhos Ergonômicos no GNOME (Keybindings)

Status: `resolved`
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

## Resolução

Implementado via tickets 01 a 04 sob `.scratch/gnome-keybindings/issues/`:
- Conflitos nativos resolvidos (`switch-input-source` remapeado para `<Control>space`).
- Atalho `Super + Return` configurado para o terminal Kitty.
- Atalho `Super + Q` configurado para fechar janelas.
- Atalho `Super + E` configurado para o Nautilus.
- Gatilhos `Super + Space` e `Super + BackSpace` registrados para Rofi e Powermenu.
- Script automatizado `scripts/apply-keybindings.sh` criado e validado em `scripts/check-status.sh`.
