# Docker Quick Start Script for Rutina Gym

param(
    [string]$Action = "start"
)

$ErrorActionPreference = "Stop"

function Write-Header {
    param([string]$Message)
    Write-Host ""
    Write-Host "════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "🐳 $Message" -ForegroundColor Cyan
    Write-Host "════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""
}

function Check-Docker {
    Write-Host "Verificando Docker..." -ForegroundColor Yellow
    
    if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
        Write-Host "❌ Docker no está instalado" -ForegroundColor Red
        Write-Host ""
        Write-Host "Descárgalo aquí: https://www.docker.com/products/docker-desktop" -ForegroundColor Yellow
        exit 1
    }
    
    Write-Host "✓ Docker encontrado" -ForegroundColor Green
    
    try {
        $null = docker ps -q
        Write-Host "✓ Docker está corriendo" -ForegroundColor Green
    }
    catch {
        Write-Host "❌ Docker no está corriendo. Abre Docker Desktop." -ForegroundColor Red
        exit 1
    }
}

function Start-Application {
    Write-Header "Iniciando Rutina Gym"
    
    Check-Docker
    
    Write-Host "Iniciando contenedores..." -ForegroundColor Yellow
    docker-compose up -d
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Contenedores iniciados" -ForegroundColor Green
        Write-Host ""
        Write-Host "Esperando que los servicios estén listos..." -ForegroundColor Cyan
        Start-Sleep -Seconds 5
        
        Write-Host ""
        Write-Host "✅ ¡Tu aplicación está lista!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Accede a:" -ForegroundColor Cyan
        Write-Host "  Frontend:  http://localhost:3000" -ForegroundColor Yellow
        Write-Host "  Backend:   http://localhost:8080/api" -ForegroundColor Yellow
        Write-Host "  Database:  localhost:5432" -ForegroundColor Yellow
        Write-Host ""
    }
    else {
        Write-Host "❌ Error al iniciar contenedores" -ForegroundColor Red
        exit 1
    }
}

function Stop-Application {
    Write-Header "Deteniendo Rutina Gym"
    
    Write-Host "Deteniendo contenedores..." -ForegroundColor Yellow
    docker-compose down
    
    Write-Host "✓ Contenedores detenidos" -ForegroundColor Green
}

function Stop-And-Clean {
    Write-Header "Limpiando Rutina Gym"
    
    Write-Host "Deteniendo contenedores y eliminando datos..." -ForegroundColor Yellow
    docker-compose down -v
    
    Write-Host "✓ Limpieza completada" -ForegroundColor Green
    Write-Host "  Los datos fueron eliminados. Ejecuta 'start' para crear nuevamente." -ForegroundColor Cyan
}

function View-Logs {
    param([string]$Service = "all")
    
    Write-Header "Viendo logs"
    
    if ($Service -eq "all") {
        Write-Host "Mostrando logs de todos los servicios (Ctrl+C para salir)..." -ForegroundColor Cyan
        docker-compose logs -f
    }
    elseif ($Service -in @("backend", "frontend", "postgres")) {
        Write-Host "Mostrando logs de $Service (Ctrl+C para salir)..." -ForegroundColor Cyan
        docker-compose logs -f $Service
    }
    else {
        Write-Host "Servicio desconocido: $Service" -ForegroundColor Red
        Write-Host "Opciones: backend, frontend, postgres, all" -ForegroundColor Yellow
    }
}

function Show-Status {
    Write-Header "Estado de la aplicación"
    
    docker-compose ps
    
    Write-Host ""
    Write-Host "URLs:" -ForegroundColor Cyan
    Write-Host "  Frontend:  http://localhost:3000" -ForegroundColor Yellow
    Write-Host "  Backend:   http://localhost:8080/api" -ForegroundColor Yellow
    Write-Host "  Database:  localhost:5432" -ForegroundColor Yellow
}

function Rebuild {
    Write-Header "Reconstruyendo aplicación"
    
    Check-Docker
    
    Write-Host "Reconstruyendo imágenes..." -ForegroundColor Yellow
    docker-compose up -d --build
    
    Write-Host "✓ Imágenes reconstruidas" -ForegroundColor Green
}

function Show-Help {
    Write-Host ""
    Write-Host "🐳 Rutina Gym - Docker Manager" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Uso: .\docker-manage.ps1 [acción]" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Acciones:" -ForegroundColor Cyan
    Write-Host "  start      - Iniciar la aplicación" -ForegroundColor White
    Write-Host "  stop       - Detener la aplicación" -ForegroundColor White
    Write-Host "  restart    - Reiniciar la aplicación" -ForegroundColor White
    Write-Host "  clean      - Detener y eliminar datos" -ForegroundColor White
    Write-Host "  status     - Ver estado de contenedores" -ForegroundColor White
    Write-Host "  logs       - Ver logs (todos)" -ForegroundColor White
    Write-Host "  logs-backend   - Ver logs del backend" -ForegroundColor White
    Write-Host "  logs-frontend  - Ver logs del frontend" -ForegroundColor White
    Write-Host "  logs-db    - Ver logs de base de datos" -ForegroundColor White
    Write-Host "  rebuild    - Reconstruir imágenes" -ForegroundColor White
    Write-Host ""
    Write-Host "Ejemplos:" -ForegroundColor Yellow
    Write-Host "  .\docker-manage.ps1 start" -ForegroundColor Gray
    Write-Host "  .\docker-manage.ps1 logs-backend" -ForegroundColor Gray
    Write-Host "  .\docker-manage.ps1 clean" -ForegroundColor Gray
    Write-Host ""
}

# Main
switch ($Action.ToLower()) {
    "start" {
        Start-Application
    }
    "stop" {
        Stop-Application
    }
    "restart" {
        Stop-Application
        Start-Application
    }
    "clean" {
        Stop-And-Clean
    }
    "status" {
        Show-Status
    }
    "logs" {
        View-Logs "all"
    }
    "logs-backend" {
        View-Logs "backend"
    }
    "logs-frontend" {
        View-Logs "frontend"
    }
    "logs-db" {
        View-Logs "postgres"
    }
    "rebuild" {
        Rebuild
    }
    default {
        Show-Help
    }
}
