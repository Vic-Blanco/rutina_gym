#!/usr/bin/env bash
# Verificación rápida de configuración Docker - Rutina Gym

set -e

echo "═══════════════════════════════════════════════════════════"
echo "  🔍 VERIFICACIÓN DE CONFIGURACIÓN DOCKER"
echo "═══════════════════════════════════════════════════════════"
echo ""

# 1. Verificar Docker
echo "1️⃣  Verificando Docker..."
if command -v docker &> /dev/null; then
    DOCKER_VERSION=$(docker --version)
    echo "   ✅ $DOCKER_VERSION"
else
    echo "   ❌ Docker no encontrado. Instala Docker Desktop."
    exit 1
fi

# 2. Verificar Docker Compose
echo ""
echo "2️⃣  Verificando Docker Compose..."
if command -v docker-compose &> /dev/null; then
    COMPOSE_VERSION=$(docker-compose --version)
    echo "   ✅ $COMPOSE_VERSION"
else
    echo "   ❌ Docker Compose no encontrado"
    exit 1
fi

# 3. Verificar Java
echo ""
echo "3️⃣  Verificando Java..."
if command -v java &> /dev/null; then
    JAVA_VERSION=$(java -version 2>&1 | grep "version" | head -1)
    echo "   ✅ $JAVA_VERSION"
else
    echo "   ❌ Java no encontrado"
    exit 1
fi

# 4. Verificar Maven
echo ""
echo "4️⃣  Verificando Maven..."
if command -v mvn &> /dev/null; then
    MVN_VERSION=$(mvn --version | head -1)
    echo "   ✅ $MVN_VERSION"
else
    echo "   ⚠️  Maven no encontrado (se descargará en Docker)"
fi

# 5. Verificar archivos Prolog
echo ""
echo "5️⃣  Verificando archivos Prolog..."
PROLOG_FILES=(
    "knowledge_base.pl"
    "rules.pl"
    "validation.pl"
    "examples.pl"
    "integration.pl"
    "ejercicios.pl"
)

ALL_FOUND=true
for file in "${PROLOG_FILES[@]}"; do
    if [ -f "prolog/$file" ]; then
        echo "   ✅ $file"
    else
        echo "   ❌ $file NO ENCONTRADO"
        ALL_FOUND=false
    fi
done

if [ "$ALL_FOUND" = false ]; then
    echo ""
    echo "   ⚠️  Algunos archivos Prolog faltan"
fi

# 6. Verificar estructura backend
echo ""
echo "6️⃣  Verificando estructura backend..."
if [ -f "backend/pom.xml" ]; then
    echo "   ✅ pom.xml"
else
    echo "   ❌ pom.xml no encontrado"
    exit 1
fi

if [ -f "backend/Dockerfile" ]; then
    echo "   ✅ Dockerfile"
else
    echo "   ❌ Dockerfile no encontrado"
    exit 1
fi

# 7. Verificar estructura frontend
echo ""
echo "7️⃣  Verificando estructura frontend..."
if [ -f "frontend/package.json" ]; then
    echo "   ✅ package.json"
else
    echo "   ❌ package.json no encontrado"
    exit 1
fi

if [ -f "frontend/Dockerfile" ]; then
    echo "   ✅ Dockerfile"
else
    echo "   ❌ Dockerfile no encontrado"
    exit 1
fi

# 8. Verificar docker-compose.yml
echo ""
echo "8️⃣  Verificando docker-compose.yml..."
if [ -f "docker-compose.yml" ]; then
    echo "   ✅ docker-compose.yml presente"
else
    echo "   ❌ docker-compose.yml no encontrado"
    exit 1
fi

# Resumen
echo ""
echo "═══════════════════════════════════════════════════════════"
echo "  ✅ VERIFICACIÓN COMPLETADA"
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "Próximos pasos:"
echo "  1. cd backend && mvn clean package"
echo "  2. docker-compose build"
echo "  3. docker-compose up -d"
echo "  4. Verifica en http://localhost:8080/api/v1/usuarios"
echo ""
