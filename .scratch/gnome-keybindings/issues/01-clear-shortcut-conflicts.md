# 01: Resolução de Conflitos de Atalhos Nativos do GNOME

**What to build:** Desvincular atalhos padrões do GNOME (em especial `<Super>space` em `switch-input-source` e eventuais conflitos com `Super + q`, `Super + e`, `Super + Return`), liberando as combinações para o rice sem remover funcionalidades essenciais do teclado.

**Blocked by:** None (can start immediately)

**Status:** resolved

- [x] Identificar todas as chaves do GNOME (`org.gnome.desktop.wm.keybindings` e `media-keys`) que usem `<Super>space`, `<Super>q`, `<Super>e` ou `<Super>Return`.
- [x] Remapear `switch-input-source` para `<Control>space` e `toggle-message-tray` para `<Super>v`.
- [x] Garantir que o comportamento padrão do Zorin OS não sobreponha a liberação dessas teclas.

## Resolução

1. `org.gnome.desktop.wm.keybindings switch-input-source`: remapeado de `['<Super>space', 'XF86Keyboard']` para `['<Control>space', 'XF86Keyboard']`.
2. `org.gnome.desktop.wm.keybindings switch-input-source-backward`: remapeado para `['<Shift><Control>space', '<Shift>XF86Keyboard']`.
3. `org.gnome.shell.keybindings toggle-message-tray`: desvinculado `<Super>m` (mantendo apenas `<Super>v`).
4. As combinações `<Super>space`, `<Super>Return`, `<Super>q` e `<Super>m` estão totalmente livres para os atalhos do rice.
