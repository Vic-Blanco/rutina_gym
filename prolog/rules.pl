% =====================================================
% REGLAS DE INFERENCIA Y LÓGICA EXPERTA
% =====================================================
% Contiene únicamente las reglas activas en el flujo de generación y validación.

:- include('knowledge_base.pl').

% =====================================================
% 1. NIVEL Y TIPO DE EJERCICIO
% =====================================================

% Verifica si el usuario tiene el nivel suficiente para el ejercicio
nivel_suficiente(principiante, principiante) :- !.
nivel_suficiente(intermedio, principiante) :- !.
nivel_suficiente(intermedio, intermedio) :- !.
nivel_suficiente(avanzado, _) :- !.

% Ejercicios compuestos (priorizan sobre aislados en la selección)
ejercicio_compuesto(EjercicioID) :-
    ejercicio(EjercicioID, _, _, compuesto, _, _).

% =====================================================
% 2. GENERACIÓN AUTOMÁTICA vs PERSONALIZADA
% =====================================================

% Generar rutina automática: Prolog selecciona grupos basada en días.
generar_rutina_automatica(UsuarioID, Nivel, Objetivo, Dias, Rutina) :-
    seleccionar_grupos_para_dias(Dias, GruposMusculares),
    generar_rutina_desde_parametros(UsuarioID, Nivel, Objetivo, Dias, GruposMusculares, auto, Rutina).

% Seleccionar grupos automáticamente según días disponibles
seleccionar_grupos_para_dias(Dias, [pecho, espalda, hombros, biceps, triceps, core, gluteos, cuadriceps, isquiotibial]) :-
    Dias =< 3, !.
seleccionar_grupos_para_dias(4, [pecho, espalda, hombros, biceps, triceps, core, gluteos, cuadriceps, isquiotibial]) :- !.
seleccionar_grupos_para_dias(Dias, [pecho, espalda, hombros, biceps, triceps, cuadriceps, isquiotibial, gluteos, core]) :-
    Dias >= 6, !.

% Generar rutina personalizada con tipo de entrada en calor elegido por el usuario.
% TipoEntradaCalor: cardio_ligero | movilidad_dinamica | activacion_muscular
generar_rutina_personalizada(UsuarioID, Nivel, Objetivo, Dias, GruposMusculares, TipoEntradaCalor, Rutina) :-
    tipo_entrada_calor(TipoEntradaCalor, _),
    generar_rutina_desde_parametros(UsuarioID, Nivel, Objetivo, Dias, GruposMusculares, TipoEntradaCalor, Rutina).

% Versión sin tipo explícito: usa selección automática de entrada en calor
generar_rutina_personalizada(UsuarioID, Nivel, Objetivo, Dias, GruposMusculares, Rutina) :-
    generar_rutina_desde_parametros(UsuarioID, Nivel, Objetivo, Dias, GruposMusculares, auto, Rutina).

% =====================================================
% 3. DISTRIBUCIÓN DE GRUPOS MUSCULARES EN LOS DÍAS
% =====================================================

crear_dias_vacios(0, []) :- !.
crear_dias_vacios(N, [[]|Resto]) :-
    N > 0,
    N1 is N - 1,
    crear_dias_vacios(N1, Resto).

generar_plan_semanal(GruposMusculares, Dias, PlanSemanal) :-
    distribuir_grupos(GruposMusculares, Dias, Distribucion),
    numerar_dias(Distribucion, 1, PlanSemanal).

% Si hay menos grupos que días, cicla los grupos para que ningún día quede vacío.
% La rotación de ejercicios por número de día garantiza variedad en los días repetidos.
distribuir_grupos(Grupos, Dias, Distribucion) :-
    length(Grupos, NumGrupos),
    (NumGrupos < Dias ->
        ciclar_grupos(Grupos, Dias, GruposCiclados),
        crear_dias_vacios(Dias, DiasVacios),
        repartir_grupos(GruposCiclados, DiasVacios, Distribucion)
    ;
        crear_dias_vacios(Dias, DiasVacios),
        repartir_grupos(Grupos, DiasVacios, Distribucion)
    ).

% Genera una lista de exactamente N grupos ciclando la lista original
ciclar_grupos(Grupos, N, Ciclados) :-
    ciclar_acc(Grupos, Grupos, N, [], Ciclados).

ciclar_acc(_, _, 0, Acc, Acc) :- !.
ciclar_acc([], Original, N, Acc, Result) :- !,
    ciclar_acc(Original, Original, N, Acc, Result).
ciclar_acc([G|Resto], Original, N, Acc, Result) :-
    N > 0,
    N1 is N - 1,
    append(Acc, [G], NuevoAcc),
    ciclar_acc(Resto, Original, N1, NuevoAcc, Result).

repartir_grupos([], Distribucion, Distribucion).
repartir_grupos([Grupo|Resto], DiasActuales, DistribucionFinal) :-
    insertar_en_dia_menos_cargado(Grupo, DiasActuales, NuevosDias),
    repartir_grupos(Resto, NuevosDias, DistribucionFinal).

insertar_en_dia_menos_cargado(Grupo, Dias, NuevosDias) :-
    obtener_indice_dia_menos_cargado(Dias, Indice),
    insertar_grupo_en_indice(Dias, Indice, Grupo, NuevosDias).

obtener_indice_dia_menos_cargado(Dias, Indice) :-
    maplist(length, Dias, Longitudes),
    min_list(Longitudes, Min),
    nth0(Indice, Longitudes, Min).

insertar_grupo_en_indice([Dia|Resto], 0, Grupo, [[Grupo|Dia]|Resto]) :- !.
insertar_grupo_en_indice([Dia|Resto], Indice, Grupo, [Dia|NuevoResto]) :-
    Indice > 0,
    Indice1 is Indice - 1,
    insertar_grupo_en_indice(Resto, Indice1, Grupo, NuevoResto).

numerar_dias([], _, []).
numerar_dias([Grupos|Resto], NumeroDia, [dia(NumeroDia, Grupos)|Plan]) :-
    SiguienteDia is NumeroDia + 1,
    numerar_dias(Resto, SiguienteDia, Plan).

% =====================================================
% 4. GENERADOR PRINCIPAL
% =====================================================

% TipoEntradaCalor: auto | cardio_ligero | movilidad_dinamica | activacion_muscular
generar_rutina_desde_parametros(_UsuarioID, Nivel, Objetivo, Dias, GruposMusculares, TipoEntradaCalor, Rutina) :-
    generar_plan_semanal(GruposMusculares, Dias, PlanSemanal),
    generar_dias_desde_plan(Nivel, Objetivo, TipoEntradaCalor, PlanSemanal, Rutina).

% =====================================================
% 5. GENERAR RUTINA A PARTIR DEL PLAN SEMANAL
% =====================================================

generar_dias_desde_plan(_Nivel, _Objetivo, _TipoEntradaCalor, [], []).
generar_dias_desde_plan(Nivel, Objetivo, TipoEntradaCalor,
                         [dia(Dia, GruposDia)|RestoPlan],
                         [dia(Dia, Sesion)|RestoRutina]) :-
    generar_dia_desde_parametros(Nivel, Objetivo, Dia, GruposDia, TipoEntradaCalor, Sesion),
    generar_dias_desde_plan(Nivel, Objetivo, TipoEntradaCalor, RestoPlan, RestoRutina).

% Genera un día con estructura sesion(EntradaCalor, Movilidad, Principales)
generar_dia_desde_parametros(Nivel, Objetivo, Dia, GruposMusculares, TipoEntradaCalor,
                              sesion(EntradaCalor, EjMovilidad, EjPrincipales)) :-
    seleccionar_entrada_calor(TipoEntradaCalor, GruposMusculares, EntradaCalor),
    seleccionar_movilidad_dia(GruposMusculares, Dia, 3, EjMovilidad),
    findall(
        grupo_ejercicios(Grupo, Ejercicios),
        (member(Grupo, GruposMusculares),
         generar_ejercicios_desde_parametros(Nivel, Objetivo, Dia, Grupo, Ejercicios)),
        EjerciciosPorGrupo
    ),
    seleccionar_principales(EjerciciosPorGrupo, EjPrincipales),
    !.

% =====================================================
% 6. SELECCIÓN DE EJERCICIOS PRINCIPALES (5-6 por día)
% =====================================================

% Máximo 4 compuestos + aislados hasta completar 6
seleccionar_principales(GruposEjercicios, GruposLimitados) :-
    findall(
        Grupo-Ejercicio,
        (member(grupo_ejercicios(Grupo, Ejercicios), GruposEjercicios),
         member(Ejercicio, Ejercicios)),
        EjerciciosPlanos
    ),
    separar_ejercicios(EjerciciosPlanos, Compuestos, Aislados),
    take(4, Compuestos, CompuestosSeleccionados),
    length(CompuestosSeleccionados, NumCompSelec),
    Disponibles is 6 - NumCompSelec,
    (Disponibles > 0 ->
        take(Disponibles, Aislados, AisladosSeleccionados)
    ;   AisladosSeleccionados = []),
    append(CompuestosSeleccionados, AisladosSeleccionados, EjerciciosSeleccionados),
    agrupar_ejercicios(EjerciciosSeleccionados, GruposEjercicios, GruposLimitados).

separar_ejercicios([], [], []) :- !.
separar_ejercicios([Grupo-Ejer|Rest], [Grupo-Ejer|Compuestos], Aislados) :-
    Ejer = ejercicio_info(EjercicioID, _, _, _, _),
    ejercicio_compuesto(EjercicioID), !,
    separar_ejercicios(Rest, Compuestos, Aislados).
separar_ejercicios([EjerPair|Rest], Compuestos, [EjerPair|Aislados]) :-
    separar_ejercicios(Rest, Compuestos, Aislados).

take(0, _, []) :- !.
take(_, [], []) :- !.
take(N, [H|T], [H|Rest]) :-
    N > 0,
    N1 is N - 1,
    take(N1, T, Rest).

rotate_list(_, 0, List, List) :- !.
rotate_list(_, _, [], []) :- !.
rotate_list(Total, N, [H|T], Rotated) :-
    N > 0,
    N1 is N - 1,
    append(T, [H], Shifted),
    rotate_list(Total, N1, Shifted, Rotated).

agrupar_ejercicios(EjerciciosSeleccionados, GruposOriginales, GruposLimitados) :-
    findall(
        grupo_ejercicios(Grupo, EjerciciosFiltrados),
        (member(grupo_ejercicios(Grupo, _), GruposOriginales),
         findall(
            Ejer,
            member(Grupo-Ejer, EjerciciosSeleccionados),
            EjerciciosFiltrados
         ),
         EjerciciosFiltrados \= []),
        GruposLimitados
    ).

% Generar ejercicios para un grupo muscular con rotación según día
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

% =====================================================
% 7. ENTRADA EN CALOR Y MOVILIDAD
% =====================================================

tipo_entrada_calor(cardio_ligero,       'Cardio suave de 5-10 minutos para elevar temperatura corporal').
tipo_entrada_calor(movilidad_dinamica,  'Movilidad dinámica articular de cuerpo completo').
tipo_entrada_calor(activacion_muscular, 'Activación muscular específica del grupo principal del día').

% Selección automática: infiere tipo según los grupos del día
seleccionar_entrada_calor(auto, GruposDelDia, EjCalor) :-
    (   (member(cuadriceps, GruposDelDia) ; member(piernas, GruposDelDia) ;
         member(isquiotibial, GruposDelDia) ; member(gluteos, GruposDelDia))
    ->  TipoAuto = activacion_muscular
    ;   TipoAuto = cardio_ligero
    ),
    seleccionar_entrada_calor(TipoAuto, GruposDelDia, EjCalor), !.

seleccionar_entrada_calor(cardio_ligero, _,
                           ejercicio_info(EjID, Nombre, 1, 10, 0)) :-
    once(ejercicio(EjID, Nombre, cardio, compuesto, general, principiante)), !.

seleccionar_entrada_calor(movilidad_dinamica, _,
                           ejercicio_info(EjID, Nombre, 2, 10, 0)) :-
    once(ejercicio(EjID, Nombre, activacion, compuesto, activacion, principiante)), !.

seleccionar_entrada_calor(activacion_muscular, GruposDelDia,
                           ejercicio_info(EjID, Nombre, 2, 15, 0)) :-
    once((member(Grupo, GruposDelDia),
          movilidad_para_grupo(Grupo, EjID),
          ejercicio(EjID, Nombre, _, _, _, _))), !.

% Fallback: cardio ligero si ningún tipo encuentra ejercicio
seleccionar_entrada_calor(_, _, ejercicio_info(EjID, Nombre, 1, 10, 0)) :-
    once(ejercicio(EjID, Nombre, cardio, _, general, principiante)), !.

% Selecciona N ejercicios de movilidad rotados por número de día
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
    (Total > 0 -> Offset is ((Dia - 1) * 2) mod Total ; Offset = 0),
    rotate_list(Total, Offset, Combinados, CombRotados),
    take(NumObjetivo, CombRotados, EjIDsSeleccionados),
    findall(
        ejercicio_info(EjID, Nombre, 1, 1, 0),
        (member(EjID, EjIDsSeleccionados),
         once(ejercicio(EjID, Nombre, _, _, _, _))),
        EjerciciosMovilidad
    ).

% Versión sin rotación (compatibilidad)
seleccionar_movilidad_dia(GruposDelDia, NumObjetivo, EjerciciosMovilidad) :-
    seleccionar_movilidad_dia(GruposDelDia, 1, NumObjetivo, EjerciciosMovilidad).

% =====================================================
% 8. ANÁLISIS DE BALANCE Y VALIDACIÓN
% =====================================================

contar_empujes(Rutina, Total) :-
    findall(1, (member(dia(_, sesion(_, _, Principales)), Rutina),
                member(grupo_ejercicios(_, Ejes), Principales),
                member(ejercicio_info(EID, _, _, _, _), Ejes),
                ejercicio(EID, _, _, _, empuje, _)), Todos),
    length(Todos, Total).

contar_tirones(Rutina, Total) :-
    findall(1, (member(dia(_, sesion(_, _, Principales)), Rutina),
                member(grupo_ejercicios(_, Ejes), Principales),
                member(ejercicio_info(EID, _, _, _, _), Ejes),
                ejercicio(EID, _, _, _, tiron, _)), Todos),
    length(Todos, Total).

push_pull_balanceado(Rutina) :-
    contar_empujes(Rutina, Empujes),
    contar_tirones(Rutina, Tirones),
    Empujes > 0, Tirones > 0,
    Ratio is Empujes / Tirones,
    Ratio >= 0.8,
    Ratio =< 1.2.

musculo_dia(Dia, Rutina, Musculo) :-
    member(dia(Dia, sesion(_, _, Principales)), Rutina),
    member(grupo_ejercicios(Grupo, _), Principales),
    grupo_musculos(Grupo, Musculos),
    member(Musculo, Musculos).

fatiga_detectada(Rutina) :-
    member(dia(D1, _), Rutina),
    D2 is D1 + 1,
    member(dia(D2, _), Rutina),
    musculo_dia(D1, Rutina, Musculo),
    musculo_dia(D2, Rutina, Musculo).

sin_musculos_consecutivos(Rutina) :-
    \+ fatiga_detectada(Rutina).

recuperacion_suficiente(Rutina) :-
    \+ fatiga_detectada(Rutina).

volumen_total_semana(Rutina, VolumenTotal) :-
    findall(Series, (member(dia(_, sesion(_, _, Principales)), Rutina),
                     member(grupo_ejercicios(_, Ejercicios), Principales),
                     member(ejercicio_info(_, _, Series, _, _), Ejercicios)),
            TodasLasSeries),
    sumlist(TodasLasSeries, VolumenTotal).

volumen_adecuado(UsuarioID, Rutina) :-
    usuario(UsuarioID, _, Nivel, _, _, _, _),
    volumen_maximo(Nivel, VolumeMax),
    volumen_total_semana(Rutina, VolumenTotal),
    VolumenTotal =< VolumeMax.

rutina_valida(UsuarioID, Rutina) :-
    sin_musculos_consecutivos(Rutina),
    recuperacion_suficiente(Rutina),
    volumen_adecuado(UsuarioID, Rutina),
    push_pull_balanceado(Rutina).

% =====================================================
% 9. SUGERENCIAS DE MEJORA
% =====================================================

sugerencia_balance_push_pull(Rutina, Sugerencia) :-
    \+ push_pull_balanceado(Rutina),
    contar_empujes(Rutina, Empujes),
    contar_tirones(Rutina, Tirones),
    (Empujes > Tirones ->
        Sugerencia = 'Considere agregar más ejercicios de tirón para balancear push/pull'
    ;   Sugerencia = 'Considere agregar más ejercicios de empuje para balancear push/pull').

sugerencia_volumen_alto(UsuarioID, Rutina, Sugerencia) :-
    usuario(UsuarioID, _, Nivel, _, _, _, _),
    volumen_maximo(Nivel, VolumeMax),
    volumen_total_semana(Rutina, VolumenTotal),
    VolumenTotal > VolumeMax * 0.9,
    Sugerencia = 'El volumen de entrenamiento está al límite. Considere reducir volumen o días.'.

sugerencia_recuperacion(Rutina, Sugerencia) :-
    \+ sin_musculos_consecutivos(Rutina),
    Sugerencia = 'Existe riesgo de recuperación inadecuada. Se detectaron grupos musculares en días consecutivos.'.

obtener_sugerencias(UsuarioID, Rutina, ListaSugerencias) :-
    findall(S, (
        (sugerencia_balance_push_pull(Rutina, S), !);
        (sugerencia_volumen_alto(UsuarioID, Rutina, S), !);
        (sugerencia_recuperacion(Rutina, S), !)
    ), ListaSugerencias).

% =====================================================
% 10. PREDICADOS PUENTE — INTERFACE CON EL BACKEND
% =====================================================

seleccionar_division_por_dias(Dias, 'Full Body')      :- Dias =< 3, !.
seleccionar_division_por_dias(4,    'Torso-Pierna')   :- !.
seleccionar_division_por_dias(5,    'Push-Pull-Legs') :- !.
seleccionar_division_por_dias(_,    'Weider').

validar_rutina_completa(UsuarioID, Rutina, valida) :-
    rutina_valida(UsuarioID, Rutina), !.
validar_rutina_completa(_, _, invalida).

validar_rutina_completa(UsuarioID, Rutina, Valida, Problemas, Explicacion) :-
    (rutina_valida(UsuarioID, Rutina) ->
        Valida = true
    ;   Valida = false),
    findall(P, (
        (\+ sin_musculos_consecutivos(Rutina) -> P = grupos_consecutivos  ; fail) ;
        (\+ volumen_adecuado(UsuarioID, Rutina) -> P = volumen_excedido    ; fail) ;
        (\+ push_pull_balanceado(Rutina)        -> P = desbalance_push_pull ; fail)
    ), Problemas),
    (Valida = true ->
        Explicacion = 'Rutina válida: cumple todos los criterios de calidad'
    ;   Explicacion = 'Rutina con observaciones: revisar los problemas indicados').

% UsuarioID es un entero enviado desde Java; si no está en KB usa principiante por defecto.
generar_rutina_completa(UsuarioID, Dias, Objetivo, Grupos, Rutina, Validacion, Recomendaciones, Explicacion) :-
    (usuario(UsuarioID, _, Nivel, _, _, _, _) -> true ; Nivel = principiante),
    (Grupos = [] ->
        generar_rutina_automatica(UsuarioID, Nivel, Objetivo, Dias, Rutina)
    ;   generar_rutina_personalizada(UsuarioID, Nivel, Objetivo, Dias, Grupos, auto, Rutina)
    ),
    (catch(validar_rutina_completa(UsuarioID, Rutina, Validacion, _, _), _, Validacion = true)),
    (catch(obtener_sugerencias(UsuarioID, Rutina, Recomendaciones), _, Recomendaciones = [])),
    atomic_list_concat(['Rutina de ', Dias, ' días con objetivo ', Objetivo], Explicacion).
