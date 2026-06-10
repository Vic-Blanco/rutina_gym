# API Examples - Rutina Gym

## Base URL
```
http://localhost:8080/api
```

---

## 1️⃣ USUARIOS

### Registrar nuevo usuario

**Endpoint:** `POST /v1/usuarios/registro`

```bash
curl -X POST http://localhost:8080/api/v1/usuarios/registro \
  -H "Content-Type: application/json" \
  -d '{
    "email": "juan@example.com",
    "nombre": "Juan Pérez",
    "password": "securepass123",
    "genero": "masculino"
  }'
```

**Respuesta exitosa (200):**
```json
{
  "mensaje": "Usuario registrado exitosamente",
  "datos": {
    "id": 1,
    "email": "juan@example.com",
    "nombre": "Juan Pérez",
    "genero": "MASCULINO",
    "fechaCreacion": "2026-05-28T10:30:00"
  }
}
```

---

### Login de usuario

**Endpoint:** `POST /v1/usuarios/login`

```bash
curl -X POST http://localhost:8080/api/v1/usuarios/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "juan@example.com",
    "password": "securepass123"
  }'
```

**Respuesta exitosa (200):**
```json
{
  "mensaje": "Login exitoso",
  "datos": {
    "id": 1,
    "email": "juan@example.com",
    "nombre": "Juan Pérez",
    "genero": "MASCULINO"
  }
}
```

---

### Obtener perfil de usuario

**Endpoint:** `GET /v1/usuarios/{usuarioId}`

```bash
curl -X GET http://localhost:8080/api/v1/usuarios/1
```

**Respuesta exitosa (200):**
```json
{
  "mensaje": "Perfil obtenido",
  "datos": {
    "id": 1,
    "email": "juan@example.com",
    "nombre": "Juan Pérez",
    "genero": "MASCULINO",
    "fechaCreacion": "2026-05-28T10:30:00",
    "ultimaActualizacion": "2026-05-28T10:30:00"
  }
}
```

---

## 2️⃣ RUTINAS

### Generar rutina personalizada

**Endpoint:** `POST /v1/rutinas/generar`

**Parámetros Query:**
- `usuarioId`: ID del usuario (Long)
- `nombre`: Nombre de la rutina (String)
- `nivel`: inicial, intermedio, avanzado (String)
- `numDias`: Número de días 1-7 (Integer)

**Body (JSON Array de grupos musculares):**

```bash
curl -X POST 'http://localhost:8080/api/v1/rutinas/generar?usuarioId=1&nombre=Rutina%20Fuerza&nivel=intermedio&numDias=4' \
  -H "Content-Type: application/json" \
  -d '["pecho", "espalda", "piernas", "hombros"]'
```

**Respuesta exitosa (200):**
```json
{
  "mensaje": "Rutina generada exitosamente",
  "datos": {
    "id": 1,
    "usuario": {
      "id": 1,
      "email": "juan@example.com",
      "nombre": "Juan Pérez"
    },
    "nombre": "Rutina Fuerza",
    "descripcion": "Rutina de 4 días para trabajar pecho, espalda, piernas, hombros",
    "nivel": "INTERMEDIO",
    "numDias": 4,
    "diasEntrenamiento": [
      {
        "id": 1,
        "numeroDia": 1,
        "descripcion": "Día 1: pecho, triceps",
        "ejercicios": [
          {
            "id": 1,
            "nombre": "Press Banca Barra",
            "grupoMuscular": "PECHO",
            "nivelDificultad": "INTERMEDIO",
            "series": 4,
            "repeticiones": 12,
            "descansoSegundos": 60
          },
          {
            "id": 2,
            "nombre": "Fondos en Barras",
            "grupoMuscular": "TRICEPS",
            "nivelDificultad": "INTERMEDIO",
            "series": 4,
            "repeticiones": 12,
            "descansoSegundos": 60
          }
        ]
      }
    ],
    "fechaCreacion": "2026-05-28T10:35:00"
  }
}
```

---

### Obtener todas las rutinas de un usuario

**Endpoint:** `GET /v1/rutinas/usuario/{usuarioId}`

```bash
curl -X GET http://localhost:8080/api/v1/rutinas/usuario/1
```

**Respuesta exitosa (200):**
```json
{
  "mensaje": "Rutinas obtenidas",
  "datos": [
    {
      "id": 1,
      "nombre": "Rutina Fuerza",
      "nivel": "INTERMEDIO",
      "numDias": 4,
      "descripcion": "Rutina de 4 días...",
      "fechaCreacion": "2026-05-28T10:35:00"
    },
    {
      "id": 2,
      "nombre": "Rutina Volumen",
      "nivel": "AVANZADO",
      "numDias": 5,
      "descripcion": "Rutina de 5 días...",
      "fechaCreacion": "2026-05-28T11:00:00"
    }
  ]
}
```

---

### Obtener rutina específica

**Endpoint:** `GET /v1/rutinas/{rutinaId}`

```bash
curl -X GET http://localhost:8080/api/v1/rutinas/1
```

**Respuesta exitosa (200):**
```json
{
  "mensaje": "Rutina obtenida",
  "datos": {
    "id": 1,
    "nombre": "Rutina Fuerza",
    "nivel": "INTERMEDIO",
    "numDias": 4,
    "diasEntrenamiento": [
      {
        "id": 1,
        "numeroDia": 1,
        "descripcion": "Día 1: pecho, triceps",
        "ejercicios": [...]
      }
    ]
  }
}
```

---

### Eliminar rutina

**Endpoint:** `DELETE /v1/rutinas/{rutinaId}`

```bash
curl -X DELETE http://localhost:8080/api/v1/rutinas/1
```

**Respuesta exitosa (200):**
```json
{
  "mensaje": "Rutina eliminada exitosamente",
  "datos": null
}
```

---

## ⚠️ ERRORES

### Error 400 - Solicitud Inválida

```json
{
  "error": "El número de días debe estar entre 1 y 7"
}
```

### Error 404 - No Encontrado

```json
{
  "error": "Usuario no encontrado"
}
```

### Error 500 - Error Interno del Servidor

```json
{
  "error": "Error al generar rutina: [descripción del error]"
}
```

---

## 🧪 CASOS DE USO COMPLETOS

### Caso 1: Crear rutina para principiante femenino

```bash
# 1. Registrar usuario
curl -X POST http://localhost:8080/api/v1/usuarios/registro \
  -H "Content-Type: application/json" \
  -d '{
    "email": "maria@example.com",
    "nombre": "María García",
    "password": "pass123",
    "genero": "femenino"
  }'

# 2. Generar rutina (captura el usuarioId de la respuesta anterior)
curl -X POST 'http://localhost:8080/api/v1/rutinas/generar?usuarioId=2&nombre=Mi%20Primera%20Rutina&nivel=inicial&numDias=3' \
  -H "Content-Type: application/json" \
  -d '["pecho", "espalda", "piernas"]'

# 3. Obtener todas las rutinas
curl -X GET http://localhost:8080/api/v1/rutinas/usuario/2

# 4. Ver detalles de una rutina (captura rutinaId)
curl -X GET http://localhost:8080/api/v1/rutinas/1
```

---

### Caso 2: Crear rutina avanzada

```bash
# Generar rutina avanzada para usuario masculino
curl -X POST 'http://localhost:8080/api/v1/rutinas/generar?usuarioId=1&nombre=Rutina%20Elite&nivel=avanzado&numDias=6' \
  -H "Content-Type: application/json" \
  -d '[
    "pecho", 
    "espalda", 
    "piernas",
    "hombros",
    "brazos",
    "core"
  ]'
```

---

## 📊 GRUPOS MUSCULARES DISPONIBLES

```
- pecho
- espalda
- hombros
- biceps
- triceps
- antebrazo
- cuadriceps
- isquiotibial
- gluteos
- pantorrilla
- core
- cardio
```

---

## 🔐 NIVELES DISPONIBLES

```
- inicial    (principiante)
- intermedio (experiencia 6+ meses)
- avanzado   (experiencia 2+ años)
```

---

## 🧬 GÉNEROS SOPORTADOS

```
- masculino
- femenino
- otro
```

---

## 💡 CONSEJOS

1. **Almacena el usuarioId** después de registrarte para futuras operaciones
2. **Experimenta con diferentes combinaciones** de grupos musculares
3. **Prueba cada nivel** para ver cómo cambian los ejercicios
4. **Valida las respuestas** antes de procesarlas en tu frontend

---

## 🚀 PRÓXIMAS MEJORAS

- [ ] Agregar autenticación JWT
- [ ] Implementar paginación en listados
- [ ] Agregar filtros avanzados
- [ ] Exportar rutinas en PDF
- [ ] Compartir rutinas entre usuarios
- [ ] Historial de entrenamientos

---

**¡Listo para usar la API! Comienza a generar rutinas personalizadas 💪**
