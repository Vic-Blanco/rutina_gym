# GUÍA DE MIGRACIÓN - Sistema Experto Prolog

## 📋 Resumen Ejecutivo

El proyecto ha sido transformado de un simple almacén de ejercicios a un **sistema experto** completo con capacidades de razonamiento, validación y explicación.

## 🔄 Cambios Principales

### ANTES: Estructura Simple
```
ejercicios.pl (1 archivo monolítico)
├── Hechos de ejercicios por género/nivel
├── Planes de distribución semanal
├── Predicados básicos de validación
└── Sin razonamiento inteligente
```

### AHORA: Arquitectura Modular
```
Sistema Experto (5 módulos especializados)
├── knowledge_base.pl    (Hechos y datos del dominio)
├── rules.pl             (Lógica de inferencia)
├── validation.pl        (Validación profunda)
├── examples.pl          (Interfaz y ejemplos)
├── integration.pl       (API REST)
└── README_SISTEMA_EXPERTO.md (Documentación)
```

## 🎯 Mejoras Implementadas

### 1. **Base de Conocimiento Enriquecida**

| Aspecto | Antes | Ahora |
|--------|--------|--------|
| Ejercicios | 40 hechos simples | 30+ con propiedades completas |
| Información por ejercicio | Nombre, grupo, género | ID, tipo, patrón, dificultad, músculos secundarios |
| Usuarios | No definidos | 3 usuarios de ejemplo con todas las propiedades |
| Objetivos | No explícitos | 4 objetivos con parámetros detallados |
| Niveles | 3 básicos | 3 con compatibilidades definidas |

### 2. **Lógica de Inferencia**

#### ANTES:
- Búsqueda de ejercicios manual
- Sin selección automática de división
- Sin validación

#### AHORA:
- ✓ Selección automática de división según disponibilidad
- ✓ Validación inteligente de ejercicios por nivel
- ✓ Generación automática de rutinas
- ✓ Parámetros adaptativos según objetivo
- ✓ Análisis de balance muscular
- ✓ Detección de fatiga

### 3. **Validación Profunda**

#### ANTES:
```prolog
rutina_valida(Nivel, Genero) :- 
    nivel(Nivel), 
    genero(Genero).
```

#### AHORA:
```prolog
validaciones_individuales(UsuarioID, Rutina, [
    validacion_recuperacion(Result),
    validacion_volumen(Result),
    validacion_frecuencia(Result),
    validacion_balance(Result),
    validacion_grupos(Result)
])
```

### 4. **Capacidades de Explicación**

| Característica | Disponibilidad |
|----------------|----------------|
| Por qué se eligió esta división | ✓ |
| Por qué se rechazó un ejercicio | ✓ |
| Por qué se seleccionó este ejercicio | ✓ |
| Consideraciones especiales | ✓ |
| Recomendaciones personalizadas | ✓ |
| Reportes completos | ✓ |

## 📊 Comparación de Funcionalidades

### Capacidad de Generación

```prolog
% ANTES: No existe
generar_rutina_completa(user1).
% ERROR: No existe predicado

% AHORA: Completo
?- generar_rutina_completa(user1).
% Genera: división → rutina → validación → recomendaciones
```

### Validación

```prolog
% ANTES: Validación superficial
?- rutina_valida(inicial, masculino).
% true / false

% AHORA: Validación profunda
?- validar_rutina_completa(user1, Rutina, Resultado).
% Retorna: validacion_ok([...]) o validacion_fallida([...])
```

### Análisis

```prolog
% ANTES: No existe
push_pull_balanceado(Rutina).
% ERROR: No existe

% AHORA: Análisis automático
?- contar_empujes(Rutina, Empujes),
   contar_tirones(Rutina, Tirones).
% Empujes = 15, Tirones = 12
```

## 🚀 Cómo Migrar Tu Código

### Paso 1: Cargar la Nueva Base de Conocimiento

**ANTES:**
```prolog
?- consult('ejercicios.pl').
```

**AHORA:**
```prolog
?- consult('knowledge_base.pl').
```

### Paso 2: Ejecutar Predicados

**ANTES - Si queríamos obtener ejercicios:**
```prolog
?- ejercicios_grupo(pecho, inicial, masculino, Ejercicios).
% Ejercicios = [...]
```

**AHORA - Generar rutina completa:**
```prolog
?- generar_rutina_completa(user1).
% Ejecuta flujo completo con validación
```

### Paso 3: Análisis y Validación

**ANTES:**
```prolog
?- plan_semanal(1, 4, Grupos).
% Grupos = [...]
```

**AHORA:**
```prolog
?- generar_rutina_semanal(user1, 'Torso-Pierna', Rutina),
   rutina_valida(user1, Rutina),
   generar_recomendaciones(user1, Rutina, Recs).
% Rutina completa + validación + recomendaciones
```

## 🔍 Mapeo de Funcionalidades

### Consultas Antiguas → Nuevas

| Operación | ANTES | AHORA |
|-----------|--------|--------|
| Listar ejercicios por grupo | `ejercicios_grupo/4` | `generar_ejercicios_grupo/3` |
| Sugerir días | `dias_sugeridos/2` | `seleccionar_division/2` |
| Validar rutina básica | `rutina_valida/2` | `rutina_valida/2` (mejorado) |
| Generar rutina | ❌ NO EXISTE | `generar_rutina_semanal/3` ✓ |
| Explicar decisiones | ❌ NO EXISTE | `explicacion_completa/4` ✓ |
| Obtener recomendaciones | ❌ NO EXISTE | `generar_recomendaciones/3` ✓ |
| Validación profunda | ❌ NO EXISTE | `validar_rutina_completa/3` ✓ |
| Generar reporte | ❌ NO EXISTE | `generar_reporte_rutina/3` ✓ |

## 📈 Ejemplos de Migración

### Ejemplo 1: Obtener Ejercicios

```prolog
% ANTES
?- findall(E, ejercicio_recomendado(E, pecho, intermedio, masculino), Ejes).

% AHORA - Más inteligente
?- usuario(user2, _, Nivel, _, _, _, _),
   generar_ejercicios_grupo(user2, pecho, Ejes).
```

### Ejemplo 2: Validar Rutina

```prolog
% ANTES - Solo verifica tipo
?- rutina_valida(intermedio, masculino).
true.

% AHORA - Validación completa
?- generar_rutina_semanal(user2, Division, Rutina),
   validar_rutina_completa(user2, Rutina, Resultado).
Resultado = validacion_ok([...])
```

### Ejemplo 3: Planeación Semanal

```prolog
% ANTES - Solo lista grupos
?- plan_semanal(1, 4, Grupos).
Grupos = [pecho, triceps]

% AHORA - Genera estructura completa
?- generar_rutina_semanal(user2, 'Torso-Pierna', Rutina).
Rutina = [
  dia(1, [grupo_ejercicios(pecho, [...]), ...]),
  dia(2, [grupo_ejercicios(piernas, [...]), ...]),
  ...
]
```

## 🔧 Compatibilidad Hacia Atrás

El nuevo sistema **mantiene compatibilidad** con:

✓ Nombres de grupos musculares  
✓ Niveles de dificultad  
✓ Tipos de ejercicios  
✓ Géneros  

```prolog
% Estos predicados siguen funcionando:
?- grupo_muscular(pecho).
true.

?- nivel(intermedio).
true.

?- genero(masculino).
true.
```

## ⚠️ Cambios Requeridos

### En la Base de Datos

Si tienen ejercicios adicionales, debe agregarlos en:
```
knowledge_base.pl → sección "BIBLIOTECA DE EJERCICIOS"
```

Formato esperado:
```prolog
ejercicio(ex_NNN, 'Nombre Ejercicio', grupo, tipo, patron, dificultad).
```

### En la Lógica

Los predicados antiguos específicos pueden reemplazarse por:
```prolog
% Antiguo
ejercicios_grupo(Grupo, Nivel, Genero, Ejercicios).

% Nuevo (mejor)
generar_ejercicios_grupo(UsuarioID, Grupo, Ejercicios).
```

## 🎓 Nuevos Conceptos

### 1. **Usuario Completo**
```prolog
usuario(user1, 'Juan', principiante, hipertrofia, 3, [pecho, espalda, piernas], pecho).
```

### 2. **Objetivo Detallado**
```prolog
objetivo(hipertrofia, 8, 12, 3, 60, 'media-alta').
% Reps: 8-12, Series: 3, Descanso: 60min, Intensidad: media-alta
```

### 3. **Ejercicio Completo**
```prolog
ejercicio(ex_001, 'Press Banca', pecho, compuesto, empuje, intermedio).
musculo_secundario(ex_001, triceps, media).
musculo_secundario(ex_001, hombros, baja).
```

### 4. **Divisiones de Rutina**
```prolog
division_rutina('Full Body', [2, 3], 'Todos los grupos en cada sesión').
distribucion('Full Body', 1, [pecho, cuadriceps, espalda]).
```

### 5. **Validaciones Múltiples**
```prolog
validacion_recuperacion(ok|fallo).
validacion_volumen(ok|fallo).
validacion_frecuencia(ok|fallo).
validacion_balance(ok|fallo).
validacion_grupos(ok|fallo).
```

## 🔌 Integración con Spring Boot

**NUEVO**: El sistema incluye integración REST API

```prolog
% En integration.pl
?- api_generate_routine(user1, ResponseJSON).
% Retorna rutina en formato JSON
```

Ver `integration.pl` para detalles.

## 📚 Referencias

### Archivos Principales

- `knowledge_base.pl` - Base de datos del dominio
- `rules.pl` - Lógica de inferencia
- `validation.pl` - Validación y análisis
- `examples.pl` - Interfaz y ejemplos
- `integration.pl` - API REST

### Documentación

- `README_SISTEMA_EXPERTO.md` - Documentación completa
- Este archivo - Guía de migración

## ✅ Checklist de Migración

- [ ] Leer `README_SISTEMA_EXPERTO.md`
- [ ] Ejecutar `consult('knowledge_base.pl')`
- [ ] Probar `generar_rutina_completa(user1)`
- [ ] Revisar ejemplos en `examples.pl`
- [ ] Agregar datos personalizados a `knowledge_base.pl`
- [ ] Probar validaciones con `validar_rutina_completa/3`
- [ ] Integrar con Spring Boot si es necesario

## 🆘 Troubleshooting

### Error: "Undefined procedure: generar_rutina_semanal/3"
**Solución**: Asegúrate de haber cargado `knowledge_base.pl` y `rules.pl`

### Error: "Unknown user: user1"
**Solución**: Agrega el usuario a `knowledge_base.pl` o usa usuarios existentes

### Rutina no valida
**Solución**: Usa `generar_recomendaciones/3` para ver qué está mal

## 📞 Soporte

Para preguntas específicas:
1. Revisa `examples.pl`
2. Consulta `README_SISTEMA_EXPERTO.md`
3. Revisa comentarios en los archivos `.pl`

---

**Versión**: 1.0  
**Fecha**: Junio 2, 2024  
**Estado**: Migración Completa ✓
