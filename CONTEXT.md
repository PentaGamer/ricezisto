# Ricezisto Context

Ambiente de customização e modularização estética (rice) para Zorin OS 18 (GNOME 46 no Wayland), com foco em segurança, isolamento em usuário secundário e automação de dotfiles.

## Language

**Rice**:
A personalização profunda da estética e do comportamento do ambiente gráfico e do terminal, harmonizando cores, tipografia, ícones e janelas.
_Avoid_: Customização avulsa, tweak, tema padrão

**Sandbox User**:
Usuário do sistema operacional criado de forma isolada para instalação, execução e teste de novos temas, extensões e scripts sem impactar as configurações do usuário principal.
_Avoid_: Usuário convidado, conta temporária

**Dotfiles**:
Arquivos de configuração baseados no diretório do usuário que determinam o comportamento e a aparência de aplicações de desktop e ferramentas de terminal.
_Avoid_: Arquivos de sistema, scripts globais

**Stow Package**:
Módulo independente dentro do repositório de configurações, projetado para ter sua árvore espelhada na pasta home por meio de links simbólicos gerenciados pelo GNU Stow.
_Avoid_: Pasta avulsa, pacote binário

**Backup Snapshot**:
Cópia de segurança com registro de data e hora gerada automaticamente a partir das configurações existentes do usuário antes da aplicação de quaisquer novos symlinks ou alterações no dconf.
_Avoid_: Cópia manual, sobrescrita direta

**Floating Dock**:
Elemento gráfico de lançamento e alternância de janelas em formato de pílula flutuante desvinculada das bordas da tela, com cantos arredondados e comportamento autohide inteligente.
_Avoid_: Barra de tarefas única, painel integrado

**Dynamic Blur**:
Efeito visual de desfoque e translucidez aplicado a componentes da casca do desktop (painel superior, dock, tela de bloqueio e visão geral), reagindo ao fundo de tela.
_Avoid_: Transparência estática, opacidade sólida

**Lightweight Shell**:
Ambiente de linha de comando baseado em Zsh configurado com carregamento direto e assíncrono de módulos indispensáveis sem frameworks monolíticos pesados.
_Avoid_: Framework volumoso, shell monolítico

**Accent Color**:
Tonalidade de destaque primária (Mauve no Catppuccin Mocha) aplicada a botões de ação, seleções ativas, realces de sintaxe e elementos focados da interface.
_Avoid_: Cor de fundo, tema claro

**Homologation**:
Procedimento de teste e validação interativa na conta sandbox antes da liberação e aplicação definitiva dos dotfiles na conta principal.
_Avoid_: Teste em produção, rollout cego

**Zorin Standard Animations**:
Conjunto nativo e consistente de animações rápidas do sistema operacional, prescindindo de efeitos elásticos (wobbly) ou distorções visuais (lâmpada mágica).
_Avoid_: Efeitos fluidos, janelas gelatinosas

**Sandbox Agent**:
Instância do assistente Antigravity executada no contexto de processo da conta sandbox, permitindo manipular sessões D-Bus, extensões e dotfiles em tempo real.
_Avoid_: Agente remoto, execução cruzada



