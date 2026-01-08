# Primeiros passos (Minha Vero)

## Links
- [Configuração do Maestro no Windows](maestro-windows-setup.md)
- [Troubleshooting (erros e soluções)](troubleshooting.md)
- [Plano de teste (ISO/IEC/IEEE 29119-3)](plano-de-teste-iso29119-3.md)

---

## Estrutura dos testes

```
tests\
├── auth\
├── financeiro\
├── flows\
└── pages\
```

---

## Rodar suites principais

Certifique-se de que o arquivo `.env` na raiz do projeto esteja configurado com suas credenciais (`CPF_TESTE`, `SENHA_TESTE`, dados do cartão, etc.).

No PowerShell, na raiz do projeto:

```powershell
maestro test .\tests\flows\suite_auth_flow.yaml
```

```powershell
maestro test .\tests\flows\suite_financeiro_flow.yaml
```

---

## Evidências e saída

O projeto define o diretório de saída em:

- `./test-results` (ver [maestro.yaml](file:///c:/Users/edcle/OneDrive/Desktop/minhaVeroApp/maestro.yaml))

---

## Executar testes via script

```powershell
cd "C:\Users\edcle\OneDrive\Desktop\minhaVeroApp"
.\run-tests-with-notifications.ps1
```

Com parâmetro específico:
```powershell
.\run-tests-with-notifications.ps1 -TestFile "tests/home.yaml"
```

---

## Suporte adicional

Logs do script:
```powershell
Get-Content .\logs\test-run_*.log
```

Ativar debug do Maestro:
```powershell
$env:DEBUG="maestro:*"
maestro test tests/login.yaml
```

Comunidade Maestro:
- https://github.com/mobile-dev-inc/maestro
- https://github.com/mobile-dev-inc/maestro/discussions
