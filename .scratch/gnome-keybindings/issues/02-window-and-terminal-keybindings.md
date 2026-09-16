# 02: Atalhos de Produtividade de Janelas e Terminal

**What to build:** O usuário consegue abrir o terminal Kitty instantaneamente via `Super + Return`, fechar a janela ativa com `Super + Q` (mantendo `Alt + F4`), abrir o gerenciador de arquivos Nautilus com `Super + E` e alternar maximização com `Super + M`.

**Blocked by:** 01 (Resolução de Conflitos de Atalhos Nativos do GNOME)

**Status:** resolved

- [x] Configurar `close` em `org.gnome.desktop.wm.keybindings` para suportar `['<Super>q', '<Alt>F4']`.
- [x] Configurar `toggle-maximized` em `org.gnome.desktop.wm.keybindings` para `['<Super>m']`.
- [x] Criar atalho customizado no GNOME Media Keys para o Kitty com binding `<Super>Return`.
- [x] Configurar atalho nativo para o Nautilus (Home) com binding `['<Super>e']`.

## Resolução

1. `org.gnome.desktop.wm.keybindings close` configurado para `['<Super>q', '<Alt>F4']`.
2. `org.gnome.desktop.wm.keybindings toggle-maximized` configurado para `['<Super>m']`.
3. `org.gnome.settings-daemon.plugins.media-keys home` garantido como `['<Super>e']`.
4. `custom0` registrado para comando `kitty` com atalho `<Super>Return`.
