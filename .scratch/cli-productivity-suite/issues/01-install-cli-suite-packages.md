# 01: Instalação dos Pacotes da Suite CLI

**What to build:** Instalar os binários essenciais da suite moderna (`eza`, `bat`, `fzf`, `zoxide`) no sistema, garantir compatibilidade de invocação via `/usr/local/bin/bat -> /usr/bin/batcat` e registrar os pacotes em `scripts/install-deps.sh`.

**Blocked by:** None (can start immediately)

**Status:** resolved

- [x] Instalar `eza`, `bat`, `fzf`, `zoxide` via APT.
- [x] Criar symlink `/usr/local/bin/bat` apontando para `/usr/bin/batcat`.
- [x] Atualizar `scripts/install-deps.sh` para incluir esses pacotes em provisionamentos futuros.

## Resolução

1. Pacotes `eza` (0.18.2), `bat` (0.24.0), `fzf` (0.44.1) e `zoxide` (0.9.3) instalados via APT.
2. Symlink `/usr/local/bin/bat -> /usr/bin/batcat` ativo e funcional.
3. `scripts/install-deps.sh` atualizado para conter esses pacotes no provisionamento automatizado.
