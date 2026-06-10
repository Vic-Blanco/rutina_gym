:-include('/app/prolog/knowledge_base.pl').
:-include('/app/prolog/rules.pl').

:- write('=== TEST DETALLADO ==='), nl.

% Test 1: ¿existe objetivo(hipertrofia)?
:- write('1. objetivo(hipertrofia) = '),
   (objetivo(hipertrofia, A, B, C, D, E) -> 
    write('SI - '), write(C), nl ; 
    write('NO'), nl).

% Test 2: ¿generar_ejercicios_desde_parametros?
:- write('2. generar_ejercicios_desde_parametros(intermedio, hipertrofia, pecho, Ejer):'), nl,
   (generar_ejercicios_desde_parametros(intermedio, hipertrofia, pecho, Ejer) ->
    (write('   Encontrados '), length(Ejer, Len), write(Len), write(' ejercicios'), nl) ;
    write('   FALLO'), nl).

% Test 3: ¿generar_dia_desde_parametros con 1 grupo?
:- write('3. generar_dia_desde_parametros(intermedio, hipertrofia, 1, [pecho], Dia):'), nl,
   (generar_dia_desde_parametros(intermedio, hipertrofia, 1, [pecho], Dia) ->
    (write('   Estructura: '), write(Dia), nl) ;
    write('   FALLO'), nl).

% Test 4: ¿generar_dia_desde_parametros con múltiples grupos?
:- write('4. generar_dia_desde_parametros(intermedio, hipertrofia, 1, [pecho, espalda], Dia):'), nl,
   (generar_dia_desde_parametros(intermedio, hipertrofia, 1, [pecho, espalda], Dia) ->
    (write('   Estructura: '), write(Dia), nl) ;
    write('   FALLO'), nl).

% Test 5: ¿generar_rutina_desde_parametros?
:- write('5. generar_rutina_desde_parametros(user1, intermedio, hipertrofia, 2, [pecho, espalda], Rutina):'), nl,
   (generar_rutina_desde_parametros(user1, intermedio, hipertrofia, 2, [pecho, espalda], Rutina) ->
    (length(Rutina, Len), write('   ✓ '), write(Len), write(' días'), nl) ;
    write('   FALLO'), nl).

:- halt.
