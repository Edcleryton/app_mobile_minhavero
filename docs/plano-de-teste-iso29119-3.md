# Plano de Teste — Minha Vero (ISO/IEC/IEEE 29119-3)

## 1. Cabeçalho

**Projeto:** Minha Vero (APK Android)  
**Identificador Único do Documento:** MV-TP-ISO29119-3-001  
**Data:** 2026-01-07  
**Responsável:** QA / Automação (Maestro)

| Versão | Data       | Autor            | Mudança                           |
|-------:|------------|------------------|-----------------------------------|
| 1.0.0  | 2026-01-07 | Edcleryton Silva | Criação inicial do plano de teste |

## 2. Visão Geral

**Objetivo do teste**  
Validar os fluxos críticos de uso do aplicativo Minha Vero no Android, com foco em navegação, conteúdo essencial de telas e ações principais, reduzindo risco de regressões em produção.

**Itens a serem testados**  
- APK Android do aplicativo Minha Vero (`app_versao/*.apk`)
- Flows Maestro (`tests/**/*.yaml`)

## 3. Escopo

**In Scope**
- Login
- Recuperação de senha (SMS/e-mail) e fluxos de Ajuda ("Precisa de ajuda?")
- Home (validação de tela)
- Plano (validação e múltiplos endereços)
- Financeiro (validação de tela, pagamentos com cartão, scroll em formulários longos)

**Out of Scope**
- Validações de regras de negócio no backend (cálculo de faturas, juros, conciliação)
- Testes de carga/performance, consumo de bateria e memória
- Compatibilidade ampla de dispositivos (fora do(s) device(s) definido(s) para teste)
- Segurança (pentest), criptografia e análise de vulnerabilidades
- Integrações externas (gateways de pagamento, bancos) além da navegação/UI

## 4. Estratégia de Teste

**Automação com Maestro**
- Ferramenta principal: Maestro (CLI e Studio) para execução de testes UI.
- Estratégia de Dados:
  - Uso de variáveis de ambiente (`.env`) para credenciais sensíveis (CPF, Senha, Cartão).
  - Remoção de hardcoding nos arquivos de teste para maior portabilidade e segurança.
- Técnicas de Interação:
  - `scrollUntilVisible`: Essencial para telas longas (formulários de cartão, termos de uso).
  - Regex (`(?i)texto.*`, `.*R\$.*`): Uso extensivo para lidar com valores dinâmicos, quebras de linha em botões e variações de texto.
  - `swipe`: Utilizado para ajustes finos de visibilidade quando o scroll padrão não é suficiente (ex: rodapé de pagamento).
- Evidências em falha:
  - `screenshotOnFailure: true` e `videoOnFailure: true` (configurado em `maestro.yaml`).
  - Diretório configurado do projeto: `./test-results` (ver `maestro.yaml`).

**Abordagem de Page Objects e Nested Flows**
- Page Objects: validações e checks de cada tela ficam em `tests/pages/*.yaml` (ex.: `financeiro_page.yaml`, `pagamentos_page.yaml`, `login_page.yaml`).
- Nested Flows: cenários reutilizáveis e passos comuns são chamados via `runFlow` (ex.: `tests/flows/login_sucesso_flow.yaml`).
- Princípios adotados:
  - Evitar duplicação: o teste “de cenário” contém navegação e ação principal; validações de tela ficam no Page correspondente.
  - Independência: cada flow deve poder ser executado isoladamente (preferencialmente com `launchApp: clearState: true` quando necessário).
  - Robustez: preferir `scrollUntilVisible` para elementos ocultos (especialmente em formulários) e regex flexível (ex.: `.*R\$.*`) para valores monetários e botões com quebra de linha.

**Execução de Suites**
- Execução por pasta (suite) com ordem definida e continuidade após falha:
  - `tests/auth/config.yaml` define `executionOrder` com `continueOnFailure: true`.
- Execução por arquivo “suite” (encadeamento via `runFlow`):
  - `tests/flows/suite_auth_flow.yaml`
  - `tests/flows/suite_financeiro_flow.yaml`

Exemplos (CLI):
```bash
maestro test tests/auth
maestro test tests/flows/suite_auth_flow.yaml
maestro test tests/flows/suite_financeiro_flow.yaml
```

## 5. Critérios de Transição

**Critérios de Entrada**
- APK disponível e instalável (build estável e assinado conforme ambiente de teste).
- Ambiente de execução pronto:
  - Android Emulator/Device disponível e acessível via ADB.
  - Dependências instaladas (Maestro, SDK Android).
- Dados de teste configurados (variáveis em `.env` e/ou variáveis de ambiente no processo).

**Critérios de Saída**
- 100% dos casos críticos (Prioridade Alta) aprovados.
- Evidências de falhas (screenshot/vídeo/log) coletadas para cada caso reprovado.
- Nenhum bloqueador aberto sem plano de correção acordado.

## 6. Riscos e Contingências

| ID  | Risco | Probabilidade | Impacto | Plano de Mitigação |
|-----|-------|---------------|---------|--------------------|
| R-01 | Elementos sem `testID`/IDs acessíveis dificultam seleção estável | Alta | Alto | Preferir seletores por texto/regex, solicitar `testID` no app, usar `scrollUntilVisible` e pontos apenas quando inevitável |
| R-02 | Textos variam (copy, capitalização, pontuação) causando falsos negativos | Média | Médio | Usar `assertVisible` com `text:` regex e `extendedWaitUntil` para mensagens dinâmicas |
| R-03 | Dependência de estado (sessão, onboarding, biometria) quebra execução em sequência | Alta | Alto | Garantir `clearState` nos fluxos críticos, criar passos defensivos para modais recorrentes (ex.: “Agora Não”) |
| R-04 | Instabilidade do ambiente (emulador lento, ADB intermitente) | Média | Alto | Padronizar device, ajustar timeouts, reiniciar emulador/ADB, executar em máquina dedicada quando possível |
| R-05 | Mudanças de layout exigem atualização constante dos Page Objects | Média | Médio | Centralizar validações em `tests/pages/*`, revisar pages por release e manter testes de cenário mínimos |
| R-07 | Teclado virtual cobrindo elementos de ação (botões de rodapé) | Alta | Alto | Uso sistemático de `hideKeyboard` antes de interações finais e `swipe` manual para garantir visibilidade |
| R-08 | Quebra de linha em botões com valores monetários (ex: "Pagar \n R$ 100") | Alta | Alto | Adoção de regex que ignora quebras de linha (`.*R\$.*`) em vez de match exato de texto |

## 7. Modelo de Caso de Teste

Tabela completa (casos executados): [casos-de-teste.md](casos-de-teste.md)

| ID | Título | Prioridade | Passos | Resultados Esperados |
|----|--------|------------|--------|----------------------|
| TC-AUTH-001 | Login com credenciais válidas | Alta | 1) Abrir app 2) Informar CPF 3) Informar senha 4) Entrar | Usuário autenticado e Home exibida com elementos principais |
| TC-AUTH-002 | Login com senha errada | Alta | 1) Abrir app 2) Informar CPF 3) Informar senha inválida 4) Entrar | Mensagem de autenticação falhou exibida |
| TC-FIN-001 | Validar tela Financeiro | Alta | 1) Login 2) Abrir Financeiro 3) Validar elementos | Cards e FAQ visíveis |
