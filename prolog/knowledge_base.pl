% =====================================================
% BASE DE CONOCIMIENTO - SISTEMA EXPERTO DE RUTINAS
% =====================================================
% Sistema experto para generación y validación de rutinas de gimnasio
% Implementa razonamiento basado en reglas, inferencia y explicaciones

% =====================================================
% 1. DEFINICIÓN DE USUARIOS
% =====================================================
% usuario(ID, Nombre, Nivel, Objetivo, DiasDisponibles, GruposMusculares, GrupoPrioritario)

usuario(user1, 'Juan', principiante, hipertrofia, 3, [pecho, espalda, piernas], pecho).
usuario(user2, 'María', intermedio, fuerza, 4, [pecho, espalda, hombros, piernas], espalda).
usuario(user3, 'Carlos', avanzado, resistencia, 6, [pecho, espalda, hombros, biceps, triceps, piernas], piernas).

% =====================================================
% 2. DEFINICIÓN DE OBJETIVOS DE ENTRENAMIENTO
% =====================================================
% objetivo(Objetivo, RangoRepMin, RangoRepMax, SeriesRecomendadas, DescansoMinutos, Intensidad)

objetivo(hipertrofia, 8, 12, 3, 60, 'media-alta').
objetivo(fuerza, 3, 6, 5, 180, 'muy-alta').
objetivo(resistencia, 15, 20, 2, 30, 'media').
objetivo(acondicionamiento, 10, 15, 3, 45, 'media').

% =====================================================
% 3. NIVELES DE EXPERIENCIA Y COMPATIBILIDAD
% =====================================================
% nivel(Nivel, Descripcion)

nivel(principiante, 'Menos de 6 meses de entrenamiento').
nivel(intermedio, 'Entre 6 meses y 2 años de entrenamiento').
nivel(avanzado, 'Más de 2 años de entrenamiento').

% compatibilidad_ejercicio(Ejercicio, NivelMinimo)
% Especifica el nivel mínimo requerido para realizar un ejercicio

compatibilidad_ejercicio('Flexiones Pared', principiante).
compatibilidad_ejercicio('Press Banca', intermedio).
compatibilidad_ejercicio('Peso Muerto', intermedio).
compatibilidad_ejercicio('Press Banca Larguero', avanzado).
compatibilidad_ejercicio('Sentadilla con Barra', avanzado).

% =====================================================
% 4. DEFINICIÓN DE GRUPOS MUSCULARES
% =====================================================
% grupo_muscular(Nombre, Clasificacion, EsSecundario)

grupo_muscular(pecho, empuje, principal).
grupo_muscular(espalda, tiron, principal).
grupo_muscular(hombros, empuje, principal).
grupo_muscular(biceps, tiron, principal).
grupo_muscular(triceps, empuje, principal).
grupo_muscular(antebrazo, tiron, secundario).
grupo_muscular(cuadriceps, piernas, principal).
grupo_muscular(isquiotibial, piernas, principal).
grupo_muscular(gluteos, piernas, principal).
grupo_muscular(pantorrilla, piernas, secundario).
grupo_muscular(core, empuje, secundario).
grupo_muscular(cardio, general, complementario).

% =====================================================
% 5. BIBLIOTECA DE EJERCICIOS
% =====================================================
% ejercicio(ID, Nombre, GrupoMuscularPrincipal, Tipo, Patron, DificultadMinima)
% Tipo: compuesto o aislado
% Patron: empuje o tiron
% DificultadMinima: principiante, intermedio, avanzado

% PECHO - COMPUESTOS
ejercicio(ex_001, 'Press Banca', pecho, compuesto, empuje, intermedio).
ejercicio(ex_002, 'Press Inclinado', pecho, compuesto, empuje, intermedio).
ejercicio(ex_003, 'Flexiones', pecho, compuesto, empuje, principiante).
ejercicio(ex_004, 'Press Mancuerna Plano', pecho, compuesto, empuje, intermedio).

% PECHO - AISLADOS
ejercicio(ex_005, 'Aperturas Máquina', pecho, aislado, empuje, principiante).
ejercicio(ex_006, 'Aperturas Mancuerna', pecho, aislado, empuje, intermedio).
ejercicio(ex_007, 'Pec Deck', pecho, aislado, empuje, principiante).

% ESPALDA - COMPUESTOS
ejercicio(ex_101, 'Peso Muerto', espalda, compuesto, tiron, avanzado).
ejercicio(ex_102, 'Remo Barra', espalda, compuesto, tiron, intermedio).
ejercicio(ex_103, 'Jalón Frente', espalda, compuesto, tiron, principiante).
ejercicio(ex_104, 'Remo Máquina', espalda, compuesto, tiron, principiante).

% ESPALDA - AISLADOS
ejercicio(ex_105, 'Remo Unilateral', espalda, aislado, tiron, intermedio).
ejercicio(ex_106, 'Pull Over', espalda, aislado, tiron, intermedio).
ejercicio(ex_107, 'Jalón Asistido', espalda, aislado, tiron, principiante).

% HOMBROS - COMPUESTOS
ejercicio(ex_201, 'Press Militar', hombros, compuesto, empuje, intermedio).
ejercicio(ex_202, 'Press Mancuerna Sentado', hombros, compuesto, empuje, intermedio).
ejercicio(ex_203, 'Press Pike Máquina', hombros, compuesto, empuje, principiante).

% HOMBROS - AISLADOS
ejercicio(ex_204, 'Elevación Frontal', hombros, aislado, empuje, principiante).
ejercicio(ex_205, 'Elevación Lateral', hombros, aislado, empuje, principiante).
ejercicio(ex_206, 'Shrugs Mancuerna', hombros, aislado, empuje, principiante).

% BICEPS
ejercicio(ex_301, 'Curl Barra', biceps, aislado, tiron, intermedio).
ejercicio(ex_302, 'Curl Mancuerna', biceps, aislado, tiron, principiante).
ejercicio(ex_303, 'Martillo Mancuerna', biceps, aislado, tiron, principiante).
ejercicio(ex_304, 'Curl Máquina', biceps, aislado, tiron, principiante).

% TRICEPS
ejercicio(ex_401, 'Fondos', triceps, compuesto, empuje, intermedio).
ejercicio(ex_402, 'Extensión Polea', triceps, aislado, empuje, principiante).
ejercicio(ex_403, 'Extensión Mancuerna Sentado', triceps, aislado, empuje, principiante).
ejercicio(ex_404, 'Press Francés', triceps, aislado, empuje, intermedio).

% PIERNAS - COMPUESTOS
ejercicio(ex_501, 'Sentadilla Libre', cuadriceps, compuesto, empuje, avanzado).
ejercicio(ex_502, 'Sentadilla Máquina', cuadriceps, compuesto, empuje, principiante).
ejercicio(ex_503, 'Leg Press', cuadriceps, compuesto, empuje, principiante).
ejercicio(ex_504, 'Sentadilla Goblet', cuadriceps, compuesto, empuje, principiante).

% PIERNAS - AISLADOS CUADRICEPS
ejercicio(ex_505, 'Extensión Cuádriceps', cuadriceps, aislado, empuje, principiante).

% PIERNAS - ISQUIOTIBIALES Y GLÚTEOS
ejercicio(ex_601, 'Peso Muerto Rumano', isquiotibial, compuesto, tiron, intermedio).
ejercicio(ex_602, 'Curl Isquiotibial', isquiotibial, aislado, tiron, principiante).
ejercicio(ex_603, 'Hip Thrust', gluteos, compuesto, empuje, principiante).
ejercicio(ex_604, 'Sentadilla Búlgara', gluteos, compuesto, empuje, intermedio).

% PIERNAS - PANTORRILLA
ejercicio(ex_605, 'Elevación Pantorrilla', pantorrilla, aislado, empuje, principiante).

% PIERNAS - GRUPO GENERAL
ejercicio(ex_650, 'Sentadilla Goblet', piernas, compuesto, empuje, principiante).
ejercicio(ex_651, 'Peso Muerto Convencional', piernas, compuesto, tiron, intermedio).
ejercicio(ex_652, 'Leg Press Máquina', piernas, compuesto, empuje, principiante).
ejercicio(ex_653, 'Hack Squat', piernas, compuesto, empuje, intermedio).
ejercicio(ex_654, 'Smith Machine Sentadilla', piernas, compuesto, empuje, principiante).

% CORE
ejercicio(ex_701, 'Planchas', core, aislado, estatico, principiante).
ejercicio(ex_702, 'Abdominales Máquina', core, aislado, empuje, principiante).
ejercicio(ex_703, 'Crunches', core, aislado, empuje, principiante).
ejercicio(ex_704, 'Cable Crunch', core, aislado, empuje, intermedio).

% =====================================================
% 6. MÚSCULOS SECUNDARIOS POR EJERCICIO
% =====================================================
% musculo_secundario(EjercicioID, GrupoMuscularSecundario, Intensidad)
% Intensidad: alta, media, baja

musculo_secundario(ex_001, triceps, media).           % Press Banca -> Tríceps
musculo_secundario(ex_001, hombros, baja).            % Press Banca -> Hombros
musculo_secundario(ex_002, hombros, media).           % Press Inclinado -> Hombros
musculo_secundario(ex_101, biceps, media).            % Peso Muerto -> Bíceps
musculo_secundario(ex_102, biceps, media).            % Remo Barra -> Bíceps
musculo_secundario(ex_201, triceps, media).           % Press Militar -> Tríceps
musculo_secundario(ex_501, gluteos, alta).            % Sentadilla -> Glúteos
musculo_secundario(ex_601, gluteos, media).           % Peso Muerto Rumano -> Glúteos

% =====================================================
% 7. COMPATIBILIDAD ENTRE GRUPOS MUSCULARES
% =====================================================
% compatible(Grupo1, Grupo2)
% Indica que estos grupos trabajen bien juntos en una misma sesión

compatible(pecho, triceps).
compatible(triceps, pecho).
compatible(espalda, biceps).
compatible(biceps, espalda).
compatible(hombros, core).
compatible(core, hombros).
compatible(cuadriceps, pantorrilla).
compatible(pantorrilla, cuadriceps).
compatible(isquiotibial, gluteos).
compatible(gluteos, isquiotibial).

% =====================================================
% 8. INCOMPATIBILIDADES MUSCULARES
% =====================================================
% incompatible(Grupo1, Grupo2, Razon)
% Combinaciones no recomendadas

incompatible(piernas, espalda_pesada, 'Fatiga CNS elevada').
incompatible(piernas, piernas, 'Sobrecarga al mismo grupo').
incompatible(pecho, pecho, 'Sobrecarga al mismo grupo').
incompatible(espalda, espalda, 'Sobrecarga al mismo grupo').

% =====================================================
% 9. DIVISIONES DE RUTINA
% =====================================================
% division_rutina(Nombre, DiasRecomendados, Descripcion)

division_rutina('Full Body', [2, 3], 'Todos los grupos en cada sesión').
division_rutina('Torso-Pierna', [4], 'Torso/Pierna alternado').
division_rutina('Push-Pull-Legs', [5], 'Empuje/Tirón/Piernas').
division_rutina('Weider', [6], 'Cada grupo muscular en un día').

% =====================================================
% 10. DISTRIBUCIÓN DE GRUPOS MUSCULARES POR DIVISIÓN
% =====================================================
% distribucion(Division, Dia, GruposMusculares)

distribucion('Full Body', 1, [pecho, cuadriceps, espalda]).
distribucion('Full Body', 2, [hombros, isquiotibial, biceps]).
distribucion('Full Body', 3, [pecho, gluteos, triceps]).

distribucion('Torso-Pierna', 1, [pecho, espalda, hombros]).
distribucion('Torso-Pierna', 2, [cuadriceps, isquiotibial, gluteos]).
distribucion('Torso-Pierna', 3, [pecho, espalda, hombros]).
distribucion('Torso-Pierna', 4, [cuadriceps, isquiotibial, gluteos]).

distribucion('Push-Pull-Legs', 1, [pecho, hombros, triceps]).
distribucion('Push-Pull-Legs', 2, [espalda, biceps, antebrazo]).
distribucion('Push-Pull-Legs', 3, [cuadriceps, isquiotibial, gluteos]).
distribucion('Push-Pull-Legs', 4, [pecho, hombros, triceps]).
distribucion('Push-Pull-Legs', 5, [espalda, biceps, antebrazo]).

distribucion('Weider', 1, [pecho]).
distribucion('Weider', 2, [espalda]).
distribucion('Weider', 3, [hombros]).
distribucion('Weider', 4, [cuadriceps, isquiotibial]).
distribucion('Weider', 5, [biceps, triceps]).
distribucion('Weider', 6, [piernas, core]).

% =====================================================
% 11. FRECUENCIA MUSCULAR RECOMENDADA
% =====================================================
% frecuencia_semanal(Grupo, Nivel, VecesAlaSemana)
% Cuántas veces por semana entrenar un grupo según nivel

frecuencia_semanal(pecho, principiante, 1).
frecuencia_semanal(pecho, intermedio, 2).
frecuencia_semanal(pecho, avanzado, 2).

frecuencia_semanal(espalda, principiante, 1).
frecuencia_semanal(espalda, intermedio, 2).
frecuencia_semanal(espalda, avanzado, 2).

frecuencia_semanal(hombros, principiante, 1).
frecuencia_semanal(hombros, intermedio, 1).
frecuencia_semanal(hombros, avanzado, 2).

frecuencia_semanal(biceps, principiante, 1).
frecuencia_semanal(biceps, intermedio, 2).
frecuencia_semanal(biceps, avanzado, 2).

frecuencia_semanal(triceps, principiante, 1).
frecuencia_semanal(triceps, intermedio, 2).
frecuencia_semanal(triceps, avanzado, 2).

frecuencia_semanal(cuadriceps, principiante, 1).
frecuencia_semanal(cuadriceps, intermedio, 1).
frecuencia_semanal(cuadriceps, avanzado, 2).

frecuencia_semanal(isquiotibial, principiante, 1).
frecuencia_semanal(isquiotibial, intermedio, 1).
frecuencia_semanal(isquiotibial, avanzado, 1).

frecuencia_semanal(gluteos, principiante, 1).
frecuencia_semanal(gluteos, intermedio, 2).
frecuencia_semanal(gluteos, avanzado, 2).

frecuencia_semanal(core, principiante, 2).
frecuencia_semanal(core, intermedio, 3).
frecuencia_semanal(core, avanzado, 3).

% =====================================================
% 12. VOLUMEN MÁXIMO RECOMENDADO
% =====================================================
% volumen_maximo(Nivel, SeriesPorSemana)
% Límite de series semanales por nivel

volumen_maximo(principiante, 150).
volumen_maximo(intermedio, 200).
volumen_maximo(avanzado, 250).

% =====================================================
% 13. RECUPERACIÓN MUSCULAR
% =====================================================
% recuperacion(GrupoMuscular, HorasMinimas)
% Tiempo mínimo de descanso entre entrenamientos del mismo grupo

recuperacion(pecho, 48).
recuperacion(espalda, 48).
recuperacion(hombros, 48).
recuperacion(biceps, 48).
recuperacion(triceps, 48).
recuperacion(cuadriceps, 72).
recuperacion(isquiotibial, 72).
recuperacion(gluteos, 48).
recuperacion(pantorrilla, 48).
recuperacion(core, 24).
recuperacion(antebrazo, 48).

% =====================================================
% 14. HISTORIAL DE USUARIO
% =====================================================
% historial_rutina(UsuarioID, RutinaID, FechaInicio, FechaFin, Estado)
% Estado: activa, completada, cancelada

historial_rutina(user1, rutina_001, '2024-01-01', '2024-03-31', completada).
historial_rutina(user1, rutina_002, '2024-04-01', null, activa).

% =====================================================
% 15. HISTORIAL DE EJERCICIOS REALIZADOS
% =====================================================
% ejercicio_realizado(UsuarioID, EjercicioID, Fecha, Series, Reps, Peso)

ejercicio_realizado(user1, ex_001, '2024-01-10', 3, 10, 80).
ejercicio_realizado(user1, ex_001, '2024-01-15', 3, 11, 85).
ejercicio_realizado(user1, ex_001, '2024-01-20', 3, 12, 85).

% =====================================================
% 16. PATRONES DE MOVIMIENTO
% =====================================================
% patron(Nombre, Descripcion)

patron(empuje, 'Movimientos de empuje horizontal o vertical').
patron(tiron, 'Movimientos de tirón hacia el cuerpo').
patron(estatico, 'Movimientos de contracción isométrica').

% =====================================================
% 17. BALANCE PUSH/PULL
% =====================================================
% balance_push_pull(EjercicioID, Tipo)
% Categoriza ejercicios como empuje, tirón o neutral

balance_push_pull(ex_001, empuje).      % Press Banca
balance_push_pull(ex_101, tiron).       % Peso Muerto
balance_push_pull(ex_201, empuje).      % Press Militar
balance_push_pull(ex_701, neutral).     % Planchas

% =====================================================
% HECHOS ADICIONALES PARA CONTEXTO
% =====================================================

% Estado del sistema experto
estado_sistema(activo).
ultima_actualizacion('2024-06-02').
version_base_conocimiento('1.0').
