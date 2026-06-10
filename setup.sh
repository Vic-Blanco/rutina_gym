#!/bin/bash

echo "🚀 Iniciando Rutina Gym..."

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Verificar requisitos
echo -e "${YELLOW}📋 Verificando requisitos...${NC}"

# Verificar Java
if ! command -v java &> /dev/null; then
    echo -e "${RED}❌ Java no está instalado${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Java encontrado${NC}"

# Verificar Maven
if ! command -v mvn &> /dev/null; then
    echo -e "${RED}❌ Maven no está instalado${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Maven encontrado${NC}"

# Verificar Node
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js no está instalado${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Node.js encontrado${NC}"

# Verificar PostgreSQL
if ! command -v psql &> /dev/null; then
    echo -e "${YELLOW}⚠️  PostgreSQL no encontrado en PATH${NC}"
    echo -e "${YELLOW}   Asegúrate de que PostgreSQL esté corriendo en localhost:5432${NC}"
else
    echo -e "${GREEN}✓ PostgreSQL encontrado${NC}"
fi

# Compilar backend
echo -e "\n${YELLOW}🔨 Compilando backend...${NC}"
cd backend
mvn clean install -q
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Backend compilado${NC}"
else
    echo -e "${RED}❌ Error compilando backend${NC}"
    exit 1
fi
cd ..

# Instalar frontend
echo -e "\n${YELLOW}📦 Instalando dependencias del frontend...${NC}"
cd frontend
npm install --legacy-peer-deps -q
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Dependencias instaladas${NC}"
else
    echo -e "${RED}❌ Error instalando dependencias${NC}"
    exit 1
fi
cd ..

echo -e "\n${GREEN}✅ Todos los requisitos cumplidos${NC}"
echo -e "\n${YELLOW}🚀 Para iniciar la aplicación, ejecuta:${NC}"
echo -e "  1. Backend:  cd backend && mvn spring-boot:run"
echo -e "  2. Frontend: cd frontend && npm start"
echo -e "  3. Abre http://localhost:3000 en tu navegador"
