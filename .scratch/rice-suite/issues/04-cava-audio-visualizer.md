# Issue 04: Visualizador de Áudio Cava (Kitty + Mauve Gradient)

Status: `resolved`
Type: `task`
Iniciativa: `rice-suite`

## Descrição

Criar o pacote GNU Stow `stow/cava` e configurar o visualizador de barras de frequência de áudio em tempo real com o gradiente Catppuccin Mocha Mauve.

## Critérios de Aceite

1. Instalar `cava` no sistema via APT.
2. Criar `stow/cava/.config/cava/config` com gradiente Catppuccin Mocha Mauve (Sapphire -> Blue -> Lavender -> Pink -> Mauve) e captura via PulseAudio/PipeWire.
3. Integrar symlink no `setup.sh` e verificação no `scripts/check-status.sh`.

## Resolução

- Pacote `cava` instalado via APT e adicionado a `scripts/install-deps.sh`.
- Módulo `stow/cava/.config/cava/config` criado com 60 FPS, framerate suave, captura PulseAudio/PipeWire e gradiente de 6 cores Catppuccin Mocha culminando no tom Mauve.
- Symlinks automatizados no `setup.sh` e integridade validada em `scripts/check-status.sh` com 100% `[OK]`.
