# 📑 Índice Completo del Proyecto Rutina Gym

## 📚 Documentación Principal

| Archivo | Descripción |
|---------|------------|
| **README.md** | Guía completa, arquitectura, instalación |
| **QUICKSTART.md** | Inicio rápido en 5 minutos |
| **PROJECT_SUMMARY.md** | Resumen ejecutivo de logros |
| **DATABASE_SETUP.md** | Configuración de PostgreSQL |
| **PROLOG_GUIDE.md** | Guía de Prolog y consultas |
| **API_EXAMPLES.md** | Ejemplos de uso de endpoints |
| **TROUBLESHOOTING.md** | Resolución de problemas |
| **.gitignore** | Archivos a ignorar en Git |
| **docker-compose.yml** | Orquestación de contenedores |

---

## 🔙 Backend (Java Spring Boot)

### Archivo de Configuración
```
backend/pom.xml
├── Java 17
├── Spring Boot 3.2.0
├── PostgreSQL Driver
├── JPA/Hibernate
├── JPL7 (Java Prolog Interface)
├── Jackson
└── Lombok
```

### Código Java

#### Entidades (Model)
```
backend/src/main/java/com/rutinagym/model/
├── Usuario.java              # Usuario del sistema
├── Rutina.java              # Rutina de entrenamiento
├── DiaEntrenamiento.java    # Día específico
├── Ejercicio.java           # Ejercicio individual
├── Genero.java              # Enum de géneros
├── Nivel.java               # Enum de niveles
└── GrupoMuscular.java       # Enum de grupos
```

#### Repositorios (Data Access)
```
backend/src/main/java/com/rutinagym/repository/
├── UsuarioRepository.java   # CRUD de usuarios
└── RutinaRepository.java    # CRUD de rutinas
```

#### Servicios (Business Logic)
```
backend/src/main/java/com/rutinagym/service/
├── RutinaService.java       # Generación de rutinas OOP
└── PrologService.java       # Integración con Prolog
```

#### Controladores (REST API)
```
backend/src/main/java/com/rutinagym/controller/
├── UsuarioController.java   # Endpoints de usuarios
└── RutinaController.java    # Endpoints de rutinas
```

#### Aplicación
```
backend/src/main/java/com/rutinagym/
└── RutinaGymApplication.java  # Main de Spring Boot
```

#### Configuración
```
backend/src/main/resources/
└── application.yml          # Configuración (BD, Prolog, etc.)
```

#### Build
```
backend/
└── Dockerfile              # Contenedor Docker
```

---

## ⚛️ Frontend (React)

### Configuración
```
frontend/
├── package.json            # Dependencias npm
├── Dockerfile              # Contenedor Docker
└── .gitignore             # Archivos a ignorar
```

### Archivos Principales
```
frontend/public/
└── index.html              # HTML base

frontend/src/
├── index.js               # Punto de entrada
├── index.css              # Estilos globales
└── App.js                 # Router principal
```

### Páginas (Pages)
```
frontend/src/pages/
├── Login.js               # Página de login
├── Login.scss             # Estilos de login
├── Registro.js            # Página de registro
├── Registro.scss          # Estilos de registro
├── Dashboard.js           # Panel principal
├── Dashboard.scss         # Estilos dashboard
├── GenerarRutina.js       # Generar rutina
├── GenerarRutina.scss     # Estilos generador
├── MisRutinas.js          # Listado de rutinas
├── MisRutinas.scss        # Estilos listado
├── DetalleRutina.js       # Detalle de rutina
└── DetalleRutina.scss     # Estilos detalle
```

### Componentes (Components)
```
frontend/src/components/
├── Navbar.js              # Barra de navegación
└── Navbar.scss            # Estilos navbar
```

### API Client
```
frontend/src/api/
└── api.js                 # Cliente HTTP con Axios
```

### Estilos Globales
```
frontend/src/
└── App.scss               # Estilos principales
```

---

## 🧠 Prolog (Base de Conocimiento)

```
prolog/
└── ejercicios.pl          # Base de conocimiento Prolog
   ├── Definiciones de grupos musculares
   ├── Definiciones de niveles
   ├── Definiciones de géneros
   ├── 50+ ejercicios por combinación
   ├── Distribución de días
   ├── Reglas de validación
   ├── Reglas de recuperación
   └── Consultas útiles
```

---

## 🐳 Contenedorización

```
docker-compose.yml         # Orquestación completa
├── PostgreSQL service
├── Backend service
└── Frontend service
```

```
backend/Dockerfile         # Imagen Java
├── Compilación Maven
└── Runtime OpenJDK 17
```

```
frontend/Dockerfile        # Imagen Node
├── Build React
└── Serve con PM2
```

---

## 📊 Resumen de Archivos

### Por Categoría

**Documentación: 9 archivos**
- README.md
- QUICKSTART.md
- PROJECT_SUMMARY.md
- DATABASE_SETUP.md
- PROLOG_GUIDE.md
- API_EXAMPLES.md
- TROUBLESHOOTING.md
- INDEX.md (este archivo)

**Backend: 15+ archivos**
- pom.xml
- application.yml
- 8 archivos Java
- Dockerfile

**Frontend: 20+ archivos**
- package.json
- 12 componentes/páginas
- 8 archivos SASS
- api.js
- Dockerfile

**Prolog: 1 archivo**
- ejercicios.pl (500+ líneas)

**Configuración: 3 archivos**
- docker-compose.yml
- .gitignore
- setup.sh

**TOTAL: 50+ archivos de código y documentación**

---

## 🎯 Navegación Rápida

### Quiero...

**... empezar rápido**
→ Ver [QUICKSTART.md](QUICKSTART.md)

**... entender la arquitectura**
→ Ver [README.md](README.md)

**... usar la API**
→ Ver [API_EXAMPLES.md](API_EXAMPLES.md)

**... aprender Prolog**
→ Ver [PROLOG_GUIDE.md](PROLOG_GUIDE.md)

**... configurar la BD**
→ Ver [DATABASE_SETUP.md](DATABASE_SETUP.md)

**... solucionar problemas**
→ Ver [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

**... ver resumen del proyecto**
→ Ver [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)

---

## 🏗️ Estructura Lógica

```
rutina_gym/
│
├── 📖 DOCUMENTACIÓN
│   ├── README.md (Overview)
│   ├── QUICKSTART.md (Inicio)
│   ├── PROJECT_SUMMARY.md (Resumen)
│   ├── DATABASE_SETUP.md (BD)
│   ├── PROLOG_GUIDE.md (Lógica)
│   ├── API_EXAMPLES.md (Endpoints)
│   ├── TROUBLESHOOTING.md (Errores)
│   └── INDEX.md (Este archivo)
│
├── 🖥️ BACKEND (OOP)
│   ├── pom.xml (Dependencias)
│   ├── src/main/java/
│   │   └── com/rutinagym/
│   │       ├── model/ (Entidades)
│   │       ├── repository/ (Datos)
│   │       ├── service/ (Lógica)
│   │       └── controller/ (API)
│   ├── src/main/resources/
│   │   └── application.yml (Config)
│   └── Dockerfile
│
├── ⚛️ FRONTEND (React)
│   ├── package.json
│   ├── public/index.html
│   ├── src/
│   │   ├── pages/ (Vistas)
│   │   ├── components/ (Componentes)
│   │   ├── api/ (HTTP Client)
│   │   └── App.js (Router)
│   └── Dockerfile
│
├── 🧠 PROLOG (Lógica)
│   └── ejercicios.pl (Base de Conocimiento)
│
└── 🐳 DOCKER
    ├── docker-compose.yml
    └── .gitignore
```

---

## 📈 Flujo de Generación de Rutina

```
Usuario (Frontend)
    ↓
    Completa formulario
    ├─ Nombre
    ├─ Nivel
    ├─ Días
    └─ Grupos musculares
    ↓
Frontend (React)
    ↓
    POST /api/v1/rutinas/generar
    ↓
Backend (Spring Boot)
    ↓
    RutinaController (recibe)
    ↓
    RutinaService.generarRutinaPersonalizada()
    ├─ OOP: Crea Rutina
    ├─ OOP: Crea DiaEntrenamiento
    ├─ Prolog: plan_semanal() → obtiene grupos
    ├─ OOP: Para cada grupo...
    │   ├─ Prolog: ejercicio_recomendado() → ejercicios
    │   └─ OOP: Crea Ejercicio
    └─ OOP: Guarda en BD PostgreSQL
    ↓
Frontend (React)
    ↓
    Muestra rutina con:
    ├─ Estructura de días
    ├─ Ejercicios por día
    ├─ Series, reps, descanso
    └─ Estadísticas
```

---

## 🔐 Seguridad (Por Implementar)

- [ ] JWT para autenticación
- [ ] BCrypt para contraseñas
- [ ] HTTPS/TLS
- [ ] Rate limiting
- [ ] SQL injection prevention
- [ ] CORS configuration
- [ ] Input validation
- [ ] Error handling

---

## 📊 Estadísticas de Líneas de Código

| Componente | Líneas | Estimado |
|-----------|--------|----------|
| Backend Java | 500+ | 8 clases |
| Frontend React | 800+ | 15+ componentes |
| Prolog | 500+ | 50+ hechos/reglas |
| Estilos SASS | 400+ | 8 archivos |
| Configuración | 100+ | YAML, JSON |
| Documentación | 2000+ | 9 archivos |
| **TOTAL** | **4300+** | **Proyecto completo** |

---

## 🚀 Deployment

### Local
```bash
# Terminal 1: Backend
cd backend && mvn spring-boot:run

# Terminal 2: Frontend
cd frontend && npm start

# Acceder: http://localhost:3000
```

### Docker
```bash
docker-compose up -d
# Acceder: http://localhost:3000
```

### Cloud (Sugerencias)
- Backend: Heroku, Railway, Fly.io
- Frontend: Vercel, Netlify
- BD: AWS RDS, Google Cloud SQL

---

## 📞 Soporte por Tipo de Problema

| Problema | Documento | Sección |
|----------|-----------|---------|
| No sé por dónde empezar | QUICKSTART.md | Inicio Rápido |
| Errores en Backend | TROUBLESHOOTING.md | Backend |
| Errores en Frontend | TROUBLESHOOTING.md | Frontend |
| No entiendo Prolog | PROLOG_GUIDE.md | Toda |
| BD no conecta | DATABASE_SETUP.md | Verificación |
| API no funciona | API_EXAMPLES.md | Ejemplos |
| Quiero customizar | README.md | Personalización |

---

## ✅ Checklist Completo

- [x] Backend OOP configurado
- [x] Frontend React funcional
- [x] Prolog integrado
- [x] Base de datos PostgreSQL
- [x] API REST completa
- [x] Autenticación básica
- [x] Generación de rutinas
- [x] Interfaz responsive
- [x] Documentación completa
- [x] Ejemplos de uso
- [x] Troubleshooting guide
- [x] Docker compose
- [x] Índice del proyecto

---

## 🎓 Conceptos Implementados

✅ **OOP**: Clases, herencia, encapsulación, polimorfismo
✅ **Prolog**: Hechos, reglas, consultas, backtracking
✅ **REST**: GET, POST, DELETE, paths, query params
✅ **React**: Componentes, hooks, routing, estado
✅ **Spring Boot**: Inyección, JPA, transacciones
✅ **Docker**: Containerización, compose
✅ **PostgreSQL**: Relaciones, constraints, índices

---

## 📞 Contacto y Soporte

Para problemas específicos:

1. **Revisa la documentación**: Todos los archivos .md
2. **Checa TROUBLESHOOTING.md**: Soluciones comunes
3. **Verifica los logs**: Terminal y archivos de log
4. **Consulta ejemplos**: API_EXAMPLES.md

---

**¡Proyecto completado y documentado! Ahora a crear rutinas con OOP + Prolog 💪**

*Última actualización: Mayo 28, 2026*
*Versión: 1.0.0*
