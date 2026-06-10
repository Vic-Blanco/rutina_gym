% =====================================================
% REGLAS DE INFERENCIA Y LÓGICA EXPERTA
% =====================================================
% Define las reglas para generación, validación y razonamiento de rutinas

:- include('knowledge_base.pl').

% =====================================================
% 1. SELECCIÓN DE DIVISIÓN DE RUTINA
% =====================================================

% Regla: Seleccionar división automáticamente según días disponibles
seleccionar_division(UsuarioID, Division) :-
    usuario(UsuarioID, _, _, _, DiasDisponibles, _, _),
    division_rutina(Division, DiasRecomendados, _),
    member(DiasDisponibles, DiasRecomendados),
    !.

% Si no hay coincidencia exacta, usar la más cercana
seleccionar_division(UsuarioID, 'Full Body') :-
    usuario(UsuarioID, _, _, _, DiasDisponibles, _, _),
    DiasDisponibles =< 3,
    !.

seleccionar_division(UsuarioID, 'Torso-Pierna') :-
    usuario(UsuarioID, _, _, _, DiasDisponibles, _, _),
    DiasDisponibles = 4,
    !.

seleccionar_division(UsuarioID, 'Push-Pull-Legs') :-
    usuario(UsuarioID, _, _, _, DiasDisponibles, _, _),
    DiasDisponibles = 5,
    !.

seleccionar_division(UsuarioID, 'Weider') :-
    usuario(UsuarioID, _, _, _, DiasDisponibles, _, _),
    DiasDisponibles >= 6,
    !.

% =====================================================
% 2. SELECCIÓN DE EJERCICIOS VÁLIDOS
% =====================================================

% Ejercicio válido para usuario: debe cumplir nivel mínimo
ejercicio_valido_para_usuario(UsuarioID, EjercicioID) :-
    usuario(UsuarioID, _, Nivel, _, _, _, _),
    ejercicio(EjercicioID, _, _, _, _, NivelMinimo),
    nivel_suficiente(Nivel, NivelMinimo).

% Verificar que el usuario tiene nivel suficiente
nivel_suficiente(principiante, principiante) :- !.
nivel_suficiente(intermedio, principiante) :- !.
nivel_suficiente(intermedio, intermedio) :- !.
nivel_suficiente(avanzado, principiante) :- !.
nivel_suficiente(avanzado, intermedio) :- !.
nivel_suficiente(avanzado, avanzado) :- !.

% Ejercicio para grupo muscular específico
ejercicio_para_grupo(EjercicioID, GrupoMuscular) :-
    ejercicio(EjercicioID, _, GrupoMuscular, _, _, _).

% Ejercicios compuestos (para principiantes, priorizan estos)
ejercicio_compuesto(EjercicioID) :-
    ejercicio(EjercicioID, _, _, compuesto, _, _).

% Ejercicios aislados (complementarios)
ejercicio_aislado(EjercicioID) :-
    ejercicio(EjercicioID, _, _, aislado, _, _).

% =====================================================
% 3. PARÁMETROS DE ENTRENAMIENTO
% =====================================================

% Obtener parámetros recomendados según objetivo
obtener_parametros_objetivo(UsuarioID, RepMin, RepMax, Series, Descanso, Intensidad) :-
    usuario(UsuarioID, _, _, Objetivo, _, _, _),
    objetivo(Objetivo, RepMin, RepMax, Series, Descanso, Intensidad).

% =====================================================
% 4. LÓGICA DE PRIORIDADES
% =====================================================

% Grupo muscular tiene prioridad
es_prioritario(UsuarioID, GrupoMuscular) :-
    usuario(UsuarioID, _, _, _, _, _, GrupoPrioritario),
    GrupoPrioritario = GrupoMuscular,
    !.

% Volumen adicional para grupo prioritario
volumen_adicional_prioritario(GrupoMuscular, SeriesAdicionales) :-
    es_prioritario(_, GrupoMuscular),
    SeriesAdicionales is 2.

% =====================================================
% 5. GENERACIÓN DE RUTINA SEMANAL
% =====================================================

% Generar rutina completa para usuario (estructura sesion/3)
generar_rutina_semanal(UsuarioID, Division, Rutina) :-
    usuario(UsuarioID, _, Nivel, Objetivo, _, _, _),
    findall(
        dia(Dia, Sesion),
        (distribucion(Division, Dia, GruposEnDia),
         generar_dia_desde_parametros(Nivel, Objetivo, Dia, GruposEnDia, auto, Sesion)),
        Rutina
    ).

% =====================================================
% GENERACIÓN AUTOMÁTICA vs PERSONALIZADA
% =====================================================

% Generar rutina automática: Prolog selecciona división y grupos basada en días.
% La entrada en calor se elige automáticamente según los grupos del día.
generar_rutina_automatica(UsuarioID, Nivel, Objetivo, Dias, Rutina) :-
    seleccionar_grupos_para_dias(Dias, GruposMusculares),
    generar_rutina_desde_parametros(UsuarioID, Nivel, Objetivo, Dias, GruposMusculares, auto, Rutina).

% Seleccionar grupos automáticamente según días disponibles
seleccionar_grupos_para_dias(Dias, [pecho, espalda, hombros, biceps, triceps, core]) :-
    Dias =< 3, !.

seleccionar_grupos_para_dias(4, [pecho, espalda, cuadriceps, isquiotibial, gluteos, core]) :- !.

seleccionar_grupos_para_dias(Dias, [pecho, espalda, hombros, biceps, triceps, cuadriceps, isquiotibial, gluteos, core]) :-
    Dias >= 5, !.

% Generar rutina personalizada con tipo de entrada en calor elegido por el usuario.
% TipoEntradaCalor: cardio_ligero | movilidad_dinamica | activacion_muscular
generar_rutina_personalizada(UsuarioID, Nivel, Objetivo, Dias, GruposMusculares, TipoEntradaCalor, Rutina) :-
    tipo_entrada_calor(TipoEntradaCalor, _),
    generar_rutina_desde_parametros(UsuarioID, Nivel, Objetivo, Dias, GruposMusculares, TipoEntradaCalor, Rutina).

% Versión sin tipo explícito: usa selección automática de entrada en calor
generar_rutina_personalizada(UsuarioID, Nivel, Objetivo, Dias, GruposMusculares, Rutina) :-
    generar_rutina_desde_parametros(UsuarioID, Nivel, Objetivo, Dias, GruposMusculares, auto, Rutina).

% =====================================================
% GENERADOR PRINCIPAL - No depende de KB de usuario
% =====================================================

% Generar rutina completa desde parámetros explícitos (sin leer usuario de KB)
% TipoEntradaCalor: auto | cardio_ligero | movilidad_dinamica | activacion_muscular
generar_rutina_desde_parametros(_UsuarioID, Nivel, Objetivo, Dias, GruposMusculares, TipoEntradaCalor, Rutina) :-
    generar_dias_rutina(Nivel, Objetivo, Dias, GruposMusculares, TipoEntradaCalor, 1, Rutina).

% Cláusula de compatibilidad hacia atrás: usa entrada en calor automática
generar_rutina_desde_parametros(UsuarioID, Nivel, Objetivo, Dias, GruposMusculares, Rutina) :-
    generar_rutina_desde_parametros(UsuarioID, Nivel, Objetivo, Dias, GruposMusculares, auto, Rutina).

% Generar lista de días recursivamente
generar_dias_rutina(_, _, Dias, _, _, DiaCurrent, []) :-
    DiaCurrent > Dias, !.

generar_dias_rutina(Nivel, Objetivo, Dias, GruposMusculares, TipoEntradaCalor, DiaCurrent,
                    [dia(DiaCurrent, Sesion) | RestoDias]) :-
    generar_dia_desde_parametros(Nivel, Objetivo, DiaCurrent, GruposMusculares, TipoEntradaCalor, Sesion),
    DiaSiguiente is DiaCurrent + 1,
    generar_dias_rutina(Nivel, Objetivo, Dias, GruposMusculares, TipoEntradaCalor, DiaSiguiente, RestoDias).

% Generar un día completo con estructura sesion/3:
%   sesion(EntradaCalor, Movilidad, Principales)
%   - EntradaCalor : ejercicio_info/5  — 1 ejercicio de calentamiento
%   - Movilidad    : lista de 3 ejercicios de movilidad/flexibilidad
%   - Principales  : lista de grupo_ejercicios/2 con 5-6 ejercicios en total
generar_dia_desde_parametros(Nivel, Objetivo, Dia, GruposMusculares, TipoEntradaCalor,
                              sesion(EntradaCalor, EjMovilidad, EjPrincipales)) :-
    % 1. Entrada en calor (1 ejercicio)
    seleccionar_entrada_calor(TipoEntradaCalor, GruposMusculares, EntradaCalor),
    % 2. Movilidad (3 ejercicios relevantes al día, rotados por número de día)
    seleccionar_movilidad_dia(GruposMusculares, Dia, 3, EjMovilidad),
    % 3. Ejercicios principales (5-6 totales, priorizando compuestos, rotados por día)
    findall(
        grupo_ejercicios(Grupo, Ejercicios),
        (member(Grupo, GruposMusculares),
         generar_ejercicios_desde_parametros(Nivel, Objetivo, Dia, Grupo, Ejercicios)),
        EjerciciosPorGrupo
    ),
    seleccionar_principales(EjerciciosPorGrupo, EjPrincipales),
    !.

% =====================================================
% SELECCIÓN DE EJERCICIOS PRINCIPALES - Entre 5 y 6 por día
% =====================================================

% Seleccionar 5-6 ejercicios principales priorizando compuestos (máx 4) + aislados
seleccionar_principales(GruposEjercicios, GruposLimitados) :-
    % Convertir grupos a lista plana con etiqueta de grupo
    findall(
        Grupo-Ejercicio,
        (member(grupo_ejercicios(Grupo, Ejercicios), GruposEjercicios),
         member(Ejercicio, Ejercicios)),
        EjerciciosPlanos
    ),
    % Separar compuestos de aislados (los compuestos tienen prioridad)
    separar_ejercicios(EjerciciosPlanos, Compuestos, Aislados),
    % Máximo 4 compuestos; completar con aislados hasta llegar a 6
    take(4, Compuestos, CompuestosSeleccionados),
    length(CompuestosSeleccionados, NumCompSelec),
    Disponibles is 6 - NumCompSelec,
    (Disponibles > 0 ->
        take(Disponibles, Aislados, AisladosSeleccionados)
    ;   AisladosSeleccionados = []),
    append(CompuestosSeleccionados, AisladosSeleccionados, EjerciciosSeleccionados),
    % Reconstruir estructura de grupos
    agrupar_ejercicios(EjerciciosSeleccionados, GruposEjercicios, GruposLimitados).

% Separar ejercicios en compuestos y aislados
separar_ejercicios([], [], []) :- !.
separar_ejercicios([Grupo-Ejer|Rest], [Grupo-Ejer|Compuestos], Aislados) :-
    Ejer = ejercicio_info(EjercicioID, _, _, _, _),
    ejercicio_compuesto(EjercicioID), !,
    separar_ejercicios(Rest, Compuestos, Aislados).
separar_ejercicios([EjerPair|Rest], Compuestos, [EjerPair|Aislados]) :-
    separar_ejercicios(Rest, Compuestos, Aislados).

% Tomar primeros N elementos de una lista
take(0, _, []) :- !.
take(_, [], []) :- !.
take(N, [H|T], [H|Rest]) :-
    N > 0,
    N1 is N - 1,
    take(N1, T, Rest).

% Rotar lista N posiciones hacia la izquierda
rotate_list(_, 0, List, List) :- !.
rotate_list(_, _, [], []) :- !.
rotate_list(Total, N, [H|T], Rotated) :-
    N > 0,
    N1 is N - 1,
    append(T, [H], Shifted),
    rotate_list(Total, N1, Shifted, Rotated).

% Agrupar ejercicios seleccionados de vuelta en estructura de grupos
agrupar_ejercicios(EjerciciosSeleccionados, GruposOriginales, GruposLimitados) :-
    findall(
        grupo_ejercicios(Grupo, EjerciciosFiltrados),
        (member(grupo_ejercicios(Grupo, _), GruposOriginales),
         findall(
            Ejer,
            (member(Grupo-Ejer, EjerciciosSeleccionados)),
            EjerciciosFiltrados
         ),
         EjerciciosFiltrados \= []),  % Solo incluir grupos que tengan ejercicios
        GruposLimitados
    ).

% Generar ejercicios para grupo con rotación según día (5-arity)
generar_ejercicios_desde_parametros(Nivel, Objetivo, Dia, GrupoMuscular, ListaEjerciciosLimitada) :-
    objetivo(Objetivo, RepMin, RepMax, SeriesBase, DescansoBase, _), !,
    findall(
        ejercicio_info(EjercicioID, Nombre, Series, Reps, Descanso),
        (ejercicio(EjercicioID, Nombre, GrupoMuscular, _, _, NivelMinimo),
         nivel_suficiente(Nivel, NivelMinimo),
         Reps is RepMin + (RepMax - RepMin) // 2,
         (ejercicio_compuesto(EjercicioID) -> Series = SeriesBase ; Series is SeriesBase - 1),
         Descanso = DescansoBase),
        ListaEjercicios
    ),
    list_to_set(ListaEjercicios, DedupEjercicios),
    length(DedupEjercicios, Total),
    (Total =< 4 ->
        ListaEjerciciosLimitada = DedupEjercicios
    ;
        Offset is ((Dia - 1) * 3) mod Total,
        rotate_list(Total, Offset, DedupEjercicios, Rotados),
        take(4, Rotados, ListaEjerciciosLimitada)
    ).

% Fallback 5-arity
generar_ejercicios_desde_parametros(_, _, _, _, []).

% Versión 4-arity por compatibilidad (usa día 1, sin rotación)
generar_ejercicios_desde_parametros(Nivel, Objetivo, GrupoMuscular, ListaEjerciciosLimitada) :-
    objetivo(Objetivo, RepMin, RepMax, SeriesBase, DescansoBase, _), !,
    findall(
        ejercicio_info(EjercicioID, Nombre, Series, Reps, Descanso),
        (ejercicio(EjercicioID, Nombre, GrupoMuscular, _, _, NivelMinimo),
         nivel_suficiente(Nivel, NivelMinimo),
         Reps is RepMin + (RepMax - RepMin) // 2,
         (ejercicio_compuesto(EjercicioID) -> Series = SeriesBase ; Series is SeriesBase - 1),
         Descanso = DescansoBase),
        ListaEjercicios
    ),
    % Deduplicar y limitar a máximo 4 ejercicios por grupo
    list_to_set(ListaEjercicios, DedupEjercicios),
    take(4, DedupEjercicios, ListaEjerciciosLimitada).

% Generar plan de un día específico
generar_dia(UsuarioID, Dia, GruposEnDia, EjerciciosPorGrupo) :-
    findall(
        grupo_ejercicios(Grupo, Ejercicios),
        (member(Grupo, GruposEnDia),
         generar_ejercicios_grupo(UsuarioID, Grupo, Ejercicios)),
        EjerciciosPorGrupo
    ).

% Generar ejercicios para un grupo muscular
generar_ejercicios_grupo(UsuarioID, GrupoMuscular, ListaEjercicios) :-
    usuario(UsuarioID, _, _, _, _, _, _),
    findall(
        ejercicio_info(EjercicioID, Nombre, Series, Reps, Descanso),
        (ejercicio_valido_para_usuario(UsuarioID, EjercicioID),
         ejercicio(EjercicioID, Nombre, GrupoMuscular, _, _, _),
         obtener_parametros_ejercicio(UsuarioID, EjercicioID, Series, Reps, Descanso)),
        ListaEjercicios
    ).

% Parámetros específicos para ejercicio
obtener_parametros_ejercicio(UsuarioID, EjercicioID, Series, Reps, Descanso) :-
    usuario(UsuarioID, _, _, Objetivo, _, _, _),
    objetivo(Objetivo, RepMin, RepMax, SeriesBase, DescansoBase, _),
    Reps is RepMin + (RepMax - RepMin) // 2,
    (ejercicio_compuesto(EjercicioID) -> Series = SeriesBase ; Series is SeriesBase - 1),
    Descanso = DescansoBase.

% =====================================================
% 6. ANÁLISIS DE BALANCE
% =====================================================

% Contar ejercicios de empuje en rutina (estructura sesion/3)
contar_empujes(Rutina, Total) :-
    findall(1, (member(dia(_, sesion(_, _, Principales)), Rutina),
                member(grupo_ejercicios(_, Ejes), Principales),
                member(ejercicio_info(EID, _, _, _, _), Ejes),
                ejercicio(EID, _, _, _, empuje, _)), Todos),
    length(Todos, Total).

% Contar ejercicios de tirón en rutina (estructura sesion/3)
contar_tirones(Rutina, Total) :-
    findall(1, (member(dia(_, sesion(_, _, Principales)), Rutina),
                member(grupo_ejercicios(_, Ejes), Principales),
                member(ejercicio_info(EID, _, _, _, _), Ejes),
                ejercicio(EID, _, _, _, tiron, _)), Todos),
    length(Todos, Total).

% Ratio push/pull debería estar entre 1:1 y 1:1.2
push_pull_balanceado(Rutina) :-
    contar_empujes(Rutina, Empujes),
    contar_tirones(Rutina, Tirones),
    Empujes > 0, Tirones > 0,
    Ratio is Empujes / Tirones,
    Ratio >= 0.8,
    Ratio =< 1.2.

% =====================================================
% 7. DETECCIÓN DE FATIGA MUSCULAR
% =====================================================

% Detectar si un músculo ya fue trabajado indirectamente como secundario (sesion/3)
musculo_trabajado_indirectamente(Rutina, Dia, GrupoMuscular) :-
    member(dia(DiaAnterior, sesion(_, _, Principales)), Rutina),
    DiaAnterior is Dia - 1,
    member(grupo_ejercicios(_, Ejercicios), Principales),
    member(ejercicio_info(EjercicioID, _, _, _, _), Ejercicios),
    musculo_secundario(EjercicioID, GrupoMuscular, _).

% =====================================================
% 8. VALIDACIÓN DE RECUPERACIÓN
% =====================================================

% Verificar que no se entrenan dos días consecutivos el mismo grupo
sin_grupos_consecutivos(Rutina) :-
    \+ contiene_grupos_consecutivos(Rutina, _, 1).

% Verificar recuperación mínima
recuperacion_suficiente(Rutina, GrupoMuscular) :-
    recuperacion(GrupoMuscular, HorasMinimas),
    % En una rutina semanal normal, si no aparecen días consecutivos está bien
    \+ (member(dia(D1, _), Rutina),
        member(dia(D2, _), Rutina),
        D2 is D1 + 1,
        aparece_grupo_en_dia(D1, GrupoMuscular, Rutina),
        aparece_grupo_en_dia(D2, GrupoMuscular, Rutina)).

% Auxiliar: detectar si grupo aparece en día (estructura sesion/3)
aparece_grupo_en_dia(Dia, GrupoMuscular, Rutina) :-
    member(dia(Dia, sesion(_, _, Principales)), Rutina),
    member(grupo_ejercicios(GrupoMuscular, _), Principales).

% Auxiliar: detectar grupos consecutivos
contiene_grupos_consecutivos(Rutina, Grupo, D) :-
    aparece_grupo_en_dia(D, Grupo, Rutina),
    D2 is D + 1,
    aparece_grupo_en_dia(D2, Grupo, Rutina),
    !.

% =====================================================
% 9. CÁLCULO DE VOLUMEN TOTAL
% =====================================================

% Calcular volumen total de la semana (solo ejercicios principales, excluye calor/movilidad)
volumen_total_semana(Rutina, VolumenTotal) :-
    findall(Series, (member(dia(_, sesion(_, _, Principales)), Rutina),
                     member(grupo_ejercicios(_, Ejercicios), Principales),
                     member(ejercicio_info(_, _, Series, _, _), Ejercicios)),
            TodasLasSeries),
    sumlist(TodasLasSeries, VolumenTotal).

% Verificar que el volumen está dentro de límites
volumen_adecuado(UsuarioID, Rutina) :-
    usuario(UsuarioID, _, Nivel, _, _, _, _),
    volumen_maximo(Nivel, VolumeMax),
    volumen_total_semana(Rutina, VolumenTotal),
    VolumenTotal =< VolumeMax.

% =====================================================
% 10. VALIDACIÓN GENERAL DE RUTINA
% =====================================================

% Una rutina es válida si cumple todas las restricciones
rutina_valida(UsuarioID, Rutina) :-
    sin_grupos_consecutivos(Rutina),
    volumen_adecuado(UsuarioID, Rutina),
    push_pull_balanceado(Rutina).

% Validar compatibility entre ejercicios de un día
dia_compatible(DiaInfo) :-
    \+ (member(grupo_ejercicios(G1, _), DiaInfo),
        member(grupo_ejercicios(G2, _), DiaInfo),
        G1 \= G2,
        incompatible(G1, G2, _)).

% =====================================================
% 11. SUGERENCIAS DE MEJORA
% =====================================================

% Sugerir cambios si el balance push/pull es deficiente
sugerencia_balance_push_pull(Rutina, Sugerencia) :-
    \+ push_pull_balanceado(Rutina),
    contar_empujes(Rutina, Empujes),
    contar_tirones(Rutina, Tirones),
    (Empujes > Tirones ->
        Sugerencia = 'Considere agregar más ejercicios de tirón para balancear push/pull'
    ;   Sugerencia = 'Considere agregar más ejercicios de empuje para balancear push/pull').

% Sugerir cambios si el volumen es muy alto
sugerencia_volumen_alto(UsuarioID, Rutina, Sugerencia) :-
    usuario(UsuarioID, _, Nivel, _, _, _, _),
    volumen_maximo(Nivel, VolumeMax),
    volumen_total_semana(Rutina, VolumenTotal),
    VolumenTotal > VolumeMax * 0.9,
    Sugerencia = 'El volumen de entrenamiento está al límite. Considere reducir volumen o días.'.

% Sugerir cambios si hay grupos consecutivos (con advertencia)
sugerencia_recuperacion(Rutina, Sugerencia) :-
    \+ sin_grupos_consecutivos(Rutina),
    Sugerencia = 'Existe riesgo de recuperación inadecuada. Se detectaron grupos musculares en días consecutivos.'.

% Obtener todas las sugerencias para una rutina
obtener_sugerencias(UsuarioID, Rutina, ListaSugerencias) :-
    findall(S, (
        (sugerencia_balance_push_pull(Rutina, S), !);
        (sugerencia_volumen_alto(UsuarioID, Rutina, S), !);
        (sugerencia_recuperacion(Rutina, S), !)
    ), ListaSugerencias).

% =====================================================
% 12. PROGRESIÓN Y RECOMENDACIONES DE AUMENTO
% =====================================================

% Recomendar aumento de peso
recomendar_aumento_peso(UsuarioID, EjercicioID) :-
    % Obtener últimas 3 sesiones
    findall(Peso-Reps, ejercicio_realizado(UsuarioID, EjercicioID, _, _, Reps, Peso), Registros),
    length(Registros, N),
    N >= 3,
    % Si las últimas 3 sesiones completaron todas las reps, aumentar peso
    last(Registros, Peso1-Reps1),
    nth0(1, Registros, Peso2-Reps2),
    nth0(0, Registros, Peso3-Reps3),
    Reps1 >= 12, Reps2 >= 12, Reps3 >= 12,
    Peso1 = Peso2, Peso2 = Peso3.

% =====================================================
% 13. EXPLICACIONES DEL SISTEMA
% =====================================================

% Explicar por qué se eligió una división
explicar_division(UsuarioID, Division, Explicacion) :-
    usuario(UsuarioID, _, _, _, DiasDisponibles, _, _),
    division_rutina(Division, DiasRecomendados, Descripcion),
    member(DiasDisponibles, DiasRecomendados),
    atomic_list_concat(['Se seleccionó ', Division, ' porque tiene ',
                        DiasDisponibles, ' días disponibles. ', Descripcion], Explicacion).

% Explicar por qué se rechazó un ejercicio
explicar_rechazo_ejercicio(UsuarioID, EjercicioID, Razon) :-
    usuario(UsuarioID, _, Nivel, _, _, _, _),
    ejercicio(EjercicioID, Nombre, _, _, _, NivelMinimo),
    \+ nivel_suficiente(Nivel, NivelMinimo),
    atomic_list_concat(['El ejercicio ', Nombre, ' requiere nivel ', NivelMinimo,
                        ', pero el usuario es ', Nivel], Razon).

% Explicar selección de ejercicio
explicar_seleccion_ejercicio(EjercicioID, Razon) :-
    ejercicio(EjercicioID, Nombre, Grupo, Tipo, _, _),
    atomic_list_concat(['Se seleccionó ', Nombre, ' - ', Tipo, ' para ', Grupo], Razon).

% =====================================================
% 14. ENTRADA EN CALOR Y MOVILIDAD
% =====================================================

% Tipos de entrada en calor disponibles para selección del usuario
tipo_entrada_calor(cardio_ligero,       'Cardio suave de 5-10 minutos para elevar temperatura corporal').
tipo_entrada_calor(movilidad_dinamica,  'Movilidad dinámica articular de cuerpo completo').
tipo_entrada_calor(activacion_muscular, 'Activación muscular específica del grupo principal del día').

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

% ---
% seleccionar_entrada_calor(+Tipo, +GruposDelDia, -EjercicioCalor)
% Selecciona 1 ejercicio de entrada en calor.
% Tipo = auto | cardio_ligero | movilidad_dinamica | activacion_muscular
% ---

% Selección automática: infiere el tipo según los grupos del día
seleccionar_entrada_calor(auto, GruposDelDia, EjCalor) :-
    (   (member(cuadriceps, GruposDelDia) ; member(piernas, GruposDelDia) ;
         member(isquiotibial, GruposDelDia) ; member(gluteos, GruposDelDia))
    ->  TipoAuto = activacion_muscular
    ;   TipoAuto = cardio_ligero
    ),
    seleccionar_entrada_calor(TipoAuto, GruposDelDia, EjCalor), !.

% Cardio ligero: máquina cardiovascular a baja intensidad
seleccionar_entrada_calor(cardio_ligero, _,
                           ejercicio_info(EjID, Nombre, 1, 10, 0)) :-
    once(ejercicio(EjID, Nombre, cardio, compuesto, general, principiante)), !.

% Movilidad dinámica: ejercicio de activación compuesto (ej. Bear Crawl, Inchworm)
seleccionar_entrada_calor(movilidad_dinamica, _,
                           ejercicio_info(EjID, Nombre, 2, 10, 0)) :-
    once(ejercicio(EjID, Nombre, activacion, compuesto, activacion, principiante)), !.

% Activación muscular: ejercicio de movilidad específico para el primer grupo del día
seleccionar_entrada_calor(activacion_muscular, GruposDelDia,
                           ejercicio_info(EjID, Nombre, 2, 15, 0)) :-
    once((member(Grupo, GruposDelDia),
          movilidad_para_grupo(Grupo, EjID),
          ejercicio(EjID, Nombre, _, _, _, _))), !.

% Fallback: si ningún tipo encuentra ejercicio, usar cardio ligero
seleccionar_entrada_calor(_, _, ejercicio_info(EjID, Nombre, 1, 10, 0)) :-
    once(ejercicio(EjID, Nombre, cardio, _, general, principiante)), !.

% ---
% seleccionar_movilidad_dia(+GruposDelDia, +N, -EjerciciosMovilidad)
% Selecciona N ejercicios de movilidad relevantes para los grupos del día.
% Prioriza los específicos del día; rellena con generales si hacen falta.
% ---
% Versión con rotación por día (4-arity, recomendada)
seleccionar_movilidad_dia(GruposDelDia, Dia, NumObjetivo, EjerciciosMovilidad) :-
    findall(EjID,
            (member(Grupo, GruposDelDia), movilidad_para_grupo(Grupo, EjID)),
            EspecificosConDups),
    list_to_set(EspecificosConDups, Especificos),
    findall(EjID2, ejercicio(EjID2, _, movilidad, _, movilidad, principiante), GeneralesConDups),
    list_to_set(GeneralesConDups, Generales),
    append(Especificos, Generales, CombConDups),
    list_to_set(CombConDups, Combinados),
    length(Combinados, Total),
    (Total > 0 ->
        Offset is ((Dia - 1) * 2) mod Total
    ;   Offset = 0),
    rotate_list(Total, Offset, Combinados, CombRotados),
    take(NumObjetivo, CombRotados, EjIDsSeleccionados),
    findall(
        ejercicio_info(EjID, Nombre, 1, 1, 0),
        (member(EjID, EjIDsSeleccionados),
         once(ejercicio(EjID, Nombre, _, _, _, _))),
        EjerciciosMovilidad
    ).

% Versión sin rotación (3-arity, compatibilidad)
seleccionar_movilidad_dia(GruposDelDia, NumObjetivo, EjerciciosMovilidad) :-
    seleccionar_movilidad_dia(GruposDelDia, 1, NumObjetivo, EjerciciosMovilidad).

% =====================================================
% CONSULTAS ÚTILES (EJEMPLOS DE USO)
% =====================================================

% ?- seleccionar_division(user1, Division).
% ?- generar_rutina_semanal(user1, 'Full Body', Rutina).
% ?- rutina_valida(user1, Rutina).
% ?- obtener_sugerencias(user1, Rutina, Sugerencias).
% ?- recomendar_aumento_peso(user1, 'ex_001').
%
% --- Rutina automática (entrada en calor automática) ---
% ?- generar_rutina_automatica(user1, intermedio, hipertrofia, 4, Rutina).
%
% --- Rutina personalizada con tipo de entrada en calor ---
% ?- generar_rutina_personalizada(user1, intermedio, hipertrofia, 4, [pecho, triceps], cardio_ligero, Rutina).
% ?- generar_rutina_personalizada(user1, intermedio, hipertrofia, 4, [piernas], activacion_muscular, Rutina).
% ?- generar_rutina_personalizada(user1, intermedio, hipertrofia, 4, [espalda, biceps], movilidad_dinamica, Rutina).
%
% --- Sin tipo explícito (selección automática) ---
% ?- generar_rutina_personalizada(user1, intermedio, hipertrofia, 4, [pecho, espalda], Rutina).
%
% --- Consultas de entrada en calor y movilidad ---
% ?- seleccionar_entrada_calor(cardio_ligero, [pecho, triceps], EjCalor).
% ?- seleccionar_entrada_calor(auto, [piernas, gluteos], EjCalor).
% ?- seleccionar_movilidad_dia([piernas, gluteos], 3, EjMovilidad).
% ?- tipo_entrada_calor(Tipo, Descripcion).

% =====================================================
% 15. PREDICADOS PUENTE — INTERFACE CON EL BACKEND
% =====================================================
% Estos predicados adaptan la nomenclatura/aridad que PrologService.java invoca.

% ---
% seleccionar_division_por_dias(+Dias, -Division)
% Llamado desde PrologService.obtenerExplicacionDivision
% ---
seleccionar_division_por_dias(Dias, 'Full Body')      :- Dias =< 3, !.
seleccionar_division_por_dias(4,    'Torso-Pierna')   :- !.
seleccionar_division_por_dias(5,    'Push-Pull-Legs') :- !.
seleccionar_division_por_dias(_,    'Weider').

% ---
% validar_rutina_completa/3  — versión compacta usada en integration.pl
% validar_rutina_completa/5  — versión extendida llamada por PrologService.validarRutina
% ---
validar_rutina_completa(UsuarioID, Rutina, valida) :-
    rutina_valida(UsuarioID, Rutina), !.
validar_rutina_completa(_, _, invalida).

validar_rutina_completa(UsuarioID, Rutina, Valida, Problemas, Explicacion) :-
    (rutina_valida(UsuarioID, Rutina) ->
        Valida = true
    ;   Valida = false),
    findall(P, (
        (\+ sin_grupos_consecutivos(Rutina)     -> P = grupos_consecutivos  ; fail) ;
        (\+ volumen_adecuado(UsuarioID, Rutina) -> P = volumen_excedido     ; fail) ;
        (\+ push_pull_balanceado(Rutina)        -> P = desbalance_push_pull ; fail)
    ), Problemas),
    (Valida = true ->
        Explicacion = 'Rutina válida: cumple todos los criterios de calidad'
    ;   Explicacion = 'Rutina con observaciones: revisar los problemas indicados').

% ---
% generar_rutina_completa/8 — llamado por PrologService.generarRutinaCompleta
% UsuarioID es un entero enviado desde Java; si coincide con un átomo en KB se usa su nivel,
% si no, se usa principiante como nivel por defecto seguro.
% ---
generar_rutina_completa(UsuarioID, Dias, Objetivo, Grupos, Rutina, Validacion, Recomendaciones, Explicacion) :-
    (usuario(UsuarioID, _, Nivel, _, _, _, _) -> true ; Nivel = principiante),
    (Grupos = [] ->
        generar_rutina_automatica(UsuarioID, Nivel, Objetivo, Dias, Rutina)
    ;   generar_rutina_personalizada(UsuarioID, Nivel, Objetivo, Dias, Grupos, auto, Rutina)
    ),
    (catch(validar_rutina_completa(UsuarioID, Rutina, Validacion, _, _), _, Validacion = true)),
    (catch(obtener_sugerencias(UsuarioID, Rutina, Recomendaciones), _, Recomendaciones = [])),
    atomic_list_concat(['Rutina de ', Dias, ' días con objetivo ', Objetivo], Explicacion).
