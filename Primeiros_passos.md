# Guia Completo: Instalação e Primeiros Passos com Maestro Studio

## 📋 Índice
1. Pré-requisitos e Dependências
2. Instalação passo a passo
3. Primeiros passos no Maestro Studio
4. Configuração de testes
5. Rodando os testes
6. CI/CD com GitHub

---

## 1️⃣ PRÉ-REQUISITOS E DEPENDÊNCIAS

### Requisitos Mínimos do Sistema

- **Windows 10/11** ou macOS/Linux
- **4GB de RAM** (recomendado 8GB)
- **2GB de espaço em disco** (para ferramentas)
- **Acesso à internet** (para downloads)

### Dependências Obrigatórias

1. **Java Development Kit (JDK)**
   - Versão: 17 ou superior
   - Necessário para: Android SDK, Maestro

2. **Node.js + npm**
   - Versão: 16 ou superior
   - Necessário para: Maestro CLI

3. **Android SDK**
   - Para: Testar em emuladores Android
   - Ferramentas necessárias: Android Emulator, Platform Tools

4. **Git**
   - Para: Versionamento de código
   - Necessário para: GitHub, CI/CD

### Dependências Opcionais

- **Python** (recomendado para scripts de token dinâmico)
- **Visual Studio Code** (editor para YAML)

---

## 2️⃣ INSTALAÇÃO PASSO A PASSO

### A. Instalação via Download (Recomendado para Iniciantes)

#### Passo 1: Instalar Java (JDK 17)

**Link de Download:**
```
https://www.oracle.com/java/technologies/downloads/#java17
```

**Passos:**
1. Acesse o link acima
2. Clique em "Windows x64 Installer" (se usar Windows)
3. Faça login (crie conta Oracle grátis se necessário)
4. Execute o instalador
5. Clique "Next" → "Install" → "Finish"

**Verificar instalação:**
```powershell
java -version
```

Deve retornar algo como: `java version "17.0.x"`

---

#### Passo 2: Instalar Node.js

**Link de Download:**
```
https://nodejs.org/en/download/
```

**Passos:**
1. Acesse o link acima
2. Clique em "Windows Installer (.msi)" - versão LTS
3. Execute o instalador
4. Clique "Next" → aceite os termos → "Install" → "Finish"
5. Marque "Automatically install the necessary tools"

**Verificar instalação:**
```powershell
node --version
npm --version
```

---

#### Passo 3: Instalar Git

**Link de Download:**
```
https://git-scm.com/download/win
```

**Passos:**
1. Acesse o link acima
2. O download começa automaticamente
3. Execute o instalador
4. Clique "Next" em todas as telas (padrão é OK)
5. Clique "Finish"

**Verificar instalação:**
```powershell
git --version
```

---

#### Passo 4: Instalar Android Studio + SDK

**Link de Download:**
```
https://developer.android.com/studio
```

**Passos:**
1. Acesse o link acima
2. Clique em "Download Android Studio"
3. Aceite os termos e comece o download
4. Execute o instalador
5. Na tela de componentes, certifique-se que estão marcados:
   - ☑ Android SDK
   - ☑ Android SDK Platform
   - ☑ Android Emulator
   - ☑ Android SDK Platform-Tools
6. Clique "Next" → "Install"
7. Deixe aberto quando terminar

**Configurar variável de ambiente:**

1. Abra o **PowerShell como Administrador**
2. Execute:

```powershell
[Environment]::SetEnvironmentVariable("ANDROID_HOME", "C:\Users\$env:USERNAME\AppData\Local\Android\Sdk", "User")
[Environment]::SetEnvironmentVariable("PATH", "$env:PATH;C:\Users\$env:USERNAME\AppData\Local\Android\Sdk\platform-tools", "User")
```

3. Feche e reabra o PowerShell

**Verificar instalação:**
```powershell
adb --version
```

---

#### Passo 5: Instalar Maestro

**Link de Download Direto:**
```
https://get.maestro.mobile.dev
```

**Via PowerShell (recomendado):**

```powershell
# Execute como Administrador
curl -Ls "https://get.maestro.mobile.dev" | bash
```

Se receber erro de SSL, tente:

```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
curl -Ls "https://get.maestro.mobile.dev" | bash
```

**Ou manualmente:**

1. Vá até: `https://github.com/mobile-dev-inc/maestro/releases`
2. Procure a versão mais recente
3. Baixe `maestro-cli-x.xx.x-windows.zip`
4. Extraia em `C:\Maestro`
5. Adicione ao PATH do Windows:

```powershell
[Environment]::SetEnvironmentVariable("PATH", "$env:PATH;C:\Maestro\bin", "User")
```

**Verificar instalação:**
```powershell
maestro --version
```

---

### B. Instalação via PowerShell (Automatizada)

Se preferir instalar tudo de uma vez, execute este script no **PowerShell como Administrador**:

```powershell
# Script de instalação completa do Maestro

Write-Host "=== Instalando Maestro e Dependências ===" -ForegroundColor Green

# Instalar Chocolatey (gerenciador de pacotes)
Write-Host "Instalando Chocolatey..." -ForegroundColor Yellow
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Instalar dependências via Chocolatey
Write-Host "Instalando Java 17..." -ForegroundColor Yellow
choco install jdk17 -y

Write-Host "Instalando Node.js..." -ForegroundColor Yellow
choco install nodejs -y

Write-Host "Instalando Git..." -ForegroundColor Yellow
choco install git -y

Write-Host "Instalando Android Studio..." -ForegroundColor Yellow
choco install android-studio -y

# Instalar Maestro
Write-Host "Instalando Maestro..." -ForegroundColor Yellow
curl -Ls "https://get.maestro.mobile.dev" | bash

# Configurar variáveis de ambiente
Write-Host "Configurando variáveis de ambiente..." -ForegroundColor Yellow
[Environment]::SetEnvironmentVariable("ANDROID_HOME", "C:\Users\$env:USERNAME\AppData\Local\Android\Sdk", "User")
[Environment]::SetEnvironmentVariable("PATH", "$env:PATH;C:\Users\$env:USERNAME\AppData\Local\Android\Sdk\platform-tools", "User")

Write-Host "=== Instalação Completa! ===" -ForegroundColor Green
Write-Host "Feche e reabra o PowerShell para aplicar as mudanças." -ForegroundColor Cyan

# Verificar instalações
Write-Host "`nVerificando instalações..." -ForegroundColor Yellow
Write-Host "Java: $(java -version 2>&1 | Select-Object -First 1)"
Write-Host "Node: $(node --version)"
Write-Host "Git: $(git --version)"
Write-Host "Maestro: $(maestro --version)"
```

**Para usar este script:**

1. Copie o código acima
2. Abra **PowerShell como Administrador**
3. Cole o código e pressione Enter
4. Deixe rodar (pode levar 15-20 minutos)
5. Feche e reabra o PowerShell

---

## 3️⃣ PRIMEIROS PASSOS NO MAESTRO STUDIO

### Iniciar Maestro Studio

```powershell
maestro studio
```

Isso abrirá a interface visual do Maestro.

### Estrutura de Pastas Recomendada

```
C:\Users\SeuUsuario\Desktop\MaestroTests\
├── login_test.yaml
├── .env
├── .gitignore
└── .github\
    └── workflows\
        └── maestro-tests.yml
```

**Criar as pastas:**

```powershell
mkdir C:\Users\$env:USERNAME\Desktop\MaestroTests
cd C:\Users\$env:USERNAME\Desktop\MaestroTests
mkdir .github\workflows
```

---

## 4️⃣ CONFIGURAÇÃO DE TESTES

### Criar arquivo de teste: `login_test.yaml`

No Maestro Studio, crie um novo arquivo com o conteúdo abaixo:

```yaml
appId: com.vero_mobile
env:
  CPF_TESTE: ${CPF_TESTE}
  SENHA_TESTE: ${SENHA_TESTE}
---
# ============================================
# CENÁRIO 1: Validação - CPF obrigatório
# ============================================
- launchApp:
    clearState: true

- assertVisible: "CPF ou CNPJ:"
- tapOn: "Avançar"
- assertVisible: "Campo obrigatório"
- assertVisible: "Por favor, preencha o campo de CPF ou CNPJ."
- tapOn: "OK"

# ============================================
# CENÁRIO 2: Validação - Senha obrigatória
# ============================================
- launchApp:
    clearState: true

- tapOn: "Insira o número do seu documento"
- inputText: ${CPF_TESTE}
- tapOn: "Avançar"
- assertVisible: "Senha:"
- tapOn: "Entrar"
- assertVisible: "Campo obrigatório"
- assertVisible: "Preencha o campo de senha."
- tapOn: "OK"

# ============================================
# CENÁRIO 3: Validação - Credenciais inválidas
# ============================================
- launchApp:
    clearState: true

- tapOn: "Insira o número do seu documento"
- inputText: ${CPF_TESTE}
- tapOn: "Avançar"
- assertVisible: "Senha:"
- tapOn: "Insira sua senha"
- inputText: "senhaerrada123"
- tapOn: "Entrar"
- assertVisible: "Autenticação falhou"
- assertVisible: "Verifique se os dados de acesso estão corretos e tente novamente."
- tapOn: "OK"

# ============================================
# CENÁRIO 4: Login com sucesso (Happy Path)
# ============================================
- launchApp:
    clearState: true

- tapOn: "Insira o número do seu documento"
- inputText: ${CPF_TESTE}
- tapOn: "Avançar"
- assertVisible: "Senha:"
- tapOn: "Insira sua senha"
- inputText: ${SENHA_TESTE}
- tapOn: "Entrar"
- assertVisible: "Acesso rápido"
- assertVisible: "Destaques"
- assertVisible: "Home"
```

### Configurar Variáveis de Ambiente no Maestro Studio

1. Abra o **Environment Manager** (ícone de engrenagem ⚙️)
2. Clique em **"+ Add"** para criar novo environment
3. Nomeie como `local` ou deixe `env1`
4. Clique em **"+ Add Variable"**
5. Configure:
   - **Key:** `CPF_TESTE` | **Value:** `12345678909` (CPF válido de teste)
   - **Key:** `SENHA_TESTE` | **Value:** `sua_senha_valida`
6. Clique em **"Save"**

### Criar arquivo `.env` (local)

Na pasta `MaestroTests`, crie arquivo `.env`:

```env
CPF_TESTE=12345678909
SENHA_TESTE=sua_senha_aqui
```

### Criar arquivo `.gitignore`

Para nunca fazer commit das credenciais:

```gitignore
.env
*.env
node_modules/
.maestro/
```

---

## 5️⃣ RODANDO OS TESTES

### Opção 1: Via Maestro Studio (Interface Visual)

1. Abra Maestro Studio: `maestro studio`
2. Carregue o arquivo `login_test.yaml`
3. Selecione o environment `local`
4. Clique no botão **▶️ Run**
5. Acompanhe a execução em tempo real

### Opção 2: Via PowerShell (Linha de Comando)

**Rodar um teste específico:**
```powershell
maestro test login_test.yaml
```

**Rodar todos os testes da pasta:**
```powershell
maestro test .
```

**Com variáveis de ambiente:**
```powershell
$env:CPF_TESTE="12345678909"
$env:SENHA_TESTE="sua_senha_aqui"
maestro test login_test.yaml
```

### Opção 3: Via Script PowerShell

Crie `rodar_testes.ps1`:

```powershell
# Carregar variáveis do arquivo .env
if (Test-Path ".env") {
    Get-Content ".env" | ForEach-Object {
        if ($_ -match "^([^=]+)=(.*)$") {
            [Environment]::SetEnvironmentVariable($matches[1], $matches[2], "Process")
        }
    }
}

Write-Host "Rodando testes Maestro..." -ForegroundColor Green
maestro test login_test.yaml

Write-Host "Testes concluídos!" -ForegroundColor Yellow
```

**Para executar:**
```powershell
.\rodar_testes.ps1
```

---

## 6️⃣ CI/CD COM GITHUB

### Configurar Repositório GitHub

**1. Criar repositório:**
```powershell
cd C:\Users\$env:USERNAME\Desktop\MaestroTests
git init
git remote add origin https://github.com/seu_usuario/maestro-tests.git
```

**2. Fazer commit inicial:**
```powershell
git add .
git commit -m "Initial commit: Maestro login tests"
git branch -M main
git push -u origin main
```

### Adicionar Secrets no GitHub

1. Vá para seu repositório GitHub
2. **Settings** → **Secrets and variables** → **Actions**
3. Clique em **"New repository secret"**
4. Adicione:
   - **Name:** `CPF_TESTE` | **Value:** `12345678909`
   - **Name:** `SENHA_TESTE` | **Value:** `sua_senha_aqui`

### Criar Pipeline CI/CD

Na pasta do seu repositório, crie `.github/workflows/maestro-tests.yml`:

```yaml
name: Maestro UI Tests

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]
  schedule:
    - cron: '0 8 * * *'  # Rodar diariamente às 8:00 UTC

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3

    - name: Setup Java
      uses: actions/setup-java@v3
      with:
        distribution: 'temurin'
        java-version: '17'

    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'

    - name: Setup Android SDK
      uses: android-actions/setup-android@v2

    - name: Install Maestro
      run: |
        curl -Ls "https://get.maestro.mobile.dev" | bash
        echo "${HOME}/.maestro/bin" >> $GITHUB_PATH

    - name: Run Maestro Tests
      env:
        CPF_TESTE: ${{ secrets.CPF_TESTE }}
        SENHA_TESTE: ${{ secrets.SENHA_TESTE }}
      run: |
        maestro test login_test.yaml

    - name: Upload Test Results
      if: always()
      uses: actions/upload-artifact@v3
      with:
        name: test-results
        path: |
          maestro-report/
          logs/
```

### Fazer commit e push:

```powershell
git add .github/workflows/maestro-tests.yml
git commit -m "Add CI/CD pipeline for Maestro tests"
git push origin main
```

Agora seus testes rodarão **automaticamente** a cada push! 🚀

---

## 📝 RESUMO - CHECKLIST DE INSTALAÇÃO

- [ ] Java JDK 17 instalado
- [ ] Node.js + npm instalado
- [ ] Git instalado
- [ ] Android SDK instalado
- [ ] Maestro instalado
- [ ] Pasta de testes criada
- [ ] arquivo `login_test.yaml` criado
- [ ] Variáveis configuradas no Maestro Studio
- [ ] arquivo `.env` criado (gitignored)
- [ ] Testes rodando no Maestro Studio
- [ ] Repositório GitHub criado
- [ ] Secrets configuradas no GitHub
- [ ] Pipeline CI/CD ativa

---

## 🆘 TROUBLESHOOTING

### Problema: "maestro: comando não encontrado"
**Solução:** O PATH não foi atualizado. Feche e reabra o PowerShell como Administrador.

### Problema: "Android SDK not found"
**Solução:** Verifique se ANDROID_HOME está configurado:
```powershell
echo $env:ANDROID_HOME
```

### Problema: "Java version not found"
**Solução:** Instale Java 17+ e adicione ao PATH.

### Problema: Teste falha no GitHub Actions
**Solução:** Verifique se os Secrets estão corretos em Settings → Secrets.

### Problema: "Certificate validation failed"
**Solução:** Execute no PowerShell:
```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
```

---

## 📚 RECURSOS ÚTEIS

- **Documentação Maestro:** https://maestro.mobile.dev/
- **Comunidade Discord:** https://discord.gg/maestro
- **GitHub Maestro:** https://github.com/mobile-dev-inc/maestro
- **Android Studio:** https://developer.android.com/studio

---

## ✨ Próximos Passos

1. Seguir este guia para instalar tudo
2. Rodar os testes localmente no Maestro Studio
3. Configurar GitHub e CI/CD
4. Adicionar mais cenários de teste
5. Integrar com tokens dinâmicos de API

**Bom teste! 🚀**
