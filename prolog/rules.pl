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

% Generar rutina completa para usuario
generar_rutina_semanal(UsuarioID, Division, Rutina) :-
    usuario(UsuarioID, _, Nivel, Objetivo, _, GruposSeleccionados, _),
    findall(
        dia(Dia, EjerciciosPorGrupo),
        (distribucion(Division, Dia, GruposEnDia),
         generar_dia(UsuarioID, Dia, GruposEnDia, EjerciciosPorGrupo)),
        Rutina
    ).

% =====================================================
% GENERACIÓN AUTOMÁTICA vs PERSONALIZADA
% =====================================================

% Generar rutina automática: Prolog selecciona división y grupos basada en días
generar_rutina_automatica(UsuarioID, Nivel, Objetivo, Dias, Rutina) :-
    seleccionar_grupos_para_dias(Dias, GruposMusculares),
    generar_rutina_desde_parametros(UsuarioID, Nivel, Objetivo, Dias, GruposMusculares, Rutina).

% Seleccionar grupos automáticamente según días disponibles
seleccionar_grupos_para_dias(Dias, [pecho, espalda, hombros, biceps, triceps, core]) :-
    Dias =< 3, !.

seleccionar_grupos_para_dias(4, [pecho, espalda, cuadriceps, isquiotibial, gluteos, core]) :- !.

seleccionar_grupos_para_dias(Dias, [pecho, espalda, hombros, biceps, triceps, cuadriceps, isquiotibial, gluteos, core]) :-
    Dias >= 5, !.

% Generar rutina personalizada: Usa grupos suministrados directamente
generar_rutina_personalizada(UsuarioID, Nivel, Objetivo, Dias, GruposMusculares, Rutina) :-
    generar_rutina_desde_parametros(UsuarioID, Nivel, Objetivo, Dias, GruposMusculares, Rutina).

% =====================================================
% GENERADOR PRINCIPAL - No depende de KB de usuario
% =====================================================

% Generar rutina completa desde parámetros explícitos (sin leer usuario de KB)
generar_rutina_desde_parametros(UsuarioID, Nivel, Objetivo, Dias, GruposMusculares, Rutina) :-
    generar_dias_rutina(Nivel, Objetivo, Dias, GruposMusculares, 1, Rutina).

% Generar lista de días recursivamente
generar_dias_rutina(_, _, Dias, _, DiaCurrent, []) :-
    DiaCurrent > Dias, !.

generar_dias_rutina(Nivel, Objetivo, Dias, GruposMusculares, DiaCurrent, [dia(DiaCurrent, EjerciciosPorGrupo) | RestoDias]) :-
    generar_dia_desde_parametros(Nivel, Objetivo, DiaCurrent, GruposMusculares, EjerciciosPorGrupo),
    DiaSiguiente is DiaCurrent + 1,
    generar_dias_rutina(Nivel, Objetivo, Dias, GruposMusculares, DiaSiguiente, RestoDias).

% Generar día desde parámetros
generar_dia_desde_parametros(Nivel, Objetivo, Dia, GruposMusculares, EjerciciosPorGrupoLimitado) :-
    findall(
        grupo_ejercicios(Grupo, Ejercicios),
        (member(Grupo, GruposMusculares),
         generar_ejercicios_desde_parametros(Nivel, Objetivo, Grupo, Ejercicios)),
        EjerciciosPorGrupo
    ),
    % Limitar a máximo 6 ejercicios totales por día
    limitar_ejercicios_dia(EjerciciosPorGrupo, EjerciciosPorGrupoLimitado),
    !.

% =====================================================
% LIMITADOR DE EJERCICIOS - Máximo 6 por día
% =====================================================

% Limitar ejercicios a máximo 6 totales por día
limitar_ejercicios_dia(GruposEjercicios, GruposLimitados) :-
    % Convertir grupos a lista plana con etiqueta de grupo
    findall(
        Grupo-Ejercicio,
        (member(grupo_ejercicios(Grupo, Ejercicios), GruposEjercicios),
         member(Ejercicio, Ejercicios)),
        EjerciciosPlanos
    ),
    % Separar compuestos de aislados (priorizan compuestos)
    separar_ejercicios(EjerciciosPlanos, Compuestos, Aislados),
    % Seleccionar hasta 6 total: primero compuestos, luego aislados
    length(Compuestos, NumCompuestos),
    Disponibles is 6 - NumCompuestos,
    (Disponibles > 0 -> 
        take(Disponibles, Aislados, AisladosSeleccionados) ;
        AisladosSeleccionados = []),
    append(Compuestos, AisladosSeleccionados, EjerciciosSeleccionados),
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

% Generar ejercicios para grupo desde parámetros (sin necesidad de usuario en KB)
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

% Fallback si algo falla
generar_ejercicios_desde_parametros(_, _, _, []).

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

% Contar ejercicios de empuje en rutina
contar_empujes(Rutina, Total) :-
    findall(1, (member(dia(_, Dias), Rutina),
                member(grupo_ejercicios(_, Ejes), Dias),
                member(ejercicio_info(EID, _, _, _, _), Ejes),
                ejercicio(EID, _, _, _, empuje, _)), Todos),
    length(Todos, Total).

% Contar ejercicios de tirón en rutina
contar_tirones(Rutina, Total) :-
    findall(1, (member(dia(_, Dias), Rutina),
                member(grupo_ejercicios(_, Ejes), Dias),
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

% Detectar si un músculo ya fue trabajado indirectamente como secundario
musculo_trabajado_indirectamente(Rutina, Dia, GrupoMuscular) :-
    member(dia(DiaAnterior, DiasAnteriores), Rutina),
    DiaAnterior is Dia - 1,
    member(grupo_ejercicios(_, Ejercicios), DiasAnteriores),
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

% Auxiliar: detectar si grupo aparece en día
aparece_grupo_en_dia(Dia, GrupoMuscular, Rutina) :-
    member(dia(Dia, DiasInfo), Rutina),
    member(grupo_ejercicios(GrupoMuscular, _), DiasInfo).

% Auxiliar: detectar grupos consecutivos
contiene_grupos_consecutivos(Rutina, Grupo, D) :-
    aparece_grupo_en_dia(D, Grupo, Rutina),
    D2 is D + 1,
    aparece_grupo_en_dia(D2, Grupo, Rutina),
    !.

% =====================================================
% 9. CÁLCULO DE VOLUMEN TOTAL
% =====================================================

% Calcular volumen total de la semana
volumen_total_semana(Rutina, VolumenTotal) :-
    findall(Series, (member(dia(_, Dias), Rutina),
                     member(grupo_ejercicios(_, Ejercicios), Dias),
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
% CONSULTAS ÚTILES (EJEMPLOS DE USO)
% =====================================================

% ?- seleccionar_division(user1, Division).
% ?- generar_rutina_semanal(user1, 'Full Body', Rutina).
% ?- rutina_valida(user1, Rutina).
% ?- obtener_sugerencias(user1, Rutina, Sugerencias).
% ?- recomendar_aumento_peso(user1, 'ex_001').
