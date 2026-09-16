# Ricezisto Agent Guidelines

Diretrizes e configurações de agentes e skills para automação e engenharia do repositório Ricezisto.

## Regras de Execução

- **Idioma Obrigatório**: Todas as respostas, notas e explicações devem ser rigorosamente em Português do Brasil.
- **Ambiente Sandbox**: O desenvolvimento e homologação gráfica ocorrem primordialmente no usuário `rice` antes de qualquer sincronização com o usuário `gustavo`.
- **Integridade de Configurações**: Qualquer alteração em dotfiles ou chaves do `dconf` deve ser precedida de verificação de backup e compatibilidade.

## Agent skills

### Issue tracker

Tarefas e especificações são gerenciadas como arquivos Markdown locais sob `.scratch/` e `docs/specs/`. Veja `docs/agents/issue-tracker.md`.

### Triage labels

Vocabulário canônico dos 5 papéis de triagem (`needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`). Veja `docs/agents/triage-labels.md`.

### Domain docs

Estrutura de contexto único (*single-context*) baseada em `CONTEXT.md` e `docs/adr/`. Veja `docs/agents/domain.md`.
