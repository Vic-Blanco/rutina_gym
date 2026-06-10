:-include('/app/prolog/knowledge_base.pl').
:-include('/app/prolog/rules.pl').

:- write('=== TEST CON LÍMITE DE 6 EJERCICIOS ==='), nl.

:- (generar_rutina_personalizada('user1', 'intermedio', 'hipertrofia', 2, 
                                  [pecho, espalda], Rutina) ->
    (Rutina = [Dia1|_],
     Dia1 = dia(_, GruposDia1),
     write('Día 1 - Grupos: '), nl,
     forall(member(grupo_ejercicios(G, Ejer), GruposDia1),
            (length(Ejer, Len),
             write('  '), write(G), write(': '), write(Len), write(' ejercicios'), nl)),
     write('Total por día verificable'), nl) ;
    write('✗ FALLO'), nl).

:- halt.
