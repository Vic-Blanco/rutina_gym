# 🧠 Integración OOP + Prolog - Arquitectura Completa

## 📚 Visión General

El proyecto **Rutina Gym** combina verdaderamente dos paradigmas:
- **OOP (Java/Spring Boot):** Manejo de datos, persistencia, lógica de negocio
- **Prolog:** Consultas lógicas para decisiones inteligentes

```
┌──────────────────────────────────────────────────────┐
│           USUARIO EN NAVEGADOR (React)               │
└──────────────────┬───────────────────────────────────┘
                   │
                   ↓
┌──────────────────────────────────────────────────────┐
│     BACKEND - CAPA OOP (Java/Spring Boot)            │
│  ┌──────────────────────────────────────────────┐   │
│  │ RutinaController                             │   │
│  │ - Recibe: nombre, nivel, días, grupos       │   │
│  └──────────────────┬──────────────────────────┘   │
│                     ↓                               │
│  ┌──────────────────────────────────────────────┐   │
│  │ RutinaService (OOP)                          │   │
│  │ - Crea Rutina, DiaEntrenamiento, Ejercicio  │   │
│  │ - Llama a PrologService para decisiones     │   │
│  └──────────────────┬──────────────────────────┘   │
│                     ↓                               │
│  ┌──────────────────────────────────────────────┐   │
│  │ PrologService.obtenerEjerciciosRecomendados │   │
│  │ - Ejecuta: swipl -f query.pl                │   │
│  │ - Consulta: ejercicio_recomendado(...)      │   │
│  └──────────────────┬──────────────────────────┘   │
│                     ↓                               │
│         ┌────────────────────────┐                 │
│         │ PROLOG (Lógica Pura)   │                 │
│         └────────────────────────┘                 │
│         ejercicios.pl:                             │
│         - grupo_muscular(pecho).                   │
│         - nivel(inicial).                          │
│         - ejercicio_recomendado(...)               │
│         - plan_semanal(...)                        │
│         - Reglas, hechos, consultas                │
│         └────────────────────────┘                 │
│                     ↓                               │
│  PrologService parsea respuesta Prolog             │
│  "Flexiones Pared, Press Banca..."                 │
│                     ↓                               │
│  RutinaService crea objetos Ejercicio (OOP)        │
│                     ↓                               │
│  RutinaRepository.save() → PostgreSQL              │
│                     ↓                               │
└──────────────────────────────────────────────────────┘
                     ↓
            Respuesta JSON a Frontend
```

---

## 🔧 Cómo Funciona la Integración

### 1. **Usuario Genera Rutina (Frontend)**

```javascript
POST /api/v1/rutinas/generar
{
  "usuarioId": 1,
  "nombre": "Mi Rutina",
  "nivel": "inicial",
  "numDias": 3,
  "grupos": ["pecho", "espalda", "hombros"]
}
```

### 2. **RutinaController Recibe (OOP - Java)**

```java
@PostMapping("/generar")
public ResponseEntity<?> generarRutina(@RequestBody GenerarRutinaRequest request) {
    Rutina rutina = rutinaService.generarRutinaPersonalizada(
        usuario,
        request.getNombre(),
        request.getNivel(),      // "inicial"
        request.getNumDias(),      // 3
        request.getGrupos()        // ["pecho", "espalda", "hombros"]
    );
    return ResponseEntity.ok(rutina);
}
```

### 3. **RutinaService Orquesta (OOP - Java)**

```java
public Rutina generarRutinaPersonalizada(...) {
    // OOP: Crear estructura de datos
    Rutina rutina = new Rutina();
    rutina.setNombre(nombre);
    rutina.setNivel(Nivel.valueOf(nivel.toUpperCase()));
    
    // Para cada día
    for (int i = 1; i <= numDias; i++) {
        DiaEntrenamiento dia = crearDiaEntrenamiento(rutina, i, numDias, nivel, genero);
        dias.add(dia);
    }
    
    // Guardar en BD
    return rutinaRepository.save(rutina);
}
```

### 4. **Consulta a Prolog (Lógica - Prolog)**

En `crearDiaEntrenamiento`, se llama a `PrologService`:

```java
// Obtener qué grupos trabajar hoy
List<String> gruposDelDia = prologService.obtenerGruposParaDia(1, 3);
// Prolog responde: [pecho, triceps]

// Para cada grupo, obtener ejercicios
for (String grupo : gruposDelDia) {
    List<String> ejercicios = prologService.obtenerEjerciciosRecomendados(
        grupo,      // "pecho"
        nivel,      // "inicial"
        genero      // "masculino"
    );
    // Prolog responde: ["Flexiones Pared", "Press Banca"]
}
```

### 5. **PrologService Ejecuta SWI-Prolog**

```java
private List<String> ejecutarConsultaProlog(String consulta) {
    // Crear script temporal
    String prologScript = ":-consult('prolog/ejercicios.pl').\n" +
                          consulta +
                          "halt.";
    
    // Ejecutar: swipl -f query.pl
    Process process = Runtime.getRuntime().exec(
        new String[]{"swipl", "-q", "-f", tempFile.getAbsolutePath()}
    );
    
    // Capturar salida de Prolog
    BufferedReader reader = new BufferedReader(
        new InputStreamReader(process.getInputStream())
    );
    
    // Parsear respuestas
    return parsearResultados(reader);
}
```

### 6. **Consulta Prolog Real**

```prolog
% Script enviado a Prolog:
:-consult('prolog/ejercicios.pl').
ejercicio_recomendado(Ejercicio, 'pecho', 'inicial', 'masculino'), 
write(Ejercicio), nl, fail.
halt.

% Prolog busca todos los ejercicios que cumplen la regla:
% Prolog encuentra: ejercicio_recomendado('Flexiones Inclinadas', pecho, inicial, masculino).
% Output:
% Flexiones Inclinadas
% Press Mancuerna Ligera
% (y otros más...)
```

### 7. **Parseo de Respuesta (Java)**

```java
private List<String> parsearResultados(BufferedReader reader) {
    List<String> resultados = new ArrayList<>();
    String linea;
    while ((linea = reader.readLine()) != null) {
        linea = linea.trim();
        if (!linea.isEmpty()) {
            resultados.add(linea);  // "Flexiones Inclinadas"
        }
    }
    return resultados;  // ["Flexiones Inclinadas", "Press Mancuerna..."]
}
```

### 8. **Creación de Objetos (OOP - Java)**

```java
for (String nombreEjercicio : ejerciciosRec) {  // ["Flexiones Inclinadas", ...]
    Ejercicio ejercicio = new Ejercicio();
    ejercicio.setNombre(nombreEjercicio);        // OOP
    ejercicio.setGrupoMuscular(GrupoMuscular.PECHO);  // OOP
    ejercicio.setNivelDificultad(Nivel.INICIAL);     // OOP
    ejercicio.setSeries(3);
    ejercicio.setRepeticiones(10);
    ejercicio.setDescansoSegundos(60);
    ejercicios.add(ejercicio);
}
```

### 9. **Persistencia en BD (OOP - Spring Data)**

```java
rutinaRepository.save(rutina);
// INSERT INTO rutinas (...) VALUES (...)
// INSERT INTO dias_entrenamiento (...) VALUES (...)
// INSERT INTO ejercicios (...) VALUES (...)
```

### 10. **Respuesta al Frontend**

```json
{
  "id": 1,
  "nombre": "Mi Rutina",
  "nivel": "INICIAL",
  "numDias": 3,
  "diasEntrenamiento": [
    {
      "numeroDia": 1,
      "descripcion": "Día 1: pecho, triceps",
      "ejercicios": [
        {
          "nombre": "Flexiones Inclinadas",
          "grupoMuscular": "PECHO",
          "nivelDificultad": "INICIAL",
          "series": 3,
          "repeticiones": 10,
          "descansoSegundos": 60
        },
        {
          "nombre": "Press Mancuerna Ligera",
          "grupoMuscular": "PECHO",
          "nivelDificultad": "INICIAL",
          "series": 3,
          "repeticiones": 10,
          "descansoSegundos": 60
        }
      ]
    }
  ]
}
```

---

## 📊 Flujo de Datos

```
Usuario Input
    ↓
Java (RutinaController)
    ↓
Java (RutinaService - OOP)
    ↓
Java (PrologService) ──→ ejecutarConsultaProlog()
    ↓                          ↓
    ↓                    Prolog (swipl)
    ↓                    ejercicios.pl
    ↓                          ↓
    ←───────────────────────────┘
    (Lista de strings)
    ↓
Java (Parseo)
    ↓
Java (Creación de Objetos)
    ↓
Java (JPA - Persistencia)
    ↓
PostgreSQL (BD)
    ↓
JSON (Frontend)
```

---

## 🎯 Paradigmas en Acción

### OOP (Java)
```
✓ Encapsulación: Clases Usuario, Rutina, Ejercicio
✓ Herencia: Entidades con superclase base
✓ Polimorfismo: Comportamiento polimórfico en servicios
✓ Persistencia: JPA/Hibernate maneja la BD
✓ Inyección: Spring inyecta dependencias
```

### Lógica Declarativa (Prolog)
```
✓ Hechos: grupo_muscular(pecho). nivel(inicial).
✓ Reglas: plan_semanal(1, 3, [pecho, triceps]).
✓ Consultas: ejercicio_recomendado(X, pecho, inicial, masculino).
✓ Backtracking: Prolog busca TODAS las soluciones
✓ Unificación: Matching automático de patrones
```

---

## 🐳 En Docker

1. **Dockerfile del Backend instala SWI-Prolog**
   ```dockerfile
   RUN apt-get update && apt-get install -y swi-prolog
   ```

2. **docker-compose monta el volumen**
   ```yaml
   volumes:
     - ./prolog:/app/prolog
   ```

3. **Backend accede a Prolog**
   - Ejecuta: `swipl -f query.pl`
   - Lee: stdout de SWI-Prolog
   - Parsea: Respuestas en formato texto

---

## 🔄 Ventajas de Esta Arquitectura

| Aspecto | OOP (Java) | Prolog | Ventaja |
|--------|-----------|--------|---------|
| **Manejo de datos** | ✓ Excelente | ✗ No | Persistencia en BD |
| **Lógica compleja** | ✗ Verboso | ✓ Conciso | Reglas limpias |
| **Backtracking** | ✗ Manual | ✓ Automático | Busca exhaustiva |
| **Escalabilidad** | ✓ Fácil | ~ Moderada | Microservicios |
| **Mantenimiento** | ✓ Claro | ✓ Explícito | Código legible |

---

## 📝 Archivos Clave

| Archivo | Rol |
|---------|-----|
| `RutinaService.java` | Orquestación OOP |
| `PrologService.java` | Puente OOP ↔ Prolog |
| `ejercicios.pl` | Base de conocimiento Prolog |
| `docker-compose.yml` | Integración en Docker |
| `Dockerfile` | SWI-Prolog en contenedor |

---

## 🚀 Para Ejecutar

```bash
# Docker
docker-compose up -d

# Verificar que Prolog funciona
docker exec rutina_gym_api swipl --version

# Ver logs de una consulta
docker logs rutina_gym_api | grep "Prolog"
```

---

## 📚 Ejemplo Completo: Generar Rutina de 3 Días

### 1. Request
```bash
curl -X POST http://localhost:8080/api/v1/rutinas/generar \
  -H "Content-Type: application/json" \
  -d '{
    "usuarioId": 1,
    "nombre": "Mi Rutina Full Body",
    "nivel": "inicial",
    "numDias": 3,
    "grupos": ["pecho", "espalda", "hombros"]
  }'
```

### 2. Java (RutinaService)
```
→ Crear Rutina()
→ Para día 1:
  • Llamar: prologService.obtenerGruposParaDia(1, 3)
    [Prolog: plan_semanal(1, 3, X). → X = [pecho, triceps]]
  • Para grupo "pecho":
    - Llamar: prologService.obtenerEjerciciosRecomendados("pecho", "inicial", "masculino")
      [Prolog: ejercicio_recomendado(X, pecho, inicial, masculino).
       → X = 'Flexiones Inclinadas', 'Press Banca Mancuerna', ...]
  • Crear 3 objetos Ejercicio (OOP)
  • Crear 1 DiaEntrenamiento con 6+ ejercicios
→ Para día 2: (similar)
→ Para día 3: (similar)
→ Guardar en PostgreSQL
```

### 3. Prolog (ejercicios.pl)
```prolog
plan_semanal(1, 3, [pecho, triceps]).
ejercicio_recomendado('Flexiones Inclinadas', pecho, inicial, masculino).
ejercicio_recomendado('Press Banca Mancuerna', pecho, inicial, masculino).
...
```

### 4. Response (JSON)
```json
{
  "id": 5,
  "nombre": "Mi Rutina Full Body",
  "nivel": "INICIAL",
  "numDias": 3,
  "diasEntrenamiento": [
    {
      "id": 10,
      "numeroDia": 1,
      "ejercicios": [
        {"nombre": "Flexiones Inclinadas", "series": 3, ...},
        {"nombre": "Press Banca Mancuerna", "series": 3, ...},
        ...
      ]
    },
    ...
  ]
}
```

---

**¡Así es como OOP y Prolog trabajan juntos para crear un sistema inteligente! 🧠💪**
