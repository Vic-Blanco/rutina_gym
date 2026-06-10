% =====================================================
% ARCHIVO DE INFORMACIÓN - SISTEMA EXPERTO
% =====================================================
% Este archivo ha sido reestructurado para convertirse en
% un verdadero SISTEMA EXPERTO con razonamiento inteligente
%
% ⚠️ MIGRACIÓN COMPLETADA ✓
%
% El contenido ahora está organizado en 5 módulos:
%   1. knowledge_base.pl  ← Base de Conocimiento (hechos)
%   2. rules.pl           ← Lógica de Inferencia (reglas)
%   3. validation.pl      ← Validación y Análisis (restricciones)
%   4. examples.pl        ← Ejemplos e Interfaz (demostraciones)
%   5. integration.pl     ← Integración REST API (conectividad)
%
% =====================================================
% ESTRUCTURA NUEVA DEL SISTEMA
% =====================================================
%
% BASE DE CONOCIMIENTO (knowledge_base.pl):
%   • 3 usuarios con configuraciones diferentes
%   • 4 objetivos de entrenamiento
%   • 3 niveles de experiencia
%   • 12 grupos musculares clasificados
%   • 30+ ejercicios con propiedades completas
%   • Músculos secundarios e intensidades
%   • Compatibilidades e incompatibilidades
%   • 4 divisiones de rutina diferentes
%   • Parámetros de recuperación y volumen
%
% LÓGICA EXPERTA (rules.pl):
%   • Selección automática de división
%   • Validación inteligente de ejercicios
%   • Generación de rutinas semanales
%   • Parámetros adaptativos por objetivo
%   • Análisis de balance push/pull
%   • Detección de fatiga muscular
%   • Validación de recuperación
%   • Cálculo de volumen total
%   • Sugerencias de mejora automáticas
%
% VALIDACIÓN PROFUNDA (validation.pl):
%   • Validación completa con múltiples criterios
%   • Detección de sobreentrenamiento
%   • Detección de desbalances
%   • Detección de fatiga acumulada
%   • Explicaciones detalladas de decisiones
%   • Recomendaciones personalizadas
%   • Reportes completos y estadísticas
%
% EJEMPLOS DE USO (examples.pl):
%   • Función principal generar_rutina_completa/1
%   • Presentación amigable de resultados
%   • Comparación de rutinas
%   • Estadísticas del sistema
%   • Tests automatizados
%   • Menú interactivo
%
% INTEGRACIÓN (integration.pl):
%   • API endpoints REST simulados
%   • Exportación a JSON
%   • Conversión de datos
%   • Caché y optimización
%   • Logging y auditoría
%   • Métricas y analytics
%
% =====================================================
% CÓMO USAR EL NUEVO SISTEMA
% =====================================================
%
% Paso 1: Cargar la base de conocimiento
%   ?- consult('knowledge_base.pl').
%
% Paso 2: Generar rutina completa (recomendado)
%   ?- generar_rutina_completa(user1).
%
% Paso 3: Alternativas específicas
%   ?- seleccionar_division(user1, Division).
%   ?- generar_rutina_semanal(user1, 'Full Body', Rutina).
%   ?- rutina_valida(user1, Rutina).
%   ?- generar_recomendaciones(user1, Rutina, Recs).
%
% Paso 4: Obtener explicaciones
%   ?- explicacion_completa(user1, Division, Rutina, Explicacion).
%   ?- generar_reporte_rutina(user1, Rutina, Reporte).
%
% Paso 5: Ver estadísticas
%   ?- estadisticas_sistema.
%   ?- listar_ejercicios.
%   ?- ejecutar_tests.
%
% =====================================================
% CARACTERÍSTICAS PRINCIPALES
% =====================================================
%
% ✓ RAZONAMIENTO EXPERTO
%   - Toma decisiones basadas en reglas reales
%   - Infiere información implícita
%   - Adapta recomendaciones al contexto
%
% ✓ VALIDACIÓN AUTOMÁTICA
%   - Verifica recuperación muscular
%   - Controla volumen total
%   - Valida frecuencia por grupo
%   - Detecta desbalances push/pull
%   - Previene grupos consecutivos
%
% ✓ EXPLICACIONES TRANSPARENTES
%   - Justifica cada decisión
%   - Razonamientos inteligibles
%   - Recomendaciones personalizadas
%
% ✓ ADAPTABILIDAD
%   - Diferentes divisiones por disponibilidad
%   - Parámetros según objetivo
%   - Ejercicios por nivel
%   - Prioridades personalizadas
%
% ✓ ESCALABILIDAD
%   - Fácil agregar ejercicios
%   - Nuevas divisiones
%   - Nuevas reglas
%   - Integración REST API
%
% =====================================================
% COMPATIBILIDAD CON VERSIÓN ANTERIOR
% =====================================================

% GRUPOS MUSCULARES (mantiene compatibilidad)
grupo_muscular(pecho).
grupo_muscular(espalda).
grupo_muscular(hombros).
grupo_muscular(biceps).
grupo_muscular(triceps).
grupo_muscular(antebrazo).
grupo_muscular(cuadriceps).
grupo_muscular(isquiotibial).
grupo_muscular(gluteos).
grupo_muscular(pantorrilla).
grupo_muscular(core).
grupo_muscular(cardio).

% NIVELES (mantiene compatibilidad)
nivel(inicial).
nivel(intermedio).
nivel(avanzado).

% =====================================================
% REFERENCIA RÁPIDA DE CONSULTAS
% =====================================================
%
% 1. GENERAR RUTINA COMPLETA
%    ?- generar_rutina_completa(user1).
%    Genera rutina + validación + recomendaciones
%
% 2. SELECCIONAR DIVISIÓN
%    ?- seleccionar_division(user1, Division).
%    Retorna: Division = 'Full Body'
%
% 3. GENERAR RUTINA SEMANAL
%    ?- generar_rutina_semanal(user1, 'Full Body', Rutina).
%    Retorna estructura completa de la rutina
%
% 4. VALIDAR RUTINA
%    ?- rutina_valida(user1, Rutina).
%    true si es válida, fail si no
%
% 5. RECOMENDACIONES
%    ?- generar_recomendaciones(user1, Rutina, Recs).
%    Retorna lista de sugerencias
%
% 6. EXPLICACIONES
%    ?- explicacion_completa(user1, 'Full Body', Rutina, Expl).
%    Retorna explicación detallada
%
% 7. REPORTE
%    ?- generar_reporte_rutina(user1, Rutina, Reporte).
%    Retorna estadísticas y análisis
%
% =====================================================
% COMPARACIÓN: ANTES vs AHORA
% =====================================================
%
% ANTES (ejercicios.pl):
%  ✗ Almacenaba solo listas de ejercicios
%  ✗ Sin razonamiento inteligente
%  ✗ Sin validación automática
%  ✗ No explicaba decisiones
%  ✗ Dificil de extender
%
% AHORA (Sistema Experto):
%  ✓ Genera rutinas inteligentes
%  ✓ Valida automáticamente
%  ✓ Razona como experto
%  ✓ Explica cada decisión
%  ✓ Modular y escalable
%  ✓ Integración REST API
%  ✓ Reportes y análisis
%
% =====================================================
% PRÓXIMOS PASOS
% =====================================================
%
% 1. Cargar el nuevo sistema:
%    ?- consult('knowledge_base.pl').
%
% 2. Generar tu primera rutina:
%    ?- generar_rutina_completa(user1).
%
% 3. Explorar características:
%    ?- listar_ejercicios.
%    ?- estadisticas_sistema.
%    ?- ejecutar_tests.
%
% 4. Integrar con Spring Boot:
%    Ver archivo integration.pl
%
% =====================================================
% DOCUMENTACIÓN
% =====================================================
%
% Para documentación completa, ver:
%   /prolog/README_SISTEMA_EXPERTO.md
%
% Para ejemplos, ver:
%   /prolog/examples.pl
%
% Para integración API:
%   /prolog/integration.pl
%
% =====================================================

