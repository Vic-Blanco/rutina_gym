# Script para limpiar y compilar el proyecto en Windows

Write-Host "🔨 Limpiando proyecto..." -ForegroundColor Cyan
mvn clean

Write-Host ""
Write-Host "📦 Compilando..." -ForegroundColor Cyan
mvn compile

Write-Host ""
Write-Host "✅ Compilación completada" -ForegroundColor Green
Write-Host ""
Write-Host "Para ejecutar:" -ForegroundColor Yellow
Write-Host "  mvn spring-boot:run" -ForegroundColor Gray
