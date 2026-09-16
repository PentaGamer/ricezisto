# Especificação: Personalização da Floating Dock

Status: `ready-for-agent`  
Data: 2026-09-16  
Autor: Antigravity + Gustavo  
Iniciativa: `dock-customization`  

---

## Solução e Parâmetros

Personalização da Dash to Dock no GNOME 46 Wayland:
- `dock-position: 'BOTTOM'`
- `extend-height: false`
- `autohide: true`
- `intellihide: true`
- `dock-fixed: false`
- `dash-max-icon-size: 40`
- `click-action: 'focus-minimize-or-previews'`
- `show-mounts: true`
- `show-trash: false`
- `show-show-apps-button: true`
- `running-indicator-style: 'DOTS'`
- `require-pressure-to-show: false`
- `favorite-apps`: `['kitty.desktop', 'brave-browser.desktop', 'org.gnome.Nautilus.desktop', 'com.spotify.Client.desktop']`

## Plan of Tasks (Issues)

1. **Issue 01 (`issues/01-dock-personalization.md`)**: Atualizar `scripts/apply-gnome.sh`, `scripts/check-status.sh`, aplicar no dconf e validar o ambiente.
