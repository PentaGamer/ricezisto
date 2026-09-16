# 03: Registro dos Gatilhos de Launcher e Powermenu

**What to build:** Registrar no GNOME Media Keys os atalhos `Super + Space` (apontando para `rofi -show drun` ou script do lançador) e `Super + BackSpace` (apontando para o script de menu de energia), preparando os gatilhos para a Issue 03.

**Blocked by:** 01 (Resolução de Conflitos de Atalhos Nativos do GNOME)

**Status:** resolved

- [x] Criar atalho customizado no GNOME Media Keys para `rofi -show drun` com binding `<Super>space`.
- [x] Criar atalho customizado no GNOME Media Keys para `powermenu` com binding `<Super>BackSpace`.
- [x] Verificar integridade da lista de `custom-keybindings` sem sobreposições.

## Resolução

1. `custom1` registrado: Nome `'Rofi Launcher'`, comando `'rofi -show drun'`, atalho `'<Super>space'`.
2. `custom2` registrado: Nome `'Rofi Powermenu'`, comando `'bash -c ~/.config/rofi/powermenu.sh'`, atalho `'<Super>BackSpace'`.
3. Array `custom-keybindings` atualizado com integridade para `['custom0/', 'custom1/', 'custom2/']`.
