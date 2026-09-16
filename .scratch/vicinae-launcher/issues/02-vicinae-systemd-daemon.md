# Issue 02: Habilitação e Gestão do Daemon vicinae.service

Status: `resolved`  
Type: `task`  
Iniciativa: `vicinae-launcher`  

## Descrição

Configurar e automatizar a execução do daemon do Vicinae em segundo plano via `systemd --user` (`vicinae.service`), assegurando inicialização imediata e tempo de resposta de 0ms nos atalhos.

## Critérios de Aceite

1. Verificar que `/usr/local/lib/systemd/user/vicinae.service` está acessível para o usuário `rice`.
2. Integrar a ativação do serviço em `setup.sh`:
   - Executar `systemctl --user daemon-reload`
   - Executar `systemctl --user enable --now vicinae.service`
3. Garantir tratamento de erro resiliente no caso de ausência de sessão gráfica ativa durante pipelines não-interativos.
4. Validar o status ativo com `systemctl --user is-active vicinae.service`.

## Comments

- O daemon gerencia a janela do Vicinae oculta em memória até o recebimento do sinal via IPC (`vicinae toggle`).
