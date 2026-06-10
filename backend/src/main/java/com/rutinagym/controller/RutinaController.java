package com.rutinagym.controller;

import com.rutinagym.dto.GenerarRutinaRequest;
import com.rutinagym.model.Rutina;
import com.rutinagym.model.Nivel;
import com.rutinagym.service.RutinaService;
import com.rutinagym.service.PrologService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.*;

@RestController
@RequestMapping("/api/v1/rutinas")
@CrossOrigin(origins = "*", maxAge = 3600)
public class RutinaController {
    
    @Autowired
    private RutinaService rutinaService;
    
    @Autowired
    private PrologService prologService;
    
    /**
     * Genera una rutina sin requerir login
     * POST /v1/rutinas/generar
     */
    @PostMapping("/generar")
    public ResponseEntity<?> generarRutina(@RequestBody GenerarRutinaRequest request) {
        try {
            System.out.println("\n=== DEBUG GENERACIÓN RUTINA ===");
            System.out.println("Nombre: " + request.getNombre());
            System.out.println("Objetivo: " + request.getObjetivo());
            System.out.println("Nivel: " + request.getNivel());
            System.out.println("Días: " + request.getDiasDisponibles());
            System.out.println("Grupos recibidos: " + request.getGruposMusculares());
            System.out.println("Grupos tamaño: " + (request.getGruposMusculares() != null ? request.getGruposMusculares().size() : "null"));
            System.out.println("=============================\n");
            
            if (request.getNombre() == null || request.getNombre().isEmpty()) {
                return ResponseEntity.badRequest()
                    .body("El nombre de la rutina es requerido");
            }
            
            if (request.getObjetivo() == null || request.getObjetivo().isEmpty()) {
                return ResponseEntity.badRequest()
                    .body("El objetivo es requerido");
            }
            
            if (request.getNivel() == null || request.getNivel().isEmpty()) {
                return ResponseEntity.badRequest()
                    .body("El nivel es requerido");
            }
            
            // Validar que el objetivo sea válido
            String objetivoStr = request.getObjetivo().toUpperCase();
            String nivelStr = request.getNivel().toUpperCase();
            try {
                com.rutinagym.model.Objetivo.valueOf(objetivoStr);
            } catch (IllegalArgumentException e) {
                return ResponseEntity.badRequest()
                    .body("Objetivo no válido. Opciones: HIPERTROFIA, FUERZA, RESISTENCIA, ACONDICIONAMIENTO");
            }
            
            // Validar que el nivel sea válido
            try {
                Nivel.valueOf(nivelStr);
            } catch (IllegalArgumentException e) {
                return ResponseEntity.badRequest()
                    .body("Nivel no válido. Opciones: INICIAL, INTERMEDIO, AVANZADO");
            }
            
            if (request.getDiasDisponibles() == null || request.getDiasDisponibles() < 1 || request.getDiasDisponibles() > 7) {
                return ResponseEntity.badRequest()
                    .body("El número de días debe estar entre 1 y 7");
            }
            
            // Si gruposMusculares está vacío, es generación automática
            java.util.List<String> grupos = new java.util.ArrayList<>();
            if (request.getGruposMusculares() != null && !request.getGruposMusculares().isEmpty()) {
                grupos = request.getGruposMusculares();
            } else {
                System.out.println("\n🤖 MODO AUTOMÁTICO: Consultando Prolog para distribución...");
                try {
                    Map<String, Object> distribucion = prologService.obtenerDistribucionAutomatica(
                        objetivoStr,
                        request.getDiasDisponibles()
                    );
                    
                    if ((boolean) distribucion.getOrDefault("success", false)) {
                        java.util.List<?> gruposProlog = (java.util.List<?>) distribucion.get("grupos");
                        if (gruposProlog != null && !gruposProlog.isEmpty()) {
                            grupos = gruposProlog.stream()
                                .map(Object::toString)
                                .collect(java.util.stream.Collectors.toList());
                            System.out.println("✅ Prolog sugiere: " + grupos);
                        }
                    }
                } catch (Exception prologError) {
                    System.out.println("⚠️ Prolog no disponible, usando fallback");
                }
            }
            
            // ✅ NUEVO: Usar Prolog completamente para generar la rutina
            System.out.println("\n🧠 CEREBRO PROLOG: Generando rutina desde Prolog...");
            Rutina rutina = rutinaService.generarRutinaDesdeProlog(
                request.getNombre(),
                objetivoStr,
                nivelStr,
                request.getDiasDisponibles(),
                grupos
            );
            
            // Verificar si la rutina fue generada exitosamente
            if (rutina != null && rutina.getDiasEntrenamiento() != null && !rutina.getDiasEntrenamiento().isEmpty()) {
                System.out.println("✅ Rutina generada exitosamente: " + rutina.getDiasEntrenamiento().size() + " días");
                return ResponseEntity.ok(rutina);
            } else {
                System.out.println("⚠️ Prolog no generó rutina válida, retornando estructura vacía");
                return ResponseEntity.badRequest()
                    .body("No se pudo generar la rutina desde Prolog");
            }
            
        } catch (Exception e) {
            System.out.println("❌ Error en generarRutina: " + e.getMessage());
            e.printStackTrace();
            
            // Fallback final: si todo falla, intentar Java como último recurso
            try {
                System.out.println("⚠️ Fallback: Generando rutina con Java...");
                String objetivoStr = request.getObjetivo().toUpperCase();
                String nivelStr = request.getNivel().toUpperCase();
                java.util.List<String> grupos = request.getGruposMusculares() != null && !request.getGruposMusculares().isEmpty()
                    ? request.getGruposMusculares()
                    : new java.util.ArrayList<>();
                
                Rutina rutinaFallback = rutinaService.generarRutinaTemporal(
                    request.getNombre(),
                    objetivoStr,
                    nivelStr,
                    request.getDiasDisponibles(),
                    grupos
                );
                
                System.out.println("✅ Fallback Java completado");
                return ResponseEntity.ok()
                    .header("X-Warning", "Generada con fallback Java (Prolog no disponible)")
                    .body(rutinaFallback);
                    
            } catch (Exception fallbackError) {
                System.out.println("❌ Fallback Java también falló: " + fallbackError.getMessage());
                return ResponseEntity.internalServerError()
                    .body("Error: " + e.getMessage());
            }
        }
    }

    /**
     * Obtiene ejercicios recomendados por grupo muscular
     * GET /v1/rutinas/ejercicios/{grupoMuscular}
     * Consulta el sistema experto Prolog
     */
    @GetMapping("/ejercicios/{grupoMuscular}")
    public ResponseEntity<?> obtenerEjerciciosPorGrupo(
            @PathVariable String grupoMuscular,
            @RequestParam(defaultValue = "INTERMEDIO") String nivel) {
        try {
            // Delegar a PrologService
            Map<String, Object> resultado = prologService.obtenerEjerciciosPorGrupo(
                grupoMuscular,
                nivel
            );
            
            if ((boolean) resultado.getOrDefault("success", false)) {
                return ResponseEntity.ok(resultado);
            } else {
                // Si Prolog no está disponible, retornar estructura vacía
                Map<String, Object> respuesta = new HashMap<>();
                respuesta.put("grupoMuscular", grupoMuscular);
                respuesta.put("nivel", nivel);
                respuesta.put("ejercicios", new ArrayList<>());
                respuesta.put("total", 0);
                respuesta.put("warning", resultado.get("warning"));
                return ResponseEntity.ok(respuesta);
            }
            
        } catch (Exception e) {
            return ResponseEntity.internalServerError()
                .body(Map.of("error", e.getMessage()));
        }
    }

    /**
     * Valida una rutina generada
     * POST /v1/rutinas/validar
     * Consulta el sistema experto Prolog para validar la rutina
     */
    @PostMapping("/validar")
    public ResponseEntity<?> validarRutina(@RequestBody Rutina rutina) {
        try {
            Map<String, Object> validacion = new HashMap<>();
            
            // Intentar validación via Prolog primero
            if (rutina.getUsuario() != null) {
                Map<String, Object> prologValidacion = prologService.validarRutina(
                    rutina.getUsuario().getId(),
                    rutina
                );
                
                if ((boolean) prologValidacion.getOrDefault("success", false)) {
                    return ResponseEntity.ok(prologValidacion);
                }
            }
            
            // Fallback: Validación básica en Java
            List<String> errores = new ArrayList<>();
            List<String> advertencias = new ArrayList<>();
            
            if (rutina == null || rutina.getDiasEntrenamiento() == null || rutina.getDiasEntrenamiento().isEmpty()) {
                errores.add("La rutina no contiene días de entrenamiento");
            }
            
            if (rutina.getNumDias() < 1 || rutina.getNumDias() > 7) {
                errores.add("El número de días debe estar entre 1 y 7");
            }
            
            int totalEjercicios = 0;
            for (var dia : rutina.getDiasEntrenamiento()) {
                if (dia.getEjercicios() != null) {
                    totalEjercicios += dia.getEjercicios().size();
                }
            }
            
            if (totalEjercicios < rutina.getNumDias()) {
                advertencias.add("Algunos días tienen pocos ejercicios");
            }
            
            validacion.put("valida", errores.isEmpty());
            validacion.put("errores", errores);
            validacion.put("advertencias", advertencias);
            validacion.put("estadisticas", Map.of(
                "totalDias", rutina.getNumDias(),
                "totalEjercicios", totalEjercicios,
                "promedioPorDia", totalEjercicios / (double) rutina.getNumDias()
            ));
            validacion.put("fuente", "Java fallback (Prolog no disponible)");
            
            return ResponseEntity.ok(validacion);
            
        } catch (Exception e) {
            return ResponseEntity.internalServerError()
                .body(Map.of("error", e.getMessage()));
        }
    }

    /**
     * Obtiene explicación del sistema experto para una rutina
     * POST /v1/rutinas/explicacion
     * Consulta el sistema experto Prolog
     */
    @PostMapping("/explicacion")
    public ResponseEntity<?> explicarRutina(@RequestBody Map<String, Object> request) {
        try {
            String objetivo = (String) request.getOrDefault("objetivo", "HIPERTROFIA");
            Integer dias = (Integer) request.getOrDefault("diasDisponibles", 3);
            
            Map<String, Object> respuesta = new HashMap<>();
            respuesta.put("objetivo", objetivo);
            respuesta.put("diasDisponibles", dias);
            respuesta.put("explicacion", "Generando rutina de " + dias + " días enfocada en " + objetivo);
            respuesta.put("recomendacionesPorDias", getRecomendacionesPorDias(dias));
            respuesta.put("sistema", "SISTEMA EXPERTO PROLOG");
            
            // Intentar obtener explicación de Prolog
            try {
                Map<String, Object> explicacion = prologService.obtenerExplicacionDivision(objetivo, dias);
                if ((boolean) explicacion.getOrDefault("success", false)) {
                    respuesta.putAll(explicacion);
                }
            } catch (Exception prologError) {
                System.out.println("⚠️ Prolog no disponible, usando fallback para explicación");
            }
            
            return ResponseEntity.ok(respuesta);
            
        } catch (Exception e) {
            System.out.println("❌ Error en explicarRutina: " + e.getMessage());
            e.printStackTrace();
            
            Map<String, Object> respuesta = new HashMap<>();
            respuesta.put("objetivo", request.getOrDefault("objetivo", "HIPERTROFIA"));
            respuesta.put("diasDisponibles", request.getOrDefault("diasDisponibles", 3));
            respuesta.put("explicacion", "Sistema en modo fallback");
            respuesta.put("recomendacionesPorDias", "Consulta el sistema experto");
            respuesta.put("warning", e.getMessage());
            
            return ResponseEntity.ok(respuesta);
        }
    }

    /**
     * Obtiene información del sistema experto Prolog
     * GET /v1/rutinas/info
     */
    @GetMapping("/info")
    public ResponseEntity<?> obtenerInfo() {
        try {
            Map<String, Object> info = new HashMap<>();
            
            info.put("sistema", "Sistema Experto Prolog para Generación de Rutinas");
            info.put("version", "1.0.0");
            info.put("descripcion", "IA especializada en crear rutinas de entrenamiento personalizadas");
            info.put("estado", "operativo");
            
            Map<String, Object> capacidades = new HashMap<>();
            capacidades.put("objetivos", Arrays.asList("HIPERTROFIA", "FUERZA", "RESISTENCIA", "ACONDICIONAMIENTO"));
            capacidades.put("niveles", Arrays.asList("INICIAL", "INTERMEDIO", "AVANZADO"));
            capacidades.put("diasDisponibles", Arrays.asList(2, 3, 4, 5, 6));
            capacidades.put("gruposMusculares", Arrays.asList(
                "PECHO", "ESPALDA", "HOMBROS", "BICEPS", "TRICEPS", "PIERNAS", "CORE", "CARDIO"
            ));
            
            info.put("capacidades", capacidades);
            
            Map<String, String> endpoints = new HashMap<>();
            endpoints.put("generarRutina", "POST /v1/rutinas/generar");
            endpoints.put("ejerciciosPorGrupo", "GET /v1/rutinas/ejercicios/{grupoMuscular}");
            endpoints.put("validarRutina", "POST /v1/rutinas/validar");
            endpoints.put("explicacion", "POST /v1/rutinas/explicacion");
            endpoints.put("info", "GET /v1/rutinas/info");
            
            info.put("endpoints", endpoints);
            
            return ResponseEntity.ok(info);
            
        } catch (Exception e) {
            System.out.println("❌ Error en obtenerInfo: " + e.getMessage());
            
            Map<String, Object> info = new HashMap<>();
            info.put("sistema", "Sistema Experto Prolog");
            info.put("estado", "modo degradado");
            info.put("error", e.getMessage());
            
            return ResponseEntity.ok(info);
        }
    }
    
    /**
     * Helper method para recomendaciones por días
     */
    private String getRecomendacionesPorDias(Integer dias) {
        return switch (dias) {
            case 2 -> "Rutina de cuerpo completo 2 días: Día 1 tren superior, Día 2 tren inferior";
            case 3 -> "Rutina de cuerpo completo 3 días: Día 1 Pecho/Tríceps, Día 2 Espalda/Bíceps, Día 3 Piernas/Core";
            case 4 -> "Rutina Torso-Pierna 4 días: Día 1 Torso, Día 2 Piernas, Día 3 Torso, Día 4 Piernas";
            case 5 -> "Push-Pull-Legs 5 días: 2 días Push, 2 días Pull, 1 día Legs";
            case 6 -> "Push-Pull-Legs 6 días: 2 días Push, 2 días Pull, 2 días Legs";
            default -> "Rutina de " + dias + " días personalizada";
        };
    }
}



