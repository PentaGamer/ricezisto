# Issue 03: Integração do Atalho Super + Space com Vicinae Toggle

Status: `resolved`  
Type: `task`  
Iniciativa: `vicinae-launcher`  

## Descrição

Atualizar o script `scripts/apply-keybindings.sh` para vincular o atalho `Super + Space` diretamente ao comando nativo `vicinae toggle`, substituindo o launcher anterior.

## Critérios de Aceite

1. Modificar o slot `custom1` em `scripts/apply-keybindings.sh`:
   - Nome: `'Vicinae Launcher'`
   - Comando: `'vicinae toggle'`
   - Atalho: `'<Super>space'`
2. Assegurar que `custom2` permaneça atribuído a `'Rofi Powermenu'` com `'bash -c ~/.config/rofi/powermenu.sh'`.
3. Executar o script no usuário sandbox e verificar se as chaves em `org.gnome.settings-daemon.plugins.media-keys` foram atualizadas com sucesso.

## Comments

- `vicinae toggle` se comunica diretamente com o socket do daemon `vicinae server`, abrindo se estiver fechado e fechando se estiver aberto.
