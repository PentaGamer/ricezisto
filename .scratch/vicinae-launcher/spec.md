# Especificação: Integração do Vicinae Launcher (Catppuccin Mocha Mauve)

Status: `ready-for-agent`  
Data: 2026-09-16  
Autor: Antigravity + Gustavo  
Iniciativa: `vicinae-launcher`  

---

## Problem Statement

Durante os testes do lançador Rofi no Zorin OS 18 (GNOME 46 Wayland), identificamos restrições estruturais severas decorrentes da arquitetura do Xwayland e do compositor Mutter:
1. **Navegação por teclado degradada**: O manuseio de eventos de ponteiro e teclado pelo Xwayland interferia na navegação pelas setas direcionais, tornando o menu travado e inconsistente.
2. **Incompatibilidade de foco e click-outside**: No Wayland, o Mutter não entrega eventos de clique fora da janela para clientes X11, impedindo que o Rofi feche nativamente ao clicar fora. Tentativas de sobreposição (overlays) ativaram otimizações do Mutter que escureciam a tela com fundo preto sólido.
3. **Experiência do usuário**: O usuário já possui e utiliza com satisfação o **Vicinae** (`/usr/local/bin/vicinae`) em seu perfil principal (`gustavo`), demandando sua adoção no Ricezisto no lugar do Rofi para o lançador de aplicativos.

---

## Solution

Substituir o Rofi pelo **Vicinae** como o lançador de aplicações oficial do Ricezisto, mantendo o isolamento sandbox no usuário `rice` e a integridade modular via GNU Stow:

1. **Módulo GNU Stow (`stow/vicinae`)**:
   - `stow/vicinae/.config/vicinae/settings.json`: Configurações centrais do Vicinae com fechamento nativo por perda de foco (`"close_on_focus_loss": true`), navegação contínua (`"wrap_navigation": true`), ativação com clique único e tipografia do sistema (Inter).
   - `stow/vicinae/.local/share/vicinae/themes/catppuccin-mocha-mauve.toml`: Tema completo em formato TOML respeitando rigorosamente a paleta Catppuccin Mocha Mauve do Ricezisto (Base `#1e1e2e`, Mauve `#cba6f7`, Text `#cdd6f4`, Surface0 `#313244`).
2. **Daemon de Alta Performance (`systemd --user`)**:
   - Integração do serviço `/usr/local/lib/systemd/user/vicinae.service` na sessão gráfica do usuário sandbox (`systemctl --user enable --now vicinae.service`).
   - O daemon pré-carregado em memória reduz a latência de abertura para 0ms.
3. **Mapeamento Ergonômico de Atalhos no GNOME**:
   - Atualizar `scripts/apply-keybindings.sh` para apontar `Super + Space` diretamente para `vicinae toggle`.
   - O comando nativo `vicinae toggle` gerencia alternância instantânea entre abrir e fechar a janela.
4. **Menu de Energia Nativo (Vicinae Powermenu)**:
   - Implementação de `stow/vicinae/.config/vicinae/powermenu.sh` utilizando o comando nativo `vicinae dmenu`.
   - Remoção definitiva do Rofi do fluxo ativo de atalhos, vinculando `Super + BackSpace` diretamente ao Powermenu do Vicinae.
5. **Automação no Pipeline (`setup.sh` & `check-status.sh`)**:
   - Automatizar a criação dos symlinks do Vicinae (Launcher & Powermenu) no `setup.sh`.
   - Adicionar verificações de integridade e status do serviço daemon no `scripts/check-status.sh`.

---

## Plan of Tasks (Issues)

1. **Issue 01 (`issues/01-vicinae-stow-and-theme.md`)**: Estruturar módulo `stow/vicinae` com `settings.json` e tema `catppuccin-mocha-mauve.toml`.
2. **Issue 02 (`issues/02-vicinae-systemd-daemon.md`)**: Configurar e automatizar o daemon `vicinae.service` no `setup.sh`.
3. **Issue 03 (`issues/03-vicinae-keybindings-integration.md`)**: Atualizar o atalho `Super + Space` no GNOME para `vicinae toggle`.
4. **Issue 04 (`issues/04-cleanup-and-diagnostics.md`)**: Simplificar diagnósticos, atualizar `scripts/check-status.sh` e validar testes de homologação.
5. **Issue 05 (`issues/05-vicinae-powermenu-integration.md`)**: Implementar Powermenu nativo no Vicinae (`vicinae dmenu`) vinculado a `Super + BackSpace`.
