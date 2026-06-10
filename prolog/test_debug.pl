:- include('knowledge_base.pl').
:- include('rules.pl').

% Test debug
:- write('=== INICIANDO DEBUG ==='), nl.

% Prueba 1: ¿Existe objetivo(hipertrofia)?
:- (objetivo(hipertrofia, A, B, C, D, E) -> 
    (write('✓ objetivo(hipertrofia) encontrado: '), write(C), nl) ; 
    write('✗ objetivo(hipertrofia) NO encontrado'), nl).

% Prueba 2: ¿nivel_suficiente(intermedio, intermedio)?
:- (nivel_suficiente(intermedio, intermedio) -> 
    write('✓ nivel_suficiente(intermedio, intermedio) OK'), nl ; 
    write('✗ nivel_suficiente FALLO'), nl).

% Prueba 3: ¿ejercicio_compuesto(ex_201)?
:- (ejercicio_compuesto(ex_201) -> 
    write('✓ ejercicio_compuesto(ex_201) OK'), nl ; 
    write('✗ ejercicio_compuesto FALLO'), nl).

% Prueba 4: ¿Generar ejercicios para hombros?
:- write('Prueba: generar_ejercicios_desde_parametros(intermedio, hipertrofia, hombros, Ejer)'), nl,
   (generar_ejercicios_desde_parametros(intermedio, hipertrofia, hombros, Ejer) ->
    (write('✓ Ejercicios encontrados: '), write(Ejer), nl) ;
    write('✗ generar_ejercicios_desde_parametros FALLO'), nl).

% Prueba 5: ¿Generar día?
:- write('Prueba: generar_dia_desde_parametros(intermedio, hipertrofia, 1, [hombros], Dia)'), nl,
   (generar_dia_desde_parametros(intermedio, hipertrofia, 1, [hombros], Dia) ->
    (write('✓ Día generado: '), write(Dia), nl) ;
    write('✗ generar_dia_desde_parametros FALLO'), nl).

% Prueba 6: ¿Generar rutina automática?
:- write('Prueba: generar_rutina_automatica(user1, intermedio, hipertrofia, 4, Rutina)'), nl,
   (generar_rutina_automatica(user1, intermedio, hipertrofia, 4, Rutina) ->
    (write('✓ Rutina automática: '), write(Rutina), nl) ;
    write('✗ generar_rutina_automatica FALLO'), nl).

:- halt.
