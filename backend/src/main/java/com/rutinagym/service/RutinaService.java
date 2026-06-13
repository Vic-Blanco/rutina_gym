package com.rutinagym.service;

import com.rutinagym.model.Usuario;
import com.rutinagym.model.Rutina;
import com.rutinagym.model.DiaEntrenamiento;
import com.rutinagym.model.Ejercicio;
import com.rutinagym.model.Nivel;
import com.rutinagym.model.GrupoMuscular;
import com.rutinagym.model.TipoEjercicio;
import com.rutinagym.model.Patron;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.util.*;

/**
 * Servicio de lógica de negocio para generar rutinas.
 * Combina OOP con reglas Prolog para crear rutinas personalizadas.
 */
@Service
public class RutinaService {
    
    private static final Logger logger = LoggerFactory.getLogger(RutinaService.class);
    
    @Autowired
    private PrologService prologService;
    
    /**
     * Genera una rutina personalizada para un usuario
     * @param usuario Usuario propietario de la rutina
     * @param nombre Nombre de la rutina
     * @param objetivo Objetivo del entrenamiento
     * @param nivel Nivel de dificultad
     * @param numDias Número de días de entrenamiento
     * @param gruposObjectivo Grupos musculares a trabajar
     * @return Rutina generada
     */
    public Rutina generarRutinaPersonalizada(Usuario usuario, 
                                             String nombre,
                                             String objetivo,
                                             String nivel,
                                             Integer numDias,
                                             List<String> gruposObjectivo) {
        
        Rutina rutina = new Rutina();
        rutina.setUsuario(usuario);
        rutina.setNombre(nombre);
        rutina.setNivel(Nivel.valueOf(nivel.toUpperCase()));
        rutina.setNumDias(numDias);
        rutina.setDescripcion(
            String.format("Rutina de %d días para trabajar %s", 
                         numDias, 
                         String.join(", ", gruposObjectivo))
        );
        
        // Generar días de entrenamiento
        List<DiaEntrenamiento> dias = new ArrayList<>();
        for (int i = 1; i <= numDias; i++) {
            DiaEntrenamiento dia = crearDiaEntrenamiento(
                rutina, 
                i, 
                numDias,
                objetivo,
                nivel
            );
            dias.add(dia);
        }
        
        rutina.setDiasEntrenamiento(dias);
        return rutina;
    }
    
    /**
     * Crea un día de entrenamiento específico
     */
    private DiaEntrenamiento crearDiaEntrenamiento(Rutina rutina,
                                                  int numeroDia,
                                                  int totalDias,
                                                  String objetivo,
                                                  String nivel) {
        
        DiaEntrenamiento dia = new DiaEntrenamiento();
        dia.setRutina(rutina);
        dia.setNumeroDia(numeroDia);
        
        // Obtener grupos musculares para este día según patrón
        List<String> gruposDelDia = generarGruposPorDefecto(numeroDia, totalDias);
        
        dia.setDescripcion("Día " + numeroDia + ": " + String.join(", ", gruposDelDia));
        
        // Crear ejercicios para cada grupo muscular del día
        List<Ejercicio> ejercicios = new ArrayList<>();
        for (String grupo : gruposDelDia) {
            // Generar ejercicios recomendados por grupo muscular
            List<String> ejerciciosRec = generarEjerciciosRecomendados(grupo, nivel);
            
            for (String nombreEjercicio : ejerciciosRec) {
                Ejercicio ejercicio = crearEjercicio(
                    nombreEjercicio,
                    grupo,
                    objetivo,
                    nivel,
                    dia
                );
                ejercicios.add(ejercicio);
            }
        }
        
        dia.setEjercicios(ejercicios);
        return dia;
    }
    
    /**
     * Crea un objeto Ejercicio con valores por defecto
     * Ajusta series/reps según OBJETIVO + NIVEL (Prolog rules)
     */
    private Ejercicio crearEjercicio(String nombre,
                                    String grupoMuscular,
                                    String objetivo,
                                    String nivel,
                                    DiaEntrenamiento dia) {
        
        Ejercicio ejercicio = new Ejercicio();
        ejercicio.setNombre(nombre);
        ejercicio.setGrupoMuscular(GrupoMuscular.valueOf(grupoMuscular.toUpperCase()));
        ejercicio.setNivelDificultadMinima(Nivel.valueOf(nivel.toUpperCase()));
        ejercicio.setDiaEntrenamiento(dia);
        
        // Series, repeticiones y descanso según OBJETIVO + NIVEL
        // Basado en reglas Prolog de conocimiento de entrenamiento
        if ("HIPERTROFIA".equalsIgnoreCase(objetivo)) {
            // Hipertrofia: 6-12 reps, alto volumen
            switch (nivel.toUpperCase()) {
                case "INICIAL":
                    ejercicio.setSeries(3);
                    ejercicio.setRepeticiones(10);
                    ejercicio.setDescansoSegundos(60);
                    break;
                case "INTERMEDIO":
                    ejercicio.setSeries(4);
                    ejercicio.setRepeticiones(12);
                    ejercicio.setDescansoSegundos(60);
                    break;
                case "AVANZADO":
                    ejercicio.setSeries(5);
                    ejercicio.setRepeticiones(12);
                    ejercicio.setDescansoSegundos(90);
                    break;
            }
        } else if ("FUERZA".equalsIgnoreCase(objetivo)) {
            // Fuerza: 1-6 reps, bajo volumen, largo descanso
            switch (nivel.toUpperCase()) {
                case "INICIAL":
                    ejercicio.setSeries(3);
                    ejercicio.setRepeticiones(5);
                    ejercicio.setDescansoSegundos(120);
                    break;
                case "INTERMEDIO":
                    ejercicio.setSeries(4);
                    ejercicio.setRepeticiones(5);
                    ejercicio.setDescansoSegundos(180);
                    break;
                case "AVANZADO":
                    ejercicio.setSeries(5);
                    ejercicio.setRepeticiones(3);
                    ejercicio.setDescansoSegundos(240);
                    break;
            }
        } else if ("DEFINICION".equalsIgnoreCase(objetivo)) {
            // Definición: alto reps, bajo descanso
            switch (nivel.toUpperCase()) {
                case "INICIAL":
                    ejercicio.setSeries(2);
                    ejercicio.setRepeticiones(15);
                    ejercicio.setDescansoSegundos(30);
                    break;
                case "INTERMEDIO":
                    ejercicio.setSeries(3);
                    ejercicio.setRepeticiones(15);
                    ejercicio.setDescansoSegundos(45);
                    break;
                case "AVANZADO":
                    ejercicio.setSeries(4);
                    ejercicio.setRepeticiones(20);
                    ejercicio.setDescansoSegundos(30);
                    break;
            }
        } else if ("HIBRIDO".equalsIgnoreCase(objetivo)) {
            // Híbrido: equilibrio fuerza/resistencia
            switch (nivel.toUpperCase()) {
                case "INICIAL":
                    ejercicio.setSeries(3);
                    ejercicio.setRepeticiones(10);
                    ejercicio.setDescansoSegundos(45);
                    break;
                case "INTERMEDIO":
                    ejercicio.setSeries(4);
                    ejercicio.setRepeticiones(12);
                    ejercicio.setDescansoSegundos(60);
                    break;
                case "AVANZADO":
                    ejercicio.setSeries(4);
                    ejercicio.setRepeticiones(15);
                    ejercicio.setDescansoSegundos(45);
                    break;
            }
        } else {
            // Default (si objetivo no se reconoce)
            switch (nivel.toUpperCase()) {
                case "INICIAL":
                    ejercicio.setSeries(3);
                    ejercicio.setRepeticiones(10);
                    break;
                case "INTERMEDIO":
                    ejercicio.setSeries(4);
                    ejercicio.setRepeticiones(12);
                    break;
                case "AVANZADO":
                    ejercicio.setSeries(5);
                    ejercicio.setRepeticiones(15);
                    break;
            }
            ejercicio.setDescansoSegundos(60);
        }
        
        return ejercicio;
    }
    
    /**
     * Genera grupos musculares por defecto si Prolog no devuelve resultados
     */
    private List<String> generarGruposPorDefecto(int dia, int totalDias) {
        Map<Integer, List<List<String>>> distribuccion = new HashMap<>();
        
        // Distribución de grupos por número de días
        distribuccion.put(3, Arrays.asList(
            Arrays.asList("PECHO", "TRICEPS"),
            Arrays.asList("ESPALDA", "BICEPS"),
            Arrays.asList("HOMBROS", "PIERNAS", "CORE")
        ));
        
        distribuccion.put(4, Arrays.asList(
            Arrays.asList("PECHO", "TRICEPS"),
            Arrays.asList("ESPALDA", "BICEPS"),
            Arrays.asList("HOMBROS", "CORE"),
            Arrays.asList("PIERNAS", "CARDIO")
        ));
        
        distribuccion.put(5, Arrays.asList(
            Arrays.asList("PECHO"),
            Arrays.asList("ESPALDA"),
            Arrays.asList("PIERNAS"),
            Arrays.asList("HOMBROS"),
            Arrays.asList("BRAZOS", "CORE")
        ));
        
        List<List<String>> plan = distribuccion.getOrDefault(
            totalDias, 
            distribuccion.get(3)
        );
        
        return plan.get((dia - 1) % plan.size());
    }
    
    /**
     * Genera ejercicios recomendados por grupo muscular y nivel
     */
    private List<String> generarEjerciciosRecomendados(String grupoMuscular, String nivel) {
        Map<String, List<String>> ejerciciospPorGrupo = new HashMap<>();
        
        // Definir ejercicios por grupo muscular
        ejerciciospPorGrupo.put("PECHO", Arrays.asList(
            "Press de banca", "Press inclinado", "Aperturas", "Flexiones"
        ));
        ejerciciospPorGrupo.put("ESPALDA", Arrays.asList(
            "Dominadas", "Jalón lateral", "Remo con mancuerna", "Remo horizontal"
        ));
        ejerciciospPorGrupo.put("HOMBROS", Arrays.asList(
            "Press de hombros", "Elevaciones laterales", "Pájaros", "Press Arnold"
        ));
        ejerciciospPorGrupo.put("BICEPS", Arrays.asList(
            "Curl de barra", "Curl de mancuerna", "Curl concentrado", "Curl predicador"
        ));
        ejerciciospPorGrupo.put("TRICEPS", Arrays.asList(
            "Extensión de cuerda", "Press de brazos", "Flexiones cerradas", "Barras paralelas"
        ));
        ejerciciospPorGrupo.put("PIERNAS", Arrays.asList(
            "Sentadilla", "Peso muerto", "Prensa de piernas", "Extensión de piernas"
        ));
        ejerciciospPorGrupo.put("CORE", Arrays.asList(
            "Planchas", "Crunches", "Levantamientos de piernas", "Abdominales"
        ));
        
        List<String> ejercicios = ejerciciospPorGrupo.getOrDefault(grupoMuscular, Arrays.asList());
        
        // Limitar según nivel
        int cantidad = switch (nivel.toUpperCase()) {
            case "INICIAL" -> Math.min(2, ejercicios.size());
            case "INTERMEDIO" -> Math.min(3, ejercicios.size());
            case "AVANZADO" -> ejercicios.size();
            default -> 2;
        };
        
        return ejercicios.subList(0, cantidad);
    }
    
    /**
     * Genera una rutina temporal (sin guardar en BD, sin usuario)
     * Para uso sin autenticación
     */
    public Rutina generarRutinaTemporal(String nombre,
                                       String objetivo,
                                       String nivel,
                                       Integer numDias,
                                       List<String> gruposObjectivo) {
        
        Rutina rutina = new Rutina();
        rutina.setNombre(nombre);
        rutina.setNivel(Nivel.valueOf(nivel.toUpperCase()));
        rutina.setNumDias(numDias);
        rutina.setDescripcion(
            String.format("Rutina de %d días - Objetivo: %s - Nivel: %s", numDias, objetivo, nivel)
        );
        
        // Inicializar timestamps manualmente
        rutina.setFechaCreacion(java.time.LocalDateTime.now());
        rutina.setUltimaActualizacion(java.time.LocalDateTime.now());
        
        // Asignar división por defecto según número de días
        if (numDias == 3) {
            rutina.setDivision("Full Body");
        } else if (numDias == 4) {
            rutina.setDivision("Torso-Pierna");
        } else if (numDias >= 5) {
            rutina.setDivision("Push-Pull-Legs");
        } else {
            rutina.setDivision("Full Body");
        }
        
        // Usuario es null para rutinas temporales
        rutina.setUsuario(null);
        
        List<DiaEntrenamiento> dias = new ArrayList<>();
        
        for (int i = 1; i <= numDias; i++) {
            DiaEntrenamiento dia = crearDiaEntrenamiento(rutina, i, numDias, objetivo, nivel);
            dias.add(dia);
        }
        
        rutina.setDiasEntrenamiento(dias);
        
        // NO guardar en BD
        return rutina;
    }
    
    /**
     * Genera rutina COMPLETAMENTE desde Prolog (generar_rutina_semanal)
     * Esta es ahora la fuente primaria de lógica de generación
     */
    public Rutina generarRutinaDesdeProlog(String nombre,
                                          String objetivo,
                                          String nivel,
                                          Integer numDias,
                                          List<String> gruposObjectivo) {
        return generarRutinaDesdeProlog(nombre, objetivo, nivel, numDias, gruposObjectivo, null);
    }

    /**
     * Overload con tipoEntradaCalor explícito (para rutina personalizada).
     * tipoEntradaCalor: cardio_ligero | movilidad_dinamica | activacion_muscular | null (auto).
     */
    public Rutina generarRutinaDesdeProlog(String nombre,
                                          String objetivo,
                                          String nivel,
                                          Integer numDias,
                                          List<String> gruposObjectivo,
                                          String tipoEntradaCalor) {
        
        logger.info("🔮 INICIANDO GENERACIÓN DESDE PROLOG");
        
        Rutina rutina = new Rutina();
        rutina.setNombre(nombre);
        rutina.setNivel(Nivel.valueOf(nivel.toUpperCase()));
        rutina.setNumDias(numDias);
        rutina.setDescripcion(
            String.format("Rutina de %d días - Objetivo: %s - Nivel: %s (PROLOG)", numDias, objetivo, nivel)
        );
        
        // Timestamps manuales
        rutina.setFechaCreacion(java.time.LocalDateTime.now());
        rutina.setUltimaActualizacion(java.time.LocalDateTime.now());
        
        // División según días
        if (numDias == 3) {
            rutina.setDivision("Full Body");
        } else if (numDias == 4) {
            rutina.setDivision("Torso-Pierna");
        } else if (numDias >= 5) {
            rutina.setDivision("Push-Pull-Legs");
        } else {
            rutina.setDivision("Full Body");
        }
        
        rutina.setUsuario(null);
        
        try {
            // 1. Llamar a Prolog para generar la rutina
            String usuarioProlog = "user1";

            Map<String, Object> rutinaProlog = prologService.generarRutinaCompletaDesdeProlog(
                usuarioProlog,
                objetivo,
                nivel,
                numDias,
                gruposObjectivo,
                tipoEntradaCalor
            );
            
            if ((boolean) rutinaProlog.getOrDefault("success", false)) {
                logger.info("✅ Rutina recibida desde Prolog");
                
                // 2. Convertir estructura Prolog a objetos Java
                List<DiaEntrenamiento> dias = convertirPrologADiasEntrenamiento(
                    rutinaProlog,
                    rutina,
                    objetivo,
                    nivel
                );
                
                rutina.setDiasEntrenamiento(dias);
                logger.info("✅ Rutina convertida a objetos Java");
                
            } else {
                logger.warn("⚠️  Prolog falló, usando fallback Java");
                List<DiaEntrenamiento> dias = new ArrayList<>();
                for (int i = 1; i <= numDias; i++) {
                    DiaEntrenamiento dia = crearDiaEntrenamiento(
                        rutina, i, numDias, objetivo, nivel
                    );
                    dias.add(dia);
                }
                rutina.setDiasEntrenamiento(dias);
            }
            
        } catch (Exception e) {
            logger.error("❌ Error en generación desde Prolog: {}", e.getMessage(), e);
            // Fallback a Java
            List<DiaEntrenamiento> dias = new ArrayList<>();
            for (int i = 1; i <= numDias; i++) {
                DiaEntrenamiento dia = crearDiaEntrenamiento(
                    rutina, i, numDias, objetivo, nivel
                );
                dias.add(dia);
            }
            rutina.setDiasEntrenamiento(dias);
        }
        
        // NO guardar en BD
        return rutina;
    }
    
    /**
     * Convierte estructura parseada de Prolog a objetos DiaEntrenamiento.
     * Soporta nueva estructura sesion/3 (entradaCalor + movilidad + principales)
     * y la antigua (solo grupos).
     */
    @SuppressWarnings("unchecked")
    private List<DiaEntrenamiento> convertirPrologADiasEntrenamiento(Map<String, Object> rutinaProlog,
                                                                     Rutina rutina,
                                                                     String objetivo,
                                                                     String nivel) {
        List<DiaEntrenamiento> dias = new ArrayList<>();

        try {
            List<Map<String, Object>> diasProlog = (List<Map<String, Object>>) rutinaProlog.get("dias");
            if (diasProlog == null) {
                logger.warn("No se encontraron días en respuesta Prolog");
                return dias;
            }

            for (Map<String, Object> diaProlog : diasProlog) {
                Integer numDia = (Integer) diaProlog.get("numero");
                DiaEntrenamiento dia = new DiaEntrenamiento();
                dia.setRutina(rutina);
                dia.setNumeroDia(numDia);
                dia.setDescripcion("Día " + numDia);

                List<Ejercicio> ejercicios = new ArrayList<>();

                // --- Entrada en calor (1 ejercicio) ---
                Map<String, Object> calor = (Map<String, Object>) diaProlog.get("entradaCalor");
                if (calor != null && !calor.isEmpty()) {
                    Ejercicio ej = crearEjercicioDesdePrologMap(calor, GrupoMuscular.CARDIO,
                            TipoEjercicio.COMPUESTO, Patron.GENERAL, nivel, dia);
                    if (ej != null) ejercicios.add(ej);
                }

                // --- Movilidad (2-3 ejercicios) ---
                List<Map<String, Object>> movList = (List<Map<String, Object>>) diaProlog.get("movilidad");
                if (movList != null) {
                    for (Map<String, Object> movEj : movList) {
                        Ejercicio ej = crearEjercicioDesdePrologMap(movEj, GrupoMuscular.MOVILIDAD,
                                TipoEjercicio.AISLADO, Patron.MOVILIDAD, nivel, dia);
                        if (ej != null) ejercicios.add(ej);
                    }
                }

                // --- Ejercicios principales ---
                List<Map<String, Object>> gruposProlog = (List<Map<String, Object>>) diaProlog.get("grupos");
                if (gruposProlog != null) {
                    for (Map<String, Object> grupoProlog : gruposProlog) {
                        String grupoNombre = (String) grupoProlog.get("nombre");
                        GrupoMuscular grupoEnum = resolverGrupoMuscular(grupoNombre);
                        List<Map<String, Object>> ejsProlog = (List<Map<String, Object>>) grupoProlog.get("ejercicios");
                        if (ejsProlog != null) {
                            for (Map<String, Object> ejeProlog : ejsProlog) {
                                Ejercicio ej = crearEjercicioDesdePrologMap(ejeProlog, grupoEnum,
                                        TipoEjercicio.COMPUESTO, Patron.EMPUJE, nivel, dia);
                                if (ej != null) ejercicios.add(ej);
                            }
                        }
                    }
                }

                dia.setEjercicios(ejercicios);
                dias.add(dia);
            }

            logger.info("Convertidos {} días desde Prolog", dias.size());

        } catch (Exception e) {
            logger.error("Error convirtiendo Prolog: {}", e.getMessage(), e);
        }

        return dias;
    }

    /** Crea un Ejercicio a partir del mapa parseado de un ejercicio_info Prolog. */
    private Ejercicio crearEjercicioDesdePrologMap(Map<String, Object> ejeMap,
                                                   GrupoMuscular grupo,
                                                   TipoEjercicio tipo,
                                                   Patron patron,
                                                   String nivel,
                                                   DiaEntrenamiento dia) {
        if (ejeMap == null || ejeMap.get("nombre") == null) return null;
        Ejercicio ej = new Ejercicio();
        ej.setNombre((String) ejeMap.get("nombre"));
        ej.setGrupoMuscular(grupo);
        ej.setTipo(tipo);
        ej.setPatron(patron);
        ej.setNivelDificultadMinima(resolverNivel(nivel));
        ej.setSeries(((Number) ejeMap.getOrDefault("series", 3)).intValue());
        ej.setRepeticiones(((Number) ejeMap.getOrDefault("reps", 10)).intValue());
        ej.setDescansoSegundos(((Number) ejeMap.getOrDefault("descanso", 60)).intValue());
        ej.setDiaEntrenamiento(dia);
        return ej;
    }

    /** Resuelve GrupoMuscular desde string Prolog; fallback a CORE si desconocido. */
    private GrupoMuscular resolverGrupoMuscular(String nombre) {
        if (nombre == null) return GrupoMuscular.CORE;
        try {
            return GrupoMuscular.valueOf(nombre.toUpperCase());
        } catch (IllegalArgumentException e) {
            // Mapeos adicionales Prolog → Java
            return switch (nombre.toLowerCase()) {
                case "movilidad"  -> GrupoMuscular.MOVILIDAD;
                case "activacion" -> GrupoMuscular.ACTIVACION;
                case "cardio"     -> GrupoMuscular.CARDIO;
                case "antebrazo"  -> GrupoMuscular.ANTEBRAZO;
                default           -> GrupoMuscular.CORE;
            };
        }
    }

    /** Resuelve Nivel desde string Java; fallback a INICIAL. */
    private Nivel resolverNivel(String nivel) {
        if (nivel == null) return Nivel.INICIAL;
        try {
            return Nivel.valueOf(nivel.toUpperCase());
        } catch (IllegalArgumentException e) {
            return Nivel.INICIAL;
        }
    }

   
}
