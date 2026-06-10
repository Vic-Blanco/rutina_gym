#!/bin/bash

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}🏋️  VERIFICACIÓN DE INSTALACIÓN - RUTINA GYM${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}\n"

# Contador de checks
PASSED=0
FAILED=0

# Función para verificar comando
check_command() {
    local cmd=$1
    local display=$2
    
    if command -v $cmd &> /dev/null; then
        echo -e "${GREEN}✓${NC} $display encontrado"
        ((PASSED++))
    else
        echo -e "${RED}✗${NC} $display NO encontrado"
        ((FAILED++))
    fi
}

# Función para verificar archivo
check_file() {
    local file=$1
    local display=$2
    
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓${NC} $display existe"
        ((PASSED++))
    else
        echo -e "${RED}✗${NC} $display NO existe"
        ((FAILED++))
    fi
}

# Función para verificar directorio
check_dir() {
    local dir=$1
    local display=$2
    
    if [ -d "$dir" ]; then
        echo -e "${GREEN}✓${NC} $display existe"
        ((PASSED++))
    else
        echo -e "${RED}✗${NC} $display NO existe"
        ((FAILED++))
    fi
}

# Función para verificar servicio
check_service() {
    local service=$1
    local display=$2
    
    if nc -z localhost $service &> /dev/null; then
        echo -e "${GREEN}✓${NC} $display está corriendo"
        ((PASSED++))
    else
        echo -e "${YELLOW}⚠${NC} $display no está accesible"
        ((FAILED++))
    fi
}

# ============================================================
echo -e "${YELLOW}1. VERIFICANDO REQUISITOS DEL SISTEMA${NC}\n"

check_command "java" "Java"
check_command "mvn" "Maven"
check_command "node" "Node.js"
check_command "npm" "NPM"
check_command "psql" "PostgreSQL CLI"
check_command "swipl" "SWI-Prolog"

# ============================================================
echo -e "\n${YELLOW}2. VERIFICANDO ESTRUCTURA DE CARPETAS${NC}\n"

check_dir "./backend" "Carpeta backend"
check_dir "./frontend" "Carpeta frontend"
check_dir "./prolog" "Carpeta prolog"

# ============================================================
echo -e "\n${YELLOW}3. VERIFICANDO ARCHIVOS DE CONFIGURACIÓN${NC}\n"

check_file "backend/pom.xml" "Backend pom.xml"
check_file "backend/src/main/resources/application.yml" "Backend application.yml"
check_file "frontend/package.json" "Frontend package.json"
check_file "prolog/ejercicios.pl" "Prolog ejercicios.pl"
check_file "docker-compose.yml" "docker-compose.yml"

# ============================================================
echo -e "\n${YELLOW}4. VERIFICANDO ARCHIVOS DE CÓDIGO${NC}\n"

check_file "backend/src/main/java/com/rutinagym/RutinaGymApplication.java" "Backend main class"
check_file "backend/src/main/java/com/rutinagym/model/Usuario.java" "Backend Usuario model"
check_file "backend/src/main/java/com/rutinagym/service/RutinaService.java" "Backend RutinaService"
check_file "frontend/src/App.js" "Frontend App.js"
check_file "frontend/src/pages/Dashboard.js" "Frontend Dashboard"
check_file "frontend/src/api/api.js" "Frontend API client"

# ============================================================
echo -e "\n${YELLOW}5. VERIFICANDO DOCUMENTACIÓN${NC}\n"

check_file "README.md" "README.md"
check_file "QUICKSTART.md" "QUICKSTART.md"
check_file "DATABASE_SETUP.md" "DATABASE_SETUP.md"
check_file "PROLOG_GUIDE.md" "PROLOG_GUIDE.md"
check_file "API_EXAMPLES.md" "API_EXAMPLES.md"
check_file "TROUBLESHOOTING.md" "TROUBLESHOOTING.md"

# ============================================================
echo -e "\n${YELLOW}6. VERIFICANDO SERVICIOS EN EJECUCIÓN${NC}\n"

check_service 5432 "PostgreSQL (puerto 5432)"
check_service 8080 "Backend Spring (puerto 8080)"
check_service 3000 "Frontend React (puerto 3000)"

# ============================================================
echo -e "\n${YELLOW}7. VERIFICANDO CONECTIVIDAD${NC}\n"

# PostgreSQL
echo -n "Verificando PostgreSQL..."
if psql -U rutina_user -d rutina_gym_db -h localhost -c "SELECT version();" &> /dev/null; then
    echo -e " ${GREEN}✓${NC}"
    ((PASSED++))
else
    echo -e " ${RED}✗${NC} (Intenta: psql -U postgres)"
    ((FAILED++))
fi

# Backend
echo -n "Verificando Backend..."
if curl -s http://localhost:8080/api/v1/usuarios/1 &> /dev/null; then
    echo -e " ${GREEN}✓${NC}"
    ((PASSED++))
else
    echo -e " ${RED}✗${NC} (Asegúrate de ejecutar: mvn spring-boot:run)"
    ((FAILED++))
fi

# Frontend
echo -n "Verificando Frontend..."
if curl -s http://localhost:3000 &> /dev/null; then
    echo -e " ${GREEN}✓${NC}"
    ((PASSED++))
else
    echo -e " ${RED}✗${NC} (Asegúrate de ejecutar: npm start)"
    ((FAILED++))
fi

# ============================================================
echo -e "\n${YELLOW}8. VERIFICANDO DEPENDENCIAS${NC}\n"

# Backend dependencies
echo "Backend:"
if [ -d "backend/target" ]; then
    echo -e "  ${GREEN}✓${NC} Maven build directory existe"
    ((PASSED++))
else
    echo -e "  ${YELLOW}⚠${NC} Maven build directory no encontrado (ejecuta: mvn clean install)"
    ((FAILED++))
fi

# Frontend dependencies
echo "Frontend:"
if [ -d "frontend/node_modules" ]; then
    echo -e "  ${GREEN}✓${NC} node_modules existe"
    ((PASSED++))
else
    echo -e "  ${YELLOW}⚠${NC} node_modules no encontrado (ejecuta: npm install)"
    ((FAILED++))
fi

# ============================================================
echo -e "\n${BLUE}════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}📊 RESULTADOS DE LA VERIFICACIÓN${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}\n"

TOTAL=$((PASSED + FAILED))
PERCENTAGE=$((PASSED * 100 / TOTAL))

echo -e "✓ Pasó: ${GREEN}${PASSED}${NC}/${TOTAL}"
echo -e "✗ Falló: ${RED}${FAILED}${NC}/${TOTAL}"
echo -e "Porcentaje: ${BLUE}${PERCENTAGE}%${NC}\n"

# Recomendaciones
if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}🎉 ¡INSTALACIÓN COMPLETA Y LISTA!${NC}"
    echo -e "\n${BLUE}Próximos pasos:${NC}"
    echo -e "  1. Abre http://localhost:3000 en tu navegador"
    echo -e "  2. Crea una cuenta"
    echo -e "  3. Genera tu primera rutina"
    echo -e "  4. ¡A entrenar! 💪"
elif [ $FAILED -le 5 ]; then
    echo -e "${YELLOW}⚠️  INSTALACIÓN PARCIAL${NC}"
    echo -e "\n${BLUE}Acciones recomendadas:${NC}"
    if ! command -v "java" &> /dev/null; then
        echo -e "  - Instalar Java 17+"
    fi
    if ! command -v "mvn" &> /dev/null; then
        echo -e "  - Instalar Maven"
    fi
    if ! command -v "node" &> /dev/null; then
        echo -e "  - Instalar Node.js"
    fi
    if ! command -v "swipl" &> /dev/null; then
        echo -e "  - Instalar SWI-Prolog"
    fi
    if ! nc -z localhost 5432 &> /dev/null; then
        echo -e "  - Iniciar PostgreSQL"
    fi
    if ! nc -z localhost 8080 &> /dev/null; then
        echo -e "  - Ejecutar: cd backend && mvn spring-boot:run"
    fi
    if ! nc -z localhost 3000 &> /dev/null; then
        echo -e "  - Ejecutar: cd frontend && npm start"
    fi
else
    echo -e "${RED}❌ INSTALACIÓN INCOMPLETA${NC}"
    echo -e "\n${BLUE}Revisa:${NC}"
    echo -e "  1. README.md para instrucciones detalladas"
    echo -e "  2. QUICKSTART.md para inicio rápido"
    echo -e "  3. TROUBLESHOOTING.md para solucionar problemas"
fi

echo -e "\n${BLUE}════════════════════════════════════════════════════════════${NC}"

# Exit code
if [ $FAILED -eq 0 ]; then
    exit 0
else
    exit 1
fi
