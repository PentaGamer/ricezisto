# Issue 03: Módulo Rofi com Tema Catppuccin Mocha Mauve

Status: `resolved`
Type: `task`
Iniciativa: `rice-suite`

## Descrição

Criar o pacote GNU Stow `stow/rofi` com tema exclusivo Catppuccin Mocha Mauve, abrangendo lançador de aplicações (drun), alternador de janelas (window) e powermenu.

## Critérios de Aceite

1. Instalar pacote `rofi` compatível com o desktop Zorin OS 18.
2. Criar `stow/rofi/.config/rofi/config.rasi` e arquivo de cores `catppuccin-mocha.rasi`.
3. Criar `stow/rofi/.config/rofi/powermenu.sh` executável para suspensão, reinício e desligamento.
4. Integrar o atalho no GNOME para `Super + Space` e `Super + BackSpace`.

## Resolução

Implementado via tickets 01 a 04 sob `.scratch/rofi-launcher/issues/`:
- `rofi` (1.7.5) instalado via APT e adicionado a `scripts/install-deps.sh`.
- Módulo `stow/rofi/.config/rofi` criado com `catppuccin-mocha.rasi` (paleta Mauve, cantos arredondados) e `config.rasi` (suporte a drun, run, window, fonte Inter e ícones Papirus-Dark).
- Script `powermenu.sh` criado com opções de bloquear, suspender, deslogar, reiniciar e desligar.
- Conexão nativa com os atalhos `Super + Space` e `Super + BackSpace`.
- Pipeline de `setup.sh` e diagnóstico em `scripts/check-status.sh` validados com sucesso.
