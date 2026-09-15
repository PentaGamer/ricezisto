# 1. Uso de Sandbox User e GNU Stow com Backup Preventivo

Para construir o rice no Zorin OS 18 com segurança, decidimos isolar o desenvolvimento em um usuário secundário dedicado (`Sandbox User`) e estruturar as configurações em módulos gerenciados por GNU Stow acompanhados por um script de automação com rotina obrigatória de `Backup Snapshot`. Essa abordagem evita quebras acidentais no ambiente de trabalho do usuário principal e assegura que qualquer migração futura seja reversível e previsível.
