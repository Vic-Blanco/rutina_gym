:-consult('/app/prolog/integration.pl').
:-set_prolog_flag(unknown, fail).
:-(generar_rutina_personalizada('user1', 'intermedio', 'hipertrofia', 3, [hombros, gluteos, isquiotibial, cuadriceps], Rutina) -> write_canonical(Rutina) ; write('ERROR')).
:-halt.
