% =====================================================
% EXEMPLOS Y CASOS DE USO DEL SISTEMA EXPERTO
% =====================================================
% Demostraciones prácticas del sistema de generación de rutinas

:- include('knowledge_base.pl').
:- include('rules.pl').
:- include('validation.pl').

% =====================================================
% INTERFAZ PRINCIPAL DEL SISTEMA
% =====================================================

% Función principal: generar rutina completa para usuario
generar_rutina_completa(UsuarioID) :-
    usuario(UsuarioID, Nombre, _, _, _, _, _),
    writeln('==================================='),
    writeln('GENERACIÓN DE RUTINA DE ENTRENAMIENTO'),
    writeln('==================================='),
    format('Usuario: ~w~n', [Nombre]),
    nl,
    
    % Paso 1: Seleccionar división
    writeln('PASO 1: Seleccionar División'),
    writeln('------------------------------'),
    seleccionar_division(UsuarioID, Division),
    format('División seleccionada: ~w~n', [Division]),
    nl,
    
    % Paso 2: Generar rutina
    writeln('PASO 2: Generar Rutina'),
    writeln('------------------------------'),
    generar_rutina_semanal(UsuarioID, Division, Rutina),
    writeln('Rutina generada'),
    nl,
    
    % Paso 3: Validar
    writeln('PASO 3: Validación'),
    writeln('------------------------------'),
    validaciones_individuales(UsuarioID, Rutina, Validaciones),
    mostrar_validaciones(Validaciones),
    nl,
    
    % Paso 4: Mostrar recomendaciones
    writeln('PASO 4: Recomendaciones'),
    writeln('------------------------------'),
    generar_recomendaciones(UsuarioID, Rutina, Recs),
    mostrar_recomendaciones(Recs),
    nl,
    
    % Paso 5: Mostrar rutina
    writeln('PASO 5: Rutina Detallada'),
    writeln('------------------------------'),
    mostrar_rutina_detallada(Rutina),
    nl,
    
    writeln('===================================').

% =====================================================
% FUNCIONES DE PRESENTACIÓN
% =====================================================

% Mostrar validaciones
mostrar_validaciones([]).
mostrar_validaciones([Validacion|Rest]) :-
    mostrar_validacion_individual(Validacion),
    mostrar_validaciones(Rest).

mostrar_validacion_individual(validacion_recuperacion(ok)) :-
    writeln('  ✓ Recuperación: VÁLIDA'),
    !.

mostrar_validacion_individual(validacion_recuperacion(Fallo)) :-
    format('  ✗ Recuperación: ~w~n', [Fallo]).

mostrar_validacion_individual(validacion_volumen(ok)) :-
    writeln('  ✓ Volumen: VÁLIDO'),
    !.

mostrar_validacion_individual(validacion_volumen(Fallo)) :-
    format('  ✗ Volumen: ~w~n', [Fallo]).

mostrar_validacion_individual(validacion_frecuencia(ok)) :-
    writeln('  ✓ Frecuencia Muscular: VÁLIDA'),
    !.

mostrar_validacion_individual(validacion_frecuencia(Fallo)) :-
    format('  ✗ Frecuencia Muscular: ~w~n', [Fallo]).

mostrar_validacion_individual(validacion_balance(ok)) :-
    writeln('  ✓ Balance Push/Pull: VÁLIDO'),
    !.

mostrar_validacion_individual(validacion_balance(Fallo)) :-
    format('  ✗ Balance: ~w~n', [Fallo]).

mostrar_validacion_individual(validacion_grupos(ok)) :-
    writeln('  ✓ Grupos Musculares: VÁLIDOS'),
    !.

mostrar_validacion_individual(validacion_grupos(Fallo)) :-
    format('  ✗ Grupos: ~w~n', [Fallo]).

% Mostrar recomendaciones
mostrar_recomendaciones([]) :-
    writeln('  No hay recomendaciones especiales.'),
    !.

mostrar_recomendaciones(Recs) :-
    forall(member(Rec, Recs), (
        format('  • ~w~n', [Rec])
    )).

% Mostrar rutina detallada
mostrar_rutina_detallada([]).
mostrar_rutina_detallada([dia(Dia, DiasInfo)|Rest]) :-
    format('~nDÍA ~w:~n', [Dia]),
    writeln('--------'),
    mostrar_dia_detallado(DiasInfo),
    mostrar_rutina_detallada(Rest).

% Mostrar día detallado
mostrar_dia_detallado([]).
mostrar_dia_detallado([grupo_ejercicios(Grupo, Ejercicios)|Rest]) :-
    format('~n  ~w:~n', [Grupo]),
    mostrar_ejercicios(Ejercicios),
    mostrar_dia_detallado(Rest).

% Mostrar ejercicios
mostrar_ejercicios([]).
mostrar_ejercicios([ejercicio_info(_, Nombre, Series, Reps, Descanso)|Rest]) :-
    format('    - ~w: ~w series x ~w reps (descanso: ~w min)~n', [Nombre, Series, Reps, Descanso]),
    mostrar_ejercicios(Rest).

% =====================================================
% ANÁLISIS Y COMPARACIÓN DE RUTINAS
% =====================================================

% Comparar dos rutinas
comparar_rutinas(Rutina1, Rutina2) :-
    writeln('=== COMPARACIÓN DE RUTINAS ==='),
    nl,
    
    volumen_total_semana(Rutina1, Vol1),
    volumen_total_semana(Rutina2, Vol2),
    format('Volumen Rutina 1: ~w series~n', [Vol1]),
    format('Volumen Rutina 2: ~w series~n', [Vol2]),
    (Vol1 > Vol2 -> 
        Diff is Vol1 - Vol2,
        format('Rutina 1 tiene ~w series más~n', [Diff])
    ;   Diff is Vol2 - Vol1,
        format('Rutina 2 tiene ~w series más~n', [Diff])
    ),
    nl,
    
    contar_empujes(Rutina1, Emp1),
    contar_empujes(Rutina2, Emp2),
    contar_tirones(Rutina1, Tir1),
    contar_tirones(Rutina2, Tir2),
    
    format('Push/Pull Rutina 1: ~w / ~w (ratio: ~w)~n', [Emp1, Tir1, (Emp1/(max(Tir1,1)))]),
    format('Push/Pull Rutina 2: ~w / ~w (ratio: ~w)~n', [Emp2, Tir2, (Emp2/(max(Tir2,1)))]),
    nl,
    
    (push_pull_balanceado(Rutina1) -> writeln('Rutina 1: Push/Pull BALANCEADO') ; writeln('Rutina 1: DESBALANCE')),
    (push_pull_balanceado(Rutina2) -> writeln('Rutina 2: Push/Pull BALANCEADO') ; writeln('Rutina 2: DESBALANCE')).

% =====================================================
% EXPLICACIONES NATURALES
% =====================================================

% Explicar decisiones del sistema
explicar_sistema :-
    writeln('=== EXPLICACIÓN DEL SISTEMA EXPERTO ==='),
    nl,
    writeln('El sistema de generación de rutinas utiliza:'),
    nl,
    writeln('1. BASE DE CONOCIMIENTO:'),
    writeln('   - Biblioteca de 30+ ejercicios con propiedades detalladas'),
    writeln('   - Objetivos de entrenamiento con parámetros específicos'),
    writeln('   - Divisiones de rutina (Full Body, Push/Pull/Legs, Weider, etc.)'),
    writeln('   - Compatibilidades e incompatibilidades musculares'),
    nl,
    writeln('2. REGLAS DE INFERENCIA:'),
    writeln('   - Selección automática de división según disponibilidad'),
    writeln('   - Selección de ejercicios válidos según nivel'),
    writeln('   - Distribución inteligente de grupos musculares'),
    writeln('   - Respeto de tiempos de recuperación'),
    nl,
    writeln('3. VALIDACIÓN:'),
    writeln('   - Verificación de recuperación muscular'),
    writeln('   - Control de volumen total'),
    writeln('   - Balance push/pull'),
    writeln('   - Frecuencia muscular adecuada'),
    nl,
    writeln('4. RAZONAMIENTO:'),
    writeln('   - Explicaciones para cada decisión'),
    writeln('   - Detección de problemas'),
    writeln('   - Recomendaciones personalizadas'),
    nl.

% =====================================================
% CONSULTAS DE INTELIGENCIA EMPRESARIAL
% =====================================================

% Estadísticas del sistema
estadisticas_sistema :-
    writeln('=== ESTADÍSTICAS DEL SISTEMA ==='),
    nl,
    
    findall(1, ejercicio(_, _, _, _, _, _), Ejercicios),
    length(Ejercicios, TotalEjercicios),
    format('Total de ejercicios en BD: ~w~n', [TotalEjercicios]),
    
    findall(1, usuario(_, _, _, _, _, _, _), Usuarios),
    length(Usuarios, TotalUsuarios),
    format('Total de usuarios: ~w~n', [TotalUsuarios]),
    
    findall(1, division_rutina(_, _, _), Divisiones),
    length(Divisiones, TotalDivisiones),
    format('Total de divisiones: ~w~n', [TotalDivisiones]),
    
    nl.

% Ejercicios disponibles por grupo muscular
ejercicios_por_grupo :-
    writeln('=== EJERCICIOS POR GRUPO MUSCULAR ==='),
    nl,
    forall(grupo_muscular(Grupo, _, _), (
        findall(Nombre, ejercicio(_, Nombre, Grupo, _, _, _), Ejercicios),
        length(Ejercicios, Count),
        format('~w: ~w ejercicios~n', [Grupo, Count])
    )).

% Usuarios por nivel
usuarios_por_nivel :-
    writeln('=== USUARIOS POR NIVEL ==='),
    nl,
    forall(nivel(Nivel, Desc), (
        findall(Nombre, usuario(_, Nombre, Nivel, _, _, _, _), Usuarios),
        length(Usuarios, Count),
        format('~w (~w): ~w usuarios~n', [Nivel, Desc, Count])
    )).

% =====================================================
% TESTS Y VALIDACIÓN DE LÓGICA
% =====================================================

% Test: Verificar que todos los ejercicios tienen ID válido
test_ejercicios_validos :-
    writeln('TEST: Verificando ejercicios válidos...'),
    (   forall(ejercicio(ID, Nombre, Grupo, _, _, _), (
            nonvar(ID), nonvar(Nombre), nonvar(Grupo),
            grupo_muscular(Grupo, _, _)
        ))
    ->  writeln('  ✓ PASÓ: Todos los ejercicios son válidos')
    ;   writeln('  ✗ FALLÓ: Hay ejercicios inválidos')
    ).

% Test: Verificar que los usuarios tienen configuración válida
test_usuarios_validos :-
    writeln('TEST: Verificando usuarios válidos...'),
    (   forall(usuario(ID, Nombre, Nivel, Objetivo, Dias, Grupos, _), (
            nonvar(ID), nonvar(Nombre),
            nivel(Nivel, _),
            objetivo(Objetivo, _, _, _, _, _),
            Dias > 0, Dias =< 7,
            is_list(Grupos)
        ))
    ->  writeln('  ✓ PASÓ: Todos los usuarios son válidos')
    ;   writeln('  ✗ FALLÓ: Hay usuarios inválidos')
    ).

% Test: Verificar divisiones
test_divisiones_validas :-
    writeln('TEST: Verificando divisiones válidas...'),
    (   forall(division_rutina(Nombre, Dias, Desc), (
            nonvar(Nombre), is_list(Dias), nonvar(Desc),
            length(Dias, L), L > 0
        ))
    ->  writeln('  ✓ PASÓ: Todas las divisiones son válidas')
    ;   writeln('  ✗ FALLÓ: Hay divisiones inválidas')
    ).

% Ejecutar todos los tests
ejecutar_tests :-
    writeln('===== EJECUTANDO TESTS DEL SISTEMA ====='),
    nl,
    test_ejercicios_validos, nl,
    test_usuarios_validos, nl,
    test_divisiones_validas, nl,
    writeln('===== TESTS COMPLETADOS =====').

% =====================================================
% UTILIDADES DE CONSULTA
% =====================================================

% Listar todos los ejercicios
listar_ejercicios :-
    writeln('=== BIBLIOTECA DE EJERCICIOS ==='),
    nl,
    forall(ejercicio(ID, Nombre, Grupo, Tipo, Patron, Dif), (
        format('~w (~w): ~w - ~w (dificultad: ~w)~n', [Nombre, ID, Grupo, Tipo, Dif])
    )).

% Listar todos los usuarios
listar_usuarios :-
    writeln('=== USUARIOS DEL SISTEMA ==='),
    nl,
    forall(usuario(ID, Nombre, Nivel, Objetivo, Dias, Grupos, Prioritario), (
        format('~w (~w): Nivel=~w, Objetivo=~w, Días=~w, Prioritario=~w~n', 
               [Nombre, ID, Nivel, Objetivo, Dias, Prioritario])
    )).

% =====================================================
% DOCUMENTACIÓN DE CONSULTAS
% =====================================================

% Guía de uso del sistema
guia_uso :-
    writeln('=== GUÍA DE USO DEL SISTEMA EXPERTO ==='),
    nl,
    writeln('CONSULTAS PRINCIPALES:'),
    writeln(''),
    writeln('1. Generar rutina para usuario:'),
    writeln('   ?- generar_rutina_completa(user1).'),
    writeln(''),
    writeln('2. Seleccionar división automáticamente:'),
    writeln('   ?- seleccionar_division(user1, Division).'),
    writeln(''),
    writeln('3. Generar rutina semanal:'),
    writeln('   ?- generar_rutina_semanal(user1, Division, Rutina).'),
    writeln(''),
    writeln('4. Validar rutina:'),
    writeln('   ?- rutina_valida(user1, Rutina).'),
    writeln(''),
    writeln('5. Obtener recomendaciones:'),
    writeln('   ?- generar_recomendaciones(user1, Rutina, Recs).'),
    writeln(''),
    writeln('6. Explicación de decisiones:'),
    writeln('   ?- explicacion_completa(user1, Division, Rutina, Expl).'),
    writeln(''),
    writeln('7. Estadísticas:'),
    writeln('   ?- estadisticas_sistema.'),
    writeln(''),
    writeln('8. Listar ejercicios:'),
    writeln('   ?- listar_ejercicios.'),
    writeln(''),
    writeln('9. Ejecutar tests:'),
    writeln('   ?- ejecutar_tests.'),
    nl.

% =====================================================
% MODO INTERACTIVO
% =====================================================

% Menú principal
menu_principal :-
    writeln(''),
    writeln('╔════════════════════════════════════════╗'),
    writeln('║  SISTEMA EXPERTO DE RUTINAS - MENÚ    ║'),
    writeln('╚════════════════════════════════════════╝'),
    writeln(''),
    writeln('1. Generar rutina completa'),
    writeln('2. Comparar rutinas'),
    writeln('3. Ver estadísticas'),
    writeln('4. Listar ejercicios'),
    writeln('5. Listar usuarios'),
    writeln('6. Ejecutar tests'),
    writeln('7. Ver explicación del sistema'),
    writeln('8. Ver guía de uso'),
    writeln('9. Salir'),
    writeln(''),
    write('Seleccione una opción: ').
