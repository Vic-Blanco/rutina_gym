% =====================================================
% INTEGRATION API - Prolog <-> Backend Java
% =====================================================
% Interface para comunicación con REST API de Spring Boot

% =====================================================
% CARGAR BASES DE CONOCIMIENTO Y REGLAS
% =====================================================
:-include('/app/prolog/knowledge_base.pl').
:-include('/app/prolog/rules.pl').

% =====================================================
% 1. PREDICADOS DE EXPORTACIÓN
% =====================================================

% Exportar rutina en formato JSON-compatible
exportar_rutina_json(UsuarioID, Division, JSON) :-
    generar_rutina_semanal(UsuarioID, Division, Rutina),
    validar_rutina_completa(UsuarioID, Rutina, Validacion),
    generar_recomendaciones(UsuarioID, Rutina, Recs),
    construir_json_rutina(UsuarioID, Division, Rutina, Validacion, Recs, JSON).

% Construir JSON de rutina
construir_json_rutina(UsuarioID, Division, Rutina, Validacion, Recs, JSON) :-
    atomic_list_concat([
        '{',
        '"usuario": "', UsuarioID, '",',
        '"division": "', Division, '",',
        '"rutina": ', exportar_dias_json(Rutina), ',',
        '"validacion": ', exportar_validacion_json(Validacion), ',',
        '"recomendaciones": ', exportar_recomendaciones_json(Recs),
        '}'
    ], JSON).

% Exportar días en formato JSON
exportar_dias_json([]) :- '[]'.
exportar_dias_json([dia(Dia, DiasInfo)|Rest]) :-
    exportar_dia_json(dia(Dia, DiasInfo), DiaJSON),
    exportar_dias_json(Rest, RestJSON),
    atomic_list_concat(['[', DiaJSON, ',', RestJSON, ']'], JSON),
    JSON.

% Exportar validación
exportar_validacion_json(validacion_ok(_)) :-
    '{"estado": "valida", "errores": []}'.

exportar_validacion_json(validacion_fallida(Validaciones)) :-
    findall(Err, extraer_error(Err, Validaciones), Errores),
    atomic_list_concat(['{"estado": "invalida", "errores": ', Errores, '}'], JSON),
    JSON.

% =====================================================
% 2. CONVERSIÓN DE DATOS
% =====================================================

% Convertir usuario Prolog a formato REST
usuario_a_json(UsuarioID, JSON) :-
    usuario(UsuarioID, Nombre, Nivel, Objetivo, Dias, Grupos, Prioritario),
    atomic_list_concat([
        '{',
        '"id": "', UsuarioID, '",',
        '"nombre": "', Nombre, '",',
        '"nivel": "', Nivel, '",',
        '"objetivo": "', Objetivo, '",',
        '"diasDisponibles": ', Dias, ',',
        '"gruposMusculares": ', grupos_a_json(Grupos), ',',
        '"grupoPrioritario": "', Prioritario, '"',
        '}'
    ], JSON).

% Convertir grupos musculares a JSON
grupos_a_json(Grupos) :-
    atomic_list_concat(['["', (forall(member(G, Grupos), atomic_list_concat([G], '", "'))), '"]'], JSON),
    JSON.

% Convertir ejercicio a formato REST
ejercicio_a_json(EjercicioID, JSON) :-
    ejercicio(EjercicioID, Nombre, Grupo, Tipo, Patron, Dif),
    findall(Sec, musculo_secundario(EjercicioID, Sec, _), Secundarios),
    atomic_list_concat([
        '{',
        '"id": "', EjercicioID, '",',
        '"nombre": "', Nombre, '",',
        '"grupoMuscular": "', Grupo, '",',
        '"tipo": "', Tipo, '",',
        '"patron": "', Patron, '",',
        '"dificultad": "', Dif, '",',
        '"musculosSecundarios": ', secundarios_a_json(Secundarios),
        '}'
    ], JSON).

% =====================================================
% 3. ENDPOINTS SIMULADOS
% =====================================================

% Simular GET /api/routines/generate/{userId}
api_generate_routine(UsuarioID, ResponseJSON) :-
    seleccionar_division(UsuarioID, Division),
    generar_rutina_semanal(UsuarioID, Division, Rutina),
    validar_rutina_completa(UsuarioID, Rutina, Validacion),
    generar_recomendaciones(UsuarioID, Rutina, Recs),
    construir_json_rutina(UsuarioID, Division, Rutina, Validacion, Recs, ResponseJSON).

% Simular GET /api/routines/validate
api_validate_routine(RutinaJSON, ValidationJSON) :-
    % Parsear JSON (simplificado)
    % En producción, usar librería JSON
    ValidationJSON = '{"valid": true, "errors": []}'.

% Simular GET /api/exercises/{groupId}
api_get_exercises_by_group(Grupo, ExercisesJSON) :-
    findall(EjercicioJSON, (
        ejercicio(ID, _, Grupo, _, _, _),
        ejercicio_a_json(ID, EjercicioJSON)
    ), Ejercicios),
    atomic_list_concat(['[', (atomic_list_concat(Ejercicios, ', ')), ']'], ExercisesJSON).

% Simular GET /api/users/{userId}
api_get_user(UsuarioID, UserJSON) :-
    usuario_a_json(UsuarioID, UserJSON).

% Simular POST /api/routines/explain
api_explain_routine(UsuarioID, Division, RutinaJSON, ExplanationJSON) :-
    generar_rutina_semanal(UsuarioID, Division, Rutina),
    explicacion_completa(UsuarioID, Division, Rutina, Explicacion),
    atomic_list_concat([
        '{',
        '"usuario": "', UsuarioID, '",',
        '"division": "', Division, '",',
        '"explicacion": "', Explicacion, '"',
        '}'
    ], ExplanationJSON).

% =====================================================
% 4. CACHE Y OPTIMIZACIÓN
% =====================================================

% hechos dinámicos para caché
:- dynamic cached_routine/3.
:- dynamic cached_exercises/2.

% Guardar en caché
cache_routine(UsuarioID, Division, Rutina) :-
    assertz(cached_routine(UsuarioID, Division, Rutina)).

% Recuperar del caché
get_cached_routine(UsuarioID, Division, Rutina) :-
    cached_routine(UsuarioID, Division, Rutina),
    !.

% Limpiar caché
clear_cache :-
    retractall(cached_routine(_, _, _)),
    retractall(cached_exercises(_, _)).

% =====================================================
% 5. LOGGING Y AUDITORÍA
% =====================================================

:- dynamic log_entry/4.

% Registrar operación
log_operation(Operation, Usuario, Division, Status) :-
    get_time(Timestamp),
    assertz(log_entry(Operation, Usuario, Division, Status, Timestamp)).

% Obtener historial de operaciones
get_operation_log(Usuario, Logs) :-
    findall(log_entry(Op, U, Div, Status, Time),
            (log_entry(Op, U, Div, Status, Time), U = Usuario),
            Logs).

% =====================================================
% 6. MANEJO DE ERRORES
% =====================================================

% Predicado seguro con manejo de excepciones
generar_rutina_segura(UsuarioID, Division, Rutina, Error) :-
    catch(
        generar_rutina_semanal(UsuarioID, Division, Rutina),
        Exception,
        (Error = exception(Exception), fail)
    ).

% Validación segura
validar_rutina_segura(UsuarioID, Rutina, Resultado, Error) :-
    catch(
        validar_rutina_completa(UsuarioID, Rutina, Resultado),
        Exception,
        (Error = exception(Exception), fail)
    ).

% =====================================================
% 7. MÉTRICAS Y ANALYTICS
% =====================================================

% Contar rutinas generadas
count_routines_generated(Count) :-
    findall(1, log_entry(generate_routine, _, _, ok, _), Logs),
    length(Logs, Count).

% Operación más común
most_common_operation(Operation) :-
    findall(Op, log_entry(Op, _, _, _, _), Operations),
    most_frequent(Operations, Operation).

% Obtener estadísticas
get_statistics(Stats) :-
    count_routines_generated(Total),
    findall(ok_count, 
            (findall(1, log_entry(_, _, _, ok, _), OKs), length(OKs, ok_count)),
            [SuccessCount]),
    Stats = stats(total:Total, successful:SuccessCount).

% =====================================================
% 8. PREDICADOS AUXILIARES
% =====================================================

% Extraer error de validación
extraer_error(Error, [validacion_recuperacion(Error)|_]) :- Error \= ok, !.
extraer_error(Error, [_|Rest]) :- extraer_error(Error, Rest).

% Elemento más frecuente
most_frequent([], undefined) :- !.
most_frequent(List, Max) :-
    findall(Freq-Item, (
        member(Item, List),
        findall(1, member(Item, List), Matches),
        length(Matches, Freq)
    ), Freqs),
    sort(0, @>=, Freqs, [_-Max|_]).

% Secundarios a JSON
secundarios_a_json([]) :- '[]'.
secundarios_a_json([H|T]) :-
    (T = [] ->
        atomic_list_concat(['["', H, '"]'], JSON)
    ;   secundarios_a_json(T, RestJSON),
        atomic_list_concat(['["', H, ',', RestJSON, '"]'], JSON)).

% =====================================================
% 9. PRUEBAS DE INTEGRACIÓN
% =====================================================

% Test: Generar rutina y exportar como JSON
test_export_json :-
    writeln('TEST: Exportar rutina como JSON'),
    generar_rutina_semanal(user1, 'Full Body', Rutina),
    exportar_rutina_json(user1, 'Full Body', JSON),
    format('JSON generado: ~w~n', [JSON]).

% Test: API endpoints
test_api_endpoints :-
    writeln('TEST: Probar API endpoints'),
    api_get_user(user1, UserJSON),
    format('GET /users/user1: ~w~n', [UserJSON]),
    api_get_exercises_by_group(pecho, ExercisesJSON),
    format('GET /exercises/pecho: ~w~n', [ExercisesJSON]).

% =====================================================
% DOCUMENTACIÓN DE INTEGRACIÓN
% =====================================================

% Guía de integración con Spring Boot
guia_integracion :-
    writeln('=== GUÍA DE INTEGRACIÓN PROLOG-SPRING BOOT ==='),
    nl,
    writeln('1. INSTALACIÓN DE CLIENTE PROLOG EN JAVA:'),
    writeln('   - Usar librería: JPL (Java Prolog Library)'),
    writeln('   - Agregar dependencia: org.swi-prolog:jpl'),
    nl,
    writeln('2. CARGAR BASE DE CONOCIMIENTO:'),
    writeln('   - Query.onSolution = initProlog();'),
    writeln('   - Term result = Query.solve("consult(knowledge_base)");'),
    nl,
    writeln('3. LLAMAR PREDICADOS DESDE JAVA:'),
    writeln('   - Query query = new Query("generar_rutina_semanal(user1, Division, Rutina)");'),
    writeln('   - Map<String, Term> solution = query.oneSolution();'),
    nl,
    writeln('4. CONVERTIR RESULTADOS A JSON:'),
    writeln('   - Usar mapper ObjectMapper de Jackson'),
    writeln('   - Serializar resultados Prolog'),
    nl,
    writeln('5. ENDPOINTS DISPONIBLES:'),
    writeln('   - GET /api/routines/generate/{userId}'),
    writeln('   - POST /api/routines/validate'),
    writeln('   - GET /api/exercises/{groupId}'),
    writeln('   - POST /api/routines/explain'),
    nl.

% =====================================================
% EJEMPLO DE USO
% =====================================================

% ?- api_generate_routine(user1, JSON).
% ?- api_get_exercises_by_group(pecho, Exercises).
% ?- test_export_json.
% ?- guia_integracion.
