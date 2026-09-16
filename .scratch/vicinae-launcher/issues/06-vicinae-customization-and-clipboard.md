# Issue 06: Customização de Provedores do Vicinae e Atalho para Clipboard

Status: `resolved`  
Type: `task`  
Iniciativa: `vicinae-launcher`  

## Descrição

Personalizar o comportamento e os recursos do Vicinae com base na entrevista com o usuário:
1. Manter exclusivamente os provedores de **Aplicativos (`applications`)** e **Área de Transferência (`clipboard`)** ativos.
2. Desativar provedores ruidosos e desnecessários na busca raiz (`files`, `calculator`, `core`, `system`, `developer`, `font`, `power`, `snippets`, `wm`, etc.).
3. Fixar favoritos no topo: **Terminal Kitty**, **Arquivos (Nautilus)** e **Brave Browser**.
4. Desativar relógio na barra de status para manter o visual minimalista.
5. Criar script e atalho dedicado **`Super + V`** para abrir/alternar diretamente o histórico da área de transferência (`clipboard:history`).

## Critérios de Aceite

1. `stow/vicinae/.config/vicinae/settings.json` atualizado com:
   - Provedores desativados explicitamente (`enabled: false`).
   - `fallbacks: []`.
   - `clock.enabled: false`.
   - `favorites`: `kitty`, `Nautilus` e `brave-browser`.
2. Criar `stow/vicinae/.config/vicinae/clipboard.sh` com suporte a alternância (toggle) via `vicinae state open`.
3. Atualizar `scripts/apply-keybindings.sh` liberando `Super + V` do `toggle-message-tray` e atribuindo a `custom3` para o Clipboard.
4. Atualizar `setup.sh` e `scripts/check-status.sh` com diagnósticos 100% `[OK]`.
