#!/bin/bash
# Script para limpiar y compilar el proyecto

echo "🔨 Limpiando proyecto..."
mvn clean

echo ""
echo "📦 Compilando..."
mvn compile

echo ""
echo "✅ Compilación completada"
echo ""
echo "Para ejecutar:"
echo "  mvn spring-boot:run"
