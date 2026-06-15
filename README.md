# Rutina Gym

Aplicación web para generar rutinas de gimnasio personalizadas. Combina un backend Java (Spring Boot) con un sistema experto en Prolog que decide la distribución de grupos musculares, ejercicios, entrada en calor y movilidad según el objetivo y nivel del usuario.

---

## Tecnologías

| Capa | Tecnología |
|------|-----------|
| Frontend | React |
| Backend | Java 17 / Spring Boot 3 |
| Sistema experto | SWI-Prolog |
| Base de datos | PostgreSQL |
| Contenedores | Docker / Docker Compose |

---

## Estructura

```
rutina_gym/
+-- backend/          # API REST (Spring Boot + JPA)
�   +-- src/main/java/com/rutinagym/
�       +-- controller/   RutinaController.java
�       +-- service/      RutinaService.java � PrologService.java
�       +-- model/        Rutina � DiaEntrenamiento � Ejercicio � enums
�       +-- dto/          GenerarRutinaRequest.java
+-- frontend/         # SPA React
�   +-- src/
�       +-- pages/    SeleccionarTipo � GenerarRutinaAutomatica � GenerarRutinaPersonalizada � DetalleRutina
�       +-- api/      api.js
�       +-- utils/    exerciseImages.js
+-- prolog/           # Sistema experto
    +-- knowledge_base.pl   ejercicios, objetivos, movilidad, usuarios
    +-- rules.pl            generaci�n, distribuci�n, validaci�n
    +-- integration.pl      predicados de integraci�n con Java
    +-- validation.pl       validaciones adicionales
```
Hay metodos/clases/reglas/datos adicionales que no se utilizan en esta version ya que fue iniciado con un alcance mayor pero luego se limito a poder hacer una aplicacion funcional con lo basico para llegar con los plazos de entrega.
---

## Cómo levantar el proyecto

### Con Docker (recomendado)

```bash
docker-compose up --build
```

- Frontend: http://localhost:3000  
- Backend API: http://localhost:8080/api

### Manual

**Base de datos**
```bash
createdb rutina_gym_db
```

**Backend**
```bash
cd backend
mvn spring-boot:run
```

**Frontend**
```bash
cd frontend
npm install
npm start
```

Requiere SWI-Prolog instalado y en el PATH.

---

## API

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| POST | `/api/v1/rutinas/generar` | Genera una rutina (automática o personalizada) |
| GET | `/api/v1/rutinas/ejercicios/{grupo}` | Ejercicios por grupo muscular |
| GET | `/api/v1/rutinas/info` | Estado del sistema experto |

### Ejemplo: generar rutina automática

```json
POST /api/v1/rutinas/generar
{
  "nombre": "Mi Rutina",
  "objetivo": "HIPERTROFIA",
  "nivel": "INTERMEDIO",
  "diasDisponibles": 4
}
```

### Ejemplo: generar rutina personalizada

```json
POST /api/v1/rutinas/generar
{
  "nombre": "Rutina Piernas",
  "objetivo": "FUERZA",
  "nivel": "AVANZADO",
  "diasDisponibles": 3,
  "gruposMusculares": ["cuadriceps", "isquiotibial", "gluteos"],
  "tipoEntradaCalor": "activacion_muscular"
}
```

---

## Cómo funciona el sistema experto

Prolog recibe nivel, objetivo, días y grupos musculares y devuelve una estructura con:

- **Entrada en calor** (1 ejercicio, automático o del tipo elegido)
- **Movilidad** (3 ejercicios rotados por día)
- **Ejercicios principales** (5-6 por día, máx 4 compuestos + aislados, rotados por día)

Si hay menos grupos que días, los grupos se ciclan para que ningún día quede vacío y cada día repetido muestra ejercicios distintos por rotación.

La rutina mostrada al usuario es **orientativa y genérica**. Se recomienda consultar a un profesional antes de comenzar.
