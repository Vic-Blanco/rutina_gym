:- include('knowledge_base.pl').
:- include('rules.pl').

:- write('=== TEST generar_rutina_personalizada ==='), nl.
:- (generar_rutina_personalizada('user1', 'intermedio', 'hipertrofia', 2, [pecho, espalda], Rutina) ->
    write('✓ generar_rutina_personalizada OK'), nl ;
    write('✗ generar_rutina_personalizada FALLO'), nl).

:- halt.
