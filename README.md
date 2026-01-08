# Documentação — Minha Vero

Esta pasta centraliza a documentação usada para execução e manutenção dos testes automatizados (Maestro) do aplicativo Minha Vero (Android).

## Acesso rápido
- [Primeiros passos](primeiros-passos.md)
- [Configuração do Maestro no Windows](maestro-windows-setup.md)
- [Troubleshooting (erros e soluções)](troubleshooting.md)
- [Plano de teste (ISO/IEC/IEEE 29119-3)](plano-de-teste-iso29119-3.md)
- [Casos de teste](casos-de-teste.md)

---

## Fluxo recomendado

1. Prepare o ambiente (Java, Android SDK, Node/NPM, Maestro):
   - [Configuração do Maestro no Windows](maestro-windows-setup.md)
2. Rode os testes e colete evidências:
   - [Primeiros passos](primeiros-passos.md)
3. Se algo falhar, use o guia de correções rápidas:
   - [Troubleshooting (erros e soluções)](troubleshooting.md)
4. Consulte a especificação do que será validado e os critérios:
   - [Plano de teste (ISO/IEC/IEEE 29119-3)](plano-de-teste-iso29119-3.md)
5. Consulte a lista de casos (tabela completa):
   - [Casos de teste](casos-de-teste.md)

---

## Estrutura relacionada no repositório

Arquivos/pastas citados nesta documentação:

- `tests/` — flows, pages e suites de execução (Maestro YAML)
- `maestro.yaml` — configuração global (ex.: evidências e output)
- `run-tests-with-notifications.ps1` — execução via script, logs e evidências no projeto
- `test-results/` — artefatos e evidências (quando configurado)
- `logs/` — logs gerados pelo script

---

## Como manter esta documentação

- Atualize o [plano de teste](plano-de-teste-iso29119-3.md) quando mudar escopo/estratégia/critério.
- Atualize os [casos de teste](casos-de-teste.md) quando criar/remover/alterar flows.
- Adicione novos erros no [troubleshooting](troubleshooting.md) quando surgirem falhas recorrentes.
