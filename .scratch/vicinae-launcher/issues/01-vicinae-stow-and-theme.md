# Issue 01: Módulo GNU Stow e Tema Catppuccin Mocha Mauve para Vicinae

Status: `resolved`  
Type: `task`  
Iniciativa: `vicinae-launcher`  

## Descrição

Criar a estrutura do pacote `stow/vicinae` contendo o arquivo de configurações central `settings.json` e o tema exclusivo em formato TOML `catppuccin-mocha-mauve.toml`.

## Critérios de Aceite

1. Criar o diretório `stow/vicinae/.config/vicinae/` e o arquivo `settings.json` configurado com:
   - `"close_on_focus_loss": true`
   - `"activate_on_single_click": true`
   - `"wrap_navigation": true`
   - Fontes: `Inter` (10.5 pt)
   - Tema escuro ativo: `"catppuccin-mocha-mauve"` com ícones `Papirus-Dark`.
2. Criar o diretório `stow/vicinae/.local/share/vicinae/themes/` e o arquivo `catppuccin-mocha-mauve.toml` com a paleta:
   - Base / Fundo: `#1e1e2e`
   - Mantle / Fundo Secundário: `#181825`
   - Destaque (Accent): `#cba6f7` (Mauve)
   - Texto Principal: `#cdd6f4`
   - Texto Secundário / Muted: `#a6adc8`
   - Bordas: `#313244` ou acentuadas `#cba6f7`
3. Garantir que os arquivos estejam no formato aceito pelo Vicinae v0.24.0.

## Comments

- A separação entre `.config` e `.local/share` reflete as especificações XDG e as convenções internas do Vicinae.
