# File: run-tests-with-notifications.ps1
# Script para executar testes Maestro com captura de evidências e notificação por email

param(
    [string]$TestFile = "tests/login.yaml",
    [string]$AppPath = "C:\Users\edcle\OneDrive\Desktop\minhaVeroApp\app versao\app-v2-hml-10489.apk",
    [string]$EmailTo = "seu-email@gmail.com",
    [string]$EmailFrom = "seu-email@gmail.com",
    [string]$SmtpServer = "smtp.gmail.com",
    [int]$SmtpPort = 587
)

# ========== CONFIGURAÇÕES ==========
$ResultsDir = ".\test-results"
$LogDir = ".\logs"
$EvidenceDir = "$ResultsDir\evidences"
$Timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$LogFile = "$LogDir\test-run_$Timestamp.log"

# Criar diretórios se não existirem
if (-not (Test-Path $ResultsDir)) { New-Item -ItemType Directory -Path $ResultsDir | Out-Null }
if (-not (Test-Path $LogDir)) { New-Item -ItemType Directory -Path $LogDir | Out-Null }
if (-not (Test-Path $EvidenceDir)) { New-Item -ItemType Directory -Path $EvidenceDir | Out-Null }

# ========== FUNÇÕES ==========
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $LogMessage = "[$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss'))] [$Level] $Message"
    Write-Host $LogMessage
    Add-Content -Path $LogFile -Value $LogMessage
}

function Get-FailedTestInfo {
    param([string]$TestOutput)
    
    $FailedTests = @()
    $Lines = $TestOutput -split "`n"
    
    foreach ($Line in $Lines) {
        if ($Line -match "FAILED|ERROR|❌") {
            $FailedTests += $Line
        }
    }
    
    return $FailedTests
}

function Send-EmailNotification {
    param(
        [string]$TestResult,
        [array]$FailedTests,
        [string]$LogFilePath,
        [array]$Screenshots
    )
    
    Write-Log "Preparando envio de email de notificação..."
    
    try {
        # Criar credenciais (será solicitado a senha na primeira execução)
        $SecurePassword = Read-Host "Digite sua senha de email (ou senha de app)" -AsSecureString
        $Credential = New-Object System.Management.Automation.PSCredential($EmailFrom, $SecurePassword)
        
        # Montar o corpo do email
        $EmailBody = @"
RELATÓRIO DE TESTES - MINHA VERO APP
=====================================

Data/Hora: $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')
Arquivo de Teste: $TestFile

RESULTADO: $TestResult

TESTES COM FALHA:
$(if ($FailedTests.Count -gt 0) { $FailedTests | Out-String } else { "Nenhum teste falhou!" })

LOCALIZAÇÃO DAS EVIDÊNCIAS:
- Pasta de Resultados: $ResultsDir
- Pasta de Evidências: $EvidenceDir
- Log Detalhado: $LogFilePath

SCREENSHOTS/VÍDEOS CAPTURADOS:
$(if ($Screenshots.Count -gt 0) { $Screenshots | ForEach-Object { "  - $_" } | Out-String } else { "Nenhum screenshot capturado" })

PRÓXIMOS PASSOS:
1. Verifique as evidências em: $EvidenceDir
2. Analise o log completo em: $LogFilePath
3. Corrija os problemas identificados
4. Execute novamente os testes

Att,
Sistema de Testes Maestro
"@

        $EmailParams = @{
            From       = $EmailFrom
            To         = $EmailTo
            Subject    = "⚠️ FALHA NOS TESTES - Minha Vero App [$Timestamp]"
            Body       = $EmailBody
            SmtpServer = $SmtpServer
            Port       = $SmtpPort
            UseSsl     = $true
            Credential = $Credential
        }
        
        Send-MailMessage @EmailParams -ErrorAction Stop
        Write-Log "Email enviado com sucesso para $EmailTo" "SUCCESS"
        
    } catch {
        Write-Log "Erro ao enviar email: $($_.Exception.Message)" "ERROR"
        Write-Log "Verifique suas credenciais e configurações SMTP" "WARNING"
    }
}

function Organize-TestArtifacts {
    # Procurar por screenshots e vídeos gerados pelo Maestro
    Write-Log "Organizando artefatos de teste..."
    
    $Screenshots = @()
    $Videos = @()
    
    # Procurar em diretórios comuns onde Maestro salva evidências
    $SearchDirs = @(
        "$ResultsDir",
        ".\build\test-results",
        "$env:TEMP\maestro"
    )
    
    foreach ($Dir in $SearchDirs) {
        if (Test-Path $Dir) {
            $Screenshots += Get-ChildItem -Path $Dir -Filter "*.png" -Recurse -ErrorAction SilentlyContinue
            $Videos += Get-ChildItem -Path $Dir -Filter "*.mp4" -Recurse -ErrorAction SilentlyContinue
        }
    }
    
    # Copiar para pasta de evidências
    foreach ($Screenshot in $Screenshots) {
        Copy-Item -Path $Screenshot.FullName -Destination $EvidenceDir -Force -ErrorAction SilentlyContinue
        Write-Log "Screenshot armazenado: $($Screenshot.Name)" "INFO"
    }
    
    foreach ($Video in $Videos) {
        Copy-Item -Path $Video.FullName -Destination $EvidenceDir -Force -ErrorAction SilentlyContinue
        Write-Log "Vídeo armazenado: $($Video.Name)" "INFO"
    }
    
    return @{
        Screenshots = $Screenshots.Name
        Videos = $Videos.Name
    }
}

# ========== EXECUÇÃO PRINCIPAL ==========
Write-Log "========== INICIANDO EXECUÇÃO DE TESTES ==========" "INFO"
Write-Log "Arquivo de teste: $TestFile" "INFO"
Write-Log "App: $AppPath" "INFO"
Write-Log "Resultados serão salvos em: $ResultsDir" "INFO"

try {
    # Executar testes Maestro
    Write-Log "Executando testes Maestro..." "INFO"
    
    $MaestroCmd = "maestro test `"$TestFile`" --app-file `"$AppPath`" --output `"$ResultsDir`""
    Write-Log "Comando: $MaestroCmd" "DEBUG"
    
    $TestOutput = Invoke-Expression $MaestroCmd 2>&1
    $TestResult = $LASTEXITCODE
    
    Write-Log "Testes concluídos com código de saída: $TestResult" "INFO"
    
    # Organizar artefatos
    $Artifacts = Organize-TestArtifacts
    
    # Verificar se houve falhas
    if ($TestResult -ne 0) {
        Write-Log "⚠️ FALHA DETECTADA NOS TESTES" "ERROR"
        
        $FailedTests = Get-FailedTestInfo $TestOutput
        Write-Log "Testes com falha: $(($FailedTests | Measure-Object).Count)" "ERROR"
        
        # Enviar notificação por email
        Write-Log "Enviando notificação por email..." "INFO"
        Send-EmailNotification -TestResult "FALHOU ❌" -FailedTests $FailedTests -LogFilePath $LogFile -Screenshots $Artifacts.Screenshots
        
        Write-Log "EVIDÊNCIAS SALVAS EM: $EvidenceDir" "ERROR"
        
    } else {
        Write-Log "✅ TODOS OS TESTES PASSARAM!" "SUCCESS"
        Write-Log "Nenhuma notificação de erro será enviada" "INFO"
    }
    
} catch {
    Write-Log "Erro ao executar testes: $($_.Exception.Message)" "ERROR"
    Write-Log "Stack Trace: $($_.ScriptStackTrace)" "ERROR"
}

Write-Log "========== EXECUÇÃO FINALIZADA ==========" "INFO"
Write-Log "Logs salvos em: $LogFile" "INFO"
Write-Log "Evidências em: $EvidenceDir" "INFO"

# Abrir pastas automaticamente para visualização
if ($TestResult -ne 0) {
    Write-Host "`nAbrindo pasta de evidências..." -ForegroundColor Yellow
    Start-Process explorer.exe -ArgumentList $EvidenceDir
    
    Write-Host "Abrindo arquivo de log..." -ForegroundColor Yellow
    Start-Process notepad.exe -ArgumentList $LogFile
}
