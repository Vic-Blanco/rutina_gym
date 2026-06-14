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
usuario(user3, 'Carlos', avanzado, definicion, 6, [pecho, espalda, hombros, biceps, triceps, piernas], piernas).

% =====================================================
% 2. DEFINICIÓN DE OBJETIVOS DE ENTRENAMIENTO
% =====================================================
% objetivo(Objetivo, RangoRepMin, RangoRepMax, SeriesRecomendadas, DescansoMinutos, Intensidad)

objetivo(fuerza, 8, 12, 4, 90, 'media-alta').
objetivo(hipertrofia, 5, 8, 3, 180, 'muy-alta').
objetivo(definicion, 15, 20, 4, 30, 'media').
objetivo(hibrido, 10, 15, 3, 45, 'media').
% Aliases para compatibilidad con el enum Objetivo de Java
objetivo(resistencia,      15, 20, 4, 30, 'media').        % alias de definicion
objetivo(acondicionamiento, 10, 15, 3, 45, 'media').        % alias de hibrido

% =====================================================
% 3. NIVELES DE EXPERIENCIA Y COMPATIBILIDAD
% =====================================================
% nivel(Nivel, Descripcion)

nivel(principiante, 'Menos de 6 meses de entrenamiento').
nivel(intermedio, 'Entre 6 meses y 2 años de entrenamiento').
nivel(avanzado, 'Más de 2 años de entrenamiento').



% =====================================================
% 4. DEFINICIÓN DE GRUPOS MUSCULARES
% =====================================================
% grupo_muscular(Nombre)

grupo_muscular(pecho).
grupo_muscular(espalda).
grupo_muscular(hombros).
grupo_muscular(biceps).
grupo_muscular(triceps).
grupo_muscular(cuadriceps).
grupo_muscular(isquiotibial).
grupo_muscular(gluteos).
grupo_muscular(core).

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
grupo_muscular(movilidad, general, complementario).
grupo_muscular(activacion, general, complementario).

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

% ======================================================
% BIBLIOTECA AMPLIADA DE EJERCICIOS
% ======================================================

% PECHO - COMPUESTOS ADICIONALES
ejercicio(ex_008, 'Press Declinado Barra',      pecho, compuesto, empuje, intermedio).
ejercicio(ex_009, 'Press Mancuerna Inclinado',  pecho, compuesto, empuje, intermedio).
ejercicio(ex_010, 'Press Mancuerna Declinado',  pecho, compuesto, empuje, intermedio).
ejercicio(ex_011, 'Flexiones Inclinadas',        pecho, compuesto, empuje, principiante).
ejercicio(ex_012, 'Flexiones Diamante',          pecho, compuesto, empuje, principiante).
ejercicio(ex_013, 'Flexiones Archer',            pecho, compuesto, empuje, intermedio).
ejercicio(ex_017, 'Press Máquina Pecho',         pecho, compuesto, empuje, principiante).
ejercicio(ex_018, 'Press Máquina Inclinado',     pecho, compuesto, empuje, principiante).
ejercicio(ex_019, 'Fondos Pecho',                pecho, compuesto, empuje, intermedio).

% PECHO - AISLADOS ADICIONALES
ejercicio(ex_014, 'Aperturas Cable Polea Media', pecho, aislado, empuje, principiante).
ejercicio(ex_015, 'Aperturas Cable Polea Alta',  pecho, aislado, empuje, principiante).
ejercicio(ex_016, 'Aperturas Cable Polea Baja',  pecho, aislado, empuje, principiante).
ejercicio(ex_020, 'Pull Over Mancuerna',          pecho, aislado, empuje, intermedio).
ejercicio(ex_021, 'Svend Press',                  pecho, aislado, empuje, principiante).

% ESPALDA - COMPUESTOS ADICIONALES
ejercicio(ex_108, 'Dominadas',            espalda, compuesto, tiron, avanzado).
ejercicio(ex_109, 'Dominadas Asistidas',  espalda, compuesto, tiron, principiante).
ejercicio(ex_110, 'Remo Cable Sentado',   espalda, compuesto, tiron, principiante).
ejercicio(ex_111, 'Remo Mancuerna',       espalda, compuesto, tiron, principiante).
ejercicio(ex_112, 'Remo T-Bar',           espalda, compuesto, tiron, intermedio).
ejercicio(ex_113, 'Jalón Agarre Neutro',  espalda, compuesto, tiron, principiante).
ejercicio(ex_114, 'Jalón Detrás Nuca',    espalda, compuesto, tiron, intermedio).
ejercicio(ex_117, 'Peso Muerto Sumo',     espalda, compuesto, tiron, avanzado).
ejercicio(ex_120, 'Remo Pendlay',         espalda, compuesto, tiron, intermedio).
ejercicio(ex_121, 'Jalón Polea Baja',     espalda, compuesto, tiron, principiante).

% ESPALDA - AISLADOS ADICIONALES
ejercicio(ex_115, 'Remo Cable Unilateral',  espalda, aislado, tiron,    principiante).
ejercicio(ex_116, 'Face Pull',              espalda, aislado, tiron,    principiante).
ejercicio(ex_118, 'Superman',               espalda, aislado, estatico, principiante).
ejercicio(ex_119, 'Extensiones Lumbares',   espalda, aislado, empuje,   principiante).

% HOMBROS - COMPUESTOS ADICIONALES
ejercicio(ex_207, 'Press Arnold',           hombros, compuesto, empuje, intermedio).
ejercicio(ex_208, 'Press Máquina Hombros',  hombros, compuesto, empuje, principiante).
ejercicio(ex_215, 'Press Landmine Hombro',  hombros, compuesto, empuje, intermedio).

% HOMBROS - AISLADOS ADICIONALES
ejercicio(ex_209, 'Elevación Lateral Cable',    hombros, aislado, empuje, principiante).
ejercicio(ex_210, 'Elevación Frontal Cable',    hombros, aislado, empuje, principiante).
ejercicio(ex_211, 'Shrugs Barra',               hombros, aislado, empuje, principiante).
ejercicio(ex_212, 'Face Pull Hombro Posterior', hombros, aislado, tiron,  principiante).
ejercicio(ex_213, 'Pájaros Mancuerna',          hombros, aislado, tiron,  principiante).
ejercicio(ex_214, 'Pájaros Cable',              hombros, aislado, tiron,  principiante).
ejercicio(ex_216, 'Elevación Lateral Máquina',  hombros, aislado, empuje, principiante).

% BÍCEPS - ADICIONALES
ejercicio(ex_305, 'Curl Predicador',              biceps, aislado, tiron, intermedio).
ejercicio(ex_306, 'Curl Concentración',           biceps, aislado, tiron, principiante).
ejercicio(ex_307, 'Curl Cable',                   biceps, aislado, tiron, principiante).
ejercicio(ex_308, 'Curl Inverso Barra',           biceps, aislado, tiron, intermedio).
ejercicio(ex_309, 'Curl Araña',                   biceps, aislado, tiron, intermedio).
ejercicio(ex_310, 'Curl Barra Z',                 biceps, aislado, tiron, principiante).
ejercicio(ex_311, 'Curl Inclinado Mancuerna',     biceps, aislado, tiron, principiante).
ejercicio(ex_312, 'Curl Polea Alta',              biceps, aislado, tiron, principiante).
ejercicio(ex_313, 'Curl 21s Barra',               biceps, aislado, tiron, intermedio).
ejercicio(ex_314, 'Curl Mancuerna Banco Inclinado', biceps, aislado, tiron, principiante).
ejercicio(ex_315, 'Curl Cuerda Cable',            biceps, aislado, tiron, principiante).

% TRÍCEPS - ADICIONALES
ejercicio(ex_405, 'Patada Tríceps Mancuerna',     triceps, aislado,   empuje, principiante).
ejercicio(ex_406, 'Patada Tríceps Cable',          triceps, aislado,   empuje, principiante).
ejercicio(ex_407, 'Fondos en Banco',               triceps, compuesto, empuje, principiante).
ejercicio(ex_408, 'Press Cerrado Barra',           triceps, compuesto, empuje, intermedio).
ejercicio(ex_409, 'Press Cerrado Máquina',         triceps, compuesto, empuje, principiante).
ejercicio(ex_410, 'Extensión Polea Alta Cuerda',   triceps, aislado,   empuje, principiante).
ejercicio(ex_411, 'Extensión Mancuerna Acostado',  triceps, aislado,   empuje, principiante).
ejercicio(ex_412, 'Extensión Cable sobre Cabeza',  triceps, aislado,   empuje, principiante).
ejercicio(ex_413, 'Press Francés Cable',           triceps, aislado,   empuje, intermedio).
ejercicio(ex_414, 'Flexiones Diamante Tríceps',    triceps, compuesto, empuje, principiante).
ejercicio(ex_415, 'Extensión Polea Reversa',       triceps, aislado,   empuje, principiante).

% PIERNAS - CUÁDRICEPS ADICIONALES
ejercicio(ex_506, 'Sentadilla Frontal',              cuadriceps, compuesto, empuje, avanzado).
ejercicio(ex_507, 'Zancada Mancuernas',              cuadriceps, compuesto, empuje, principiante).
ejercicio(ex_508, 'Step Up Banco',                   cuadriceps, compuesto, empuje, principiante).
ejercicio(ex_509, 'Prensa Unipodal',                 cuadriceps, compuesto, empuje, intermedio).
ejercicio(ex_510, 'Extensión Cuádriceps Unilateral', cuadriceps, aislado,   empuje, principiante).

% PIERNAS - ISQUIOTIBIALES ADICIONALES
ejercicio(ex_606, 'Peso Muerto Sumo Mancuernas', isquiotibial, compuesto, tiron, principiante).
ejercicio(ex_607, 'Curl Isquiotibial Nórdico',   isquiotibial, compuesto, tiron, avanzado).
ejercicio(ex_608, 'Buenos Días Barra',           isquiotibial, compuesto, tiron, intermedio).

% PIERNAS - GLÚTEOS ADICIONALES
ejercicio(ex_609, 'Patada Glúteo Cable',      gluteos, aislado, empuje, principiante).
ejercicio(ex_610, 'Abducción Cadera Máquina', gluteos, aislado, empuje, principiante).
ejercicio(ex_611, 'Aducción Cadera Máquina',  gluteos, aislado, tiron,  principiante).

% PIERNAS - PANTORRILLA ADICIONALES
ejercicio(ex_612, 'Elevación Pantorrilla Sentado',    pantorrilla, aislado, empuje, principiante).
ejercicio(ex_613, 'Elevación Pantorrilla Unilateral', pantorrilla, aislado, empuje, principiante).

% PIERNAS - GRUPO GENERAL ADICIONALES
ejercicio(ex_655, 'Zancada Caminando',      piernas, compuesto, empuje, principiante).
ejercicio(ex_656, 'Sentadilla Sumo',        piernas, compuesto, empuje, principiante).
ejercicio(ex_657, 'Sentadilla Pausa',       piernas, compuesto, empuje, intermedio).
ejercicio(ex_658, 'Box Squat',              piernas, compuesto, empuje, intermedio).
ejercicio(ex_659, 'Peso Muerto Trap Bar',   piernas, compuesto, tiron,  intermedio).
ejercicio(ex_660, 'Sentadilla Zercher',     piernas, compuesto, empuje, avanzado).
ejercicio(ex_661, 'Sentadilla con Salto',   piernas, compuesto, empuje, principiante).

% CORE - ADICIONALES
ejercicio(ex_705, 'Plancha Lateral',              core, aislado,   estatico, principiante).
ejercicio(ex_706, 'Rueda Abdominal',              core, compuesto, empuje,   intermedio).
ejercicio(ex_707, 'Dragon Flag',                  core, compuesto, empuje,   avanzado).
ejercicio(ex_708, 'Elevación de Piernas Colgado', core, compuesto, tiron,    intermedio).
ejercicio(ex_709, 'Plancha con Toque Hombro',     core, aislado,   estatico, intermedio).
ejercicio(ex_710, 'Rotación Rusa',                core, aislado,   empuje,   principiante).
ejercicio(ex_711, 'Dead Bug',                     core, aislado,   estatico, principiante).
ejercicio(ex_712, 'Pallof Press',                 core, aislado,   empuje,   principiante).
ejercicio(ex_713, 'Crunch Bicicleta',             core, aislado,   empuje,   principiante).
ejercicio(ex_714, 'Elevación de Piernas Tumbado', core, aislado,   empuje,   principiante).
ejercicio(ex_715, 'Hollow Hold',                  core, aislado,   estatico, intermedio).
ejercicio(ex_716, 'V-Ups',                        core, aislado,   empuje,   intermedio).

% CARDIO
ejercicio(ex_800, 'Cinta de Correr',        cardio, compuesto, general, principiante).
ejercicio(ex_801, 'Bicicleta Estática',     cardio, compuesto, general, principiante).
ejercicio(ex_802, 'Elíptica',               cardio, compuesto, general, principiante).
ejercicio(ex_803, 'Remo Ergómetro',         cardio, compuesto, general, principiante).
ejercicio(ex_804, 'Salto a la Comba',       cardio, compuesto, general, principiante).
ejercicio(ex_805, 'Burpees',                cardio, compuesto, general, principiante).
ejercicio(ex_806, 'Mountain Climbers',      cardio, compuesto, general, principiante).
ejercicio(ex_807, 'Jumping Jacks',          cardio, compuesto, general, principiante).
ejercicio(ex_808, 'Sprints',                cardio, compuesto, general, intermedio).
ejercicio(ex_809, 'HIIT en Cinta',          cardio, compuesto, general, intermedio).
ejercicio(ex_810, 'Escalador de Escaleras', cardio, compuesto, general, principiante).
ejercicio(ex_811, 'Battle Ropes',           cardio, compuesto, general, principiante).
ejercicio(ex_812, 'Saltos al Cajón',        cardio, compuesto, general, intermedio).
ejercicio(ex_813, 'Kettlebell Swing',       cardio, compuesto, general, intermedio).
ejercicio(ex_814, 'Air Bike',               cardio, compuesto, general, principiante).


% MOVILIDAD
ejercicio(ex_900, 'Estiramiento de Pecho en Marco',    movilidad, aislado,   movilidad, principiante).
ejercicio(ex_901, 'Estiramiento Isquiotibial de Pie',  movilidad, aislado,   movilidad, principiante).
ejercicio(ex_902, 'Postura del Niño',                   movilidad, aislado,   movilidad, principiante).
ejercicio(ex_903, 'Paloma',                             movilidad, aislado,   movilidad, principiante).
ejercicio(ex_904, 'Rotación Torácica',                  movilidad, aislado,   movilidad, principiante).
ejercicio(ex_905, 'Apertura de Cadera Mariposa',        movilidad, aislado,   movilidad, principiante).
ejercicio(ex_906, 'Estiramiento Cuádriceps de Pie',     movilidad, aislado,   movilidad, principiante).
ejercicio(ex_907, 'Gato-Vaca',                          movilidad, aislado,   movilidad, principiante).
ejercicio(ex_908, 'Apertura de Hombros con Banda',      movilidad, aislado,   movilidad, principiante).
ejercicio(ex_909, 'Hip 90/90',                          movilidad, aislado,   movilidad, principiante).
ejercicio(ex_910, 'Cossack Squat',                      movilidad, compuesto, movilidad, intermedio).
ejercicio(ex_911, 'Estiramiento de Tríceps',            movilidad, aislado,   movilidad, principiante).
ejercicio(ex_912, 'Rotación de Cadera en Suelo',        movilidad, aislado,   movilidad, principiante).
ejercicio(ex_913, 'Extensión Dorsal en Suelo',          movilidad, aislado,   movilidad, principiante).
ejercicio(ex_914, 'Estiramiento de Pantorrilla Pared',  movilidad, aislado,   movilidad, principiante).
ejercicio(ex_915, 'Pec Minor Stretch',                  movilidad, aislado,   movilidad, principiante).

% ACTIVACIÓN
ejercicio(ex_950, 'Glute Bridge',                     activacion, aislado,   activacion, principiante).
ejercicio(ex_951, 'Clamshells con Banda',             activacion, aislado,   activacion, principiante).
ejercicio(ex_952, 'Monster Walks con Banda',          activacion, aislado,   activacion, principiante).
ejercicio(ex_953, 'Rotación Externa Cadera Banda',    activacion, aislado,   activacion, principiante).
ejercicio(ex_954, 'Activación Manguito Rotador',      activacion, aislado,   activacion, principiante).
ejercicio(ex_955, 'Face Pull Activación',             activacion, aislado,   activacion, principiante).
ejercicio(ex_956, 'Band Pull Apart',                  activacion, aislado,   activacion, principiante).
ejercicio(ex_957, 'Pullover con Banda',               activacion, aislado,   activacion, principiante).
ejercicio(ex_958, 'Press Pecho con Banda',            activacion, aislado,   activacion, principiante).
ejercicio(ex_959, 'Activación Isquiotibial en Suelo', activacion, aislado,   activacion, principiante).
ejercicio(ex_960, 'Remo con Banda',                   activacion, aislado,   activacion, principiante).
ejercicio(ex_961, 'Plancha con Elevación de Cadera',  activacion, aislado,   activacion, principiante).
ejercicio(ex_962, 'Dead Bug Activación',              activacion, aislado,   activacion, principiante).
ejercicio(ex_963, 'Bear Crawl',                       activacion, compuesto, activacion, principiante).
ejercicio(ex_964, 'Inchworm',                         activacion, compuesto, activacion, principiante).
ejercicio(ex_965, 'Activación Core Respiración',      activacion, aislado,   activacion, principiante).

% =====================================================
% 5.B. CLASIFICACIÓN AVANZADA DE EJERCICIOS
% =====================================================
% clasificacion_ejercicio(EjercicioID, Clasificacion)
% Un ejercicio puede tener múltiples clasificaciones simultáneas.
%
% Clasificaciones disponibles:
%   unilateral  - Trabaja un solo lado del cuerpo a la vez
%   bilateral   - Trabaja ambos lados del cuerpo de forma simultánea
%   explosivo   - Movimiento rápido/potente; recluta fibras de contracción rápida
%   isometrico  - Contracción muscular sin cambio en la longitud del músculo
%   funcional   - Imita patrones naturales del movimiento humano
%   movilidad   - Mejora el rango de movimiento articular
%   activacion  - Activa y prepara grupos musculares antes del entrenamiento
%   cardio      - Eleva la frecuencia cardíaca; beneficio cardiovascular

% Descripción de cada tipo de clasificación
clasificacion_tipo(unilateral,  'Trabaja un solo lado del cuerpo a la vez').
clasificacion_tipo(bilateral,   'Trabaja ambos lados del cuerpo de forma simultánea').
clasificacion_tipo(explosivo,   'Movimiento rápido y potente; recluta fibras de contracción rápida').
clasificacion_tipo(isometrico,  'Contracción muscular sin cambio en la longitud del músculo').
clasificacion_tipo(funcional,   'Imita patrones naturales del movimiento humano').
clasificacion_tipo(movilidad,   'Mejora el rango de movimiento articular').
clasificacion_tipo(activacion,  'Activa y prepara grupos musculares antes del entrenamiento').
clasificacion_tipo(cardio,      'Eleva la frecuencia cardíaca y mejora el sistema cardiovascular').

% --- PECHO ---
clasificacion_ejercicio(ex_001, bilateral).                     % Press Banca
clasificacion_ejercicio(ex_002, bilateral).                     % Press Inclinado
clasificacion_ejercicio(ex_003, bilateral).                     % Flexiones
clasificacion_ejercicio(ex_003, funcional).
clasificacion_ejercicio(ex_004, bilateral).                     % Press Mancuerna Plano
clasificacion_ejercicio(ex_005, bilateral).                     % Aperturas Máquina
clasificacion_ejercicio(ex_005, activacion).
clasificacion_ejercicio(ex_006, bilateral).                     % Aperturas Mancuerna
clasificacion_ejercicio(ex_007, bilateral).                     % Pec Deck
clasificacion_ejercicio(ex_007, activacion).

% --- ESPALDA ---
clasificacion_ejercicio(ex_101, bilateral).                     % Peso Muerto
clasificacion_ejercicio(ex_101, funcional).
clasificacion_ejercicio(ex_102, bilateral).                     % Remo Barra
clasificacion_ejercicio(ex_103, bilateral).                     % Jalón Frente
clasificacion_ejercicio(ex_104, bilateral).                     % Remo Máquina
clasificacion_ejercicio(ex_105, unilateral).                    % Remo Unilateral
clasificacion_ejercicio(ex_106, bilateral).                     % Pull Over
clasificacion_ejercicio(ex_107, bilateral).                     % Jalón Asistido

% --- HOMBROS ---
clasificacion_ejercicio(ex_201, bilateral).                     % Press Militar
clasificacion_ejercicio(ex_202, bilateral).                     % Press Mancuerna Sentado
clasificacion_ejercicio(ex_203, bilateral).                     % Press Pike Máquina
clasificacion_ejercicio(ex_204, bilateral).                     % Elevación Frontal
clasificacion_ejercicio(ex_204, activacion).
clasificacion_ejercicio(ex_205, bilateral).                     % Elevación Lateral
clasificacion_ejercicio(ex_205, activacion).
clasificacion_ejercicio(ex_206, bilateral).                     % Shrugs Mancuerna

% --- BÍCEPS ---
clasificacion_ejercicio(ex_301, bilateral).                     % Curl Barra
clasificacion_ejercicio(ex_302, bilateral).                     % Curl Mancuerna
clasificacion_ejercicio(ex_303, bilateral).                     % Martillo Mancuerna
clasificacion_ejercicio(ex_304, bilateral).                     % Curl Máquina

% --- TRÍCEPS ---
clasificacion_ejercicio(ex_401, bilateral).                     % Fondos
clasificacion_ejercicio(ex_401, funcional).
clasificacion_ejercicio(ex_402, bilateral).                     % Extensión Polea
clasificacion_ejercicio(ex_403, bilateral).                     % Extensión Mancuerna Sentado
clasificacion_ejercicio(ex_404, bilateral).                     % Press Francés

% --- PIERNAS - COMPUESTOS ---
clasificacion_ejercicio(ex_501, bilateral).                     % Sentadilla Libre
clasificacion_ejercicio(ex_501, funcional).
clasificacion_ejercicio(ex_502, bilateral).                     % Sentadilla Máquina
clasificacion_ejercicio(ex_503, bilateral).                     % Leg Press
clasificacion_ejercicio(ex_504, bilateral).                     % Sentadilla Goblet
clasificacion_ejercicio(ex_504, funcional).

% --- PIERNAS - CUÁDRICEPS AISLADOS ---
clasificacion_ejercicio(ex_505, bilateral).                     % Extensión Cuádriceps

% --- PIERNAS - ISQUIOTIBIALES Y GLÚTEOS ---
clasificacion_ejercicio(ex_601, bilateral).                     % Peso Muerto Rumano
clasificacion_ejercicio(ex_601, funcional).
clasificacion_ejercicio(ex_602, bilateral).                     % Curl Isquiotibial
clasificacion_ejercicio(ex_603, bilateral).                     % Hip Thrust
clasificacion_ejercicio(ex_603, activacion).
clasificacion_ejercicio(ex_604, unilateral).                    % Sentadilla Búlgara
clasificacion_ejercicio(ex_604, funcional).

% --- PANTORRILLA ---
clasificacion_ejercicio(ex_605, bilateral).                     % Elevación Pantorrilla

% --- PIERNAS - GRUPO GENERAL ---
clasificacion_ejercicio(ex_650, bilateral).                     % Sentadilla Goblet
clasificacion_ejercicio(ex_650, funcional).
clasificacion_ejercicio(ex_651, bilateral).                     % Peso Muerto Convencional
clasificacion_ejercicio(ex_651, funcional).
clasificacion_ejercicio(ex_652, bilateral).                     % Leg Press Máquina
clasificacion_ejercicio(ex_653, bilateral).                     % Hack Squat
clasificacion_ejercicio(ex_654, bilateral).                     % Smith Machine Sentadilla

% --- CORE ---
clasificacion_ejercicio(ex_701, bilateral).                     % Planchas
clasificacion_ejercicio(ex_701, isometrico).
clasificacion_ejercicio(ex_701, funcional).
clasificacion_ejercicio(ex_702, bilateral).                     % Abdominales Máquina
clasificacion_ejercicio(ex_703, bilateral).                     % Crunches
clasificacion_ejercicio(ex_704, bilateral).                     % Cable Crunch

% --- PECHO ADICIONALES ---
clasificacion_ejercicio(ex_008, bilateral).
clasificacion_ejercicio(ex_009, bilateral).
clasificacion_ejercicio(ex_010, bilateral).
clasificacion_ejercicio(ex_011, bilateral).
clasificacion_ejercicio(ex_011, funcional).
clasificacion_ejercicio(ex_012, bilateral).
clasificacion_ejercicio(ex_013, unilateral).
clasificacion_ejercicio(ex_014, bilateral).
clasificacion_ejercicio(ex_015, bilateral).
clasificacion_ejercicio(ex_016, bilateral).
clasificacion_ejercicio(ex_017, bilateral).
clasificacion_ejercicio(ex_018, bilateral).
clasificacion_ejercicio(ex_019, bilateral).
clasificacion_ejercicio(ex_019, funcional).
clasificacion_ejercicio(ex_020, bilateral).
clasificacion_ejercicio(ex_021, bilateral).
clasificacion_ejercicio(ex_021, activacion).

% --- ESPALDA ADICIONALES ---
clasificacion_ejercicio(ex_108, bilateral).
clasificacion_ejercicio(ex_108, funcional).
clasificacion_ejercicio(ex_109, bilateral).
clasificacion_ejercicio(ex_110, bilateral).
clasificacion_ejercicio(ex_111, bilateral).
clasificacion_ejercicio(ex_112, bilateral).
clasificacion_ejercicio(ex_113, bilateral).
clasificacion_ejercicio(ex_114, bilateral).
clasificacion_ejercicio(ex_115, unilateral).
clasificacion_ejercicio(ex_116, bilateral).
clasificacion_ejercicio(ex_116, activacion).
clasificacion_ejercicio(ex_117, bilateral).
clasificacion_ejercicio(ex_117, funcional).
clasificacion_ejercicio(ex_118, bilateral).
clasificacion_ejercicio(ex_118, activacion).
clasificacion_ejercicio(ex_119, bilateral).
clasificacion_ejercicio(ex_120, bilateral).
clasificacion_ejercicio(ex_121, bilateral).

% --- HOMBROS ADICIONALES ---
clasificacion_ejercicio(ex_207, bilateral).
clasificacion_ejercicio(ex_208, bilateral).
clasificacion_ejercicio(ex_209, bilateral).
clasificacion_ejercicio(ex_209, activacion).
clasificacion_ejercicio(ex_210, bilateral).
clasificacion_ejercicio(ex_210, activacion).
clasificacion_ejercicio(ex_211, bilateral).
clasificacion_ejercicio(ex_212, bilateral).
clasificacion_ejercicio(ex_212, activacion).
clasificacion_ejercicio(ex_213, bilateral).
clasificacion_ejercicio(ex_213, activacion).
clasificacion_ejercicio(ex_214, bilateral).
clasificacion_ejercicio(ex_214, activacion).
clasificacion_ejercicio(ex_215, bilateral).
clasificacion_ejercicio(ex_216, bilateral).
clasificacion_ejercicio(ex_216, activacion).

% --- BÍCEPS ADICIONALES ---
clasificacion_ejercicio(ex_305, bilateral).
clasificacion_ejercicio(ex_306, unilateral).
clasificacion_ejercicio(ex_307, bilateral).
clasificacion_ejercicio(ex_308, bilateral).
clasificacion_ejercicio(ex_309, bilateral).
clasificacion_ejercicio(ex_310, bilateral).
clasificacion_ejercicio(ex_311, bilateral).
clasificacion_ejercicio(ex_312, bilateral).
clasificacion_ejercicio(ex_313, bilateral).
clasificacion_ejercicio(ex_314, bilateral).
clasificacion_ejercicio(ex_315, bilateral).

% --- TRÍCEPS ADICIONALES ---
clasificacion_ejercicio(ex_405, unilateral).
clasificacion_ejercicio(ex_406, unilateral).
clasificacion_ejercicio(ex_407, bilateral).
clasificacion_ejercicio(ex_407, funcional).
clasificacion_ejercicio(ex_408, bilateral).
clasificacion_ejercicio(ex_409, bilateral).
clasificacion_ejercicio(ex_410, bilateral).
clasificacion_ejercicio(ex_411, bilateral).
clasificacion_ejercicio(ex_412, bilateral).
clasificacion_ejercicio(ex_413, bilateral).
clasificacion_ejercicio(ex_414, bilateral).
clasificacion_ejercicio(ex_414, funcional).
clasificacion_ejercicio(ex_415, bilateral).

% --- PIERNAS ADICIONALES ---
clasificacion_ejercicio(ex_506, bilateral).
clasificacion_ejercicio(ex_506, funcional).
clasificacion_ejercicio(ex_507, unilateral).
clasificacion_ejercicio(ex_507, funcional).
clasificacion_ejercicio(ex_508, unilateral).
clasificacion_ejercicio(ex_508, funcional).
clasificacion_ejercicio(ex_509, unilateral).
clasificacion_ejercicio(ex_510, unilateral).
clasificacion_ejercicio(ex_606, bilateral).
clasificacion_ejercicio(ex_606, funcional).
clasificacion_ejercicio(ex_607, bilateral).
clasificacion_ejercicio(ex_608, bilateral).
clasificacion_ejercicio(ex_609, unilateral).
clasificacion_ejercicio(ex_610, bilateral).
clasificacion_ejercicio(ex_610, activacion).
clasificacion_ejercicio(ex_611, bilateral).
clasificacion_ejercicio(ex_611, activacion).
clasificacion_ejercicio(ex_612, bilateral).
clasificacion_ejercicio(ex_613, unilateral).
clasificacion_ejercicio(ex_655, unilateral).
clasificacion_ejercicio(ex_655, funcional).
clasificacion_ejercicio(ex_656, bilateral).
clasificacion_ejercicio(ex_656, funcional).
clasificacion_ejercicio(ex_657, bilateral).
clasificacion_ejercicio(ex_657, funcional).
clasificacion_ejercicio(ex_658, bilateral).
clasificacion_ejercicio(ex_659, bilateral).
clasificacion_ejercicio(ex_659, funcional).
clasificacion_ejercicio(ex_660, bilateral).
clasificacion_ejercicio(ex_661, bilateral).
clasificacion_ejercicio(ex_661, explosivo).
clasificacion_ejercicio(ex_661, funcional).

% --- CORE ADICIONALES ---
clasificacion_ejercicio(ex_705, bilateral).
clasificacion_ejercicio(ex_705, isometrico).
clasificacion_ejercicio(ex_706, bilateral).
clasificacion_ejercicio(ex_707, bilateral).
clasificacion_ejercicio(ex_708, bilateral).
clasificacion_ejercicio(ex_709, bilateral).
clasificacion_ejercicio(ex_709, isometrico).
clasificacion_ejercicio(ex_710, bilateral).
clasificacion_ejercicio(ex_711, bilateral).
clasificacion_ejercicio(ex_711, isometrico).
clasificacion_ejercicio(ex_711, activacion).
clasificacion_ejercicio(ex_712, bilateral).
clasificacion_ejercicio(ex_712, isometrico).
clasificacion_ejercicio(ex_712, funcional).
clasificacion_ejercicio(ex_713, bilateral).
clasificacion_ejercicio(ex_714, bilateral).
clasificacion_ejercicio(ex_715, bilateral).
clasificacion_ejercicio(ex_715, isometrico).
clasificacion_ejercicio(ex_716, bilateral).

% --- CARDIO ---
clasificacion_ejercicio(ex_800, bilateral).
clasificacion_ejercicio(ex_800, cardio).
clasificacion_ejercicio(ex_800, funcional).
clasificacion_ejercicio(ex_801, bilateral).
clasificacion_ejercicio(ex_801, cardio).
clasificacion_ejercicio(ex_802, bilateral).
clasificacion_ejercicio(ex_802, cardio).
clasificacion_ejercicio(ex_803, bilateral).
clasificacion_ejercicio(ex_803, cardio).
clasificacion_ejercicio(ex_803, funcional).
clasificacion_ejercicio(ex_804, bilateral).
clasificacion_ejercicio(ex_804, cardio).
clasificacion_ejercicio(ex_804, explosivo).
clasificacion_ejercicio(ex_805, bilateral).
clasificacion_ejercicio(ex_805, cardio).
clasificacion_ejercicio(ex_805, funcional).
clasificacion_ejercicio(ex_805, explosivo).
clasificacion_ejercicio(ex_806, bilateral).
clasificacion_ejercicio(ex_806, cardio).
clasificacion_ejercicio(ex_806, funcional).
clasificacion_ejercicio(ex_807, bilateral).
clasificacion_ejercicio(ex_807, cardio).
clasificacion_ejercicio(ex_808, bilateral).
clasificacion_ejercicio(ex_808, cardio).
clasificacion_ejercicio(ex_808, explosivo).
clasificacion_ejercicio(ex_809, bilateral).
clasificacion_ejercicio(ex_809, cardio).
clasificacion_ejercicio(ex_810, bilateral).
clasificacion_ejercicio(ex_810, cardio).
clasificacion_ejercicio(ex_811, bilateral).
clasificacion_ejercicio(ex_811, cardio).
clasificacion_ejercicio(ex_812, bilateral).
clasificacion_ejercicio(ex_812, cardio).
clasificacion_ejercicio(ex_812, explosivo).
clasificacion_ejercicio(ex_813, bilateral).
clasificacion_ejercicio(ex_813, cardio).
clasificacion_ejercicio(ex_813, explosivo).
clasificacion_ejercicio(ex_813, funcional).
clasificacion_ejercicio(ex_814, bilateral).
clasificacion_ejercicio(ex_814, cardio).
clasificacion_ejercicio(ex_815, bilateral).
clasificacion_ejercicio(ex_815, cardio).
clasificacion_ejercicio(ex_815, funcional).

% --- MOVILIDAD ---
clasificacion_ejercicio(ex_900, bilateral).
clasificacion_ejercicio(ex_900, movilidad).
clasificacion_ejercicio(ex_901, bilateral).
clasificacion_ejercicio(ex_901, movilidad).
clasificacion_ejercicio(ex_902, bilateral).
clasificacion_ejercicio(ex_902, movilidad).
clasificacion_ejercicio(ex_903, unilateral).
clasificacion_ejercicio(ex_903, movilidad).
clasificacion_ejercicio(ex_904, bilateral).
clasificacion_ejercicio(ex_904, movilidad).
clasificacion_ejercicio(ex_905, bilateral).
clasificacion_ejercicio(ex_905, movilidad).
clasificacion_ejercicio(ex_906, unilateral).
clasificacion_ejercicio(ex_906, movilidad).
clasificacion_ejercicio(ex_907, bilateral).
clasificacion_ejercicio(ex_907, movilidad).
clasificacion_ejercicio(ex_908, bilateral).
clasificacion_ejercicio(ex_908, movilidad).
clasificacion_ejercicio(ex_909, bilateral).
clasificacion_ejercicio(ex_909, movilidad).
clasificacion_ejercicio(ex_910, unilateral).
clasificacion_ejercicio(ex_910, movilidad).
clasificacion_ejercicio(ex_910, funcional).
clasificacion_ejercicio(ex_911, bilateral).
clasificacion_ejercicio(ex_911, movilidad).
clasificacion_ejercicio(ex_912, bilateral).
clasificacion_ejercicio(ex_912, movilidad).
clasificacion_ejercicio(ex_913, bilateral).
clasificacion_ejercicio(ex_913, movilidad).
clasificacion_ejercicio(ex_914, bilateral).
clasificacion_ejercicio(ex_914, movilidad).
clasificacion_ejercicio(ex_915, bilateral).
clasificacion_ejercicio(ex_915, movilidad).

% --- ACTIVACIÓN ---
clasificacion_ejercicio(ex_950, bilateral).
clasificacion_ejercicio(ex_950, activacion).
clasificacion_ejercicio(ex_951, unilateral).
clasificacion_ejercicio(ex_951, activacion).
clasificacion_ejercicio(ex_952, bilateral).
clasificacion_ejercicio(ex_952, activacion).
clasificacion_ejercicio(ex_953, unilateral).
clasificacion_ejercicio(ex_953, activacion).
clasificacion_ejercicio(ex_954, unilateral).
clasificacion_ejercicio(ex_954, activacion).
clasificacion_ejercicio(ex_955, bilateral).
clasificacion_ejercicio(ex_955, activacion).
clasificacion_ejercicio(ex_956, bilateral).
clasificacion_ejercicio(ex_956, activacion).
clasificacion_ejercicio(ex_957, bilateral).
clasificacion_ejercicio(ex_957, activacion).
clasificacion_ejercicio(ex_958, bilateral).
clasificacion_ejercicio(ex_958, activacion).
clasificacion_ejercicio(ex_959, bilateral).
clasificacion_ejercicio(ex_959, activacion).
clasificacion_ejercicio(ex_960, bilateral).
clasificacion_ejercicio(ex_960, activacion).
clasificacion_ejercicio(ex_961, bilateral).
clasificacion_ejercicio(ex_961, activacion).
clasificacion_ejercicio(ex_961, isometrico).
clasificacion_ejercicio(ex_962, bilateral).
clasificacion_ejercicio(ex_962, activacion).
clasificacion_ejercicio(ex_963, bilateral).
clasificacion_ejercicio(ex_963, activacion).
clasificacion_ejercicio(ex_963, funcional).
clasificacion_ejercicio(ex_964, bilateral).
clasificacion_ejercicio(ex_964, activacion).
clasificacion_ejercicio(ex_964, movilidad).
clasificacion_ejercicio(ex_965, bilateral).
clasificacion_ejercicio(ex_965, activacion).
clasificacion_ejercicio(ex_965, isometrico).

% =====================================================
% 5.C. VARIANTES DE EJERCICIOS
% =====================================================
% variante_ejercicio(EjercicioBase, EjercicioVariante, TipoVariacion)
% Relaciona un ejercicio base con sus variantes directas.
%
% TipoVariacion:
%   equipo      - Mismo movimiento con distinto equipamiento
%   inclinacion - Variación del ángulo o plano de movimiento
%   agarre      - Distinto agarre (ancho, estrecho, neutro, supino, prono)
%   unilateral  - Versión de un solo brazo/pierna
%   asistido    - Versión facilitada (máquina o banda de asistencia)
%   tempo       - Variación de velocidad, explosividad o pausa
%   parcial     - Rango de movimiento reducido

tipo_variacion(equipo,      'Mismo movimiento con distinto equipamiento').
tipo_variacion(inclinacion, 'Variación del ángulo o plano de movimiento').
tipo_variacion(agarre,      'Distinto agarre: ancho, estrecho, neutro, supino, prono').
tipo_variacion(unilateral,  'Versión de un solo brazo o pierna').
tipo_variacion(asistido,    'Versión facilitada con máquina o banda de asistencia').
tipo_variacion(tempo,       'Variación de velocidad, inclusión de pausa o explosividad').
tipo_variacion(parcial,     'Rango de movimiento reducido').

% --- VARIANTES PECHO ---
variante_ejercicio(ex_001, ex_002, inclinacion).   % Press Banca -> Press Inclinado Barra
variante_ejercicio(ex_001, ex_008, inclinacion).   % Press Banca -> Press Declinado Barra
variante_ejercicio(ex_001, ex_004, equipo).        % Press Banca -> Press Mancuerna Plano
variante_ejercicio(ex_001, ex_009, inclinacion).   % Press Banca -> Press Mancuerna Inclinado
variante_ejercicio(ex_001, ex_010, inclinacion).   % Press Banca -> Press Mancuerna Declinado
variante_ejercicio(ex_001, ex_017, asistido).      % Press Banca -> Press Máquina Pecho
variante_ejercicio(ex_001, ex_018, inclinacion).   % Press Banca -> Press Máquina Inclinado
variante_ejercicio(ex_003, ex_011, inclinacion).   % Flexiones -> Flexiones Inclinadas
variante_ejercicio(ex_003, ex_012, agarre).        % Flexiones -> Flexiones Diamante
variante_ejercicio(ex_003, ex_013, unilateral).    % Flexiones -> Flexiones Archer
variante_ejercicio(ex_003, ex_019, inclinacion).   % Flexiones -> Fondos Pecho
variante_ejercicio(ex_006, ex_014, equipo).        % Aperturas Mancuerna -> Cable Polea Media
variante_ejercicio(ex_006, ex_015, equipo).        % Aperturas Mancuerna -> Cable Polea Alta
variante_ejercicio(ex_006, ex_016, equipo).        % Aperturas Mancuerna -> Cable Polea Baja
variante_ejercicio(ex_005, ex_007, equipo).        % Aperturas Máquina -> Pec Deck
variante_ejercicio(ex_106, ex_020, equipo).        % Pull Over Espalda -> Pull Over Mancuerna Pecho

% --- VARIANTES ESPALDA ---
variante_ejercicio(ex_101, ex_117, agarre).        % Peso Muerto -> Peso Muerto Sumo
variante_ejercicio(ex_101, ex_651, equipo).        % Peso Muerto -> Peso Muerto Convencional
variante_ejercicio(ex_102, ex_111, equipo).        % Remo Barra -> Remo Mancuerna
variante_ejercicio(ex_102, ex_112, equipo).        % Remo Barra -> Remo T-Bar
variante_ejercicio(ex_102, ex_120, tempo).         % Remo Barra -> Remo Pendlay
variante_ejercicio(ex_103, ex_113, agarre).        % Jalón Frente -> Jalón Agarre Neutro
variante_ejercicio(ex_103, ex_114, inclinacion).   % Jalón Frente -> Jalón Detrás Nuca
variante_ejercicio(ex_103, ex_107, asistido).      % Jalón Frente -> Jalón Asistido
variante_ejercicio(ex_103, ex_121, inclinacion).   % Jalón Frente -> Jalón Polea Baja
variante_ejercicio(ex_104, ex_110, equipo).        % Remo Máquina -> Remo Cable Sentado
variante_ejercicio(ex_105, ex_115, equipo).        % Remo Unilateral -> Remo Cable Unilateral
variante_ejercicio(ex_108, ex_109, asistido).      % Dominadas -> Dominadas Asistidas

% --- VARIANTES HOMBROS ---
variante_ejercicio(ex_201, ex_202, equipo).        % Press Militar -> Press Mancuerna Sentado
variante_ejercicio(ex_201, ex_207, equipo).        % Press Militar -> Press Arnold
variante_ejercicio(ex_201, ex_208, asistido).      % Press Militar -> Press Máquina Hombros
variante_ejercicio(ex_201, ex_215, equipo).        % Press Militar -> Press Landmine Hombro
variante_ejercicio(ex_205, ex_209, equipo).        % Elevación Lateral -> Cable
variante_ejercicio(ex_205, ex_216, asistido).      % Elevación Lateral -> Máquina
variante_ejercicio(ex_204, ex_210, equipo).        % Elevación Frontal -> Cable
variante_ejercicio(ex_206, ex_211, equipo).        % Shrugs Mancuerna -> Shrugs Barra
variante_ejercicio(ex_116, ex_212, equipo).        % Face Pull Espalda -> Face Pull Hombro

% --- VARIANTES BÍCEPS ---
variante_ejercicio(ex_301, ex_310, equipo).        % Curl Barra -> Curl Barra Z
variante_ejercicio(ex_301, ex_308, agarre).        % Curl Barra -> Curl Inverso Barra
variante_ejercicio(ex_301, ex_313, tempo).         % Curl Barra -> Curl 21s
variante_ejercicio(ex_302, ex_306, tempo).         % Curl Mancuerna -> Curl Concentración
variante_ejercicio(ex_302, ex_311, inclinacion).   % Curl Mancuerna -> Curl Inclinado
variante_ejercicio(ex_302, ex_314, inclinacion).   % Curl Mancuerna -> Curl Banco Inclinado
variante_ejercicio(ex_304, ex_305, equipo).        % Curl Máquina -> Curl Predicador
variante_ejercicio(ex_304, ex_307, equipo).        % Curl Máquina -> Curl Cable
variante_ejercicio(ex_303, ex_315, equipo).        % Martillo -> Curl Cuerda Cable
variante_ejercicio(ex_307, ex_312, inclinacion).   % Curl Cable -> Curl Polea Alta
variante_ejercicio(ex_302, ex_309, agarre).        % Curl Mancuerna -> Curl Araña

% --- VARIANTES TRÍCEPS ---
variante_ejercicio(ex_402, ex_410, equipo).        % Extensión Polea -> Cuerda
variante_ejercicio(ex_402, ex_415, agarre).        % Extensión Polea -> Reversa
variante_ejercicio(ex_402, ex_412, inclinacion).   % Extensión Polea -> sobre Cabeza
variante_ejercicio(ex_403, ex_411, inclinacion).   % Ext Mancuerna Sentado -> Acostado
variante_ejercicio(ex_404, ex_413, equipo).        % Press Francés Barra -> Cable
variante_ejercicio(ex_401, ex_407, asistido).      % Fondos -> Fondos en Banco
variante_ejercicio(ex_001, ex_408, agarre).        % Press Banca -> Press Cerrado Barra
variante_ejercicio(ex_408, ex_409, equipo).        % Press Cerrado Barra -> Máquina
variante_ejercicio(ex_405, ex_406, equipo).        % Patada Mancuerna -> Cable
variante_ejercicio(ex_003, ex_414, agarre).        % Flexiones -> Diamante Tríceps

% --- VARIANTES PIERNAS ---
variante_ejercicio(ex_501, ex_506, inclinacion).   % Sentadilla Libre -> Frontal
variante_ejercicio(ex_501, ex_502, asistido).      % Sentadilla Libre -> Máquina
variante_ejercicio(ex_501, ex_504, equipo).        % Sentadilla Libre -> Goblet
variante_ejercicio(ex_501, ex_656, agarre).        % Sentadilla Libre -> Sumo
variante_ejercicio(ex_501, ex_657, tempo).         % Sentadilla Libre -> Pausa
variante_ejercicio(ex_501, ex_658, parcial).       % Sentadilla Libre -> Box Squat
variante_ejercicio(ex_501, ex_660, equipo).        % Sentadilla Libre -> Zercher
variante_ejercicio(ex_501, ex_661, tempo).         % Sentadilla Libre -> con Salto
variante_ejercicio(ex_503, ex_509, unilateral).    % Leg Press -> Prensa Unipodal
variante_ejercicio(ex_505, ex_510, unilateral).    % Extensión Cuádriceps -> Unilateral
variante_ejercicio(ex_604, ex_507, equipo).        % Sentadilla Búlgara -> Zancada Mancuernas
variante_ejercicio(ex_604, ex_655, tempo).         % Sentadilla Búlgara -> Zancada Caminando
variante_ejercicio(ex_604, ex_508, equipo).        % Sentadilla Búlgara -> Step Up Banco
variante_ejercicio(ex_601, ex_606, equipo).        % Peso Muerto Rumano -> Sumo Mancuernas
variante_ejercicio(ex_602, ex_607, equipo).        % Curl Isquiotibial -> Nórdico
variante_ejercicio(ex_603, ex_609, unilateral).    % Hip Thrust -> Patada Glúteo
variante_ejercicio(ex_605, ex_612, equipo).        % Elevación Pantorrilla -> Sentado
variante_ejercicio(ex_605, ex_613, unilateral).    % Elevación Pantorrilla -> Unilateral
variante_ejercicio(ex_651, ex_659, equipo).        % Peso Muerto Convencional -> Trap Bar
variante_ejercicio(ex_653, ex_654, equipo).        % Hack Squat -> Smith Machine

% --- VARIANTES CORE ---
variante_ejercicio(ex_701, ex_705, inclinacion).   % Plancha -> Plancha Lateral
variante_ejercicio(ex_701, ex_709, tempo).         % Plancha -> con Toque Hombro
variante_ejercicio(ex_701, ex_711, equipo).        % Plancha -> Dead Bug
variante_ejercicio(ex_701, ex_715, inclinacion).   % Plancha -> Hollow Hold
variante_ejercicio(ex_703, ex_713, tempo).         % Crunches -> Bicicleta
variante_ejercicio(ex_703, ex_710, equipo).        % Crunches -> Rotación Rusa
variante_ejercicio(ex_703, ex_716, tempo).         % Crunches -> V-Ups
variante_ejercicio(ex_704, ex_712, inclinacion).   % Cable Crunch -> Pallof Press
variante_ejercicio(ex_708, ex_714, equipo).        % Elevación Piernas Colgado -> Tumbado
variante_ejercicio(ex_706, ex_707, tempo).         % Rueda Abdominal -> Dragon Flag

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
% 16. PATRONES DE MOVIMIENTO
% =====================================================
% patron(Nombre, Descripcion)

patron(empuje,    'Movimientos de empuje horizontal o vertical').
patron(tiron,     'Movimientos de tirón hacia el cuerpo').
patron(estatico,  'Movimientos de contracción isométrica').
patron(general,   'Ejercicios de categoría general o multi-patrón (cardio, funcional)').
patron(movilidad, 'Movimientos enfocados en flexibilidad y rango articular').
patron(activacion,'Movimientos de baja intensidad para activar grupos musculares').

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
% 18. EQUIPAMIENTO REQUERIDO
% =====================================================
% equipamiento(EjercicioID, Equipo)
% Un ejercicio puede requerir más de un tipo de equipamiento.
%
% Valores posibles de Equipo:
%   barra          - Barra olímpica o de dominadas
%   mancuernas     - Par o mancuerna individual
%   polea          - Máquina de cable / polea
%   maquina        - Máquina guiada (prensa, jalón, etc.)
%   banda_elastica - Banda de resistencia elástica
%   peso_corporal  - Sin equipamiento externo

% Descripción de cada tipo de equipamiento
equipamiento_tipo(barra,          'Barra olímpica o de dominadas').
equipamiento_tipo(mancuernas,     'Par de mancuernas o mancuerna individual').
equipamiento_tipo(polea,          'Máquina de cable / polea ajustable').
equipamiento_tipo(maquina,        'Máquina guiada (prensa, jalón, pec deck, etc.)').
equipamiento_tipo(banda_elastica, 'Banda de resistencia elástica').
equipamiento_tipo(peso_corporal,  'Sin equipamiento externo; solo el peso del cuerpo').

% --- PECHO ---
equipamiento(ex_001, barra).                        % Press Banca
equipamiento(ex_002, barra).                        % Press Inclinado
equipamiento(ex_003, peso_corporal).                % Flexiones
equipamiento(ex_004, mancuernas).                   % Press Mancuerna Plano
equipamiento(ex_005, maquina).                      % Aperturas Máquina
equipamiento(ex_006, mancuernas).                   % Aperturas Mancuerna
equipamiento(ex_007, maquina).                      % Pec Deck

% --- ESPALDA ---
equipamiento(ex_101, barra).                        % Peso Muerto
equipamiento(ex_102, barra).                        % Remo Barra
equipamiento(ex_103, maquina).                      % Jalón Frente
equipamiento(ex_104, maquina).                      % Remo Máquina
equipamiento(ex_105, mancuernas).                   % Remo Unilateral
equipamiento(ex_106, mancuernas).                   % Pull Over
equipamiento(ex_107, maquina).                      % Jalón Asistido

% --- HOMBROS ---
equipamiento(ex_201, barra).                        % Press Militar
equipamiento(ex_202, mancuernas).                   % Press Mancuerna Sentado
equipamiento(ex_203, maquina).                      % Press Pike Máquina
equipamiento(ex_204, mancuernas).                   % Elevación Frontal
equipamiento(ex_205, mancuernas).                   % Elevación Lateral
equipamiento(ex_206, mancuernas).                   % Shrugs Mancuerna

% --- BÍCEPS ---
equipamiento(ex_301, barra).                        % Curl Barra
equipamiento(ex_302, mancuernas).                   % Curl Mancuerna
equipamiento(ex_303, mancuernas).                   % Martillo Mancuerna
equipamiento(ex_304, maquina).                      % Curl Máquina

% --- TRÍCEPS ---
equipamiento(ex_401, peso_corporal).                % Fondos
equipamiento(ex_402, polea).                        % Extensión Polea
equipamiento(ex_403, mancuernas).                   % Extensión Mancuerna Sentado
equipamiento(ex_404, barra).                        % Press Francés

% --- PIERNAS - COMPUESTOS ---
equipamiento(ex_501, barra).                        % Sentadilla Libre
equipamiento(ex_502, maquina).                      % Sentadilla Máquina
equipamiento(ex_503, maquina).                      % Leg Press
equipamiento(ex_504, mancuernas).                   % Sentadilla Goblet

% --- PIERNAS - CUÁDRICEPS AISLADOS ---
equipamiento(ex_505, maquina).                      % Extensión Cuádriceps

% --- PIERNAS - ISQUIOTIBIALES Y GLÚTEOS ---
equipamiento(ex_601, barra).                        % Peso Muerto Rumano
equipamiento(ex_602, maquina).                      % Curl Isquiotibial
equipamiento(ex_603, peso_corporal).                % Hip Thrust (también con barra)
equipamiento(ex_603, barra).
equipamiento(ex_604, peso_corporal).                % Sentadilla Búlgara (también mancuernas)
equipamiento(ex_604, mancuernas).

% --- PANTORRILLA ---
equipamiento(ex_605, peso_corporal).                % Elevación Pantorrilla

% --- PIERNAS - GRUPO GENERAL ---
equipamiento(ex_650, mancuernas).                   % Sentadilla Goblet
equipamiento(ex_651, barra).                        % Peso Muerto Convencional
equipamiento(ex_652, maquina).                      % Leg Press Máquina
equipamiento(ex_653, maquina).                      % Hack Squat
equipamiento(ex_654, barra).                        % Smith Machine Sentadilla

% --- CORE ---
equipamiento(ex_701, peso_corporal).                % Planchas
equipamiento(ex_702, maquina).                      % Abdominales Máquina
equipamiento(ex_703, peso_corporal).                % Crunches
equipamiento(ex_704, polea).                        % Cable Crunch

% --- NUEVOS TIPOS DE EQUIPAMIENTO ---
equipamiento_tipo(kettlebell,     'Pesa rusa (kettlebell)').
equipamiento_tipo(barra_dominadas,'Barra fija para dominadas (instalada en pared, parque o marco)').

% --- PECHO ADICIONALES ---
equipamiento(ex_008, barra).
equipamiento(ex_009, mancuernas).
equipamiento(ex_010, mancuernas).
equipamiento(ex_011, peso_corporal).
equipamiento(ex_012, peso_corporal).
equipamiento(ex_013, peso_corporal).
equipamiento(ex_014, polea).
equipamiento(ex_015, polea).
equipamiento(ex_016, polea).
equipamiento(ex_017, maquina).
equipamiento(ex_018, maquina).
equipamiento(ex_019, peso_corporal).
equipamiento(ex_020, mancuernas).
equipamiento(ex_021, peso_corporal).

% --- ESPALDA ADICIONALES ---
equipamiento(ex_108, barra_dominadas).
equipamiento(ex_109, maquina).
equipamiento(ex_110, polea).
equipamiento(ex_111, mancuernas).
equipamiento(ex_112, barra).
equipamiento(ex_113, maquina).
equipamiento(ex_114, maquina).
equipamiento(ex_115, polea).
equipamiento(ex_116, polea).
equipamiento(ex_117, barra).
equipamiento(ex_118, peso_corporal).
equipamiento(ex_119, maquina).
equipamiento(ex_120, barra).
equipamiento(ex_121, polea).

% --- HOMBROS ADICIONALES ---
equipamiento(ex_207, mancuernas).
equipamiento(ex_208, maquina).
equipamiento(ex_209, polea).
equipamiento(ex_210, polea).
equipamiento(ex_211, barra).
equipamiento(ex_212, polea).
equipamiento(ex_213, mancuernas).
equipamiento(ex_214, polea).
equipamiento(ex_215, barra).
equipamiento(ex_216, maquina).

% --- BÍCEPS ADICIONALES ---
equipamiento(ex_305, maquina).
equipamiento(ex_306, mancuernas).
equipamiento(ex_307, polea).
equipamiento(ex_308, barra).
equipamiento(ex_309, barra).
equipamiento(ex_310, barra).
equipamiento(ex_311, mancuernas).
equipamiento(ex_312, polea).
equipamiento(ex_313, barra).
equipamiento(ex_314, mancuernas).
equipamiento(ex_315, polea).

% --- TRÍCEPS ADICIONALES ---
equipamiento(ex_405, mancuernas).
equipamiento(ex_406, polea).
equipamiento(ex_407, peso_corporal).
equipamiento(ex_408, barra).
equipamiento(ex_409, maquina).
equipamiento(ex_410, polea).
equipamiento(ex_411, mancuernas).
equipamiento(ex_412, polea).
equipamiento(ex_413, polea).
equipamiento(ex_414, peso_corporal).
equipamiento(ex_415, polea).

% --- PIERNAS ADICIONALES ---
equipamiento(ex_506, barra).
equipamiento(ex_507, mancuernas).
equipamiento(ex_508, peso_corporal).
equipamiento(ex_509, maquina).
equipamiento(ex_510, maquina).
equipamiento(ex_606, mancuernas).
equipamiento(ex_607, peso_corporal).
equipamiento(ex_608, barra).
equipamiento(ex_609, polea).
equipamiento(ex_610, maquina).
equipamiento(ex_611, maquina).
equipamiento(ex_612, maquina).
equipamiento(ex_613, peso_corporal).
equipamiento(ex_655, mancuernas).
equipamiento(ex_656, peso_corporal).
equipamiento(ex_657, barra).
equipamiento(ex_658, barra).
equipamiento(ex_659, barra).
equipamiento(ex_660, barra).
equipamiento(ex_661, peso_corporal).

% --- CORE ADICIONALES ---
equipamiento(ex_705, peso_corporal).
equipamiento(ex_706, peso_corporal).
equipamiento(ex_707, peso_corporal).
equipamiento(ex_708, barra_dominadas).
equipamiento(ex_709, peso_corporal).
equipamiento(ex_710, peso_corporal).
equipamiento(ex_711, peso_corporal).
equipamiento(ex_712, polea).
equipamiento(ex_713, peso_corporal).
equipamiento(ex_714, peso_corporal).
equipamiento(ex_715, peso_corporal).
equipamiento(ex_716, peso_corporal).

% --- CARDIO ---
equipamiento(ex_800, maquina).
equipamiento(ex_801, maquina).
equipamiento(ex_802, maquina).
equipamiento(ex_803, maquina).
equipamiento(ex_804, peso_corporal).
equipamiento(ex_805, peso_corporal).
equipamiento(ex_806, peso_corporal).
equipamiento(ex_807, peso_corporal).
equipamiento(ex_808, peso_corporal).
equipamiento(ex_809, maquina).
equipamiento(ex_810, maquina).
equipamiento(ex_811, peso_corporal).
equipamiento(ex_812, peso_corporal).
equipamiento(ex_813, kettlebell).
equipamiento(ex_814, maquina).
equipamiento(ex_815, peso_corporal).

% --- MOVILIDAD ---
equipamiento(ex_900, peso_corporal).
equipamiento(ex_901, peso_corporal).
equipamiento(ex_902, peso_corporal).
equipamiento(ex_903, peso_corporal).
equipamiento(ex_904, peso_corporal).
equipamiento(ex_905, peso_corporal).
equipamiento(ex_906, peso_corporal).
equipamiento(ex_907, peso_corporal).
equipamiento(ex_908, banda_elastica).
equipamiento(ex_909, peso_corporal).
equipamiento(ex_910, peso_corporal).
equipamiento(ex_911, peso_corporal).
equipamiento(ex_912, peso_corporal).
equipamiento(ex_913, peso_corporal).
equipamiento(ex_914, peso_corporal).
equipamiento(ex_915, peso_corporal).

% --- ACTIVACIÓN ---
equipamiento(ex_950, peso_corporal).
equipamiento(ex_951, banda_elastica).
equipamiento(ex_952, banda_elastica).
equipamiento(ex_953, banda_elastica).
equipamiento(ex_954, banda_elastica).
equipamiento(ex_955, polea).
equipamiento(ex_956, banda_elastica).
equipamiento(ex_957, banda_elastica).
equipamiento(ex_958, banda_elastica).
equipamiento(ex_959, peso_corporal).
equipamiento(ex_960, banda_elastica).
equipamiento(ex_961, peso_corporal).
equipamiento(ex_962, peso_corporal).
equipamiento(ex_963, peso_corporal).
equipamiento(ex_964, peso_corporal).
equipamiento(ex_965, peso_corporal).

% =====================================================
% 19. LUGAR DE ENTRENAMIENTO
% =====================================================
% lugar(Nombre, Descripcion)
% lugar_ejercicio(EjercicioID, Lugar)
% lugar_usuario(UsuarioID, Lugar)  (extendible en sesión)
%
% Valores posibles de Lugar: gimnasio | hogar | parque

lugar(gimnasio, 'Centro deportivo con máquinas y pesos libres').
lugar(hogar,    'Entrenamiento en casa con equipamiento limitado').
lugar(parque,   'Espacios al aire libre con mobiliario urbano o sin equipamiento').

% La disponibilidad de un ejercicio en un lugar se deriva del equipamiento:
%   - peso_corporal  → disponible en gimnasio, hogar y parque
%   - mancuernas     → disponible en gimnasio y hogar (si se poseen)
%   - barra          → disponible en gimnasio (barras de dominadas en parque para algunos)
%   - polea/maquina  → disponible solo en gimnasio

lugar_ejercicio(ex_001, gimnasio).                  % Press Banca (barra)
lugar_ejercicio(ex_002, gimnasio).                  % Press Inclinado (barra)
lugar_ejercicio(ex_003, gimnasio).                  % Flexiones
lugar_ejercicio(ex_003, hogar).
lugar_ejercicio(ex_003, parque).
lugar_ejercicio(ex_004, gimnasio).                  % Press Mancuerna Plano
lugar_ejercicio(ex_004, hogar).
lugar_ejercicio(ex_005, gimnasio).                  % Aperturas Máquina
lugar_ejercicio(ex_006, gimnasio).                  % Aperturas Mancuerna
lugar_ejercicio(ex_006, hogar).
lugar_ejercicio(ex_007, gimnasio).                  % Pec Deck

lugar_ejercicio(ex_101, gimnasio).                  % Peso Muerto (barra)
lugar_ejercicio(ex_102, gimnasio).                  % Remo Barra
lugar_ejercicio(ex_103, gimnasio).                  % Jalón Frente
lugar_ejercicio(ex_104, gimnasio).                  % Remo Máquina
lugar_ejercicio(ex_105, gimnasio).                  % Remo Unilateral
lugar_ejercicio(ex_105, hogar).
lugar_ejercicio(ex_106, gimnasio).                  % Pull Over
lugar_ejercicio(ex_106, hogar).
lugar_ejercicio(ex_107, gimnasio).                  % Jalón Asistido

lugar_ejercicio(ex_201, gimnasio).                  % Press Militar
lugar_ejercicio(ex_202, gimnasio).                  % Press Mancuerna Sentado
lugar_ejercicio(ex_202, hogar).
lugar_ejercicio(ex_203, gimnasio).                  % Press Pike Máquina
lugar_ejercicio(ex_204, gimnasio).                  % Elevación Frontal
lugar_ejercicio(ex_204, hogar).
lugar_ejercicio(ex_205, gimnasio).                  % Elevación Lateral
lugar_ejercicio(ex_205, hogar).
lugar_ejercicio(ex_206, gimnasio).                  % Shrugs Mancuerna
lugar_ejercicio(ex_206, hogar).

lugar_ejercicio(ex_301, gimnasio).                  % Curl Barra
lugar_ejercicio(ex_302, gimnasio).                  % Curl Mancuerna
lugar_ejercicio(ex_302, hogar).
lugar_ejercicio(ex_303, gimnasio).                  % Martillo Mancuerna
lugar_ejercicio(ex_303, hogar).
lugar_ejercicio(ex_304, gimnasio).                  % Curl Máquina

lugar_ejercicio(ex_401, gimnasio).                  % Fondos
lugar_ejercicio(ex_401, parque).
lugar_ejercicio(ex_402, gimnasio).                  % Extensión Polea
lugar_ejercicio(ex_403, gimnasio).                  % Extensión Mancuerna Sentado
lugar_ejercicio(ex_403, hogar).
lugar_ejercicio(ex_404, gimnasio).                  % Press Francés

lugar_ejercicio(ex_501, gimnasio).                  % Sentadilla Libre
lugar_ejercicio(ex_502, gimnasio).                  % Sentadilla Máquina
lugar_ejercicio(ex_503, gimnasio).                  % Leg Press
lugar_ejercicio(ex_504, gimnasio).                  % Sentadilla Goblet
lugar_ejercicio(ex_504, hogar).
lugar_ejercicio(ex_505, gimnasio).                  % Extensión Cuádriceps

lugar_ejercicio(ex_601, gimnasio).                  % Peso Muerto Rumano
lugar_ejercicio(ex_602, gimnasio).                  % Curl Isquiotibial
lugar_ejercicio(ex_603, gimnasio).                  % Hip Thrust
lugar_ejercicio(ex_603, hogar).
lugar_ejercicio(ex_603, parque).
lugar_ejercicio(ex_604, gimnasio).                  % Sentadilla Búlgara
lugar_ejercicio(ex_604, hogar).
lugar_ejercicio(ex_604, parque).
lugar_ejercicio(ex_605, gimnasio).                  % Elevación Pantorrilla
lugar_ejercicio(ex_605, hogar).
lugar_ejercicio(ex_605, parque).

lugar_ejercicio(ex_650, gimnasio).                  % Sentadilla Goblet
lugar_ejercicio(ex_650, hogar).
lugar_ejercicio(ex_651, gimnasio).                  % Peso Muerto Convencional
lugar_ejercicio(ex_652, gimnasio).                  % Leg Press Máquina
lugar_ejercicio(ex_653, gimnasio).                  % Hack Squat
lugar_ejercicio(ex_654, gimnasio).                  % Smith Machine Sentadilla

lugar_ejercicio(ex_701, gimnasio).                  % Planchas
lugar_ejercicio(ex_701, hogar).
lugar_ejercicio(ex_701, parque).
lugar_ejercicio(ex_702, gimnasio).                  % Abdominales Máquina
lugar_ejercicio(ex_703, gimnasio).                  % Crunches
lugar_ejercicio(ex_703, hogar).
lugar_ejercicio(ex_703, parque).
lugar_ejercicio(ex_704, gimnasio).                  % Cable Crunch

% --- PECHO ADICIONALES ---
lugar_ejercicio(ex_008, gimnasio).
lugar_ejercicio(ex_009, gimnasio).
lugar_ejercicio(ex_009, hogar).
lugar_ejercicio(ex_010, gimnasio).
lugar_ejercicio(ex_010, hogar).
lugar_ejercicio(ex_011, gimnasio).
lugar_ejercicio(ex_011, hogar).
lugar_ejercicio(ex_011, parque).
lugar_ejercicio(ex_012, gimnasio).
lugar_ejercicio(ex_012, hogar).
lugar_ejercicio(ex_012, parque).
lugar_ejercicio(ex_013, gimnasio).
lugar_ejercicio(ex_013, hogar).
lugar_ejercicio(ex_013, parque).
lugar_ejercicio(ex_014, gimnasio).
lugar_ejercicio(ex_015, gimnasio).
lugar_ejercicio(ex_016, gimnasio).
lugar_ejercicio(ex_017, gimnasio).
lugar_ejercicio(ex_018, gimnasio).
lugar_ejercicio(ex_019, gimnasio).
lugar_ejercicio(ex_019, parque).
lugar_ejercicio(ex_020, gimnasio).
lugar_ejercicio(ex_020, hogar).
lugar_ejercicio(ex_021, gimnasio).
lugar_ejercicio(ex_021, hogar).

% --- ESPALDA ADICIONALES ---
lugar_ejercicio(ex_108, gimnasio).
lugar_ejercicio(ex_108, parque).
lugar_ejercicio(ex_109, gimnasio).
lugar_ejercicio(ex_110, gimnasio).
lugar_ejercicio(ex_111, gimnasio).
lugar_ejercicio(ex_111, hogar).
lugar_ejercicio(ex_112, gimnasio).
lugar_ejercicio(ex_113, gimnasio).
lugar_ejercicio(ex_114, gimnasio).
lugar_ejercicio(ex_115, gimnasio).
lugar_ejercicio(ex_116, gimnasio).
lugar_ejercicio(ex_117, gimnasio).
lugar_ejercicio(ex_118, gimnasio).
lugar_ejercicio(ex_118, hogar).
lugar_ejercicio(ex_118, parque).
lugar_ejercicio(ex_119, gimnasio).
lugar_ejercicio(ex_120, gimnasio).
lugar_ejercicio(ex_121, gimnasio).

% --- HOMBROS ADICIONALES ---
lugar_ejercicio(ex_207, gimnasio).
lugar_ejercicio(ex_207, hogar).
lugar_ejercicio(ex_208, gimnasio).
lugar_ejercicio(ex_209, gimnasio).
lugar_ejercicio(ex_210, gimnasio).
lugar_ejercicio(ex_211, gimnasio).
lugar_ejercicio(ex_212, gimnasio).
lugar_ejercicio(ex_213, gimnasio).
lugar_ejercicio(ex_213, hogar).
lugar_ejercicio(ex_214, gimnasio).
lugar_ejercicio(ex_215, gimnasio).
lugar_ejercicio(ex_216, gimnasio).

% --- BÍCEPS ADICIONALES ---
lugar_ejercicio(ex_305, gimnasio).
lugar_ejercicio(ex_306, gimnasio).
lugar_ejercicio(ex_306, hogar).
lugar_ejercicio(ex_307, gimnasio).
lugar_ejercicio(ex_308, gimnasio).
lugar_ejercicio(ex_309, gimnasio).
lugar_ejercicio(ex_310, gimnasio).
lugar_ejercicio(ex_311, gimnasio).
lugar_ejercicio(ex_311, hogar).
lugar_ejercicio(ex_312, gimnasio).
lugar_ejercicio(ex_313, gimnasio).
lugar_ejercicio(ex_314, gimnasio).
lugar_ejercicio(ex_314, hogar).
lugar_ejercicio(ex_315, gimnasio).

% --- TRÍCEPS ADICIONALES ---
lugar_ejercicio(ex_405, gimnasio).
lugar_ejercicio(ex_405, hogar).
lugar_ejercicio(ex_406, gimnasio).
lugar_ejercicio(ex_407, gimnasio).
lugar_ejercicio(ex_407, hogar).
lugar_ejercicio(ex_407, parque).
lugar_ejercicio(ex_408, gimnasio).
lugar_ejercicio(ex_409, gimnasio).
lugar_ejercicio(ex_410, gimnasio).
lugar_ejercicio(ex_411, gimnasio).
lugar_ejercicio(ex_411, hogar).
lugar_ejercicio(ex_412, gimnasio).
lugar_ejercicio(ex_413, gimnasio).
lugar_ejercicio(ex_414, gimnasio).
lugar_ejercicio(ex_414, hogar).
lugar_ejercicio(ex_414, parque).
lugar_ejercicio(ex_415, gimnasio).

% --- PIERNAS ADICIONALES ---
lugar_ejercicio(ex_506, gimnasio).
lugar_ejercicio(ex_507, gimnasio).
lugar_ejercicio(ex_507, hogar).
lugar_ejercicio(ex_508, gimnasio).
lugar_ejercicio(ex_508, hogar).
lugar_ejercicio(ex_508, parque).
lugar_ejercicio(ex_509, gimnasio).
lugar_ejercicio(ex_510, gimnasio).
lugar_ejercicio(ex_606, gimnasio).
lugar_ejercicio(ex_606, hogar).
lugar_ejercicio(ex_607, gimnasio).
lugar_ejercicio(ex_607, hogar).
lugar_ejercicio(ex_608, gimnasio).
lugar_ejercicio(ex_609, gimnasio).
lugar_ejercicio(ex_610, gimnasio).
lugar_ejercicio(ex_611, gimnasio).
lugar_ejercicio(ex_612, gimnasio).
lugar_ejercicio(ex_613, gimnasio).
lugar_ejercicio(ex_613, hogar).
lugar_ejercicio(ex_613, parque).
lugar_ejercicio(ex_655, gimnasio).
lugar_ejercicio(ex_655, hogar).
lugar_ejercicio(ex_655, parque).
lugar_ejercicio(ex_656, gimnasio).
lugar_ejercicio(ex_656, hogar).
lugar_ejercicio(ex_657, gimnasio).
lugar_ejercicio(ex_658, gimnasio).
lugar_ejercicio(ex_659, gimnasio).
lugar_ejercicio(ex_660, gimnasio).
lugar_ejercicio(ex_661, gimnasio).
lugar_ejercicio(ex_661, hogar).
lugar_ejercicio(ex_661, parque).

% --- CORE ADICIONALES ---
lugar_ejercicio(ex_705, gimnasio).
lugar_ejercicio(ex_705, hogar).
lugar_ejercicio(ex_705, parque).
lugar_ejercicio(ex_706, gimnasio).
lugar_ejercicio(ex_706, hogar).
lugar_ejercicio(ex_707, gimnasio).
lugar_ejercicio(ex_708, gimnasio).
lugar_ejercicio(ex_708, parque).
lugar_ejercicio(ex_709, gimnasio).
lugar_ejercicio(ex_709, hogar).
lugar_ejercicio(ex_709, parque).
lugar_ejercicio(ex_710, gimnasio).
lugar_ejercicio(ex_710, hogar).
lugar_ejercicio(ex_710, parque).
lugar_ejercicio(ex_711, gimnasio).
lugar_ejercicio(ex_711, hogar).
lugar_ejercicio(ex_711, parque).
lugar_ejercicio(ex_712, gimnasio).
lugar_ejercicio(ex_713, gimnasio).
lugar_ejercicio(ex_713, hogar).
lugar_ejercicio(ex_713, parque).
lugar_ejercicio(ex_714, gimnasio).
lugar_ejercicio(ex_714, hogar).
lugar_ejercicio(ex_714, parque).
lugar_ejercicio(ex_715, gimnasio).
lugar_ejercicio(ex_715, hogar).
lugar_ejercicio(ex_715, parque).
lugar_ejercicio(ex_716, gimnasio).
lugar_ejercicio(ex_716, hogar).
lugar_ejercicio(ex_716, parque).

% --- CARDIO ---
lugar_ejercicio(ex_800, gimnasio).
lugar_ejercicio(ex_801, gimnasio).
lugar_ejercicio(ex_801, hogar).
lugar_ejercicio(ex_802, gimnasio).
lugar_ejercicio(ex_803, gimnasio).
lugar_ejercicio(ex_804, gimnasio).
lugar_ejercicio(ex_804, hogar).
lugar_ejercicio(ex_804, parque).
lugar_ejercicio(ex_805, gimnasio).
lugar_ejercicio(ex_805, hogar).
lugar_ejercicio(ex_805, parque).
lugar_ejercicio(ex_806, gimnasio).
lugar_ejercicio(ex_806, hogar).
lugar_ejercicio(ex_806, parque).
lugar_ejercicio(ex_807, gimnasio).
lugar_ejercicio(ex_807, hogar).
lugar_ejercicio(ex_807, parque).
lugar_ejercicio(ex_808, gimnasio).
lugar_ejercicio(ex_808, parque).
lugar_ejercicio(ex_809, gimnasio).
lugar_ejercicio(ex_810, gimnasio).
lugar_ejercicio(ex_811, gimnasio).
lugar_ejercicio(ex_812, gimnasio).
lugar_ejercicio(ex_812, parque).
lugar_ejercicio(ex_813, gimnasio).
lugar_ejercicio(ex_813, hogar).
lugar_ejercicio(ex_814, gimnasio).
lugar_ejercicio(ex_815, parque).

% --- MOVILIDAD ---  (disponible en los tres entornos)
lugar_ejercicio(ex_900, gimnasio). lugar_ejercicio(ex_900, hogar). lugar_ejercicio(ex_900, parque).
lugar_ejercicio(ex_901, gimnasio). lugar_ejercicio(ex_901, hogar). lugar_ejercicio(ex_901, parque).
lugar_ejercicio(ex_902, gimnasio). lugar_ejercicio(ex_902, hogar). lugar_ejercicio(ex_902, parque).
lugar_ejercicio(ex_903, gimnasio). lugar_ejercicio(ex_903, hogar). lugar_ejercicio(ex_903, parque).
lugar_ejercicio(ex_904, gimnasio). lugar_ejercicio(ex_904, hogar). lugar_ejercicio(ex_904, parque).
lugar_ejercicio(ex_905, gimnasio). lugar_ejercicio(ex_905, hogar). lugar_ejercicio(ex_905, parque).
lugar_ejercicio(ex_906, gimnasio). lugar_ejercicio(ex_906, hogar). lugar_ejercicio(ex_906, parque).
lugar_ejercicio(ex_907, gimnasio). lugar_ejercicio(ex_907, hogar). lugar_ejercicio(ex_907, parque).
lugar_ejercicio(ex_908, gimnasio). lugar_ejercicio(ex_908, hogar). lugar_ejercicio(ex_908, parque).
lugar_ejercicio(ex_909, gimnasio). lugar_ejercicio(ex_909, hogar). lugar_ejercicio(ex_909, parque).
lugar_ejercicio(ex_910, gimnasio). lugar_ejercicio(ex_910, hogar). lugar_ejercicio(ex_910, parque).
lugar_ejercicio(ex_911, gimnasio). lugar_ejercicio(ex_911, hogar). lugar_ejercicio(ex_911, parque).
lugar_ejercicio(ex_912, gimnasio). lugar_ejercicio(ex_912, hogar). lugar_ejercicio(ex_912, parque).
lugar_ejercicio(ex_913, gimnasio). lugar_ejercicio(ex_913, hogar). lugar_ejercicio(ex_913, parque).
lugar_ejercicio(ex_914, gimnasio). lugar_ejercicio(ex_914, hogar). lugar_ejercicio(ex_914, parque).
lugar_ejercicio(ex_915, gimnasio). lugar_ejercicio(ex_915, hogar). lugar_ejercicio(ex_915, parque).

% --- ACTIVACIÓN --- (disponible en los tres entornos salvo polea)
lugar_ejercicio(ex_950, gimnasio). lugar_ejercicio(ex_950, hogar). lugar_ejercicio(ex_950, parque).
lugar_ejercicio(ex_951, gimnasio). lugar_ejercicio(ex_951, hogar). lugar_ejercicio(ex_951, parque).
lugar_ejercicio(ex_952, gimnasio). lugar_ejercicio(ex_952, hogar). lugar_ejercicio(ex_952, parque).
lugar_ejercicio(ex_953, gimnasio). lugar_ejercicio(ex_953, hogar). lugar_ejercicio(ex_953, parque).
lugar_ejercicio(ex_954, gimnasio). lugar_ejercicio(ex_954, hogar). lugar_ejercicio(ex_954, parque).
lugar_ejercicio(ex_955, gimnasio).                                                             % polea
lugar_ejercicio(ex_956, gimnasio). lugar_ejercicio(ex_956, hogar). lugar_ejercicio(ex_956, parque).
lugar_ejercicio(ex_957, gimnasio). lugar_ejercicio(ex_957, hogar). lugar_ejercicio(ex_957, parque).
lugar_ejercicio(ex_958, gimnasio). lugar_ejercicio(ex_958, hogar). lugar_ejercicio(ex_958, parque).
lugar_ejercicio(ex_959, gimnasio). lugar_ejercicio(ex_959, hogar). lugar_ejercicio(ex_959, parque).
lugar_ejercicio(ex_960, gimnasio). lugar_ejercicio(ex_960, hogar). lugar_ejercicio(ex_960, parque).
lugar_ejercicio(ex_961, gimnasio). lugar_ejercicio(ex_961, hogar). lugar_ejercicio(ex_961, parque).
lugar_ejercicio(ex_962, gimnasio). lugar_ejercicio(ex_962, hogar). lugar_ejercicio(ex_962, parque).
lugar_ejercicio(ex_963, gimnasio). lugar_ejercicio(ex_963, hogar). lugar_ejercicio(ex_963, parque).
lugar_ejercicio(ex_964, gimnasio). lugar_ejercicio(ex_964, hogar). lugar_ejercicio(ex_964, parque).
lugar_ejercicio(ex_965, gimnasio). lugar_ejercicio(ex_965, hogar). lugar_ejercicio(ex_965, parque).

% =====================================================
% 20. TIEMPO DISPONIBLE PARA ENTRENAR
% =====================================================
% tiempo_sesion(Minutos, Etiqueta, Descripcion)
% Franjas de tiempo reconocidas por el sistema.

tiempo_sesion(30, corto,   'Sesión corta de 30 minutos').
tiempo_sesion(45, estandar,'Sesión estándar de 45 minutos').
tiempo_sesion(60, largo,   'Sesión larga de 60 minutos').
tiempo_sesion(90, completo,'Sesión completa de 90 minutos').

% ajuste_tiempo(Etiqueta, MaxEjercicios, MaxSeriesTotal, Accesorios, IncluirCardio)
% Define los límites de volumen que el sistema debe aplicar según el tiempo disponible.
%   MaxEjercicios  - Número máximo de ejercicios en la sesión
%   MaxSeriesTotal - Volumen máximo de series totales
%   Accesorios     - Cantidad de ejercicios accesorios permitidos (0 = ninguno)
%   IncluirCardio  - yes | no

ajuste_tiempo(corto,    4,  12, 0, no).
ajuste_tiempo(estandar, 5,  16, 1, no).
ajuste_tiempo(largo,    6,  20, 2, yes).
ajuste_tiempo(completo, 8,  28, 3, yes).

% tiempo_ejercicio_estimado(EjercicioID, MinutosPorEjercicio)
% Tiempo medio (en minutos) que ocupa un ejercicio, incluyendo descanso entre series.
% Se usa para estimar la duración total de la sesión generada.

tiempo_ejercicio_estimado(ex_001, 8).   % Press Banca        (3s × ~2,5 min)
tiempo_ejercicio_estimado(ex_002, 8).   % Press Inclinado
tiempo_ejercicio_estimado(ex_003, 5).   % Flexiones          (peso corporal, descanso corto)
tiempo_ejercicio_estimado(ex_004, 8).   % Press Mancuerna Plano
tiempo_ejercicio_estimado(ex_005, 6).   % Aperturas Máquina
tiempo_ejercicio_estimado(ex_006, 6).   % Aperturas Mancuerna
tiempo_ejercicio_estimado(ex_007, 6).   % Pec Deck
tiempo_ejercicio_estimado(ex_101, 10).  % Peso Muerto        (descanso largo)
tiempo_ejercicio_estimado(ex_102, 8).   % Remo Barra
tiempo_ejercicio_estimado(ex_103, 7).   % Jalón Frente
tiempo_ejercicio_estimado(ex_104, 7).   % Remo Máquina
tiempo_ejercicio_estimado(ex_105, 7).   % Remo Unilateral
tiempo_ejercicio_estimado(ex_106, 7).   % Pull Over
tiempo_ejercicio_estimado(ex_107, 6).   % Jalón Asistido
tiempo_ejercicio_estimado(ex_201, 8).   % Press Militar
tiempo_ejercicio_estimado(ex_202, 7).   % Press Mancuerna Sentado
tiempo_ejercicio_estimado(ex_203, 7).   % Press Pike Máquina
tiempo_ejercicio_estimado(ex_204, 5).   % Elevación Frontal
tiempo_ejercicio_estimado(ex_205, 5).   % Elevación Lateral
tiempo_ejercicio_estimado(ex_206, 5).   % Shrugs Mancuerna
tiempo_ejercicio_estimado(ex_301, 6).   % Curl Barra
tiempo_ejercicio_estimado(ex_302, 6).   % Curl Mancuerna
tiempo_ejercicio_estimado(ex_303, 6).   % Martillo Mancuerna
tiempo_ejercicio_estimado(ex_304, 6).   % Curl Máquina
tiempo_ejercicio_estimado(ex_401, 7).   % Fondos
tiempo_ejercicio_estimado(ex_402, 6).   % Extensión Polea
tiempo_ejercicio_estimado(ex_403, 6).   % Extensión Mancuerna Sentado
tiempo_ejercicio_estimado(ex_404, 7).   % Press Francés
tiempo_ejercicio_estimado(ex_501, 10).  % Sentadilla Libre   (descanso largo)
tiempo_ejercicio_estimado(ex_502, 8).   % Sentadilla Máquina
tiempo_ejercicio_estimado(ex_503, 8).   % Leg Press
tiempo_ejercicio_estimado(ex_504, 7).   % Sentadilla Goblet
tiempo_ejercicio_estimado(ex_505, 6).   % Extensión Cuádriceps
tiempo_ejercicio_estimado(ex_601, 8).   % Peso Muerto Rumano
tiempo_ejercicio_estimado(ex_602, 6).   % Curl Isquiotibial
tiempo_ejercicio_estimado(ex_603, 6).   % Hip Thrust
tiempo_ejercicio_estimado(ex_604, 7).   % Sentadilla Búlgara
tiempo_ejercicio_estimado(ex_605, 5).   % Elevación Pantorrilla
tiempo_ejercicio_estimado(ex_650, 7).   % Sentadilla Goblet (piernas)
tiempo_ejercicio_estimado(ex_651, 9).   % Peso Muerto Convencional
tiempo_ejercicio_estimado(ex_652, 8).   % Leg Press Máquina
tiempo_ejercicio_estimado(ex_653, 8).   % Hack Squat
tiempo_ejercicio_estimado(ex_654, 8).   % Smith Machine Sentadilla
tiempo_ejercicio_estimado(ex_701, 5).   % Planchas
tiempo_ejercicio_estimado(ex_702, 5).   % Abdominales Máquina
tiempo_ejercicio_estimado(ex_703, 4).   % Crunches
tiempo_ejercicio_estimado(ex_704, 5).   % Cable Crunch

% --- PECHO ADICIONALES ---
tiempo_ejercicio_estimado(ex_008, 8).   % Press Declinado Barra
tiempo_ejercicio_estimado(ex_009, 7).   % Press Mancuerna Inclinado
tiempo_ejercicio_estimado(ex_010, 7).   % Press Mancuerna Declinado
tiempo_ejercicio_estimado(ex_011, 4).   % Flexiones Inclinadas
tiempo_ejercicio_estimado(ex_012, 4).   % Flexiones Diamante
tiempo_ejercicio_estimado(ex_013, 5).   % Flexiones Archer
tiempo_ejercicio_estimado(ex_014, 5).   % Aperturas Cable Polea Media
tiempo_ejercicio_estimado(ex_015, 5).   % Aperturas Cable Polea Alta
tiempo_ejercicio_estimado(ex_016, 5).   % Aperturas Cable Polea Baja
tiempo_ejercicio_estimado(ex_017, 6).   % Press Máquina Pecho
tiempo_ejercicio_estimado(ex_018, 6).   % Press Máquina Inclinado
tiempo_ejercicio_estimado(ex_019, 7).   % Fondos Pecho
tiempo_ejercicio_estimado(ex_020, 6).   % Pull Over Mancuerna
tiempo_ejercicio_estimado(ex_021, 5).   % Svend Press

% --- ESPALDA ADICIONALES ---
tiempo_ejercicio_estimado(ex_108, 8).   % Dominadas
tiempo_ejercicio_estimado(ex_109, 7).   % Dominadas Asistidas
tiempo_ejercicio_estimado(ex_110, 7).   % Remo Cable Sentado
tiempo_ejercicio_estimado(ex_111, 7).   % Remo Mancuerna
tiempo_ejercicio_estimado(ex_112, 8).   % Remo T-Bar
tiempo_ejercicio_estimado(ex_113, 7).   % Jalón Agarre Neutro
tiempo_ejercicio_estimado(ex_114, 7).   % Jalón Detrás Nuca
tiempo_ejercicio_estimado(ex_115, 6).   % Remo Cable Unilateral
tiempo_ejercicio_estimado(ex_116, 5).   % Face Pull
tiempo_ejercicio_estimado(ex_117, 10).  % Peso Muerto Sumo
tiempo_ejercicio_estimado(ex_118, 4).   % Superman
tiempo_ejercicio_estimado(ex_119, 5).   % Extensiones Lumbares
tiempo_ejercicio_estimado(ex_120, 8).   % Remo Pendlay
tiempo_ejercicio_estimado(ex_121, 7).   % Jalón Polea Baja

% --- HOMBROS ADICIONALES ---
tiempo_ejercicio_estimado(ex_207, 7).   % Press Arnold
tiempo_ejercicio_estimado(ex_208, 6).   % Press Máquina Hombros
tiempo_ejercicio_estimado(ex_209, 5).   % Elevación Lateral Cable
tiempo_ejercicio_estimado(ex_210, 5).   % Elevación Frontal Cable
tiempo_ejercicio_estimado(ex_211, 5).   % Shrugs Barra
tiempo_ejercicio_estimado(ex_212, 5).   % Face Pull Hombro Posterior
tiempo_ejercicio_estimado(ex_213, 5).   % Pájaros Mancuerna
tiempo_ejercicio_estimado(ex_214, 5).   % Pájaros Cable
tiempo_ejercicio_estimado(ex_215, 7).   % Press Landmine Hombro
tiempo_ejercicio_estimado(ex_216, 5).   % Elevación Lateral Máquina

% --- BÍCEPS ADICIONALES ---
tiempo_ejercicio_estimado(ex_305, 6).   % Curl Predicador
tiempo_ejercicio_estimado(ex_306, 6).   % Curl Concentración
tiempo_ejercicio_estimado(ex_307, 5).   % Curl Cable
tiempo_ejercicio_estimado(ex_308, 6).   % Curl Inverso Barra
tiempo_ejercicio_estimado(ex_309, 6).   % Curl Araña
tiempo_ejercicio_estimado(ex_310, 6).   % Curl Barra Z
tiempo_ejercicio_estimado(ex_311, 6).   % Curl Inclinado Mancuerna
tiempo_ejercicio_estimado(ex_312, 5).   % Curl Polea Alta
tiempo_ejercicio_estimado(ex_313, 7).   % Curl 21s Barra
tiempo_ejercicio_estimado(ex_314, 6).   % Curl Mancuerna Banco Inclinado
tiempo_ejercicio_estimado(ex_315, 5).   % Curl Cuerda Cable

% --- TRÍCEPS ADICIONALES ---
tiempo_ejercicio_estimado(ex_405, 5).   % Patada Tríceps Mancuerna
tiempo_ejercicio_estimado(ex_406, 5).   % Patada Tríceps Cable
tiempo_ejercicio_estimado(ex_407, 6).   % Fondos en Banco
tiempo_ejercicio_estimado(ex_408, 7).   % Press Cerrado Barra
tiempo_ejercicio_estimado(ex_409, 6).   % Press Cerrado Máquina
tiempo_ejercicio_estimado(ex_410, 5).   % Extensión Polea Alta Cuerda
tiempo_ejercicio_estimado(ex_411, 6).   % Extensión Mancuerna Acostado
tiempo_ejercicio_estimado(ex_412, 5).   % Extensión Cable sobre Cabeza
tiempo_ejercicio_estimado(ex_413, 6).   % Press Francés Cable
tiempo_ejercicio_estimado(ex_414, 4).   % Flexiones Diamante Tríceps
tiempo_ejercicio_estimado(ex_415, 5).   % Extensión Polea Reversa

% --- PIERNAS ADICIONALES ---
tiempo_ejercicio_estimado(ex_506, 10).  % Sentadilla Frontal
tiempo_ejercicio_estimado(ex_507, 7).   % Zancada Mancuernas
tiempo_ejercicio_estimado(ex_508, 6).   % Step Up Banco
tiempo_ejercicio_estimado(ex_509, 8).   % Prensa Unipodal
tiempo_ejercicio_estimado(ex_510, 5).   % Extensión Cuádriceps Unilateral
tiempo_ejercicio_estimado(ex_606, 7).   % Peso Muerto Sumo Mancuernas
tiempo_ejercicio_estimado(ex_607, 7).   % Curl Isquiotibial Nórdico
tiempo_ejercicio_estimado(ex_608, 8).   % Buenos Días Barra
tiempo_ejercicio_estimado(ex_609, 6).   % Patada Glúteo Cable
tiempo_ejercicio_estimado(ex_610, 5).   % Abducción Cadera Máquina
tiempo_ejercicio_estimado(ex_611, 5).   % Aducción Cadera Máquina
tiempo_ejercicio_estimado(ex_612, 5).   % Elevación Pantorrilla Sentado
tiempo_ejercicio_estimado(ex_613, 5).   % Elevación Pantorrilla Unilateral
tiempo_ejercicio_estimado(ex_655, 7).   % Zancada Caminando
tiempo_ejercicio_estimado(ex_656, 7).   % Sentadilla Sumo
tiempo_ejercicio_estimado(ex_657, 10).  % Sentadilla Pausa
tiempo_ejercicio_estimado(ex_658, 10).  % Box Squat
tiempo_ejercicio_estimado(ex_659, 9).   % Peso Muerto Trap Bar
tiempo_ejercicio_estimado(ex_660, 10).  % Sentadilla Zercher
tiempo_ejercicio_estimado(ex_661, 7).   % Sentadilla con Salto

% --- CORE ADICIONALES ---
tiempo_ejercicio_estimado(ex_705, 4).   % Plancha Lateral
tiempo_ejercicio_estimado(ex_706, 6).   % Rueda Abdominal
tiempo_ejercicio_estimado(ex_707, 7).   % Dragon Flag
tiempo_ejercicio_estimado(ex_708, 6).   % Elevación de Piernas Colgado
tiempo_ejercicio_estimado(ex_709, 5).   % Plancha con Toque Hombro
tiempo_ejercicio_estimado(ex_710, 5).   % Rotación Rusa
tiempo_ejercicio_estimado(ex_711, 4).   % Dead Bug
tiempo_ejercicio_estimado(ex_712, 5).   % Pallof Press
tiempo_ejercicio_estimado(ex_713, 4).   % Crunch Bicicleta
tiempo_ejercicio_estimado(ex_714, 4).   % Elevación de Piernas Tumbado
tiempo_ejercicio_estimado(ex_715, 4).   % Hollow Hold
tiempo_ejercicio_estimado(ex_716, 5).   % V-Ups

% --- CARDIO ---
tiempo_ejercicio_estimado(ex_800, 20).  % Cinta de Correr
tiempo_ejercicio_estimado(ex_801, 20).  % Bicicleta Estática
tiempo_ejercicio_estimado(ex_802, 20).  % Elíptica
tiempo_ejercicio_estimado(ex_803, 15).  % Remo Ergómetro
tiempo_ejercicio_estimado(ex_804, 10).  % Salto a la Comba
tiempo_ejercicio_estimado(ex_805, 8).   % Burpees
tiempo_ejercicio_estimado(ex_806, 6).   % Mountain Climbers
tiempo_ejercicio_estimado(ex_807, 5).   % Jumping Jacks
tiempo_ejercicio_estimado(ex_808, 10).  % Sprints
tiempo_ejercicio_estimado(ex_809, 20).  % HIIT en Cinta
tiempo_ejercicio_estimado(ex_810, 15).  % Escalador de Escaleras
tiempo_ejercicio_estimado(ex_811, 8).   % Battle Ropes
tiempo_ejercicio_estimado(ex_812, 8).   % Saltos al Cajón
tiempo_ejercicio_estimado(ex_813, 8).   % Kettlebell Swing
tiempo_ejercicio_estimado(ex_814, 20).  % Air Bike
tiempo_ejercicio_estimado(ex_815, 30).  % Natación

% --- MOVILIDAD ---
tiempo_ejercicio_estimado(ex_900, 3).   % Estiramiento de Pecho
tiempo_ejercicio_estimado(ex_901, 3).   % Estiramiento Isquiotibial
tiempo_ejercicio_estimado(ex_902, 3).   % Postura del Niño
tiempo_ejercicio_estimado(ex_903, 3).   % Paloma
tiempo_ejercicio_estimado(ex_904, 3).   % Rotación Torácica
tiempo_ejercicio_estimado(ex_905, 3).   % Apertura Cadera Mariposa
tiempo_ejercicio_estimado(ex_906, 3).   % Estiramiento Cuádriceps
tiempo_ejercicio_estimado(ex_907, 3).   % Gato-Vaca
tiempo_ejercicio_estimado(ex_908, 3).   % Apertura Hombros con Banda
tiempo_ejercicio_estimado(ex_909, 3).   % Hip 90/90
tiempo_ejercicio_estimado(ex_910, 4).   % Cossack Squat
tiempo_ejercicio_estimado(ex_911, 3).   % Estiramiento Tríceps
tiempo_ejercicio_estimado(ex_912, 3).   % Rotación de Cadera
tiempo_ejercicio_estimado(ex_913, 3).   % Extensión Dorsal
tiempo_ejercicio_estimado(ex_914, 3).   % Estiramiento Pantorrilla
tiempo_ejercicio_estimado(ex_915, 3).   % Pec Minor Stretch

% --- ACTIVACIÓN ---
tiempo_ejercicio_estimado(ex_950, 4).   % Glute Bridge
tiempo_ejercicio_estimado(ex_951, 4).   % Clamshells con Banda
tiempo_ejercicio_estimado(ex_952, 4).   % Monster Walks con Banda
tiempo_ejercicio_estimado(ex_953, 4).   % Rotación Externa Cadera
tiempo_ejercicio_estimado(ex_954, 4).   % Activación Manguito Rotador
tiempo_ejercicio_estimado(ex_955, 4).   % Face Pull Activación
tiempo_ejercicio_estimado(ex_956, 4).   % Band Pull Apart
tiempo_ejercicio_estimado(ex_957, 4).   % Pullover con Banda
tiempo_ejercicio_estimado(ex_958, 4).   % Press Pecho con Banda
tiempo_ejercicio_estimado(ex_959, 3).   % Activación Isquiotibial
tiempo_ejercicio_estimado(ex_960, 4).   % Remo con Banda
tiempo_ejercicio_estimado(ex_961, 4).   % Plancha Elevación Cadera
tiempo_ejercicio_estimado(ex_962, 4).   % Dead Bug Activación
tiempo_ejercicio_estimado(ex_963, 5).   % Bear Crawl
tiempo_ejercicio_estimado(ex_964, 4).   % Inchworm
tiempo_ejercicio_estimado(ex_965, 3).   % Activación Core Respiración

% =====================================================
% HECHOS ADICIONALES PARA CONTEXTO
% =====================================================

% Estado del sistema experto
estado_sistema(activo).
ultima_actualizacion('2024-06-02').
version_base_conocimiento('1.0').
% =====================================================
% MAPEO DE GRUPOS A MÚSCULOS
% =====================================================

grupo_musculos(pecho,
    [pecho,triceps,deltoides_anterior]).

grupo_musculos(espalda,
    [dorsales,trapecio,romboides,biceps,deltoides_posterior]).

grupo_musculos(hombros,
    [deltoides_anterior,deltoides_lateral,deltoides_posterior,triceps]).

grupo_musculos(biceps,
    [biceps]).

grupo_musculos(triceps,
    [triceps]).

grupo_musculos(cuadriceps,
    [cuadriceps,gluteos]).

grupo_musculos(isquiotibial,
    [isquiotibiales,gluteos]).

grupo_musculos(gluteos,
    [gluteos,isquiotibiales]).

grupo_musculos(piernas,
    [cuadriceps,isquiotibiales,gluteos,pantorrillas]).

grupo_musculos(core,
    [abdominales,lumbares]).
% =====================================================
% RECUPERACIÓN MUSCULAR
% =====================================================

recuperacion_musculo(pecho,48).
recuperacion_musculo(triceps,48).

recuperacion_musculo(biceps,48).

recuperacion_musculo(deltoides_anterior,48).
recuperacion_musculo(deltoides_lateral,48).
recuperacion_musculo(deltoides_posterior,48).

recuperacion_musculo(dorsales,48).
recuperacion_musculo(trapecio,48).
recuperacion_musculo(romboides,48).

recuperacion_musculo(cuadriceps,72).
recuperacion_musculo(isquiotibiales,72).
recuperacion_musculo(gluteos,72).

recuperacion_musculo(pantorrillas,48).

recuperacion_musculo(abdominales,24).
recuperacion_musculo(lumbares,48).

% Asociación entre grupos musculares y ejercicios de movilidad recomendados
movilidad_para_grupo(pecho,        ex_900).   % Estiramiento de Pecho en Marco
movilidad_para_grupo(pecho,        ex_915).   % Pec Minor Stretch
movilidad_para_grupo(espalda,      ex_904).   % Rotación Torácica
movilidad_para_grupo(espalda,      ex_913).   % Extensión Dorsal en Suelo
movilidad_para_grupo(hombros,      ex_908).   % Apertura de Hombros con Banda
movilidad_para_grupo(biceps,       ex_911).   % Estiramiento de Tríceps (antagonista)
movilidad_para_grupo(triceps,      ex_911).   % Estiramiento de Tríceps
movilidad_para_grupo(cuadriceps,   ex_906).   % Estiramiento Cuádriceps de Pie
movilidad_para_grupo(cuadriceps,   ex_910).   % Cossack Squat
movilidad_para_grupo(isquiotibial, ex_901).   % Estiramiento Isquiotibial de Pie
movilidad_para_grupo(isquiotibial, ex_903).   % Paloma
movilidad_para_grupo(gluteos,      ex_905).   % Apertura de Cadera Mariposa
movilidad_para_grupo(gluteos,      ex_909).   % Hip 90/90
movilidad_para_grupo(piernas,      ex_901).   % Estiramiento Isquiotibial de Pie
movilidad_para_grupo(piernas,      ex_906).   % Estiramiento Cuádriceps de Pie
movilidad_para_grupo(piernas,      ex_912).   % Rotación de Cadera en Suelo
movilidad_para_grupo(pantorrilla,  ex_914).   % Estiramiento de Pantorrilla en Pared
movilidad_para_grupo(core,         ex_907).   % Gato-Vaca
movilidad_para_grupo(core,         ex_902).   % Postura del Niño
