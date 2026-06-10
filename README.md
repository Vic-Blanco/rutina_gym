# 💪 Rutina Gym - Aplicación Web Interactiva

Una aplicación web moderna que combina **Programación Orientada a Objetos (OOP)** con **Lógica Declarativa (Prolog)** para generar rutinas de gimnasia personalizadas.

## 🎯 Características Principales

✅ **Generación Inteligente de Rutinas**
- Combine OOP y Prolog para crear rutinas personalizadas
- Basadas en nivel (Inicial, Intermedio, Avanzado)
- Personalizadas por género y grupo muscular
- Cantidad flexible de días (1-7 días)

✅ **Paradigmas de Programación**
- **Backend OOP**: Java Spring Boot con arquitectura en capas
- **Lógica Declarativa**: Prolog para las reglas de ejercicios
- **Frontend Interactivo**: React moderno

✅ **Funcionalidades**
- Registro e inicio de sesión de usuarios
- Generación de rutinas personalizadas
- Visualización detallada de rutinas
- Gestión completa de rutinas (CRUD)
- Persistencia en PostgreSQL

---

## 🏗️ Arquitectura del Proyecto

```
rutina_gym/
├── backend/                          # API REST (Java Spring Boot)
│   ├── src/main/java/com/rutinagym/
│   │   ├── model/                   # Entidades JPA
│   │   ├── repository/              # Acceso a datos
│   │   ├── service/                 # Lógica de negocio
│   │   ├── controller/              # Endpoints REST
│   │   └── RutinaGymApplication.java
│   ├── src/main/resources/
│   │   └── application.yml          # Configuración
│   └── pom.xml                      # Dependencias Maven
│
├── frontend/                         # Aplicación React
│   ├── public/
│   │   └── index.html
│   ├── src/
│   │   ├── pages/                   # Páginas principales
│   │   ├── components/              # Componentes reutilizables
│   │   ├── api/                     # Llamadas HTTP
│   │   ├── App.js
│   │   └── index.js
│   └── package.json
│
├── prolog/                           # Reglas de Prolog
│   └── ejercicios.pl               # Base de conocimiento
│
└── README.md                         # Este archivo
```

---

## 🚀 Instalación y Configuración

### Requisitos Previos

- **Java 17+** con JDK instalado
- **PostgreSQL 14+** corriendo
- **Node.js 16+** y npm
- **Maven 3.8+**
- **SWI-Prolog** instalado en el sistema

### 1. Configurar la Base de Datos (PostgreSQL)

```bash
# Conectar a PostgreSQL
psql -U postgres

# Crear base de datos
CREATE DATABASE rutina_gym_db;
CREATE USER rutina_user WITH PASSWORD 'rutina_pass';
ALTER ROLE rutina_user SET client_encoding TO 'utf8';
ALTER ROLE rutina_user SET default_transaction_isolation TO 'read committed';
ALTER ROLE rutina_user SET timezone TO 'UTC';
GRANT ALL PRIVILEGES ON DATABASE rutina_gym_db TO rutina_user;
```

### 2. Configurar Backend (Java Spring Boot)

```bash
cd backend

# Actualizar application.yml con tus credenciales PostgreSQL
# (opcional - ya tiene valores por defecto)

# Compilar el proyecto
mvn clean install

# Ejecutar la aplicación
mvn spring-boot:run
```

**La API estará disponible en:** `http://localhost:8080/api`

### 3. Configurar Prolog

```bash
# Verificar instalación de SWI-Prolog
swipl --version

# El archivo ejercicios.pl se cargará automáticamente desde Java
# Ubicación: prolog/ejercicios.pl
```

### 4. Configurar Frontend (React)

```bash
cd frontend

# Instalar dependencias
npm install

# Ejecutar en desarrollo
npm start
```

**La aplicación estará disponible en:** `http://localhost:3000`

---

## 📚 Paradigmas Implementados

### OOP (Java Spring Boot)

**Clases Principales:**
- `Usuario`: Entidad que representa un usuario del sistema
- `Rutina`: Entidad que almacena la rutina del usuario
- `DiaEntrenamiento`: Cada día de la rutina
- `Ejercicio`: Ejercicio específico dentro de un día

**Servicios:**
- `RutinaService`: Lógica de negocio para generar rutinas
- `PrologService`: Integración con Prolog

**Patrón de Arquitectura:**
```
Controlador → Servicio → Repositorio → Base de Datos
```

### Prolog (Lógica Declarativa)

**Base de Conocimiento (`ejercicios.pl`):**
```prolog
% Definición de ejercicios recomendados
ejercicio_recomendado('Flexiones Pared', pecho, inicial, femenino).
ejercicio_recomendado('Press Banca', pecho, intermedio, masculino).

% Distribución de grupos por plan semanal
plan_semanal(1, 3, [pecho, triceps]).
plan_semanal(2, 3, [espalda, biceps]).
```

**Características:**
- Consultas lógicas para obtener ejercicios recomendados
- Distribución automática de grupos musculares
- Validación de combinaciones de entrenamientos

---

## 🔌 API Endpoints

### Usuarios

```bash
# Registro
POST /api/v1/usuarios/registro
Content-Type: application/json

{
  "email": "usuario@example.com",
  "nombre": "Juan Pérez",
  "password": "securepass123",
  "genero": "masculino"
}

# Login
POST /api/v1/usuarios/login
{
  "email": "usuario@example.com",
  "password": "securepass123"
}

# Obtener perfil
GET /api/v1/usuarios/{usuarioId}
```

### Rutinas

```bash
# Generar rutina personalizada
POST /api/v1/rutinas/generar?usuarioId=1&nombre=Mi+Rutina&nivel=intermedio&numDias=4
Content-Type: application/json

["pecho", "espalda", "piernas", "hombros"]

# Obtener rutinas del usuario
GET /api/v1/rutinas/usuario/{usuarioId}

# Obtener rutina específica
GET /api/v1/rutinas/{rutinaId}

# Eliminar rutina
DELETE /api/v1/rutinas/{rutinaId}
```

---

## 🎨 Interfaz de Usuario

### Páginas

1. **Login** - Acceso al sistema
2. **Registro** - Crear nueva cuenta
3. **Dashboard** - Panel principal con opciones
4. **Generar Rutina** - Formulario para crear rutinas
5. **Mis Rutinas** - Listado de rutinas creadas
6. **Detalle Rutina** - Visualización completa de una rutina

### Características de UI

- ✨ Diseño moderno con gradientes
- 📱 Responsive (Mobile, Tablet, Desktop)
- 🎯 Interactivo y user-friendly
- 🎪 Animaciones suaves
- 💪 Iconos representativos

---

## 🔄 Flujo de Generación de Rutina

```
1. Usuario completa formulario
   ↓
2. Backend recibe datos (OOP)
   ├─ Valida información
   ├─ Crea Rutina en BD
   └─ Crea DiaEntrenamiento
   ↓
3. Para cada día, consulta Prolog
   ├─ plan_semanal(día, totalDías, grupos)
   └─ ejercicio_recomendado(ejercicio, grupo, nivel, género)
   ↓
4. Crea Ejercicios basados en respuesta Prolog
   ↓
5. Guarda en BD
   ↓
6. Frontend visualiza la rutina completa
```

---

## 📊 Ejemplo de Generación

**Entrada:**
- Nombre: "Rutina Fuerza"
- Nivel: Intermedio
- Días: 4
- Grupos: Pecho, Espalda, Piernas
- Género: Masculino

**Salida (generada por OOP + Prolog):**

```
DÍA 1: Pecho, Tríceps
├── Press Banca Barra (4 series × 12 reps)
├── Aperturas Mancuerna (3 series × 12 reps)
└── Fondos (4 series × 12 reps)

DÍA 2: Espalda, Bíceps
├── Remo Barra Doblada (4 series × 12 reps)
├── Jalones Frente (4 series × 12 reps)
└── Curl Barra (3 series × 12 reps)

DÍA 3: Hombros, Core
├── Press Militar (4 series × 12 reps)
├── Pájaros Voladores (3 series × 12 reps)
└── Planchas (3 series × 60s)

DÍA 4: Piernas, Cardio
├── Sentadilla Libre (4 series × 12 reps)
├── Peso Muerto Rumano (3 series × 12 reps)
└── Cinta de correr (20 minutos)
```

---

## 🛠️ Personalización

### Agregar nuevos ejercicios

Editar `prolog/ejercicios.pl`:
```prolog
ejercicio_recomendado('Nuevo Ejercicio', grupo_muscular, nivel, genero).
```

### Cambiar distribución de días

Editar en `RutinaService.java`:
```java
private List<String> generarGruposPorDefecto(int dia, int totalDias)
```

### Modificar niveles de dificultad

Editar `PrologService.java` para cambiar cómo se consultan ejercicios.

---

## 🐛 Troubleshooting

### PostgreSQL no conecta
```bash
# Verificar que PostgreSQL está corriendo
psql -U postgres

# Actualizar credenciales en application.yml
```

### Prolog no se carga
```bash
# Verificar instalación
swipl --version

# Verificar ruta en PrologService
Query.onceGoal("consult('prolog/ejercicios.pl')");
```

### React no compila
```bash
# Limpiar cache
npm cache clean --force

# Reinstalar dependencias
rm -rf node_modules
npm install
```

---

## 📝 Tecnologías Utilizadas

- **Backend**: Java 17, Spring Boot 3.2, JPA/Hibernate, PostgreSQL
- **Prolog**: SWI-Prolog 7.8, JPL7 (Java Prolog Interface)
- **Frontend**: React 18, React Router 6, Axios, SASS
- **Build**: Maven, npm
- **Otros**: Git, Docker (opcional)

---

## 🔐 Seguridad

⚠️ **En producción:**
- Implementar JWT para autenticación
- Hashear contraseñas con BCrypt
- Usar variables de entorno
- HTTPS obligatorio
- CORS configurado correctamente

---

## 📄 Licencia

Este proyecto está bajo licencia MIT.

---

## 👨‍💻 Autor

Desarrollado como demostración de integración entre OOP y Prolog para generación inteligente de rutinas de entrenamiento.

---

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Por favor:
1. Fork el proyecto
2. Crea una rama (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

---

## 📞 Soporte

Para reportar bugs o sugerencias, por favor abre un issue en el repositorio.

**¡Que disfrutes construyendo tus rutinas! 💪**
