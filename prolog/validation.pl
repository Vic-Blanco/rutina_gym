% =====================================================
% MÓDULO DE VALIDACIÓN Y EXPLICACIONES AVANZADAS
% =====================================================
% Validación profunda de rutinas y generación de explicaciones detalladas

:- include('knowledge_base.pl').
:- include('rules.pl').

% =====================================================
% 1. VALIDACIÓN COMPLETA DE RUTINA
% =====================================================

% Ejecutar todas las validaciones
validar_rutina_completa(UsuarioID, Rutina, ResultadoValidacion) :-
    validaciones_individuales(UsuarioID, Rutina, Validaciones),
    (all_pass(Validaciones) ->
        ResultadoValidacion = validacion_ok(Validaciones)
    ;   ResultadoValidacion = validacion_fallida(Validaciones)).

% Coleccionar todas las validaciones
validaciones_individuales(UsuarioID, Rutina, [
    validacion_recuperacion(ResultRecuperacion),
    validacion_volumen(ResultVolumen),
    validacion_frecuencia(ResultFrecuencia),
    validacion_balance(ResultBalance),
    validacion_grupos(ResultGrupos)
]) :-
    validar_recuperacion(Rutina, ResultRecuperacion),
    validar_volumen(UsuarioID, Rutina, ResultVolumen),
    validar_frecuencia_muscular(UsuarioID, Rutina, ResultFrecuencia),
    validar_balance_muscular(Rutina, ResultBalance),
    validar_grupos_musculares(UsuarioID, Rutina, ResultGrupos).

% Verificar si todas las validaciones pasaron
all_pass([]).
all_pass([validacion_recuperacion(ok)|Rest]) :- all_pass(Rest).
all_pass([validacion_volumen(ok)|Rest]) :- all_pass(Rest).
all_pass([validacion_frecuencia(ok)|Rest]) :- all_pass(Rest).
all_pass([validacion_balance(ok)|Rest]) :- all_pass(Rest).
all_pass([validacion_grupos(ok)|Rest]) :- all_pass(Rest).

% =====================================================
% 2. VALIDACIONES ESPECÍFICAS
% =====================================================

% Validar recuperación muscular
validar_recuperacion(Rutina, ok) :-
    sin_grupos_consecutivos(Rutina),
    !.

validar_recuperacion(_, fallo_recuperacion('Grupos musculares trabajados en días consecutivos')).

% Validar volumen
validar_volumen(UsuarioID, Rutina, ok) :-
    usuario(UsuarioID, _, Nivel, _, _, _, _),
    volumen_maximo(Nivel, VolumeMax),
    volumen_total_semana(Rutina, VolumenTotal),
    VolumenTotal =< VolumeMax,
    !.

validar_volumen(UsuarioID, Rutina, fallo_volumen(Mensaje)) :-
    usuario(UsuarioID, _, Nivel, _, _, _, _),
    volumen_maximo(Nivel, VolumeMax),
    volumen_total_semana(Rutina, VolumenTotal),
    VolumenExceso is VolumenTotal - VolumeMax,
    atomic_list_concat(['Volumen excedido: ', VolumenExceso, ' series más que lo permitido (', 
                        VolumeMax, ')'], Mensaje).

% Validar frecuencia muscular según nivel
validar_frecuencia_muscular(UsuarioID, Rutina, ok) :-
    usuario(UsuarioID, _, Nivel, _, _, _, _),
    findall(Grupo, (
        member(dia(_, Dias), Rutina),
        member(grupo_ejercicios(Grupo, _), Dias)
    ), GruposEnRutina),
    check_frecuencias_validas(GruposEnRutina, Nivel),
    !.

validar_frecuencia_muscular(_, Rutina, fallo_frecuencia('Frecuencia muscular inadecuada')).

% Verificar que las frecuencias son válidas
check_frecuencias_validas([], _) :- !.
check_frecuencias_validas([Grupo|Rest], Nivel) :-
    frecuencia_semanal(Grupo, Nivel, VecesRecomendadas),
    count_grupo_en_rutina(Grupo, VecesEnRutina),
    VecesEnRutina =< VecesRecomendadas,
    check_frecuencias_validas(Rest, Nivel).

% Validar balance push/pull
validar_balance_muscular(Rutina, ok) :-
    push_pull_balanceado(Rutina),
    !.

validar_balance_muscular(Rutina, fallo_balance(Mensaje)) :-
    contar_empujes(Rutina, Empujes),
    contar_tirones(Rutina, Tirones),
    atomic_list_concat(['Desbalance entre empuje (', Empujes, ') y tirón (', 
                        Tirones, '). Ratio debe estar entre 0.8 y 1.2'], Mensaje).

% Validar que se entrenan los grupos musculares seleccionados
validar_grupos_musculares(UsuarioID, Rutina, ok) :-
    usuario(UsuarioID, _, _, _, _, GruposSeleccionados, _),
    findall(Grupo, (
        member(dia(_, Dias), Rutina),
        member(grupo_ejercicios(Grupo, _), Dias)
    ), GruposEnRutina),
    groups_included(GruposSeleccionados, GruposEnRutina),
    !.

validar_grupos_musculares(UsuarioID, Rutina, fallo_grupos(Mensaje)) :-
    usuario(UsuarioID, _, _, _, _, GruposSeleccionados, _),
    findall(Grupo, (
        member(dia(_, Dias), Rutina),
        member(grupo_ejercicios(Grupo, _), Dias)
    ), GruposEnRutina),
    missing_groups(GruposSeleccionados, GruposEnRutina, Faltantes),
    atomic_list_concat(['No se entrenan los siguientes grupos: ', Faltantes], Mensaje).

% Verificar inclusión de grupos
groups_included([], _) :- !.
groups_included([G|Rest], GruposEnRutina) :-
    (member(G, GruposEnRutina) ; G = core),  % core es opcional
    groups_included(Rest, GruposEnRutina).

% Encontrar grupos que faltan
missing_groups([], _, []) :- !.
missing_groups([G|Rest], GruposEnRutina, Faltantes) :-
    missing_groups(Rest, GruposEnRutina, RestFaltantes),
    (member(G, GruposEnRutina) ->
        Faltantes = RestFaltantes
    ;   Faltantes = [G|RestFaltantes]).

% =====================================================
% 3. DETECCIÓN DE PROBLEMAS ESPECÍFICOS
% =====================================================

% Detectar sobreentrenamiento
detectar_sobreentrenamiento(UsuarioID, Rutina, Problemas) :-
    findall(Problema, (
        usuario(UsuarioID, _, Nivel, _, _, _, _),
        volumen_maximo(Nivel, VolumeMax),
        volumen_total_semana(Rutina, VolumenTotal),
        VolumenTotal > VolumeMax * 1.1,
        Problema = sobreentrenamiento(VolumenTotal, VolumeMax)
    ), ProblemasTemp),
    append(ProblemasTemp, [], Problemas).

% Detectar desbalances musculares
detectar_desbalances(Rutina, Problemas) :-
    findall(Problema, (
        \+ push_pull_balanceado(Rutina),
        contar_empujes(Rutina, Empujes),
        contar_tirones(Rutina, Tirones),
        Ratio is Empujes / max(Tirones, 1),
        Problema = desbalance_push_pull(Empujes, Tirones, Ratio)
    ), ProblemasTemp),
    append(ProblemasTemp, [], Problemas).

% Detectar fatiga acumulada
detectar_fatiga_acumulada(UsuarioID, Rutina, Problemas) :-
    findall(Problema, (
        member(dia(Dia, DiasInfo), Rutina),
        Dia > 1,
        member(grupo_ejercicios(Grupo, _), DiasInfo),
        musculo_trabajado_indirectamente(Rutina, Dia, Grupo),
        Problema = fatiga_acumulada(Grupo, Dia)
    ), ProblemasTemp),
    append(ProblemasTemp, [], Problemas).

% Obtener todos los problemas
obtener_todos_problemas(UsuarioID, Rutina, TodosProblemas) :-
    detectar_sobreentrenamiento(UsuarioID, Rutina, Problemas1),
    detectar_desbalances(Rutina, Problemas2),
    detectar_fatiga_acumulada(UsuarioID, Rutina, Problemas3),
    append([Problemas1, Problemas2, Problemas3], TodosProblemas).

% =====================================================
% 4. EXPLICACIONES DETALLADAS
% =====================================================

% Explicación completa del sistema experto sobre una decisión
explicacion_completa(UsuarioID, Division, Rutina, Explicacion) :-
    explicar_division(UsuarioID, Division, ExplDivision),
    explicar_selecciones_ejercicios(Rutina, ExplEjercicios),
    explicar_consideraciones(UsuarioID, Rutina, ExplConsideraciones),
    atomic_list_concat([
        'DIVISIÓN SELECCIONADA:\n', ExplDivision, '\n\n',
        'EJERCICIOS Y CRITERIOS:\n', ExplEjercicios, '\n\n',
        'CONSIDERACIONES ESPECIALES:\n', ExplConsideraciones
    ], Explicacion).

% Explicar por qué se seleccionó cada ejercicio
explicar_selecciones_ejercicios(Rutina, Explicacion) :-
    findall(Expl, (
        member(dia(Dia, Dias), Rutina),
        member(grupo_ejercicios(Grupo, Ejercicios), Dias),
        member(ejercicio_info(EID, Nombre, Series, Reps, _), Ejercicios),
        atomic_list_concat(['  - Día ', Dia, ', ', Grupo, ': ', Nombre, 
                           ' (', Series, ' x ', Reps, ')'], Expl)
    ), ExplicacionList),
    atomic_list_concat(ExplicacionList, '\n', Explicacion).

% Explicar consideraciones especiales
explicar_consideraciones(UsuarioID, Rutina, Consideraciones) :-
    usuario(UsuarioID, _, _, _, _, _, GrupoPrioritario),
    (GrupoPrioritario \= null ->
        atomic_list_concat(['  - Se priorizó ', GrupoPrioritario, 
                           ' como grupo muscular principal\n'], Cons1)
    ;   Cons1 = ''),
    (push_pull_balanceado(Rutina) ->
        Cons2 = '  - Push/pull balanceado\n'
    ;   Cons2 = '  - ADVERTENCIA: Desbalance push/pull detectado\n'),
    atomic_list_concat([Cons1, Cons2], Consideraciones).

% Explicar rechazos y restricciones
explicar_restricciones(UsuarioID, Division, ExplicacionesRechazo) :-
    usuario(UsuarioID, _, Nivel, _, _, GruposSeleccionados, _),
    findall(Expl, (
        member(Grupo, GruposSeleccionados),
        \+ (distribucion(Division, _, GruposEnDia), member(Grupo, GruposEnDia)),
        atomic_list_concat(['  - ', Grupo, ' no está incluido en la división ', 
                           Division], Expl)
    ), ExplicacionesRechazoList),
    atomic_list_concat(ExplicacionesRechazoList, '\n', ExplicacionesRechazo).

% =====================================================
% 5. RECOMENDACIONES DE MEJORA
% =====================================================

% Generar recomendaciones personalizadas
generar_recomendaciones(UsuarioID, Rutina, Recomendaciones) :-
    findall(Rec, (
        generador_recomendacion(UsuarioID, Rutina, Rec)
    ), Recomendaciones).

% Diferentes tipos de recomendaciones
generador_recomendacion(UsuarioID, Rutina, Rec) :-
    usuario(UsuarioID, _, Nivel, _, _, _, _),
    volumen_maximo(Nivel, VolumeMax),
    volumen_total_semana(Rutina, VolumenTotal),
    VolumenTotal < VolumeMax * 0.7,
    Rec = 'Volumen bajo: considera agregar más sets o ejercicios'.

generador_recomendacion(_, Rutina, Rec) :-
    \+ push_pull_balanceado(Rutina),
    contar_empujes(Rutina, Empujes),
    contar_tirones(Rutina, Tirones),
    Empujes > Tirones,
    Rec = 'Desbalance: aumenta ejercicios de tirón para equilibrio'.

generador_recomendacion(_, Rutina, Rec) :-
    \+ push_pull_balanceado(Rutina),
    contar_empujes(Rutina, Empujes),
    contar_tirones(Rutina, Tirones),
    Empujes < Tirones,
    Rec = 'Desbalance: aumenta ejercicios de empuje para equilibrio'.

generador_recomendacion(_, Rutina, Rec) :-
    \+ sin_grupos_consecutivos(Rutina),
    Rec = 'Recuperación: evita trabajar el mismo grupo en días consecutivos'.

% =====================================================
% 6. REPORTE COMPLETO
% =====================================================

% Generar reporte completo de la rutina
generar_reporte_rutina(UsuarioID, Rutina, Reporte) :-
    usuario(UsuarioID, _, Nivel, Objetivo, _, _, GrupoPrioritario),
    volumen_total_semana(Rutina, VolumenTotal),
    contar_empujes(Rutina, Empujes),
    contar_tirones(Rutina, Tirones),
    volumen_maximo(Nivel, VolumeMax),
    generar_recomendaciones(UsuarioID, Rutina, Recomendaciones),
    validaciones_individuales(UsuarioID, Rutina, Validaciones),
    
    atomic_list_concat([
        '=== REPORTE DE RUTINA ===\n',
        'Usuario: ', UsuarioID, '\n',
        'Nivel: ', Nivel, '\n',
        'Objetivo: ', Objetivo, '\n',
        'Grupo Prioritario: ', GrupoPrioritario, '\n\n',
        '=== ESTADÍSTICAS ===\n',
        'Volumen Total: ', VolumenTotal, ' / ', VolumeMax, ' series\n',
        'Porcentaje: ', (VolumenTotal * 100) // VolumeMax, '%\n',
        'Empujes: ', Empujes, '\n',
        'Tirones: ', Tirones, '\n',
        'Ratio Push/Pull: ', (Empujes / max(Tirones, 1)), '\n\n',
        '=== VALIDACIONES ===\n',
        (Validaciones -> 'Todas las validaciones pasaron' ; 'Hay validaciones fallidas'), '\n\n',
        '=== RECOMENDACIONES ===\n'
    ], ReporteBase),
    
    format_recomendaciones(Recomendaciones, RecsFmt),
    atomic_list_concat([ReporteBase, RecsFmt], Reporte).

% Formatear recomendaciones
format_recomendaciones([], '') :- !.
format_recomendaciones([H|T], Formatted) :-
    format_recomendaciones(T, RestFormatted),
    atomic_list_concat(['  - ', H, '\n', RestFormatted], Formatted).

% =====================================================
% 7. UTILIDADES AUXILIARES
% =====================================================

% Contar apariciones de un grupo en la rutina
count_grupo_en_rutina(Grupo, Count) :-
    findall(1, (
        % En una rutina almacenada
        member(dia(_, Dias), _),
        member(grupo_ejercicios(Grupo, _), Dias)
    ), Apariciones),
    length(Apariciones, Count).

% Obtener max entre dos números
max(X, Y, Max) :- (X > Y -> Max = X ; Max = Y).
max(X, Y) :- (X > Y -> X ; Y).

% =====================================================
% PREDICADOS DE CONSULTA (USO)
% =====================================================

% ?- validar_rutina_completa(user1, Rutina, Resultado).
% ?- generar_recomendaciones(user1, Rutina, Recs).
% ?- generar_reporte_rutina(user1, Rutina, Reporte).
% ?- explicacion_completa(user1, 'Full Body', Rutina, Expl).
% ?- obtener_todos_problemas(user1, Rutina, Problemas).
