# 🛣️ ROADMAP - Integración Backend Java/Spring Boot

## 🎯 Objetivo

Integrar el sistema experto Prolog con el backend Java/Spring Boot para proporcionar generación inteligente de rutinas a través de API REST.

---

## 📋 Fases de Integración

### FASE 1: Infraestructura (Semana 1)
- [ ] Instalar librería JPL (Java Prolog Library)
  - Maven dependency: `org.swi-prolog:jpl`
- [ ] Configurar SWI-Prolog en el servidor
- [ ] Crear clase `PrologEngine` para gestión de consultas
- [ ] Tests unitarios de conectividad

**Archivos a modificar**:
- `pom.xml` (backend) - Agregar dependencia JPL

---

### FASE 2: Wrapper Prolog (Semana 1-2)
- [ ] Crear clase `RutineGenerator` en Java
  ```java
  class RutineGenerator {
    public RoutineResponse generateRoutine(String userId)
    public ValidationResult validateRoutine(Routine routine)
    public List<String> getExercises(String muscleGroup)
    public ExplanationResponse explainRoutine(String userId)
  }
  ```
- [ ] Implementar manejo de excepciones
- [ ] Convertir respuestas Prolog a objetos Java
- [ ] Tests de integración

**Archivos a crear**:
- `src/main/java/com/rutinagym/service/PrologService.java`
- `src/main/java/com/rutinagym/service/RutineGenerator.java`

---

### FASE 3: REST Controllers (Semana 2)
- [ ] Crear endpoints REST
- [ ] Documentación OpenAPI/Swagger
- [ ] Validación de entrada
- [ ] Manejo de errores

**Endpoints a implementar**:
```
POST /api/routines/generate
GET /api/routines/{userId}/validate
GET /api/exercises?group={muscleGroup}
POST /api/routines/{userId}/explain
GET /api/routines/{userId}/recommendations
```

**Archivos a crear**:
- `src/main/java/com/rutinagym/controller/RutineController.java`

---

### FASE 4: Persistencia (Semana 2-3)
- [ ] Crear modelo JPA para rutinas generadas
- [ ] Guardar rutinas en BD
- [ ] Historial de usuarios
- [ ] Auditoría de cambios

**Archivos a crear**:
- `src/main/java/com/rutinagym/model/GeneratedRoutine.java`
- `src/main/java/com/rutinagym/repository/RoutineRepository.java`
- Migrations SQL

---

### FASE 5: Frontend Integration (Semana 3-4)
- [ ] Actualizar componentes React
  - `GenerarRutina.js` - usar nuevos endpoints
  - `DetalleRutina.js` - mostrar validaciones
  - `MisRutinas.js` - historial
- [ ] Llamadas a API REST
- [ ] Manejo de estados y errores
- [ ] Loading states y feedback

**Archivos a modificar**:
- `frontend/src/api/api.js` - nuevas funciones
- `frontend/src/pages/GenerarRutina.js`
- `frontend/src/pages/DetalleRutina.js`

---

### FASE 6: Optimización (Semana 4)
- [ ] Caché de resultados
- [ ] Compresión de respuestas
- [ ] Rate limiting
- [ ] Monitoreo y logs

---

## 🏗️ Arquitectura de Integración

```
┌─────────────────────────────────────────────────┐
│         FRONTEND (React)                        │
│  GenerarRutina.js → API.js                      │
└────────────────────┬────────────────────────────┘
                     │ HTTP REST
                     ↓
┌─────────────────────────────────────────────────┐
│         SPRING BOOT BACKEND                     │
│  ┌──────────────────────────────────────────┐   │
│  │ RutineController                         │   │
│  │  POST /api/routines/generate             │   │
│  │  POST /api/routines/validate             │   │
│  │  GET  /api/exercises/{group}             │   │
│  └────────────┬─────────────────────────────┘   │
│               │                                 │
│  ┌────────────↓─────────────────────────────┐   │
│  │ RutineService/PrologService              │   │
│  │  - Inicializa Prolog                     │   │
│  │  - Ejecuta consultas                     │   │
│  │  - Convierte resultados                  │   │
│  └────────────┬─────────────────────────────┘   │
│               │                                 │
│  ┌────────────↓─────────────────────────────┐   │
│  │ Persistencia (JPA/Hibernate)             │   │
│  │  - Guarda rutinas                        │   │
│  │  - Historial usuario                     │   │
│  └─────────────────────────────────────────┘   │
└─────────────────────────────────────────────────┘
                     │
                     ↓
┌─────────────────────────────────────────────────┐
│         PROLOG ENGINE (SWI-Prolog)              │
│  knowledge_base.pl                              │
│  rules.pl                                       │
│  validation.pl                                  │
│  (JPL Interface)                                │
└─────────────────────────────────────────────────┘
```

---

## 📝 Ejemplo de Implementación

### Java Service
```java
@Service
public class PrologService {
    
    private Query prologQuery;
    
    @PostConstruct
    public void initProlog() {
        Query.onSolution = initProlog();
        prologQuery = new Query("consult('knowledge_base.pl')");
    }
    
    public Routine generateRoutine(String userId) {
        Query query = new Query(
            "generar_rutina_semanal('" + userId + "', Division, Rutina)"
        );
        Map<String, Term> solution = query.oneSolution();
        return convertToRoutine(solution);
    }
    
    public ValidationResult validateRoutine(Routine routine) {
        Query query = new Query(
            "validar_rutina_completa('" + routine.getUserId() + 
            "', Rutina, Resultado)"
        );
        Map<String, Term> solution = query.oneSolution();
        return convertToValidation(solution);
    }
}
```

### REST Controller
```java
@RestController
@RequestMapping("/api/routines")
public class RutineController {
    
    @Autowired
    private PrologService prologService;
    
    @PostMapping("/generate")
    public ResponseEntity<RoutineResponse> generateRoutine(
        @RequestParam String userId) {
        
        Routine routine = prologService.generateRoutine(userId);
        return ResponseEntity.ok(new RoutineResponse(routine));
    }
    
    @PostMapping("/validate")
    public ResponseEntity<ValidationResult> validateRoutine(
        @RequestBody Routine routine) {
        
        ValidationResult result = prologService.validateRoutine(routine);
        return ResponseEntity.ok(result);
    }
}
```

---

## 📊 Plan Temporal

```
Semana 1:
  ✓ JPL Setup
  ✓ PrologEngine
  ✓ Wrapper básico
  
Semana 2:
  ✓ Controllers REST
  ✓ Conversión de datos
  ✓ Error handling
  
Semana 3:
  ✓ Persistencia
  ✓ Frontend integration
  
Semana 4:
  ✓ Optimización
  ✓ Tests E2E
  ✓ Deployment
```

---

## ✅ Checklist de Implementación

### Preparación
- [ ] Revisar `integration.pl` para referencia
- [ ] Estudiar JPL documentation
- [ ] Revisar modelos existentes en Java

### Implementación
- [ ] Configurar JPL
- [ ] Crear PrologService
- [ ] Crear RutineController
- [ ] Crear modelos JPA
- [ ] Migrar BD

### Testing
- [ ] Unit tests (Service)
- [ ] Integration tests (Controller)
- [ ] E2E tests (Frontend + Backend)
- [ ] Performance tests

### Deployment
- [ ] Docker containerization
- [ ] CI/CD pipeline
- [ ] Logs y monitoring
- [ ] Documentation

---

## 🔧 Dependencias Maven

```xml
<!-- JPL - Java Prolog Interface -->
<dependency>
    <groupId>org.swi-prolog</groupId>
    <artifactId>jpl</artifactId>
    <version>8.2.0</version>
</dependency>

<!-- JSON Processing -->
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-databind</artifactId>
</dependency>

<!-- Logging -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-logging</artifactId>
</dependency>
```

---

## 🐛 Posibles Desafíos

| Desafío | Solución |
|---------|----------|
| Performance de Prolog | Caché de resultados, optimizar queries |
| Escalabilidad | Pool de threads, conexiones |
| Errores Prolog | Manejo robusto de excepciones |
| Conversión datos | Mapper DTOs custom |
| Thread safety | Sincronización, contextos |

---

## 📚 Recursos

### Documentación
- JPL: https://jpl7.org/
- SWI-Prolog: https://www.swi-prolog.org/
- Spring Boot: https://spring.io/projects/spring-boot

### Ejemplos
- `integration.pl` - Endpoints simulados
- `examples.pl` - Uso del sistema

### Configuración
- `application.yml` - Propiedades Spring

---

## 🎯 Métricas de Éxito

| Métrica | Target |
|---------|--------|
| Latencia generación | < 500ms |
| Disponibilidad | 99.9% |
| Tests passing | 100% |
| Documentación | Completa |
| Performance | > 100 req/s |

---

## 🚀 Próximas Etapas Después

### Corto Plazo
1. ML para personalización
2. Wearables integration
3. Mobile app

### Mediano Plazo
1. Analytics dashboard
2. Social features
3. Coaching integration

### Largo Plazo
1. AI-powered recommendations
2. Community features
3. Gamification

---

## 📞 Soporte Técnico

### Preguntas Frecuentes

**P: ¿Cómo instalo JPL?**  
A: `mvn install:install-file -Dfile=jpl.jar ...`

**P: ¿SWI-Prolog debe estar instalado?**  
A: Sí, en el servidor de ejecución

**P: ¿Cómo manejo errores de Prolog?**  
A: Try-catch con manejo específico en Service

**P: ¿Cómo optimizo performance?**  
A: Caché, queries optimizadas, pooling

---

## 📈 Próximo Paso

1. Lee `integration.pl` completamente
2. Instala JPL en tu máquina
3. Crea clase `PrologService` básica
4. Prueba con una consulta simple

---

**Roadmap v1.0** - Listo para implementación
