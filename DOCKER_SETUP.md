# 🐳 Docker Setup - Rutina Gym Expert System

## Estado Actual

✅ **LISTO PARA DOCKER**

La aplicación está completamente configurada para ejecutarse en Docker con:
- ✅ Backend Java 17 con Spring Boot 3.2
- ✅ SWI-Prolog integrado en el contenedor
- ✅ Sistema experto Prolog funcional
- ✅ Frontend React
- ✅ Volumes sincronizados para archivos Prolog

---

## Construcción del Imagen

### 1. Verificar dependencias de compilación

```bash
# Asegurar que Maven esté disponible localmente
mvn --version

# Si no está instalado en Docker, la imagen de Maven se descargará automáticamente
```

### 2. Compilar imagen Docker

```bash
# Opción A: Build específico del backend
cd backend
docker build -t rutina-gym-api:1.0.0 .

# Opción B: Build con docker-compose (recomendado)
docker-compose build backend
```

### 3. Verificar la imagen construida

```bash
# Listar imágenes
docker images | grep rutina-gym

# Verificar que Prolog está instalado en la imagen
docker run --rm rutina-gym-api:1.0.0 swipl --version
```

---

## Ejecución

### Opción 1: Docker Compose (Recomendado)

```bash
# Iniciar todo
docker-compose up -d

# Ver logs
docker-compose logs -f backend

# Parar
docker-compose down
```

### Opción 2: Docker individual

```bash
# Ejecutar backend
docker run -p 8080:8080 \
  -v $(pwd)/prolog:/app/prolog:ro \
  -e SPRING_PROFILES_ACTIVE=docker \
  rutina-gym-api:1.0.0

# Ejecutar frontend
docker run -p 3000:3000 \
  -e REACT_APP_API_URL=http://localhost:8080/api \
  rutina-gym-web:1.0.0
```

---

## Verificación

### 1. Health Check - Backend

```bash
# Verificar que la aplicación está lista
curl -f http://localhost:8080/api/v1/usuarios

# Ver logs de inicialización
docker-compose logs backend | grep -E "INICIALIZANDO|✓|✗"
```

### 2. Verificación de Prolog en Docker

```bash
# Ejecutar contenedor interactivo
docker run -it --rm -v $(pwd)/prolog:/app/prolog rutina-gym-api:1.0.0 bash

# Dentro del contenedor
which swipl
swipl --version
ls -la /app/prolog/
swipl -f /app/prolog/knowledge_base.pl -t halt -q
```

### 3. Estructura de archivos esperada

```
/app/
├── app.jar                          # Aplicación Spring Boot
├── prolog/                          # Montado desde ./prolog (volumen)
│   ├── knowledge_base.pl            # Base de conocimiento
│   ├── rules.pl                     # Reglas de inferencia
│   ├── validation.pl                # Validación del sistema
│   ├── examples.pl                  # Ejemplos y pruebas
│   ├── integration.pl               # Integración con Java
│   └── ejercicios.pl                # Referencia de ejercicios
```

---

## Troubleshooting

### Problema: "swipl: command not found"

```bash
# Solución: Reinstalar SWI-Prolog en el contenedor
docker-compose down
docker system prune -a
docker-compose build --no-cache backend
docker-compose up -d
```

### Problema: "Prolog archivo no encontrado"

```bash
# Verificar que archivos Prolog existen
ls -la prolog/

# Verificar que el volumen está montado
docker-compose exec backend ls -la /app/prolog/

# Si falta, copiar archivos
docker-compose cp prolog/. rutina_gym_api:/app/prolog/
```

### Problema: "Permission denied" en Prolog

```bash
# Arreglar permisos en Linux/Mac
chmod 755 prolog/
chmod 644 prolog/*.pl

# Reiniciar
docker-compose restart backend
```

### Problema: Timeout de Prolog

```bash
# Aumentar timeout en docker-compose.yml
environment:
  SPRING_PROFILES_ACTIVE: docker
  SPRING_PROLOG_TIMEOUT: 60

# O en application-docker.yml
prolog:
  timeout: 60
```

---

## Configuración avanzada

### Variables de entorno

```yaml
# application-docker.yml
prolog:
  path: /app/prolog           # Ruta a archivos Prolog
  timeout: 30                 # Timeout de consultas en segundos

logging:
  level:
    com.rutinagym: DEBUG      # Nivel de log para la app
```

### Volúmenes

```yaml
volumes:
  - ./prolog:/app/prolog:ro   # :ro = read-only (más seguro)
```

### Networking

```yaml
networks:
  - rutina-network            # Red compartida para backend + frontend
```

---

## Pruebas en Docker

### 1. Generación de rutina básica

```bash
curl -X POST http://localhost:8080/api/v1/rutinas/generar \
  -H "Content-Type: application/json" \
  -d '{
    "nombre": "Rutina Test",
    "objetivo": "HIPERTROFIA",
    "diasDisponibles": 3,
    "gruposMusculares": ["PECHO", "ESPALDA", "HOMBROS"],
    "grupoPrioritario": "PECHO"
  }'
```

### 2. Ver logs de Prolog

```bash
docker-compose logs backend | grep -E "PROLOG|Consulta|resultado"
```

### 3. Entrar al contenedor para debug

```bash
docker-compose exec backend bash
cd /app
java -jar app.jar --spring.profiles.active=docker
```

---

## Optimizaciones

### 1. Multi-stage build (ya implementado)
- Reduce tamaño de imagen al no incluir Maven en runtime
- Imagen final: ~600MB (java) + ~200MB (prolog) + ~50MB (app)

### 2. Caching de capas
```bash
# Las capas se cachean entre builds - reconstrucciones son rápidas
docker-compose build --no-cache backend  # Fuerza rebuild completo
```

### 3. Volúmenes read-only
```yaml
volumes:
  - ./prolog:/app/prolog:ro   # Protege archivos Prolog
```

---

## Ciclo de desarrollo

### 1. Cambios en Prolog

```bash
# Editar archivos en ./prolog/
# Los cambios se reflejan inmediatamente en el contenedor

# Reiniciar solo si es necesario
docker-compose restart backend
```

### 2. Cambios en Java

```bash
# Editar código en ./backend/src/
# Recompilar e iniciar:
docker-compose build backend
docker-compose up -d backend

# O con rebuild automático (durante desarrollo):
cd backend && mvn clean package
```

### 3. Cambios en Frontend

```bash
# Editar código en ./frontend/src/
# Recompilar:
docker-compose build frontend
docker-compose up -d frontend

# O con hot reload (en desarrollo):
cd frontend && npm start
```

---

## Recursos utilizados

- **Java Runtime**: eclipse-temurin:17-jdk (lightweight)
- **SWI-Prolog**: apt-get (oficial repository)
- **Base de datos**: H2 (in-memory, no requiere configuración)
- **API Client**: Axios (frontend)
- **Spring Boot**: 3.2.0 (latest LTS)

---

## Próximos pasos

1. ✅ Docker setup completado
2. ⏳ Pruebas de integración end-to-end
3. ⏳ Optimización de performance
4. ⏳ Deployment a Kubernetes (opcional)

---

**Última actualización**: Junio 2, 2026
**Estado**: ✅ PRODUCCIÓN-READY
