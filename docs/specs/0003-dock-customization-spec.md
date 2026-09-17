# Especificação: Personalização da Floating Dock (Dash to Dock)

Status: `ready-for-agent`  
Data: 2026-09-16  
Autor: Antigravity + Gustavo  
Iniciativa: `dock-customization`  

---

## Problem Statement

A configuração inicial da dock no Ricezisto mantinha a barra fixa no rodapé sem ocultamento dinâmico (`dock-fixed: true`, `autohide: false`), consumindo área útil da tela em aplicações maximizadas. Além disso:
1. O tamanho dos ícones (36px) era reduzido para telas de alta resolução.
2. O comportamento ao clicar em janelas abertas limitava-se a minimizar sem suporte a pré-visualizações de múltiplas janelas.
3. A lista de aplicativos favoritos não incluía ferramentas centrais do usuário (como Kitty e Spotify), nem exibia dispositivos e mídias removíveis montadas.

---

## Solution

Reconfigurar a extensão **Dash to Dock** (`dash-to-dock@micxgx.gmail.com`) no GNOME 46 (Wayland) respeitando rigorosamente as decisões da entrevista de design:

1. **Visibilidade Inteligente (Intellihide)**:
   - `dock-fixed: false`, `autohide: true`, `intellihide: true`, `require-pressure-to-show: false`.
   - A dock permanece visível sobre a área de trabalho limpa, recolhendo-se suavemente assim que uma janela a sobrepõe.
2. **Formato Pílula Flutuante Centralizada**:
   - `dock-position: 'BOTTOM'`, `extend-height: false`, `custom-theme-shrink: true`.
   - Cantos arredondados integrados ao efeito de desfoque translúcido do **Blur my Shell**.
3. **Ergonomia e Escala**:
   - Ícones dimensionados para 40px (`dash-max-icon-size: 40`).
   - Indicadores de execução em pontos discretos (`running-indicator-style: 'DOTS'`).
4. **Multitarefa Aprimorada (`click-action`)**:
   - `click-action: 'focus-minimize-or-previews'`: foca a janela, minimiza se já estiver em foco, ou exibe miniaturas quando houver mais de uma instância aberta.
5. **Elementos e Mídias**:
   - Exibição de pendrives e mídias externas montadas ativada (`show-mounts: true`).
   - Botão de grade de aplicativos mantido na ponta (`show-show-apps-button: true`).
   - Lixeira oculta da dock (`show-trash: false`).
6. **Lista Canônica de Favoritos Fixados**:
   - `['kitty.desktop', 'brave-browser.desktop', 'org.gnome.Nautilus.desktop', 'com.spotify.Client.desktop']`.
7. **Blindagem de Cores e Tema do Shell (Catppuccin Mocha Mauve)**:
   - `custom-background-color: true`, `background-color: '#1e1e2e'`, `background-opacity: 0.82`.
   - `custom-theme-customize-running-dots: true`, `custom-theme-running-dots-color: '#cba6f7'`, `custom-theme-running-dots-border-color: '#cba6f7'`.
   - Vínculo explícito do tema do GNOME Shell via `user-theme` (`catppuccin-mocha-mauve-standard+default`), prevenindo herança do tema claro do sistema (`ZorinBlue-Light`) e evitando que a dock assuma a cor branca sólida/leitosa (`#ffffff`) após o boot ou logout.

---

## User Stories

1. Como usuário, quero que a dock fique visível no desktop mas se oculte automaticamente quando uma janela ocupar a parte inferior da tela (Intellihide).
2. Como usuário, quero ver ícones com tamanho equilibrado de 40px em uma pílula centralizada com fundo translúcido e desfoque.
3. Como usuário, ao clicar no ícone de um app com várias janelas abertas, quero ver miniaturas para escolher qual janela focar.
4. Como usuário, quero ter acesso direto ao Kitty, Brave, Nautilus e Spotify fixados na dock.
5. Como usuário, ao conectar um pendrive ou disco externo, quero que o ícone apareça na dock para acesso rápido e ejeção segura.
