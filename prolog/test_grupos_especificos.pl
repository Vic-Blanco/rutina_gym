:-include('/app/prolog/knowledge_base.pl').
:-include('/app/prolog/rules.pl').

:- write('=== TEST CON GRUPOS ESPECÍFICOS ==='), nl.

% Los grupos exactos del test_java_exact.pl
% [hombros, gluteos, isquiotibial, cuadriceps]

:- write('Verificar si existen ejercicios para cada grupo:'), nl.

:- (findall(X, ejercicio(X, _, hombros, _, _, _), H), length(H, LenH),
    write('  hombros: '), write(LenH), write(' ejercicios'), nl).

:- (findall(X, ejercicio(X, _, gluteos, _, _, _), G), length(G, LenG),
    write('  gluteos: '), write(LenG), write(' ejercicios'), nl).

:- (findall(X, ejercicio(X, _, isquiotibial, _, _, _), I), length(I, LenI),
    write('  isquiotibial: '), write(LenI), write(' ejercicios'), nl).

:- (findall(X, ejercicio(X, _, cuadriceps, _, _, _), Q), length(Q, LenQ),
    write('  cuadriceps: '), write(LenQ), write(' ejercicios'), nl).

% Ahora probar generar_rutina_personalizada con esos grupos
:- write('Generar rutina con esos grupos:'), nl,
   (generar_rutina_personalizada('user1', 'intermedio', 'hipertrofia', 3, 
                                  [hombros, gluteos, isquiotibial, cuadriceps], Rutina) ->
    (length(Rutina, Len), write('✓ '), write(Len), write(' días'), nl,
     Rutina = [Dia1|_],
     write('  Día 1: '), write(Dia1), nl) ;
    write('✗ FALLO'), nl).

:- halt.
