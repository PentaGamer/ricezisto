# Issue 03: Módulo Rofi-Wayland com Tema Catppuccin Mocha Mauve

Status: `ready-for-agent`
Type: `task`
Iniciativa: `rice-suite`

## Descrição

Criar o pacote GNU Stow `stow/rofi` com tema exclusivo Catppuccin Mocha Mauve, abrangendo lançador de aplicações (drun), alternador de janelas (window) e powermenu.

## Critérios de Aceite

1. Instalar `rofi-wayland` compatível com o compositor Wayland do Zorin OS 18.
2. Criar `stow/rofi/.config/rofi/config.rasi` e arquivo de cores `catppuccin-mocha.rasi`.
3. Criar `stow/rofi/.config/rofi/powermenu.sh` executável para suspensão, reinício e desligamento.
4. Integrar o atalho no GNOME para `Super + Space` e `Super + BackSpace`.
