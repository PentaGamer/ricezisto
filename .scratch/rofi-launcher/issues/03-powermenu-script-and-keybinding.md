# 03: Script Powermenu Integrado ao Rofi

**What to build:** Criar o script `stow/rofi/.config/rofi/powermenu.sh` com opções visuais para Bloquear Tela, Encerrar Sessão, Suspender, Reiniciar e Desligar o computador, utilizando ícones Nerd Font e ações via `systemctl` / `loginctl`.

**Blocked by:** 02 (Tema Catppuccin Mocha Mauve e Lançador de Apps)

**Status:** resolved

- [x] Criar script `powermenu.sh` executável.
- [x] Implementar diálogo minimalista do Rofi com os 5 botões de ação.
- [x] Conectar comandos seguros: `loginctl lock-session`, `gnome-session-quit --logout`, `systemctl suspend`, `systemctl reboot`, `systemctl poweroff`.
- [x] Testar compatibilidade de invocação com o atalho `Super + BackSpace`.

## Resolução

1. Script `stow/rofi/.config/rofi/powermenu.sh` criado e com permissão `+x`.
2. 5 opções configuradas com ícones Nerd Font e comandos nativos seguros.
3. Diálogo dinâmico do Rofi integrado na paleta Catppuccin Mocha Mauve.
4. Totalmente conectado ao atalho de teclado `Super + BackSpace` criado no GNOME.
