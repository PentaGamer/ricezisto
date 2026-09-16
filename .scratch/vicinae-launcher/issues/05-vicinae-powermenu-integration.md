# Issue 05: Integração do Powermenu Nativo do Vicinae (vicinae dmenu)

Status: `resolved`  
Type: `task`  
Iniciativa: `vicinae-launcher`  

## Descrição

Substituir o menu de energia legado do Rofi por um Powermenu moderno integrado ao ecossistema Vicinae via `vicinae dmenu`, mantendo o visual Catppuccin Mocha Mauve, navegação suave por setas e fechamento automático ao clicar fora ou perder foco.

## Critérios de Aceite

1. Criar `stow/vicinae/.config/vicinae/powermenu.sh`:
   - Lista de 5 opções com ícones Nerd Font (`Bloquear`, `Suspender`, `Encerrar Sessão`, `Reiniciar`, `Desligar`).
   - Invocação de `vicinae dmenu` com tamanho ergonômico (`-W 450 -H 280`), sem cabeçalho e sem rodapé.
   - Suporte a toggle: fecha a janela existente caso o atalho seja pressionado com o menu já aberto.
   - Execução das ações via `loginctl`, `systemctl` e `gnome-session-quit`.
2. Atualizar `scripts/apply-keybindings.sh`:
   - Mapear slot `custom2` para `'Vicinae Powermenu'` executando `'bash -c ~/.config/vicinae/powermenu.sh'` em `'<Super>BackSpace'`.
3. Atualizar `setup.sh`:
   - Incluir link simbólico e permissões de execução para `powermenu.sh`.
4. Atualizar `scripts/check-status.sh`:
   - Validar integridade do symlink e verificação do atalho `custom2`.
5. Validação com status 100% `[OK]` no usuário sandbox `rice`.

## Comments

- A transição elimina de vez os problemas de foco do Xwayland e inconsistências visuais, consolidando todo o fluxo de janelas rápidas (Launcher + Powermenu) sob o Vicinae.
