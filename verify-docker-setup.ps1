# Verificación rápida de configuración Docker - Rutina Gym (Windows)
# Ejecutar como: powershell .\verify-docker-setup.ps1

$ErrorActionPreference = "Stop"

Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  🔍 VERIFICACIÓN DE CONFIGURACIÓN DOCKER (Windows)" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# 1. Verificar Docker
Write-Host "1️⃣  Verificando Docker..." -ForegroundColor Yellow
try {
    $dockerVersion = docker --version
    Write-Host "   ✅ $dockerVersion" -ForegroundColor Green
} catch {
    Write-Host "   ❌ Docker no encontrado. Instala Docker Desktop." -ForegroundColor Red
    exit 1
}

# 2. Verificar Docker Compose
Write-Host ""
Write-Host "2️⃣  Verificando Docker Compose..." -ForegroundColor Yellow
try {
    $composeVersion = docker-compose --version
    Write-Host "   ✅ $composeVersion" -ForegroundColor Green
} catch {
    Write-Host "   ❌ Docker Compose no encontrado" -ForegroundColor Red
    exit 1
}

# 3. Verificar Java
Write-Host ""
Write-Host "3️⃣  Verificando Java..." -ForegroundColor Yellow
try {
    $javaVersion = java -version 2>&1 | Select-String "version"
    Write-Host "   ✅ $javaVersion" -ForegroundColor Green
} catch {
    Write-Host "   ❌ Java no encontrado" -ForegroundColor Red
    exit 1
}

# 4. Verificar Maven
Write-Host ""
Write-Host "4️⃣  Verificando Maven..." -ForegroundColor Yellow
try {
    $mvnVersion = mvn --version | Select-Object -First 1
    Write-Host "   ✅ $mvnVersion" -ForegroundColor Green
} catch {
    Write-Host "   ⚠️  Maven no encontrado (se descargará en Docker)" -ForegroundColor Yellow
}

# 5. Verificar archivos Prolog
Write-Host ""
Write-Host "5️⃣  Verificando archivos Prolog..." -ForegroundColor Yellow
$prologFiles = @(
    "knowledge_base.pl",
    "rules.pl",
    "validation.pl",
    "examples.pl",
    "integration.pl",
    "ejercicios.pl"
)

$allFound = $true
foreach ($file in $prologFiles) {
    $path = Join-Path "prolog" $file
    if (Test-Path $path) {
        Write-Host "   ✅ $file" -ForegroundColor Green
    } else {
        Write-Host "   ❌ $file NO ENCONTRADO" -ForegroundColor Red
        $allFound = $false
    }
}

if (-not $allFound) {
    Write-Host ""
    Write-Host "   ⚠️  Algunos archivos Prolog faltan" -ForegroundColor Yellow
}

# 6. Verificar estructura backend
Write-Host ""
Write-Host "6️⃣  Verificando estructura backend..." -ForegroundColor Yellow
if (Test-Path "backend/pom.xml") {
    Write-Host "   ✅ pom.xml" -ForegroundColor Green
} else {
    Write-Host "   ❌ pom.xml no encontrado" -ForegroundColor Red
    exit 1
}

if (Test-Path "backend/Dockerfile") {
    Write-Host "   ✅ Dockerfile" -ForegroundColor Green
} else {
    Write-Host "   ❌ Dockerfile no encontrado" -ForegroundColor Red
    exit 1
}

# 7. Verificar estructura frontend
Write-Host ""
Write-Host "7️⃣  Verificando estructura frontend..." -ForegroundColor Yellow
if (Test-Path "frontend/package.json") {
    Write-Host "   ✅ package.json" -ForegroundColor Green
} else {
    Write-Host "   ❌ package.json no encontrado" -ForegroundColor Red
    exit 1
}

if (Test-Path "frontend/Dockerfile") {
    Write-Host "   ✅ Dockerfile" -ForegroundColor Green
} else {
    Write-Host "   ❌ Dockerfile no encontrado" -ForegroundColor Red
    exit 1
}

# 8. Verificar docker-compose.yml
Write-Host ""
Write-Host "8️⃣  Verificando docker-compose.yml..." -ForegroundColor Yellow
if (Test-Path "docker-compose.yml") {
    Write-Host "   ✅ docker-compose.yml presente" -ForegroundColor Green
} else {
    Write-Host "   ❌ docker-compose.yml no encontrado" -ForegroundColor Red
    exit 1
}

# Resumen
Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  ✅ VERIFICACIÓN COMPLETADA" -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "Próximos pasos:" -ForegroundColor Yellow
Write-Host "  1. cd backend && mvn clean package" -ForegroundColor White
Write-Host "  2. docker-compose build" -ForegroundColor White
Write-Host "  3. docker-compose up -d" -ForegroundColor White
Write-Host "  4. Verifica en http://localhost:8080/api/v1/usuarios" -ForegroundColor White
Write-Host ""
