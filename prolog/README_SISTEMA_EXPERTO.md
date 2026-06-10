# Sistema Experto de Generación de Rutinas de Gimnasio - Prolog

## 📋 Descripción General

Sistema experto basado en Prolog para generación inteligente, validación y explicación de rutinas de entrenamiento. El sistema incorpora conocimiento real de entrenamiento, razonamiento experto, validación automática y capacidad de explicación de decisiones.

## 🏗️ Arquitectura Modular

El sistema está dividido en módulos independientes para mantenibilidad y escalabilidad:

### 1. **knowledge_base.pl** - Base de Conocimiento
Contiene todos los hechos del dominio:
- **Usuarios**: con nivel, objetivo, disponibilidad y preferencias
- **Objetivos**: parámetros de entrenamiento (repeticiones, series, descanso, intensidad)
- **Niveles**: principiante, intermedio, avanzado con compatibilidades
- **Grupos Musculares**: 12 grupos con clasificación (empuje/tirón/piernas)
- **Biblioteca de Ejercicios**: 30+ ejercicios con propiedades detalladas
  - ID único
  - Nombre
  - Grupo muscular principal
  - Tipo (compuesto/aislado)
  - Patrón de movimiento (empuje/tirón)
  - Dificultad mínima
- **Músculos Secundarios**: define qué músculos se trabajan indirectamente
- **Compatibilidades**: grupos que trabajan bien juntos
- **Incompatibilidades**: combinaciones no recomendadas
- **Divisiones de Rutina**: Full Body, Torso-Pierna, Push/Pull/Legs, Weider
- **Distribuciones**: asignación de grupos por día para cada división
- **Frecuencia Semanal**: veces por semana según nivel
- **Volumen Máximo**: series permitidas por semana según experiencia
- **Recuperación**: horas mínimas entre entrenamientos del mismo grupo
- **Historial**: rutinas realizadas y ejercicios completados

### 2. **rules.pl** - Reglas de Inferencia y Lógica Experta
Implementa la inteligencia del sistema:
- **Selección de División**: elige automáticamente según disponibilidad
- **Validación de Ejercicios**: verifica que usuario puede realizar cada movimiento
- **Generación de Rutina**: crea plan semanal completo
- **Parámetros de Entrenamiento**: adapta series, repeticiones, descanso según objetivo
- **Análisis de Balance**: verifica equilibrio push/pull
- **Detección de Fatiga**: identifica sobrecarga muscular
- **Validación de Recuperación**: asegura descanso adecuado entre sesiones
- **Cálculo de Volumen**: suma total de series para verificar límites
- **Sugerencias de Mejora**: recomienda cambios basado en análisis

### 3. **validation.pl** - Validación Profunda y Explicaciones
Sistema avanzado de validación:
- **Validación Completa**: ejecuta todas las restricciones
- **Validaciones Específicas**:
  - Recuperación muscular
  - Volumen total
  - Frecuencia muscular
  - Balance push/pull
  - Grupos musculares seleccionados
- **Detección de Problemas**:
  - Sobreentrenamiento
  - Desbalances musculares
  - Fatiga acumulada
- **Explicaciones Detalladas**:
  - Por qué se eligió cada división
  - Por qué se seleccionaron ejercicios
  - Consideraciones especiales
- **Recomendaciones Personalizadas**: basadas en análisis del sistema
- **Reportes Completos**: estadísticas y análisis de la rutina

### 4. **examples.pl** - Ejemplos y Casos de Uso
Interfaz de usuario y demostraciones:
- **Función Principal**: `generar_rutina_completa/1`
- **Presentación Amigable**: formatting de resultados
- **Comparación de Rutinas**: análisis lado a lado
- **Estadísticas del Sistema**: métricas generales
- **Tests Automatizados**: validación de integridad
- **Menú Interactivo**: navegación del usuario

## 🎯 Características Principales

### 1. Razonamiento Experto
- Toma decisiones basadas en reglas de entrenamiento reales
- Infiere información no explícita (p.ej., músculos secundarios)
- Adapta recomendaciones al contexto del usuario

### 2. Validación Automática
- Verifica recuperación muscular
- Controla volumen total
- Valida frecuencia por grupo
- Detecta desbalances push/pull
- Previene grupos consecutivos

### 3. Explicaciones
Toda decisión importante puede explicarse:
- "Se seleccionó esta división porque tienes 4 días disponibles"
- "Este ejercicio requiere nivel intermedio"
- "Se evitó este grupo hoy porque ya trabajó indirectamente ayer"

### 4. Adaptabilidad
- Diferentes divisiones según disponibilidad
- Parámetros distintos por objetivo (fuerza, hipertrofia, resistencia)
- Ejercicios apropiados por nivel de experiencia
- Prioridades musculares personalizadas

### 5. Análisis Profundo
- Estadísticas de push/pull
- Cálculo de volumen semanal
- Distribución de frecuencia muscular
- Identificación de problemas potenciales

## 📊 Base de Datos de Ejemplo

### Usuarios
```prolog
usuario(user1, 'Juan', principiante, hipertrofia, 3, [pecho, espalda, piernas], pecho).
usuario(user2, 'María', intermedio, fuerza, 4, [pecho, espalda, hombros, piernas], espalda).
usuario(user3, 'Carlos', avanzado, resistencia, 6, [...], piernas).
```

### Ejercicios
```prolog
ejercicio(ex_001, 'Press Banca', pecho, compuesto, empuje, intermedio).
ejercicio(ex_005, 'Aperturas Máquina', pecho, aislado, empuje, principiante).
ejercicio(ex_101, 'Peso Muerto', espalda, compuesto, tiron, avanzado).
```

### Objetivos
```prolog
objetivo(hipertrofia, 8, 12, 3, 60, 'media-alta').
objetivo(fuerza, 3, 6, 5, 180, 'muy-alta').
objetivo(resistencia, 15, 20, 2, 30, 'media').
```

## 🔍 Consultas Principales

### 1. Generar Rutina Completa
```prolog
?- generar_rutina_completa(user1).
```
Ejecuta el flujo completo: división → generación → validación → recomendaciones

### 2. Seleccionar División
```prolog
?- seleccionar_division(user1, Division).
Division = 'Full Body'.
```

### 3. Generar Rutina Semanal
```prolog
?- generar_rutina_semanal(user1, 'Full Body', Rutina).
Rutina = [dia(1, [...]), dia(2, [...]), dia(3, [...])].
```

### 4. Validar Rutina
```prolog
?- rutina_valida(user1, Rutina).
true.
```

### 5. Obtener Recomendaciones
```prolog
?- generar_recomendaciones(user1, Rutina, Recs).
Recs = ['Volumen bajo: considera agregar más sets', ...].
```

### 6. Explicación Completa
```prolog
?- explicacion_completa(user1, 'Full Body', Rutina, Expl).
% Retorna explicación detallada de todas las decisiones
```

### 7. Reporte Completo
```prolog
?- generar_reporte_rutina(user1, Rutina, Reporte).
% Retorna estadísticas, validaciones, recomendaciones
```

## 🧪 Tests y Validación

El sistema incluye validación automática:

```prolog
?- ejecutar_tests.
```

Tests incluidos:
- Validación de ejercicios
- Validación de usuarios
- Validación de divisiones
- Integridad referencial

## 📈 Estadísticas

```prolog
?- estadisticas_sistema.
?- ejercicios_por_grupo.
?- usuarios_por_nivel.
```

## 🚀 Extensión Futura

El sistema está diseñado para ser extensible:

### Fácilmente Añadible:
1. Más ejercicios a `knowledge_base.pl`
2. Nuevos usuarios
3. Nuevas divisiones de rutina
4. Nuevas reglas de validación en `rules.pl`
5. Nuevos criterios de recomendación

### Integración Potencial:
- API REST (Java/Spring Boot)
- Base de datos SQL
- Interfaz web (React/Vue)
- Mobile app
- Machine Learning para personalización

## 📋 Estructura de una Rutina Generada

```prolog
[
  dia(1, [
    grupo_ejercicios(pecho, [
      ejercicio_info('ex_001', 'Press Banca', 3, 10, 60),
      ejercicio_info('ex_005', 'Aperturas', 3, 12, 60)
    ]),
    grupo_ejercicios(biceps, [
      ejercicio_info('ex_301', 'Curl Barra', 3, 10, 60)
    ])
  ]),
  dia(2, [...]),
  dia(3, [...])
]
```

## 🎓 Conceptos Clave Implementados

1. **Predicados Dinámicos**: consultas sobre hechos y reglas
2. **Backtracking**: búsqueda de soluciones alternativas
3. **Unificación**: matching de patrones complejos
4. **Lógica de Primer Orden**: razonamiento con variables y cuantificadores
5. **Corte (!)**: control de búsqueda
6. **Negación**: uso de `\+` para exclusiones

## 💡 Ejemplo de Razonamiento

Cuando se llama `generar_rutina_semanal(user1, Division, Rutina)`:

1. El sistema obtiene el nivel del usuario
2. Encuentra ejercicios válidos para ese nivel
3. Selecciona ejercicios compuestos primero
4. Verifica compatibilidades entre grupos
5. Asegura distribución adecuada
6. Respeta tiempos de recuperación
7. Mantiene balance push/pull
8. Verifica volumen total
9. Retorna la rutina O falla si hay conflicto

## 🔧 Uso Práctico

### Para Principiantes:
```prolog
?- usuario(user1, Nombre, Nivel, _, _, _, _), 
   seleccionar_division(user1, Div),
   generar_rutina_completa(user1).
```

### Para Análisis:
```prolog
?- volumen_total_semana(Rutina, Vol),
   contar_empujes(Rutina, Emp),
   contar_tirones(Rutina, Tir).
```

### Para Validación:
```prolog
?- validar_rutina_completa(user1, Rutina, Resultado).
```

## 📚 Referencias Prácticas

- **Hipertrofia**: 8-12 reps, 3 series, descanso 60s
- **Fuerza**: 3-6 reps, 5 series, descanso 180s
- **Resistencia**: 15-20 reps, 2 series, descanso 30s
- **Recuperación**: 48-72 horas por grupo según tipo
- **Volumen Semanal**: 150-250 series según nivel

## 🎯 Próximos Pasos

1. Conectar con API REST de Spring Boot
2. Persistencia en base de datos
3. Interfaz web React
4. Historial y seguimiento de progreso
5. Recomendaciones basadas en desempeño
6. Integración con dispositivos wearables

---

**Versión**: 1.0  
**Última actualización**: Junio 2, 2024  
**Estado**: Sistema activo y funcional
