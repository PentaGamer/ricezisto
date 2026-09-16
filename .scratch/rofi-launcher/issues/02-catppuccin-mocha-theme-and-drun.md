# 02: Tema Catppuccin Mocha Mauve e Lançador de Apps

**What to build:** Criar o pacote GNU Stow `stow/rofi/.config/rofi` com o tema visual oficial Catppuccin Mocha Mauve (cores, cantos arredondados, transparência suave, fonte Inter/JetBrainsMono e suporte a ícones Papirus-Dark) e arquivo `config.rasi` configurado para busca rápida `drun` e `window`.

**Blocked by:** 01 (Instalação e Verificação do Rofi)

**Status:** resolved

- [x] Criar arquivo de tema `catppuccin-mocha.rasi` com a paleta exata Catppuccin Mocha Mauve.
- [x] Criar arquivo de configuração `config.rasi` com fontes modernas e exibição de ícones.
- [x] Validar sintaxe com `rofi -dump-config`.

## Resolução

1. Criado tema `stow/rofi/.config/rofi/catppuccin-mocha.rasi` com cantos arredondados de 16px, borda Mauve `#cba6f7` e fundo Mocha `#1e1e2e`.
2. Criado `stow/rofi/.config/rofi/config.rasi` com suporte a `drun`, `run` e `window`, fonte Inter e ícones Papirus-Dark.
3. Sintaxe validada com sucesso pelo validador do Rofi.
