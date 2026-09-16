# 3. Substituição do Lançador de Aplicações: Rofi por Vicinae

Para o lançador de aplicativos do Ricezisto no Zorin OS 18 (GNOME 46 Wayland), optamos por substituir o **Rofi** pelo **Vicinae** (`/usr/local/bin/vicinae`). 

O Rofi opera sobre a camada legada do Xwayland, na qual restrições de segurança do compositor Mutter impedem a detecção limpa de perda de foco e cliques externos sem artifícios de janelas intermediárias (as quais provocam efeitos indesejados como fundos opacos pretos e interferência na captura das setas do teclado). 

O Vicinae é um lançador moderno desenvolvido em C++/Qt com suporte nativo a Wayland e X11. Ele oferece fechamento nativo imediato ao perder o foco (`close_on_focus_loss: true`), suporte fluido e contínuo à navegação por setas e atalhos de teclado, tempo de resposta instantâneo (0ms) operando como daemon via `systemd --user` (`vicinae.service`) acionado por `vicinae toggle`, e estilização declarativa em TOML compatível com a paleta Catppuccin Mocha Mauve em `~/.local/share/vicinae/themes/`.
