# 📋 ÍNDICE - Sistema Experto de Rutinas de Gimnasio

## 🎯 Descripción General

Sistema experto completo en **Prolog** para generación inteligente de rutinas de entrenamiento. Implementa razonamiento experto, validación automática, explicaciones de decisiones e integración REST API.

**Estado**: ✅ Completamente implementado  
**Versión**: 1.0  
**Fecha**: Junio 2, 2024

---

## 📁 Estructura de Archivos

### Módulos del Sistema Experto

#### 1. **knowledge_base.pl** 
**Base de Conocimiento - 500+ líneas**

Contiene todos los hechos del dominio:
- ✓ 3 usuarios de ejemplo con propiedades completas
- ✓ 4 objetivos de entrenamiento (hipertrofia, fuerza, resistencia, acondicionamiento)
- ✓ 3 niveles de experiencia (principiante, intermedio, avanzado)
- ✓ 12 grupos musculares clasificados
- ✓ 30+ ejercicios con propiedades detalladas
- ✓ Músculos secundarios e intensidades
- ✓ Compatibilidades e incompatibilidades
- ✓ 4 divisiones de rutina (Full Body, Torso-Pierna, Push/Pull/Legs, Weider)
- ✓ Parámetros de recuperación, frecuencia y volumen
- ✓ Historial de usuario y ejercicios realizados

**Consultas principales**:
```prolog
?- usuario(user1, Nombre, Nivel, _, _, _, _).
?- ejercicio(ID, Nombre, pecho, _, _, _).
?- objetivo(hipertrofia, RepMin, RepMax, _, _, _).
```

---

#### 2. **rules.pl**
**Reglas de Inferencia - 300+ líneas**

Implementa la inteligencia del sistema:
- ✓ Selección automática de división
- ✓ Validación de ejercicios por nivel
- ✓ Generación de rutinas completas
- ✓ Parámetros adaptativos
- ✓ Análisis de balance push/pull
- ✓ Detección de fatiga muscular
- ✓ Validación de recuperación
- ✓ Cálculo de volumen
- ✓ Sugerencias automáticas

**Predicados clave**:
- `seleccionar_division/2` - Elige división automáticamente
- `generar_rutina_semanal/3` - Genera rutina completa
- `rutina_valida/2` - Valida rutina
- `push_pull_balanceado/1` - Verifica balance
- `generar_recomendaciones/3` - Sugiere mejoras

---

#### 3. **validation.pl**
**Validación Profunda - 400+ líneas**

Sistema avanzado de validación y análisis:
- ✓ Validación completa multi-criterio
- ✓ Detección de sobreentrenamiento
- ✓ Detección de desbalances
- ✓ Detección de fatiga acumulada
- ✓ Explicaciones detalladas
- ✓ Recomendaciones personalizadas
- ✓ Reportes completos

**Predicados principales**:
- `validar_rutina_completa/3` - Validación integral
- `detectar_sobreentrenamiento/3` - Identifica exceso
- `detectar_desbalances/2` - Encuentra desequilibrios
- `explicacion_completa/4` - Genera explicaciones
- `generar_reporte_rutina/3` - Crea reportes

---

#### 4. **examples.pl**
**Ejemplos e Interfaz - 350+ líneas**

Demostraciones y utilidades:
- ✓ Función principal generar_rutina_completa/1
- ✓ Presentación amigable de resultados
- ✓ Comparación de rutinas
- ✓ Estadísticas del sistema
- ✓ Tests automatizados
- ✓ Utilidades de consulta
- ✓ Menú interactivo

**Funciones principales**:
- `generar_rutina_completa/1` - Genera rutina con interfaz completa
- `comparar_rutinas/2` - Compara dos rutinas
- `estadisticas_sistema/0` - Muestra estadísticas
- `ejecutar_tests/0` - Corre tests automatizados
- `listar_ejercicios/0` - Lista todos los ejercicios

---

#### 5. **integration.pl**
**Integración REST API - 250+ líneas**

Conectividad con backend:
- ✓ Endpoints REST simulados
- ✓ Exportación a JSON
- ✓ Conversión de datos
- ✓ Caché y optimización
- ✓ Logging y auditoría
- ✓ Métricas y analytics

**APIs disponibles**:
- `api_generate_routine/2` - GET /routines/generate/{userId}
- `api_validate_routine/2` - POST /routines/validate
- `api_get_exercises_by_group/2` - GET /exercises/{groupId}
- `api_explain_routine/4` - POST /routines/explain

---

### Documentación

#### **README_SISTEMA_EXPERTO.md**
Documentación técnica completa:
- Arquitectura del sistema
- Base de datos de ejemplo
- Consultas principales
- Tests y validación
- Conceptos clave
- Ejemplo de razonamiento
- Próximos pasos

#### **MIGRATION_GUIDE.md**
Guía de migración:
- Resumen de cambios
- Mejoras implementadas
- Comparación antes/después
- Checklist de migración
- Troubleshooting

#### **ejercicios.pl**
Archivo de referencia:
- Información de migración
- Compatibilidad hacia atrás
- Predicados auxiliares

---

## 🚀 Cómo Comenzar

### 1. Cargar el Sistema
```prolog
?- consult('knowledge_base.pl').
?- consult('rules.pl').
?- consult('validation.pl').
?- consult('examples.pl').
```

### 2. Generar Primera Rutina
```prolog
?- generar_rutina_completa(user1).
```

### 3. Explorar Funcionalidades
```prolog
?- listar_ejercicios.
?- estadisticas_sistema.
?- ejecutar_tests.
```

### 4. Análisis Profundo
```prolog
?- seleccionar_division(user1, Div),
   generar_rutina_semanal(user1, Div, Rutina),
   validar_rutina_completa(user1, Rutina, Resultado),
   generar_recomendaciones(user1, Rutina, Recs).
```

---

## 📊 Estadísticas del Sistema

| Métrica | Cantidad |
|---------|----------|
| Líneas de código Prolog | 1,500+ |
| Ejercicios en BD | 30+ |
| Usuarios de ejemplo | 3 |
| Objetivos de entrenamiento | 4 |
| Divisiones de rutina | 4 |
| Grupos musculares | 12 |
| Validaciones | 5 tipos |
| Predicados de inferencia | 15+ |
| Predicados de validación | 12+ |
| Endpoints REST | 4 |

---

## 🎯 Características Principales

### Razonamiento Experto
```prolog
?- seleccionar_division(user1, Division).
% Analiza disponibilidad del usuario
% Retorna división recomendada
```

### Generación Inteligente
```prolog
?- generar_rutina_semanal(user1, Division, Rutina).
% Selecciona ejercicios válidos
% Distribuye grupos musculares
% Respeta recuperación
% Mantiene balance push/pull
```

### Validación Profunda
```prolog
?- validar_rutina_completa(user1, Rutina, Resultado).
% Verifica recuperación
% Controla volumen
% Valida frecuencia
% Detecta desbalances
```

### Explicaciones
```prolog
?- explicacion_completa(user1, Division, Rutina, Explicacion).
% "Se seleccionó Full Body porque tienes 3 días disponibles..."
% "Press Banca se eligió porque es intermedio y...
```

### Recomendaciones
```prolog
?- generar_recomendaciones(user1, Rutina, Recs).
% "Volumen bajo: considera agregar más sets"
% "Desbalance: aumenta ejercicios de tirón"
```

---

## 🔄 Flujo de Trabajo Típico

```
Usuario
   ↓
generar_rutina_completa(user1)
   ↓
┌─────────────────────────────────────┐
│ PASO 1: Seleccionar División         │
│ seleccionar_division/2              │
└─────────────────────────────────────┘
   ↓
┌─────────────────────────────────────┐
│ PASO 2: Generar Rutina              │
│ generar_rutina_semanal/3            │
└─────────────────────────────────────┘
   ↓
┌─────────────────────────────────────┐
│ PASO 3: Validar                     │
│ validaciones_individuales/3         │
└─────────────────────────────────────┘
   ↓
┌─────────────────────────────────────┐
│ PASO 4: Recomendaciones             │
│ generar_recomendaciones/3           │
└─────────────────────────────────────┘
   ↓
Rutina Completa + Validación + Recomendaciones
```

---

## 💡 Casos de Uso

### Caso 1: Principiante
```prolog
% Juan: principiante, 3 días, objetivo hipertrofia
?- generar_rutina_completa(user1).

% Sistema:
% - Selecciona Full Body
% - Elige ejercicios principiante
% - Validates recuperación
% - Sugiere aumentar volumen lentamente
```

### Caso 2: Intermedio
```prolog
% María: intermedio, 4 días, objetivo fuerza
?- generar_rutina_completa(user2).

% Sistema:
% - Selecciona Torso-Pierna
% - Elige ejercicios con barra
% - Valida volumen más alto
% - Recomienda progresión de carga
```

### Caso 3: Avanzado
```prolog
% Carlos: avanzado, 6 días, objetivo resistencia
?- generar_rutina_completa(user3).

% Sistema:
% - Selecciona Weider
% - Elige ejercicios complejos
% - Valida recuperación detallada
% - Recomienda variación de estímulo
```

---

## 🧪 Tests Disponibles

```prolog
?- ejecutar_tests.

Test 1: test_ejercicios_validos
        ✓ Todos los ejercicios son válidos

Test 2: test_usuarios_validos
        ✓ Todos los usuarios son válidos

Test 3: test_divisiones_validas
        ✓ Todas las divisiones son válidas
```

---

## 📚 Consultas Rápidas

### Información del Usuario
```prolog
?- usuario(user1, Nombre, Nivel, Objetivo, _, _, _).
```

### Ejercicios por Grupo
```prolog
?- findall(N, ejercicio(_, N, pecho, _, _, _), Ejercicios).
```

### Volumen Total
```prolog
?- volumen_total_semana(Rutina, Total).
```

### Balance Push/Pull
```prolog
?- contar_empujes(Rutina, E), contar_tirones(Rutina, T).
```

### Validaciones
```prolog
?- rutina_valida(user1, Rutina).
```

### Sugerencias
```prolog
?- generar_recomendaciones(user1, Rutina, Recs).
```

---

## 🔧 Extensiones Futuras

### Corto Plazo
- [ ] Más ejercicios a la BD
- [ ] Nuevas divisiones de rutina
- [ ] Más usuarios de ejemplo

### Mediano Plazo
- [ ] Integración completa con Spring Boot
- [ ] Persistencia en Base de Datos SQL
- [ ] API REST funcional

### Largo Plazo
- [ ] Interfaz web React
- [ ] Mobile app
- [ ] Machine Learning para personalización
- [ ] Wearables integration

---

## 📞 Soporte

### Documentación
- `README_SISTEMA_EXPERTO.md` - Referencia técnica
- `MIGRATION_GUIDE.md` - Guía de migración
- Este archivo - Índice general

### Ejemplos
- `examples.pl` - Consultas de demostración
- `knowledge_base.pl` - Datos de ejemplo

### Ayuda
1. Revisa la documentación pertinente
2. Consulta los ejemplos en `examples.pl`
3. Ejecuta los tests con `ejecutar_tests`

---

## 📊 Versiones

| Versión | Fecha | Cambios |
|---------|--------|---------|
| 0.1 | - | Sistema básico de ejercicios |
| 1.0 | Junio 2, 2024 | Sistema experto completo ✓ |

---

## ✅ Checklist Final

- [x] Base de conocimiento completa
- [x] Lógica de inferencia implementada
- [x] Validación profunda funcional
- [x] Ejemplos de uso documentados
- [x] Integración REST API
- [x] Tests automatizados
- [x] Documentación completa
- [x] Guía de migración
- [x] Índice del proyecto

---

**Sistema Experto v1.0** - Completamente Operativo ✓

Para comenzar: `?- generar_rutina_completa(user1).`
