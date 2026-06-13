# 🏋️ Sistema Experto de Rutinas - Resumen Ejecutivo

## ✨ ¿Qué es esto?

Un **sistema experto completo en Prolog** que genera, valida, explica y mejora rutinas de entrenamiento de gimnasio usando **razonamiento inteligente**, no solo almacenamiento de datos.

---

## 🎯 Problema Resuelto

| Antes | Ahora |
|--------|--------|
| ❌ Solo almacenaba ejercicios | ✅ Genera rutinas inteligentes |
| ❌ Sin validación | ✅ Valida automáticamente (5 criterios) |
| ❌ No razonaba | ✅ Razona como experto |
| ❌ No explicaba | ✅ Explica cada decisión |
| ❌ No se adaptaba | ✅ Se adapta al contexto |

---

## 🚀 Inicio Rápido

### 1. Cargar el Sistema
```prolog
?- consult('knowledge_base.pl').
```

### 2. Generar Rutina
```prolog
?- generar_rutina_completa(user1).
```

### 3. Ver Resultado
```
DIVISIÓN: Full Body
RUTINA: [día 1: pecho, espalda, piernas], ...
VALIDACIÓN: ✓ Recuperación ✓ Volumen ✓ Balance
RECOMENDACIONES: Aumentar serie lentamente...
```

---

## 📁 Estructura (5 Módulos)

```
🎓 SISTEMA EXPERTO
├─ 📚 knowledge_base.pl (Base de Conocimiento)
│  └─ 30+ ejercicios, 3 usuarios, 4 objetivos
├─ 🧠 rules.pl (Lógica de Inferencia)
│  └─ Selección división, generación, análisis
├─ ✅ validation.pl (Validación Profunda)
│  └─ 5 validaciones, detección de problemas
├─ 📖 examples.pl (Ejemplos e Interfaz)
│  └─ Función principal, tests, utilidades
└─ 🔌 integration.pl (REST API)
   └─ Endpoints JSON, conversión datos
```

---

## 🔬 Capacidades del Sistema Experto

### 1. Razonamiento Automático
```prolog
?- seleccionar_division(user1, Division).
% Analiza: nivel, días disponibles, objetivo
% Retorna: Full Body (óptimo para 3 días)
```

### 2. Generación Inteligente
```prolog
?- generar_rutina_semanal(user1, 'Full Body', Rutina).
% - Selecciona ejercicios válidos
% - Distribuye grupos musculares
% - Respeta tiempos de recuperación
% - Mantiene balance push/pull
```

### 3. Validación Multi-Criterio
```prolog
?- validar_rutina_completa(user1, Rutina, Resultado).
% Valida:
% ✓ Recuperación (48-72h por grupo)
% ✓ Volumen (límite por nivel)
% ✓ Frecuencia (veces/semana)
% ✓ Balance push/pull
% ✓ Grupos musculares
```

### 4. Explicaciones
```prolog
?- explicacion_completa(user1, Division, Rutina, Expl).
% "Se seleccionó Full Body porque:"
% "  - Tienes 3 días disponibles"
% "  - Es ideal para principiantes"
% "  - Permite recuperación adecuada"
```

### 5. Recomendaciones Personalizadas
```prolog
?- generar_recomendaciones(user1, Rutina, Recs).
% - "Volumen bajo: aumenta series"
% - "Desbalance: más ejercicios de tirón"
% - "Fatiga: descansa más"
```

---

## 📊 Base de Conocimiento

### Usuarios
```prolog
usuario(user1, 'Juan', principiante, hipertrofia, 3, 
        [pecho, espalda, piernas], pecho).
```

### Ejercicios (30+)
```prolog
ejercicio(ex_001, 'Press Banca', pecho, compuesto, empuje, intermedio).
musculo_secundario(ex_001, triceps, media).
musculo_secundario(ex_001, hombros, baja).
```

### Objetivos
```prolog
objetivo(hipertrofia, 8, 12, 3, 60, 'media-alta').
% Reps: 8-12, Series: 3, Descanso: 60min, Intensidad: media-alta
```

### Divisiones
```prolog
division_rutina('Full Body', [2,3], 'Todos los grupos cada sesión').
division_rutina('Push/Pull/Legs', [5], '3 patrones en 5 días').
```

---

## ✅ Validaciones Automáticas

| Validación | Verifica |
|------------|----------|
| **Recuperación** | 48-72h entre mismo grupo |
| **Volumen** | Límite de series por nivel |
| **Frecuencia** | Veces/semana según experiencia |
| **Balance** | Ratio push/pull 1:1 a 1.2:1 |
| **Grupos** | Entrenar grupos seleccionados |

---

## 🎓 Ejemplos Reales

### Ejemplo 1: Principiante
```prolog
?- generar_rutina_completa(user1).

Usuario: Juan (principiante, 3 días, hipertrofia)

DIVISIÓN: Full Body
VALIDACIÓN: ✓ VÁLIDA
RECOMENDACIONES:
  • Mantén buena técnica
  • Aumenta carga gradualmente
  • Descansa adecuadamente
```

### Ejemplo 2: Intermedio
```prolog
?- generar_rutina_completa(user2).

Usuario: María (intermedio, 4 días, fuerza)

DIVISIÓN: Torso-Pierna
VALIDACIÓN: ✓ VÁLIDA
RECOMENDACIONES:
  • Aumenta densidad de volumen
  • Prueba cargas más pesadas
  • Varía intensidad semanal
```

---

## 🔌 Integración REST API

Endpoints disponibles:
```
GET /routines/generate/{userId}     → Genera rutina
POST /routines/validate             → Valida rutina
GET /exercises/{groupId}            → Lista ejercicios
POST /routines/explain              → Explica decisiones
```

Ejemplo:
```prolog
?- api_generate_routine(user1, JSON).
% Retorna: {"usuario": "user1", "division": "Full Body", ...}
```

---

## 📚 Documentación Completa

| Documento | Propósito |
|-----------|-----------|
| **INDEX.md** | Índice y descripción general |
| **README_SISTEMA_EXPERTO.md** | Referencia técnica completa |
| **MIGRATION_GUIDE.md** | Cómo migrar del sistema anterior |

---

## 🧪 Tests Automatizados

```prolog
?- ejecutar_tests.

✓ Ejercicios válidos
✓ Usuarios válidos  
✓ Divisiones válidas
✓ Integridad referencial
```

---

## 📈 Estadísticas

| Métrica | Cantidad |
|---------|----------|
| Líneas de código Prolog | 1,500+ |
| Ejercicios | 30+ |
| Usuarios ejemplo | 3 |
| Objetivos | 4 |
| Validaciones | 5 |
| Predicados expertos | 27+ |
| Módulos | 5 |

---

## 💡 Conceptos Clave

### 1. **Inferencia**
El sistema infiere: división, ejercicios, parámetros

### 2. **Validación**
Asegura que cada rutina es: segura, efectiva, personalizada

### 3. **Explicación**
Todo es transparente y justificable

### 4. **Adaptabilidad**
Se ajusta a: nivel, objetivo, disponibilidad, preferencias

### 5. **Escalabilidad**
Fácil de extender: nuevos ejercicios, divisiones, reglas

---

## 🎯 Próximos Pasos

### Para Usar Ahora
1. `consult('knowledge_base.pl')`
2. `generar_rutina_completa(user1)`
3. Explorar: `listar_ejercicios`, `estadisticas_sistema`

### Para Extender
1. Agregar más ejercicios a `knowledge_base.pl`
2. Crear nuevas divisiones
3. Agregar nuevas reglas a `rules.pl`

### Para Integrar
1. Ver `integration.pl` para REST API
2. Conectar con Spring Boot backend
3. Usar endpoints JSON

---

## 🎬 Demostración Rápida

```prolog
% Cargar
?- consult('knowledge_base.pl').

% Ver usuarios
?- listar_usuarios.

% Ver ejercicios
?- listar_ejercicios.

% Generar rutina
?- generar_rutina_completa(user1).

% Obtener estadísticas
?- estadisticas_sistema.

% Ejecutar tests
?- ejecutar_tests.
```

---

## 📞 ¿Preguntas?

### Referencia Rápida
```
¿Cómo genero una rutina?
  → ?- generar_rutina_completa(user1).

¿Cómo valido una rutina?
  → ?- rutina_valida(user1, Rutina).

¿Cómo obtengo recomendaciones?
  → ?- generar_recomendaciones(user1, Rutina, Recs).

¿Cómo me explica el sistema?
  → ?- explicacion_completa(user1, Division, Rutina, Expl).
```

### Más Información
- **Técnica**: `README_SISTEMA_EXPERTO.md`
- **Migración**: `MIGRATION_GUIDE.md`
- **Índice**: `INDEX.md`
- **Ejemplos**: `examples.pl`

---

## ✨ Resumen

Este es un **verdadero sistema experto**, no solo código que almacena datos. 

✓ **Razona** como un entrenador  
✓ **Valida** automáticamente  
✓ **Explica** sus decisiones  
✓ **Se adapta** al usuario  
✓ **Mejora continuamente**  

---

**Sistema Experto v1.0** - ✅ Listo para usar

Inicio: `?- generar_rutina_completa(user1).`
