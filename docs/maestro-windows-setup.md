# Configuração do Maestro no Windows

## Links
- [Primeiros passos](primeiros-passos.md)
- [Troubleshooting (erros e soluções)](troubleshooting.md)

---

## Pré-requisitos
- Windows 10 ou Windows 11
- Acesso de Administrador
- Conexão com a internet
- Mínimo 10GB de espaço livre em disco
- Android Emulator ou Device Android conectado

---

## Instalação do Java JDK

### Baixar Java JDK
Acesse:
```
https://www.oracle.com/java/technologies/downloads/
```

Recomendado: JDK 11 ou JDK 17 (LTS)

### Instalar Java JDK
1. Execute o instalador baixado
2. Finalize com o caminho padrão (ou anote o caminho escolhido)

Local padrão após instalação:
```
C:\Program Files\Java\jdk-17
```

### Verificar instalação do Java
```powershell
java -version
javac -version
```

---

## Instalação do Android SDK

### Método 1: Android Studio (recomendado)
Baixe em:
```
https://developer.android.com/studio
```

Após instalar, verifique em File → Settings → Appearance & Behavior → System Settings → Android SDK o caminho do SDK (padrão):
```
C:\Users\[seu-usuário]\AppData\Local\Android\Sdk
```

Garanta que estão instalados:
- Android SDK Platform
- Android SDK Build-Tools
- Android Emulator
- Android SDK Platform-Tools
- Android SDK Tools

### Método 2: SDK Standalone (sem Android Studio)
1. Baixe Command line tools only em:
```
https://developer.android.com/studio
```
2. Extraia em:
```
C:\Android\cmdline-tools\latest
```
3. Instale pacotes via sdkmanager:
```powershell
cd C:\Android\cmdline-tools\latest\bin
.\sdkmanager.bat --list
.\sdkmanager.bat "platforms;android-33"
.\sdkmanager.bat "build-tools;33.0.0"
.\sdkmanager.bat "platform-tools"
```

---

## Configuração de variáveis de ambiente

### Variáveis
- `JAVA_HOME` = caminho do JDK (ex.: `C:\Program Files\Java\jdk-17`)
- `ANDROID_HOME` = caminho do SDK (ex.: `C:\Users\[seu-usuário]\AppData\Local\Android\Sdk`)

### PATH
Adicione ao PATH:
```
%JAVA_HOME%\bin
%ANDROID_HOME%\platform-tools
%ANDROID_HOME%\tools
```

### Verificar
Abra um PowerShell novo e execute:
```powershell
echo $env:JAVA_HOME
echo $env:ANDROID_HOME
adb --version
```

---

## Instalação do Node.js e NPM
Baixe a versão LTS em:
```
https://nodejs.org/
```

Verifique:
```powershell
node --version
npm --version
```

---

## Instalação do Maestro

Instale via NPM:
```powershell
npm install -g maestro-cli
```

Verifique:
```powershell
maestro --version
```

---

## Checklist final de configuração

```powershell
java -version
echo $env:ANDROID_HOME
adb --version
node --version
npm --version
maestro --version
adb devices
```
