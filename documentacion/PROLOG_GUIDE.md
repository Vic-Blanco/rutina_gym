# Guía Prolog para Rutina Gym

## Estructura de la Base de Conocimiento

El archivo `prolog/ejercicios.pl` contiene todas las reglas lógicas para generar rutinas personalizadas.

### 1. Definiciones Básicas

#### Grupos Musculares
```prolog
grupo_muscular(pecho).
grupo_muscular(espalda).
grupo_muscular(hombros).
% ... más grupos
```

#### Niveles
```prolog
nivel(inicial).
nivel(intermedio).
nivel(avanzado).
```

#### Géneros
```prolog
genero(masculino).
genero(femenino).
genero(otro).
```

### 2. Reglas de Ejercicios

#### Formato
```prolog
ejercicio_recomendado('Nombre Ejercicio', grupo_muscular, nivel, genero).
```

#### Ejemplos
```prolog
% PECHO - INICIAL - FEMENINO
ejercicio_recomendado('Flexiones Pared', pecho, inicial, femenino).

% PECHO - INTERMEDIO - MASCULINO
ejercicio_recomendado('Press Banca Barra', pecho, intermedio, masculino).

% ESPALDA - AVANZADO
ejercicio_recomendado('Dominadas Lastre', espalda, avanzado, masculino).
```

### 3. Distribución de Días (Plan Semanal)

```prolog
plan_semanal(DíaNumero, TotalDías, ListaGrupos).
```

#### Ejemplos
```prolog
% Plan de 3 días
plan_semanal(1, 3, [pecho, triceps]).
plan_semanal(2, 3, [espalda, biceps]).
plan_semanal(3, 3, [hombros, piernas, core]).

% Plan de 5 días (PPL - Push, Pull, Legs)
plan_semanal(1, 5, [pecho]).
plan_semanal(2, 5, [espalda]).
plan_semanal(3, 5, [piernas]).
plan_semanal(4, 5, [hombros]).
plan_semanal(5, 5, [brazos, core]).
```

### 4. Reglas Complejas

```prolog
% Una rutina es válida si el nivel y género son válidos
rutina_valida(Nivel, Genero) :-
    nivel(Nivel),
    genero(Genero).

% Recuperación adecuada según días
recuperacion_adecuada(Dias) :-
    Dias >= 3,
    Dias =< 7.

% Intensidad recomendada
intensidad_recomendada(1, alto) :- !.
intensidad_recomendada(2, alto) :- !.
intensidad_recomendada(X, bajo) :- X > 3.
```

## Consultas Importantes

### Obtener Ejercicios para un Grupo

```prolog
?- ejercicio_recomendado(E, pecho, inicial, femenino).
```
Respuesta: Lista de ejercicios recomendados

### Validar Rutina

```prolog
?- rutina_valida(intermedio, masculino).
```
Respuesta: true/false

### Obtener Grupos para un Día

```prolog
?- plan_semanal(1, 4, Grupos).
Grupos = [pecho, triceps]
```

## Integración con Java

### Desde PrologService.java

```java
// Consultar Prolog
Query query = new Query(
    "ejercicio_recomendado(Ejercicio, 'pecho', 'inicial', 'masculino')"
);

// Obtener resultados
while (query.hasMoreSolutions()) {
    Map<String, Term> solucion = query.nextSolution();
    String ejercicio = solucion.get("Ejercicio").toString();
}
```

## Personalizaciones Comunes

### Agregar nuevo ejercicio

```prolog
% Agregar al archivo ejercicios.pl
ejercicio_recomendado('Mi Nuevo Ejercicio', pecho, intermedio, masculino).
```

### Cambiar distribución de días

```prolog
% Modificar plan_semanal existente
plan_semanal(1, 4, [pecho, espalda]).  % Cambiar de [pecho, triceps]
```

### Agregar nivel de dificultad

```prolog
% Añadir nuevos ejercicios para el nuevo nivel
ejercicio_recomendado('Ejercicio Elite', grupo, elite, genero).

% Incluir en reglas
nivel(elite).
```

## Testing en Prolog

Puedes probar tus reglas en la terminal de SWI-Prolog:

```bash
# Abrir Prolog
swipl

% Cargar el archivo
?- consult('prolog/ejercicios.pl').

% Realizar consultas
?- ejercicio_recomendado(X, pecho, inicial, femenino).
?- plan_semanal(1, 4, G), write(G).
?- rutina_valida(avanzado, masculino).
?- findall(E, ejercicio_recomendado(E, pecho, _, _), Ejercicios).
```

## Sintaxis Prolog Importante

| Símbolo | Significado |
|---------|------------|
| `?-` | Consulta |
| `:-` | Implicación (si) |
| `,` | Y (AND) |
| `;` | O (OR) |
| `!` | Corte (cut) |
| `_` | Variable anónima |
| `[Head\|Tail]` | Deconstrucción de lista |
| `findall/3` | Encuentra todas las soluciones |
| `true` | Verdadero |
| `false`/`fail` | Falso |

## Ejemplos Prácticos

### Consulta: Todos los ejercicios de espalda para nivel avanzado

```prolog
?- ejercicio_recomendado(X, espalda, avanzado, _).
```

### Regla: Ejercicios válidos para un usuario específico

```prolog
ejercicios_usuario(Usuario, Nivel, Genero, Ejercicios) :-
    rutina_valida(Nivel, Genero),
    findall(E, ejercicio_recomendado(E, _, Nivel, Genero), Ejercicios).
```

### Uso desde Java:

```java
Query query = new Query("ejercicios_usuario(user1, inicial, femenino, Ejercicios)");
// Retorna: Ejercicios = ['Flexiones Pared', 'Press Máquina', ...]
```

## Performance y Optimización

1. **Usa variables instanciadas** cuando sea posible
2. **Evita backtracking innecesario** con cut (`!`)
3. **Usa findall** para obtener múltiples soluciones
4. **Indexa predicados frecuentes**

## Debugging

```prolog
% Modo trace
?- trace.
?- ejercicio_recomendado(X, pecho, inicial, femenino).

% Spy (observar predicado específico)
?- spy(ejercicio_recomendado/4).

% Ver árbol de prueba
?- notrace.
```

---

**¡Consulta regularmente la base de conocimiento de Prolog para entender cómo se generan las rutinas!**
