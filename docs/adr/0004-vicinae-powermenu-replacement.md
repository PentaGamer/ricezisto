# 4. Substituição do Menu de Energia: Rofi Powermenu por Vicinae Powermenu

Para o menu de gerenciamento de energia e encerramento de sessão do Ricezisto no Zorin OS 18 (GNOME 46 Wayland), optamos por substituir o **Rofi Powermenu** pelo **Vicinae Powermenu** utilizando o utilitário nativo `vicinae dmenu`.

O menu de energia legado baseado em Rofi apresentava travamentos na navegação pelas setas do teclado devido ao bridging do Xwayland com o compositor Mutter, além de exigir artifícios visuais frágeis para detecção de perda de foco (click-outside) que causavam efeito de tela preta.

O Vicinae Powermenu (`stow/vicinae/.config/vicinae/powermenu.sh`) é renderizado diretamente pelo motor gráfico do Vicinae via `vicinae dmenu`, garantindo:
1. **Consistência Visual Total**: Utiliza exatamente o mesmo tema Catppuccin Mocha Mauve (`catppuccin-mocha-mauve.toml`), cantos arredondados, tipografia do sistema e sombras já configurados no Vicinae Launcher.
2. **Navegação Suave e Busca Rápida**: Navegação imediata por setas (Cima/Baixo), suporte a digitação preditiva para filtrar ações e confirmação direta com `Enter`.
3. **Comportamento Nativo Wayland**: Fechamento instantâneo ao clicar fora ou perder o foco (`close_on_focus_loss: true`), suporte a cancelamento por tecla `Escape` e alternância nativa (toggle) ao pressionar novamente o atalho `Super + BackSpace`.
4. **Desacoplamento e Segurança**: Elimina de forma definitiva qualquer dependência do Xwayland e do Rofi na sessão de usuário do Ricezisto.
