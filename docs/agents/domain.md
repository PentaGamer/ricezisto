# Domain Docs

Regras de consumo da documentação de domínio para as engineering skills no repositório Ricezisto.

## Documentos Canônicos

- **`CONTEXT.md`**: Glossário canônico de termos do projeto Ricezisto localizado na raiz do repositório.
- **`docs/adr/`**: Decisões arquiteturais registradas sequencialmente em formato Markdown.

## Regras de Estrutura

Repositório de contexto único (single-context):
- A raiz contém o `CONTEXT.md` e a pasta `docs/adr/`.
- Qualquer novo termo ou mudança conceitual deve ser harmonizado com o glossário em `CONTEXT.md`.
- Decisões estruturais que alterem a composição do rice exigem a criação de um novo registro ADR em `docs/adr/`.
