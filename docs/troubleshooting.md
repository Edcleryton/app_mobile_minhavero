# Troubleshooting — erros e soluções

## Links
- [Configuração do Maestro no Windows](maestro-windows-setup.md)
- [Primeiros passos](primeiros-passos.md)

---

## Erro 1: java is not recognized as an internal or external command
**Causa:** Java não está no PATH ou não foi instalado.

**Solução:**
```powershell
java -version
echo $env:JAVA_HOME
```

Se `JAVA_HOME` estiver vazio, configure e abra um PowerShell novo.

---

## Erro 2: adb is not recognized as an internal or external command
**Causa:** Android SDK não está no PATH.

**Solução:**
```powershell
adb --version
echo $env:ANDROID_HOME
```

Adicione ao PATH:
```
%ANDROID_HOME%\platform-tools
%ANDROID_HOME%\tools
```

Abra um PowerShell novo.

---

## Erro 3: maestro is not recognized as an internal or external command
**Causa:** Maestro não foi instalado ou NPM não está no PATH.

**Solução:**
```powershell
node --version
npm --version
npm install -g maestro-cli
maestro --version
```

Se ainda falhar, verifique o executável:
```powershell
C:\Users\[seu-usuário]\AppData\Roaming\npm\maestro --version
```

---

## Erro 4: No Android devices found
**Causa:** Nenhum emulador está rodando ou dispositivo conectado.

**Solução:**
```powershell
adb devices
```

Resultado esperado:
```
List of attached devices
emulator-5554          device
```

Se for device físico, habilite Depuração USB nas Developer Options.

---

## Erro 5: ANDROID_HOME is not set
**Causa:** Variável ANDROID_HOME não foi configurada.

**Solução:**
1. Windows + X → Sistema → Variáveis de Ambiente
2. Crie `ANDROID_HOME` com o valor:
```
C:\Users\[seu-usuário]\AppData\Local\Android\Sdk
```
3. Abra um PowerShell novo e valide:
```powershell
echo $env:ANDROID_HOME
```

---

## Erro 6: Failed to install APK
**Causa:** Problemas ao instalar o APK no device/emulador.

**Solução:**
```powershell
adb devices
adb install -r "C:\Users\edcle\OneDrive\Desktop\minhaVeroApp\app versao\app-v2-hml-10489.apk"
```

Se necessário:
```powershell
adb uninstall com.minhaVero
adb install "C:\Users\edcle\OneDrive\Desktop\minhaVeroApp\app versao\app-v2-hml-10489.apk"
```

---

## Erro 7: PowerShell script cannot be loaded because running scripts is disabled
**Causa:** Política de execução do PowerShell bloqueada.

**Solução:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser
.\run-tests-with-notifications.ps1
```

---

## Erro 8: Maestro test failed - timeout waiting for element
**Causa:** Elemento demorou para carregar ou seletor está incorreto.

**Solução (Maestro):**

Opção 1: Espera explícita com timeout:
```yaml
- extendedWaitUntil:
    visible:
      text: "Meu Elemento"
    timeout: 15000
```

Opção 2: Espera curta antes de interagir:
```yaml
- wait:
    seconds: 2
- tapOn:
    text: "Meu Elemento"
```

Opção 3: Inspecionar no Studio:
```powershell
maestro studio
```

---

## Erro 9: Cannot connect to emulator
**Causa:** Emulador não está rodando ou ADB com porta ocupada.

**Solução:**
```powershell
adb devices
adb kill-server
adb start-server
```

Se precisar investigar porta 5037:
```powershell
netstat -ano | findstr :5037
taskkill /PID [PID] /F
adb kill-server
adb start-server
```

---

## Erro 10: App crashed or unexpectedly closed
**Causa:** Bug do app ou ambiente inconsistente.

**Solução:**
```powershell
adb logcat | findstr [seu-app-package]
```

Reinstalação:
```powershell
adb uninstall com.minhaVero
adb install "C:\caminho\app-v2-hml-10489.apk"
```

---

## Erro 11: Email notification failed to send
**Causa:** Credenciais de email incorretas ou SMTP não configurado.

**Solução (Gmail):**
1. Ative a verificação em duas etapas:
   - https://myaccount.google.com/ (Security → 2-Step Verification)
2. Gere uma senha de app:
   - https://myaccount.google.com/apppasswords
   - Selecione Mail e Windows Computer
3. Use a senha de app (16 caracteres) quando o script solicitar.

**Solução (Outlook):**
```powershell
$SmtpServer = "smtp.outlook.com"
$SmtpPort = 587
```

**Solução (outros provedores):**
Procure as configurações SMTP do provedor (host, porta, TLS e autenticação).

---

## Erro 12: No such file or directory (caminho do APK)
**Causa:** Caminho do APK incorreto ou espaços no caminho não foram interpretados corretamente.

**Solução:**
```powershell
Test-Path "C:\Users\edcle\OneDrive\Desktop\minhaVeroApp\app versao\app-v2-hml-10489.apk"
```

Se tiver espaços no caminho, use aspas:
```powershell
maestro test "tests/login.yaml" --app-file "C:\Users\edcle\OneDrive\Desktop\minhaVeroApp\app versao\app-v2-hml-10489.apk"
```

Se ainda falhar, copie para um caminho sem espaços:
```powershell
mkdir C:\Maestro\apps
Copy-Item "C:\Users\edcle\OneDrive\Desktop\minhaVeroApp\app versao\app-v2-hml-10489.apk" "C:\Maestro\apps\app.apk"
maestro test tests/login.yaml --app-file "C:\Maestro\apps\app.apk"
```

---

## Erro 13: Git Bash PowerShell script execution denied
**Causa:** Git Bash não executa scripts PowerShell diretamente como `.ps1`.

**Solução:**
No Git Bash, chame o PowerShell explicitamente:
```bash
powershell -ExecutionPolicy Bypass -File .\run-tests-with-notifications.ps1
```

---

## Erro 14: YAML syntax error
**Causa:** Erro de indentação/sintaxe no `.yaml`.

**Solução:**
- Use espaços (2 por nível) e evite tabs.
- Valide o YAML em https://www.yamllint.com/
- No VS Code, instale a extensão “YAML” para apontar erros automaticamente.

Exemplo (indentação correta):
```yaml
testCases:
  - testID: meu_teste
    commands:
      - action: launchApp
      - action: tap
        selector:
          text: "Botão"
```

---

## Erro 15: Seletor text não encontra o elemento
**Causa:** O texto não corresponde exatamente, ou o elemento é melhor identificado por `resourceId`.

**Solução:**
1. Inspecione no Studio:
```powershell
maestro studio
```

2. Prefira `resourceId` quando disponível:
```yaml
- tapOn:
    id: "com.minhaVero:id/meu_botao"
```

3. Se o texto variar, use regex:
```yaml
- assertVisible:
    text: "(?i)entrar"
```

---

## Erro 16: Device storage is full
**Causa:** Emulador ficou sem espaço livre.

**Solução:**
```powershell
adb shell pm clear com.minhaVero
adb shell rm -rf /data/local/tmp/*
```

Se for emulador, use o AVD Manager para “Wipe Data” (opção mais segura para reset total).

---

## Erro 17: Selectors are ambiguous (multiple matches)
**Causa:** O seletor encontrou múltiplos elementos.

**Solução:**
- Seja mais específico (preferencialmente com `id`):
```yaml
- tapOn:
    id: "com.minhaVero:id/btn_ok"
```

Se precisar usar texto, combine com outras estratégias (ex.: navegação até a tela correta, `scrollUntilVisible`, etc.).

---

## Erro 18: Test execution timeout
**Causa:** Um teste inteiro demorou além do esperado.

**Solução (configuração global):**
No [maestro.yaml](file:///c:/Users/edcle/OneDrive/Desktop/minhaVeroApp/maestro.yaml), aumente:
```yaml
appLaunchTimeout: 60000
commandTimeout: 30000
```

**Solução (no flow):**
```yaml
- wait:
    seconds: 3
```

---

## Erro 19: Port forwarding failed
**Causa:** Problemas de comunicação com emulador/dispositivo (ADB instável).

**Solução:**
```powershell
adb kill-server
adb start-server
Start-Sleep -Seconds 5
adb devices
```

---

## Erro 20: Build tools not found
**Causa:** Android SDK Build-Tools não está instalado.

**Solução (Android Studio):**
1. Abra Android Studio
2. File → Settings → Appearance & Behavior → System Settings → Android SDK
3. Aba SDK Tools
4. Marque Android SDK Build-Tools (versão mais recente)
5. Apply

**Solução (Command line):**
```powershell
sdkmanager "build-tools;33.0.0"
sdkmanager "build-tools;34.0.0"
```

---

## Histórico de mudanças
- v1.0 (Jan 2026): Documento inicial com 20 erros comuns e soluções
