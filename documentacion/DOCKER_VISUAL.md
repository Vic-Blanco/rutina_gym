# 🐳 Rutina Gym - Flujo Docker en 3 pasos

```
┌─────────────────────────────────────────────────────────┐
│  PASO 1: Instalar Docker                                │
│                                                          │
│  ✓ Descarga Docker Desktop: docker.com/products/...    │
│  ✓ Ejecuta el instalador                                │
│  ✓ Inicia Docker Desktop                                │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│  PASO 2: Ejecutar Docker Compose                        │
│                                                          │
│  Windows:                                               │
│  ✓ Abre PowerShell aquí                                 │
│  ✓ Escribe: .\docker-manage.ps1 start                   │
│                                                          │
│  Mac/Linux:                                             │
│  ✓ Abre terminal aquí                                   │
│  ✓ Escribe: docker-compose up -d                        │
└─────────────────────────────────────────────────────────┘
                          ↓
                  ⏳ Espera 30 seg
                          ↓
┌─────────────────────────────────────────────────────────┐
│  PASO 3: Acceder a la aplicación                        │
│                                                          │
│  ✓ Abre: http://localhost:3000                          │
│  ✓ Crea una cuenta                                      │
│  ✓ Genera tu rutina                                     │
│  ✓ ¡Entrena!                                            │
└─────────────────────────────────────────────────────────┘
```

---

## 🏗️ Lo que Docker hace automáticamente

```
docker-compose up -d
          ↓
    ┌─────┴─────┬──────────┬──────────┐
    ↓           ↓          ↓          ↓
PostgreSQL  Backend    Frontend   Network
(DB)        (Java)     (React)    (Conecta)
    ↓           ↓          ↓          ↓
puerto:     puerto:    puerto:    puerto:
5432        8080       3000       interno
```

---

## 📊 Servicios activos

Cuando ejecutas `docker-compose up -d`, ves esto:

```
Creating rutina_gym_db  ... done      ← Base de datos PostgreSQL
Creating rutina_gym_api ... done      ← Backend Spring Boot  
Creating rutina_gym_web ... done      ← Frontend React
```

Verificar estado:

```powershell
# Windows
.\docker-manage.ps1 status

# Mac/Linux
docker-compose ps
```

---

## 🔍 Acceso a cada parte

| Servicio | URL/Host | Puerto |
|----------|----------|--------|
| Aplicación Web | localhost | 3000 |
| API Backend | localhost | 8080 |
| PostgreSQL DB | localhost | 5432 |

---

## 🎛️ Control

```powershell
# Ver logs en tiempo real
.\docker-manage.ps1 logs

# Ver solo logs del backend
.\docker-manage.ps1 logs-backend

# Parar todo
.\docker-manage.ps1 stop

# Reiniciar
.\docker-manage.ps1 restart

# Limpiar (elimina datos)
.\docker-manage.ps1 clean

# Reconstruir imágenes
.\docker-manage.ps1 rebuild
```

---

## ❌ Si hay errores

### "Cannot connect to Docker daemon"
```
→ Docker Desktop no está corriendo
→ Abre Docker Desktop desde el menú de Windows/Applications
```

### "Port 3000 already in use"
```
→ Edita docker-compose.yml
→ Cambia: ports: - "3001:3000"
→ Accede a: http://localhost:3001
```

### "Cannot connect to backend"
```
→ Espera 30 segundos más
→ Verifica con: .\docker-manage.ps1 logs-backend
```

---

## 🌐 Flujo completo de uso

```
Usuario abre http://localhost:3000
            ↓
        [Registro]
        Email / Nombre / Género / Contraseña
            ↓
        [Dashboard]
        Links a "Generar Rutina" o "Mis Rutinas"
            ↓
        [Generar Rutina]
        ✓ Nombre
        ✓ Nivel (Inicial/Intermedio/Avanzado)
        ✓ Días (1-7)
        ✓ Grupos musculares (checkboxes)
            ↓
    Backend recibe petición
            ↓
    RutinaService (OOP):
    ├─ Crea estructura
    └─ Llama a Prolog
            ↓
    PrologService consulta ejercicios.pl
            ↓
    Retorna ejercicios inteligentes
            ↓
    Guarda en PostgreSQL
            ↓
    Retorna JSON al Frontend
            ↓
        [Detalle Rutina]
        Muestra todos los ejercicios
        por día, series, reps, descanso
            ↓
        ¡Listo para entrenar!
```

---

## 💾 Persistencia de datos

Los datos de PostgreSQL se guardan en volumen Docker:

```
docker-compose up -d          ← Primer inicio
  └─ Crea postgres_data volume
  └─ Todos los usuarios y rutinas se guardan aquí

docker-compose down           ← Parar
  └─ Datos permanecen en postgres_data

docker-compose down -v        ← CUIDADO: Elimina datos
  └─ Elimina postgres_data
  └─ Se pierden todos los usuarios y rutinas
```

---

## ✅ Checklist de verificación

```
[ ] Docker Desktop instalado
[ ] Docker Desktop está corriendo
[ ] Terminal abierta en d:\Downloads\rutina_gym
[ ] Ejecuté: .\docker-manage.ps1 start
[ ] Esperé 30 segundos
[ ] Abrí: http://localhost:3000
[ ] Vi la página de login
[ ] Creé una cuenta
[ ] Accedí al dashboard
[ ] Generé una rutina
[ ] ¡Éxito! 🎉
```

---

## 📚 Documentación relacionada

- **START.md** ← Comienza aquí
- **DOCKER_QUICK.md** ← Guía Docker detallada
- **TROUBLESHOOTING.md** ← Resolver problemas
- **API_EXAMPLES.md** ← Ejemplos de API
- **README.md** ← Todo sobre el proyecto

---

**¡Listo! Ejecuta `.\docker-manage.ps1 start` y a crear rutinas! 🚀💪**
