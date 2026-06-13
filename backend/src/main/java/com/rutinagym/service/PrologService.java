package com.rutinagym.service;

import org.springframework.stereotype.Service;
import org.springframework.beans.factory.annotation.Value;
import java.io.*;
import java.nio.file.*;
import java.util.*;
import java.util.concurrent.*;
import jakarta.annotation.PostConstruct;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * Servicio que integra Prolog para generar rutinas basadas en reglas lógicas.
 * Ejecuta consultas Prolog via subprocess (SWI-Prolog).
 * Mantiene verdadera separación entre OOP (Java) y Lógica (Prolog).
 */
@Service
public class PrologService {
    
    private static final Logger logger = LoggerFactory.getLogger(PrologService.class);
    private static final String SWIPL_COMMAND = isWindows() ? "swipl.exe" : "swipl";
    private static final int PROLOG_TIMEOUT_SECONDS = 30;
    
    @Value("${prolog.path:prolog}")
    private String prologPath;
    
    private String prologFilePath;
    private boolean prologAvailable = false;
    
    @PostConstruct
    private void initPrologEngine() {
        logger.info("═══════════════════════════════════════════════════════════");
        logger.info("  🚀 INICIALIZANDO SISTEMA EXPERTO PROLOG");
        logger.info("═══════════════════════════════════════════════════════════");
        
        try {
            // 1. Detectar SWI-Prolog disponible
            prologAvailable = detectPrologInstallation();
            logger.info("  ✅ SWI-Prolog disponible: {}", prologAvailable);
            
            // 2. Encontrar archivo Prolog
            prologFilePath = findPrologFile();
            if (prologFilePath != null) {
                logger.info("  ✅ Archivo Prolog encontrado: {}", prologFilePath);
            } else {
                logger.warn("  ⚠️  Archivo Prolog no encontrado - usando fallback");
            }
            
            logger.info("═══════════════════════════════════════════════════════════");
            logger.info("  Estado: {} | Archivo: {}",
                prologAvailable ? "✅ LISTO" : "⚠️  FALLBACK",
                prologFilePath != null ? "✅" : "❌"
            );
            logger.info("═══════════════════════════════════════════════════════════");
            
        } catch (Exception e) {
            logger.error("❌ Error al inicializar Prolog", e);
        }
    }
    
    /**
     * Detecta si SWI-Prolog está instalado en el sistema
     */
    private boolean detectPrologInstallation() {
        try {
            ProcessBuilder pb = new ProcessBuilder(SWIPL_COMMAND, "--version");
            pb.redirectErrorStream(true);
            Process process = pb.start();
            
            boolean finished = process.waitFor(5, TimeUnit.SECONDS);
            if (!finished) {
                process.destroyForcibly();
                return false;
            }
            
            int exitCode = process.exitValue();
            
            if (exitCode == 0) {
                // Leer versión
                try (BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()))) {
                    String version = reader.readLine();
                    logger.debug("  → Versión Prolog: {}", version);
                }
                return true;
            }
            return false;
        } catch (Exception e) {
            logger.debug("SWI-Prolog no detectado: {}", e.getMessage());
            return false;
        }
    }
    
    /**
     * Busca el archivo Prolog en múltiples ubicaciones
     */
    private String findPrologFile() {
        String[] posiblesPaths = {
            // Docker
            "/app/prolog/integration.pl",
            "/app/prolog/knowledge_base.pl",
            
            // Desarrollo local relativo
            "prolog/integration.pl",
            "prolog/knowledge_base.pl",
            
            // Rutas absolutas Windows
            "d:/Downloads/rutina_gym/prolog/integration.pl",
            "d:/Downloads/rutina_gym/prolog/knowledge_base.pl",
            
            // Con prologPath configurado
            prologPath + "/integration.pl",
            prologPath + "/knowledge_base.pl"
        };
        
        for (String path : posiblesPaths) {
            try {
                Path filePath = Paths.get(path);
                if (Files.exists(filePath)) {
                    logger.debug("  → Encontrado: {}", path);
                    return path;
                }
            } catch (Exception e) {
                // Ignorar y continuar
            }
        }
        
        logger.warn("  ⚠ No se encontró ningún archivo Prolog en ubicaciones conocidas");
        return null;
    }


    /**
     * Genera rutina completa consultando el sistema experto Prolog
     */
    public Map<String, Object> generarRutinaCompleta(Long usuarioId, String objective, 
                                                     Integer diasDisponibles, 
                                                     List<String> gruposMusculares) {
        logger.info("🔍 INICIANDO GENERACIÓN DE RUTINA EXPERTA");
        logger.info("  Usuario: {} | Objetivo: {} | Días: {} | Grupos: {}", 
            usuarioId, objective, diasDisponibles, gruposMusculares);
        
        Map<String, Object> resultado = new HashMap<>();
        
        try {
            if (!prologAvailable) {
                logger.warn("⚠️  Prolog no disponible - usando fallback");
                resultado.putAll(generarRutinaFallback(objective, diasDisponibles, gruposMusculares));
                resultado.put("success", false);
                resultado.put("warning", "Prolog no disponible");
                return resultado;
            }
            
            if (prologFilePath == null) {
                logger.warn("⚠️  Archivos Prolog no encontrados - usando fallback");
                resultado.putAll(generarRutinaFallback(objective, diasDisponibles, gruposMusculares));
                resultado.put("success", false);
                resultado.put("warning", "Archivos Prolog no encontrados");
                return resultado;
            }
            
            // Consulta Prolog para generar rutina
            String consulta = String.format(
                "generar_rutina_completa(%d, %d, '%s', %s, Rutina, Validacion, Recomendaciones, Explicacion), " +
                "write_canonical(resultado(Rutina, Validacion, Recomendaciones, Explicacion)).",
                usuarioId,
                diasDisponibles,
                objective,
                gruposMusculares.toString().toLowerCase()
            );
            
            logger.info("  → Consulta Prolog: {}", consulta);
            
            Map<String, Object> prologResult = ejecutarConsultaProlog(consulta);
            
            if (prologResult != null && (boolean) prologResult.getOrDefault("success", false)) {
                resultado.putAll(prologResult);
                resultado.put("success", true);
                logger.info("✅ Rutina generada exitosamente via {}", 
                    prologResult.getOrDefault("method", "unknown"));
            } else {
                resultado.putAll(generarRutinaFallback(objective, diasDisponibles, gruposMusculares));
                resultado.put("success", false);
                resultado.put("warning", "Rutina generada con fallback");
                logger.warn("⚠️  Usando rutina fallback");
            }
            
        } catch (Exception e) {
            logger.error("❌ Error en generación de rutina: {}", e.getMessage(), e);
            resultado.putAll(generarRutinaFallback(objective, diasDisponibles, gruposMusculares));
            resultado.put("success", false);
            resultado.put("error", e.getMessage());
        }
        
        return resultado;
    }

    
    
    /**
     * Ejecuta una consulta Prolog via subprocess
     */
    private Map<String, Object> ejecutarConsultaProlog(String consulta) throws IOException, InterruptedException {
        return ejecutarViaSubprocess(consulta);
    }
    
    /**
     * Ejecuta consulta usando subprocess (swipl desde línea de comandos)
     */
    private Map<String, Object> ejecutarViaSubprocess(String consulta) throws IOException, InterruptedException {
        Map<String, Object> resultado = new HashMap<>();
        
        logger.debug("  📌 Ejecutando via subprocess: {}", consulta);
        
        // La consulta viene en formato: "predicado(...), write_canonical(Resultado)"
        // Necesitamos separar para garantizar que write_canonical SIEMPRE se ejecute
        String prologScript;
        
        if (consulta.contains("write_canonical")) {
            // Extraer la parte de write_canonical
            // Ejemplo: "generar_rutina_semanal('user1', 'Torso-Pierna', Rutina), write_canonical(Rutina)"
            String[] parts = consulta.split(", write_canonical\\(");
            String query = parts[0];  // "generar_rutina_semanal(...)"
            String variable = parts[1].replaceAll("\\)\\.$", "").replaceAll("\\)$", "");  // "Rutina" - elimina `)` y `.` del final
            
            // Script que GARANTIZA output: si éxito muestra variable, si falla muestra ERROR
            prologScript = String.format(
                ":-consult('%s').\n" +
                ":-(%s -> write_canonical(%s) ; write('ERROR')).\n" +
                ":-halt.",
                prologFilePath,
                query,
                variable
            );
        } else {
            // Consulta simple sin write_canonical
            prologScript = String.format(
                ":-consult('%s').\n" +
                ":-(%s -> true ; write('ERROR')).\n" +
                ":-halt.",
                prologFilePath,
                consulta
            );
        }
        
        logger.debug("  → Script Prolog: {}", prologScript);
        
        // Crear archivo temporal
        File tempFile = File.createTempFile("prolog_query_", ".pl");
        tempFile.deleteOnExit();
        
        // ✅ ESCRIBIR CONTENIDO DEL SCRIPT EN EL ARCHIVO
        try (java.io.FileWriter writer = new java.io.FileWriter(tempFile)) {
            writer.write(prologScript);
        }
        
        logger.debug("  → Script Prolog guardado en: {}", tempFile.getAbsolutePath());
        
        // Ejecutar Prolog
        ProcessBuilder pb = new ProcessBuilder(SWIPL_COMMAND, "-q", "-f", tempFile.getAbsolutePath());
        pb.redirectErrorStream(false);
        
        Process process = pb.start();
        
        // Capturar stdout
        List<String> output = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()))) {
            String line;
            while ((line = reader.readLine()) != null) {
                output.add(line.trim());
                logger.debug("  → output: {}", line);
            }
        }
        
        // Capturar stderr
        List<String> errors = new ArrayList<>();
        try (BufferedReader errorReader = new BufferedReader(new InputStreamReader(process.getErrorStream()))) {
            String line;
            while ((line = errorReader.readLine()) != null) {
                errors.add(line);
                logger.debug("  → stderr: {}", line);
            }
        }
        
        // Esperar terminación
        boolean finished = process.waitFor(PROLOG_TIMEOUT_SECONDS, TimeUnit.SECONDS);
        if (!finished) {
            logger.error("  ⚠️  Subprocess excedió timeout de {}s", PROLOG_TIMEOUT_SECONDS);
            process.destroyForcibly();
            resultado.put("success", false);
            resultado.put("error", "Timeout");
            return resultado;
        }
        
        int exitCode = process.exitValue();
        logger.debug("  → exit code: {}", exitCode);
        
        resultado.put("success", exitCode == 0);
        resultado.put("method", "subprocess");
        resultado.put("exitCode", exitCode);
        
        if (!output.isEmpty()) {
            resultado.put("output", String.join("", output));
        }
        
        if (!errors.isEmpty()) {
            resultado.put("errors", String.join("\n", errors));
        }
        
        return resultado;
    }

    
    /**
     * Genera rutina fallback si Prolog no está disponible
     */
    private Map<String, Object> generarRutinaFallback(String objective, Integer diasDisponibles, 
                                                       List<String> gruposMusculares) {
        Map<String, Object> rutina = new HashMap<>();
        
        Map<Integer, List<List<String>>> distributions = new HashMap<>();
        distributions.put(3, Arrays.asList(
            Arrays.asList("PECHO", "TRICEPS"),
            Arrays.asList("ESPALDA", "BICEPS"),
            Arrays.asList("HOMBROS", "PIERNAS")
        ));
        distributions.put(4, Arrays.asList(
            Arrays.asList("PECHO"),
            Arrays.asList("ESPALDA"),
            Arrays.asList("HOMBROS", "BICEPS"),
            Arrays.asList("PIERNAS", "TRICEPS")
        ));
        
        List<List<String>> plan = distributions.getOrDefault(diasDisponibles, 
            distributions.get(3)
        );
        
        rutina.put("division", "FALLBACK_" + diasDisponibles + "_DIAS");
        rutina.put("diasEntrenamiento", plan);
        rutina.put("objetivo", objective);
        rutina.put("gruposMusculares", gruposMusculares);
        
        return rutina;
    }
    
    /**
     * Valida una rutina consultando el sistema experto
     */
    public Map<String, Object> validarRutina(Long usuarioId, Object rutinaData) {
        Map<String, Object> resultado = new HashMap<>();
        
        try {
            if (!prologAvailable) {
                logger.warn("⚠️  Prolog no disponible para validación");
                resultado.put("success", false);
                resultado.put("warning", "Validación no disponible");
                return resultado;
            }
            
            String consulta = String.format(
                "validar_rutina_completa(%d, %s, Validacion, Problemas, Explicacion), " +
                "write_canonical(validacion(Validacion, Problemas, Explicacion)).",
                usuarioId,
                rutinaData.toString()
            );
            
            logger.debug("  → Consulta validación: {}", consulta);
            
            Map<String, Object> prologResult = ejecutarConsultaProlog(consulta);
            if (prologResult != null) {
                resultado.putAll(prologResult);
            }
            
        } catch (Exception e) {
            logger.error("Error al validar rutina", e);
            resultado.put("success", false);
            resultado.put("error", e.getMessage());
        }
        
        return resultado;
    }

    /**
     * Obtiene ejercicios recomendados por grupo muscular consultando Prolog
     * @param grupo Grupo muscular (pecho, espalda, hombros, etc.)
     * @param nivel Nivel mínimo (principiante, intermedio, avanzado)
     * @return Mapa con ejercicios disponibles
     */
    public Map<String, Object> obtenerEjerciciosPorGrupo(String grupo, String nivel) {
        logger.info("📋 Buscando ejercicios para grupo: {} | Nivel: {}", grupo, nivel);
        
        Map<String, Object> resultado = new HashMap<>();
        
        try {
            if (!prologAvailable || prologFilePath == null) {
                logger.warn("⚠️  Prolog no disponible para buscar ejercicios");
                resultado.put("success", false);
                resultado.put("warning", "Prolog no disponible");
                resultado.put("ejercicios", new ArrayList<>());
                return resultado;
            }
            
            // Consulta Prolog: buscar todos los ejercicios de un grupo con nivel mínimo compatible
            String consulta = String.format(
                "findall(Nombre, (ejercicio(ID, Nombre, '%s', _, _, NivelMin), " +
                "  (NivelMin = 'principiante' ; " +
                "   (NivelMin = 'intermedio', ('%s' = 'intermedio' ; '%s' = 'avanzado')) ; " +
                "   (NivelMin = 'avanzado', '%s' = 'avanzado'))), Ejercicios), " +
                "write_canonical(ejercicios_resultado(Ejercicios)).",
                grupo.toLowerCase(),
                nivel.toLowerCase(),
                nivel.toLowerCase(),
                nivel.toLowerCase()
            );
            
            logger.debug("  → Consulta Prolog: {}", consulta);
            
            Map<String, Object> prologResult = ejecutarConsultaProlog(consulta);
            
            if (prologResult != null && (boolean) prologResult.getOrDefault("success", false)) {
                resultado.putAll(prologResult);
                resultado.put("success", true);
                logger.info("✅ {} ejercicios encontrados para {}", 
                    ((List<?>) resultado.getOrDefault("ejercicios", new ArrayList<>())).size(), grupo);
            } else {
                // Fallback: retornar lista vacía en lugar de hardcodear
                resultado.put("success", false);
                resultado.put("ejercicios", new ArrayList<>());
                logger.warn("⚠️  No se pudieron obtener ejercicios de Prolog");
            }
            
        } catch (Exception e) {
            logger.error("❌ Error al obtener ejercicios: {}", e.getMessage(), e);
            resultado.put("success", false);
            resultado.put("error", e.getMessage());
            resultado.put("ejercicios", new ArrayList<>());
        }
        
        return resultado;
    }

    /**
     * Obtiene explicación de la división de rutina consultando Prolog
     * @param objetivo Objetivo del entrenamiento
     * @param diasDisponibles Días disponibles por semana
     * @return Mapa con explicación y recomendaciones
     */
    public Map<String, Object> obtenerExplicacionDivision(String objetivo, Integer diasDisponibles) {
        logger.info("📝 Obteniendo explicación para: {} | Días: {}", objetivo, diasDisponibles);
        
        Map<String, Object> resultado = new HashMap<>();
        
        try {
            if (!prologAvailable || prologFilePath == null) {
                logger.warn("⚠️  Prolog no disponible para explicaciones");
                resultado.put("success", false);
                resultado.put("warning", "Prolog no disponible");
                return resultado;
            }
            
            // Consulta Prolog: obtener parámetros del objetivo y seleccionar división
            String consulta = String.format(
                "objetivo('%s', RepMin, RepMax, Series, Descanso, Intensidad), " +
                "seleccionar_division_por_dias(%d, Division), " +
                "write_canonical(explicacion_resultado('%s', Division, RepMin, RepMax, Series, Descanso, Intensidad)).",
                objetivo.toLowerCase(),
                diasDisponibles,
                objetivo
            );
            
            logger.debug("  → Consulta Prolog: {}", consulta);
            
            Map<String, Object> prologResult = ejecutarConsultaProlog(consulta);
            
            if (prologResult != null && (boolean) prologResult.getOrDefault("success", false)) {
                resultado.putAll(prologResult);
                resultado.put("success", true);
                logger.info("✅ Explicación generada exitosamente");
            } else {
                resultado.put("success", false);
                resultado.put("warning", "No se pudo obtener explicación de Prolog");
                logger.warn("⚠️  No se obtuvo explicación de Prolog");
            }
            
        } catch (Exception e) {
            logger.error("❌ Error al obtener explicación: {}", e.getMessage(), e);
            resultado.put("success", false);
            resultado.put("error", e.getMessage());
        }
        
        return resultado;
    }

    /**
     * Obtiene distribución automática de grupos musculares basada en objetivo y días
     * @param objetivo Objetivo del entrenamiento
     * @param diasDisponibles Días disponibles por semana
     * @return Mapa con grupos recomendados por Prolog
     */
    public Map<String, Object> obtenerDistribucionAutomatica(String objetivo, Integer diasDisponibles) {
        logger.info("🤖 Consultando Prolog para distribución automática: {} | {} días", objetivo, diasDisponibles);
        
        Map<String, Object> resultado = new HashMap<>();
        List<String> grupos = new ArrayList<>();
        
        try {
            // Usar distribución por defecto basada en objetivo y días
            grupos = generarDistribucionPorDefecto(objetivo, diasDisponibles);
            
            if (!grupos.isEmpty()) {
                resultado.put("success", true);
                resultado.put("grupos", grupos);
                resultado.put("fuente", "Distribución automática");
                logger.info("✅ Distribución recomendada: {}", grupos);
            } else {
                resultado.put("success", false);
                resultado.put("grupos", new ArrayList<>());
                logger.warn("⚠️  No se generó distribución");
            }
            
        } catch (Exception e) {
            logger.error("❌ Error al obtener distribución: {}", e.getMessage());
            resultado.put("success", false);
            resultado.put("grupos", new ArrayList<>());
        }
        
        return resultado;
    }

    /**
     * Genera distribución de grupos por defecto sin Prolog
     */
    private List<String> generarDistribucionPorDefecto(String objetivo, Integer dias) {
        List<String> grupos = new ArrayList<>();
        
        // Distribuciones predefinidas según objetivo y días
        if ("HIPERTROFIA".equalsIgnoreCase(objetivo)) {
            if (dias == 2) {
                grupos.addAll(java.util.Arrays.asList("PECHO", "ESPALDA"));
            } else if (dias == 3) {
                grupos.addAll(java.util.Arrays.asList("PECHO", "ESPALDA", "PIERNAS"));
            } else if (dias == 4) {
                grupos.addAll(java.util.Arrays.asList("PECHO", "ESPALDA", "HOMBROS", "PIERNAS"));
            } else if (dias == 5) {
                grupos.addAll(java.util.Arrays.asList("PECHO", "ESPALDA", "HOMBROS", "BICEPS", "PIERNAS"));
            } else if (dias == 6) {
                grupos.addAll(java.util.Arrays.asList("PECHO", "ESPALDA", "HOMBROS", "BICEPS", "TRICEPS", "PIERNAS"));
            }
        } else if ("FUERZA".equalsIgnoreCase(objetivo)) {
            if (dias == 2) {
                grupos.addAll(java.util.Arrays.asList("PECHO", "PIERNAS"));
            } else if (dias == 3) {
                grupos.addAll(java.util.Arrays.asList("PECHO", "ESPALDA", "PIERNAS"));
            } else if (dias >= 4) {
                grupos.addAll(java.util.Arrays.asList("PECHO", "ESPALDA", "HOMBROS", "PIERNAS"));
            }
        } else if ("RESISTENCIA".equalsIgnoreCase(objetivo)) {
            if (dias >= 2) {
                grupos.addAll(java.util.Arrays.asList("CARDIO", "CORE", "PIERNAS"));
            }
        } else if ("ACONDICIONAMIENTO".equalsIgnoreCase(objetivo)) {
            if (dias == 2) {
                grupos.addAll(java.util.Arrays.asList("PECHO", "PIERNAS"));
            } else if (dias >= 3) {
                grupos.addAll(java.util.Arrays.asList("PECHO", "ESPALDA", "PIERNAS", "CORE"));
            }
        } else {
            // Default si no coincide
            if (dias >= 3) {
                grupos.addAll(java.util.Arrays.asList("PECHO", "ESPALDA", "PIERNAS"));
            } else {
                grupos.addAll(java.util.Arrays.asList("PECHO", "PIERNAS"));
            }
        }
        
        return grupos;
    }
    
    public Map<String, Object> generarRutinaCompletaDesdeProlog(String usuarioId, String objetivo,
                                                                   String nivel, Integer diasDisponibles,
                                                                   List<String> gruposMusculares) {
        return generarRutinaCompletaDesdeProlog(usuarioId, objetivo, nivel, diasDisponibles, gruposMusculares, null);
    }

    /**
     * NUEVO: Genera rutina COMPLETA desde Prolog con generar_rutina_semanal.
     * TipoEntradaCalor: cardio_ligero | movilidad_dinamica | activacion_muscular | null (auto).
     */
    public Map<String, Object> generarRutinaCompletaDesdeProlog(String usuarioId, String objetivo,
                                                                   String nivel, Integer diasDisponibles,
                                                                   List<String> gruposMusculares,
                                                                   String tipoEntradaCalor) {
        logger.info("🔮 GENERANDO RUTINA COMPLETA DESDE PROLOG");
        logger.info("  Usuario: {} | Objetivo: {} | Nivel: {} | Días: {} | Grupos: {}", 
            usuarioId, objetivo, nivel, diasDisponibles, gruposMusculares);
        
        Map<String, Object> resultado = new HashMap<>();
        
        try {
            if (!prologAvailable) {
                logger.warn("⚠️  Prolog no disponible");
                resultado.put("success", false);
                resultado.put("warning", "Prolog no disponible");
                return resultado;
            }
            
            if (prologFilePath == null) {
                logger.warn("⚠️  Archivos Prolog no encontrados");
                resultado.put("success", false);
                resultado.put("warning", "Archivos Prolog no encontrados");
                return resultado;
            }
            
            // Mapear nivel y objetivo Java → átomos Prolog (Prolog es la fuente de verdad)
            String nivelProlog    = nivelAProlog(nivel);
            String objetivoProlog = objetivoAProlog(objetivo);

            // Determinar tipo de entrada en calor (Prolog: auto | cardio_ligero | movilidad_dinamica | activacion_muscular)
            String tipoCalorProlog = (tipoEntradaCalor == null || tipoEntradaCalor.isBlank()) ? "auto" : tipoEntradaCalor.toLowerCase();

            String consulta;

            if (gruposMusculares == null || gruposMusculares.isEmpty()) {
                // GENERACIÓN AUTOMÁTICA
                logger.info("🤖 MODO AUTOMÁTICO: Prolog decidirá división según {} días", diasDisponibles);
                consulta = String.format(
                    "generar_rutina_automatica('%s', %s, %s, %d, Rutina), write_canonical(Rutina).",
                    usuarioId, nivelProlog, objetivoProlog, diasDisponibles);
            } else {
                // GENERACIÓN PERSONALIZADA
                logger.info("🎯 MODO PERSONALIZADO: Grupos={} TipoCalor={}", gruposMusculares, tipoCalorProlog);
                String gruposProlog = "[" + gruposMusculares.stream()
                    .map(g -> g.toLowerCase())
                    .collect(java.util.stream.Collectors.joining(", ")) + "]";
                if ("auto".equals(tipoCalorProlog)) {
                    consulta = String.format(
                        "generar_rutina_personalizada('%s', %s, %s, %d, %s, Rutina), write_canonical(Rutina).",
                        usuarioId, nivelProlog, objetivoProlog, diasDisponibles, gruposProlog);
                } else {
                    consulta = String.format(
                        "generar_rutina_personalizada('%s', %s, %s, %d, %s, %s, Rutina), write_canonical(Rutina).",
                        usuarioId, nivelProlog, objetivoProlog, diasDisponibles, gruposProlog, tipoCalorProlog);
                }
            }
            
            logger.info("  → Consulta Prolog: {}", consulta);
            
            Map<String, Object> prologResult = ejecutarConsultaProlog(consulta);
            
            if (prologResult != null && (boolean) prologResult.getOrDefault("success", false)) {
                String output = (String) prologResult.get("output");
                if (output != null && !output.isEmpty()) {
                    logger.info("  → Output Prolog: {}", output);
                    
                    // Parse estructura Prolog a Map Java
                    Map<String, Object> rutinaParsed = parsearRutinaProlog(output, objetivo, nivel);
                    resultado.putAll(rutinaParsed);
                    resultado.put("success", true);
                    resultado.put("fuente", "Prolog");
                    logger.info("✅ Rutina generada desde Prolog");
                    return resultado;
                }
            }
            
            // Fallback si Prolog falla
            logger.warn("⚠️  Prolog falló, usando fallback");
            resultado.put("success", false);
            resultado.put("warning", "No se pudo generar desde Prolog");
            
        } catch (Exception e) {
            logger.error("❌ Error en generación desde Prolog: {}", e.getMessage(), e);
            resultado.put("success", false);
            resultado.put("error", e.getMessage());
        }
        
        return resultado;
    }
    
    /**
     * Mapea nivel Java (INICIAL/INTERMEDIO/AVANZADO) al átomo Prolog correspondiente.
     */
    private String nivelAProlog(String nivel) {
        if (nivel == null) return "principiante";
        return switch (nivel.toUpperCase()) {
            case "INICIAL"     -> "principiante";
            case "INTERMEDIO"  -> "intermedio";
            case "AVANZADO"    -> "avanzado";
            default            -> nivel.toLowerCase();
        };
    }

    /**
     * Mapea objetivo Java (HIPERTROFIA/FUERZA/DEFINICION/HIBRIDO)
     * al átomo Prolog correspondiente (la KB Prolog es la fuente de verdad).
     */
    private String objetivoAProlog(String objetivo) {
        if (objetivo == null) return "hipertrofia";
        return switch (objetivo.toUpperCase()) {
            case "HIPERTROFIA"      -> "hipertrofia";
            case "FUERZA"           -> "fuerza";
            case "DEFINICION"       -> "definicion";
            case "HIBRIDO"          -> "hibrido";
            default                 -> objetivo.toLowerCase();
        };
    }

    // ============================================================
    // HELPERS DE PARSING PROLOG
    // ============================================================

    /** Encuentra el índice del ')' que cierra la apertura en startParen. */
    private int findMatchingParen(String s, int startParen) {
        int depth = 0;
        boolean inStr = false;
        for (int i = startParen; i < s.length(); i++) {
            char c = s.charAt(i);
            if (c == '\'') { inStr = !inStr; continue; }
            if (inStr) continue;
            if (c == '(') depth++;
            else if (c == ')') {
                if (depth == 0) return i;
                depth--;
            }
        }
        return s.length() - 1;
    }

    /** Encuentra el índice del ']' que cierra la apertura en startBracket. */
    private int findMatchingBracket(String s, int startBracket) {
        int depth = 0;
        boolean inStr = false;
        for (int i = startBracket; i < s.length(); i++) {
            char c = s.charAt(i);
            if (c == '\'') { inStr = !inStr; continue; }
            if (inStr) continue;
            if (c == '[') depth++;
            else if (c == ']') {
                if (depth == 0) return i;
                depth--;
            }
        }
        return s.length() - 1;
    }

    /**
     * Divide una cadena por comas de nivel superior (ignora comas dentro de paréntesis/corchetes).
     * Devuelve como máximo maxParts partes (el resto va en la última).
     */
    private List<String> splitTopLevel(String s, int maxParts) {
        List<String> parts = new ArrayList<>();
        int depth = 0;
        boolean inStr = false;
        StringBuilder cur = new StringBuilder();
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            if (c == '\'') { inStr = !inStr; cur.append(c); continue; }
            if (!inStr) {
                if (c == '(' || c == '[') depth++;
                else if (c == ')' || c == ']') depth--;
                else if (c == ',' && depth == 0) {
                    if (maxParts > 0 && parts.size() >= maxParts - 1) {
                        cur.append(c);
                        continue;
                    }
                    parts.add(cur.toString().trim());
                    cur = new StringBuilder();
                    continue;
                }
            }
            cur.append(c);
        }
        if (cur.length() > 0) parts.add(cur.toString().trim());
        return parts;
    }

    /** Parsea una lista Prolog de ejercicio_info(...) y devuelve List<Map>. */
    private List<Map<String, Object>> parsearListaEjercicioInfo(String listContent) {
        List<Map<String, Object>> result = new ArrayList<>();
        int pos = 0;
        while (pos < listContent.length()) {
            int start = listContent.indexOf("ejercicio_info(", pos);
            if (start == -1) break;
            int innerStart = start + 15;
            int end = findMatchingParen(listContent, innerStart);
            String inner = listContent.substring(innerStart, end);
            result.add(parsearEjercicioProlog(inner));
            pos = end + 1;
        }
        return result;
    }

    /** Parsea una lista Prolog de grupo_ejercicios(...) y devuelve List<Map>. */
    private List<Map<String, Object>> parsearListaGruposProlog(String listContent, String objetivo, String nivel) {
        List<Map<String, Object>> result = new ArrayList<>();
        int pos = 0;
        while (pos < listContent.length()) {
            int start = listContent.indexOf("grupo_ejercicios(", pos);
            if (start == -1) break;
            int innerStart = start + 17;
            int end = findMatchingParen(listContent, innerStart);
            String inner = listContent.substring(innerStart, end);
            result.add(parsearGrupoProlog(inner, objetivo, nivel));
            pos = end + 1;
        }
        return result;
    }

    /**
     * Parser: Convierte estructura Prolog [dia(1, ...), ...] a Map Java.
     * Soporta tanto la estructura antigua [dia(N, [grupo_ejercicios...])]
     * como la nueva [dia(N, sesion(EntradaCalor, [Movilidad...], [Principales...]))].
     */
    private Map<String, Object> parsearRutinaProlog(String prologOutput, String objetivo, String nivel) {
        Map<String, Object> resultado = new HashMap<>();
        List<Map<String, Object>> dias = new ArrayList<>();

        try {
            String clean = prologOutput.trim();
            if (clean.startsWith("[") && clean.endsWith("]")) {
                clean = clean.substring(1, clean.length() - 1);
            }

            int diaNum = 1;
            int pos = 0;
            while (pos < clean.length()) {
                int diaStart = clean.indexOf("dia(", pos);
                if (diaStart == -1) break;
                int innerStart = diaStart + 4;
                int end = findMatchingParen(clean, innerStart);
                String diaContent = clean.substring(innerStart, end);
                Map<String, Object> diaMap = parsearDiaProlog(diaNum, diaContent, objetivo, nivel);
                dias.add(diaMap);
                diaNum++;
                pos = end + 1;
            }

            resultado.put("dias", dias);
            resultado.put("numDias", dias.size());
            resultado.put("objetivo", objetivo);
            resultado.put("nivel", nivel);

        } catch (Exception e) {
            logger.error("Error parseando rutina Prolog: {}", e.getMessage(), e);
            resultado.put("success", false);
        }

        return resultado;
    }

    /**
     * Parsea el contenido interno de un dia(N, ...).
     * Detecta automáticamente formato sesion/3 o lista plana de grupo_ejercicios.
     */
    private Map<String, Object> parsearDiaProlog(Integer diaNum, String diaContent,
                                                  String objetivo, String nivel) {
        Map<String, Object> dia = new HashMap<>();
        List<Map<String, Object>> grupos = new ArrayList<>();
        Map<String, Object> entradaCalor = new HashMap<>();
        List<Map<String, Object>> movilidadEj = new ArrayList<>();

        try {
            // Separar número de día del contenido
            List<String> topParts = splitTopLevel(diaContent, 2);
            if (topParts.size() < 2) { dia.put("numero", diaNum); dia.put("grupos", grupos); return dia; }

            String remainder = topParts.get(1).trim();

            if (remainder.startsWith("sesion(")) {
                // Nueva estructura: sesion(EntradaCalor, [Movilidad...], [Principales...])
                String sesionInner = remainder.substring(7); // elimina "sesion("
                // Elimina el ')' de cierre del sesion
                if (sesionInner.endsWith(")")) sesionInner = sesionInner.substring(0, sesionInner.length() - 1);

                // Dividir los 3 argumentos de sesion a nivel superior
                List<String> sesionArgs = splitTopLevel(sesionInner, 3);

                // Arg 1: ejercicio_info(...) — entrada en calor
                if (sesionArgs.size() > 0) {
                    String a1 = sesionArgs.get(0).trim();
                    if (a1.startsWith("ejercicio_info(")) {
                        int iEnd = findMatchingParen(a1, 15);
                        entradaCalor = parsearEjercicioProlog(a1.substring(15, iEnd));
                    }
                }
                // Arg 2: [ejercicio_info(...), ...] — movilidad
                if (sesionArgs.size() > 1) {
                    String a2 = sesionArgs.get(1).trim();
                    if (a2.startsWith("[") && a2.endsWith("]"))
                        movilidadEj = parsearListaEjercicioInfo(a2.substring(1, a2.length() - 1));
                }
                // Arg 3: [grupo_ejercicios(...), ...] — principales
                if (sesionArgs.size() > 2) {
                    String a3 = sesionArgs.get(2).trim();
                    if (a3.startsWith("[") && a3.endsWith("]"))
                        grupos = parsearListaGruposProlog(a3.substring(1, a3.length() - 1), objetivo, nivel);
                }

            } else {
                // Formato antiguo: [grupo_ejercicios(...), ...]
                String gruposContent = remainder;
                if (gruposContent.startsWith("[") && gruposContent.endsWith("]"))
                    gruposContent = gruposContent.substring(1, gruposContent.length() - 1);
                grupos = parsearListaGruposProlog(gruposContent, objetivo, nivel);
            }

        } catch (Exception e) {
            logger.error("Error parseando día {}: {}", diaNum, e.getMessage());
        }

        dia.put("numero", diaNum);
        dia.put("grupos", grupos);
        dia.put("entradaCalor", entradaCalor);
        dia.put("movilidad", movilidadEj);
        return dia;
    }

    /** Parse estructura grupo: (pecho, [ejercicio_info(...), ...]) */
    private Map<String, Object> parsearGrupoProlog(String grupoContent, String objetivo, String nivel) {
        Map<String, Object> grupo = new HashMap<>();
        List<Map<String, Object>> ejercicios = new ArrayList<>();
        try {
            List<String> parts = splitTopLevel(grupoContent, 2);
            if (parts.size() >= 2) {
                grupo.put("nombre", parts.get(0).trim().replaceAll("'", ""));
                String ejContent = parts.get(1).trim();
                if (ejContent.startsWith("[") && ejContent.endsWith("]"))
                    ejContent = ejContent.substring(1, ejContent.length() - 1);
                ejercicios = parsearListaEjercicioInfo(ejContent);
            }
        } catch (Exception e) {
            logger.error("Error parseando grupo: {}", e.getMessage());
        }
        grupo.put("ejercicios", ejercicios);
        return grupo;
    }

    /** Parse ejercicio: (ex_001, 'Press Banca', 3, 10, 60) */
    private Map<String, Object> parsearEjercicioProlog(String ejeContent) {
        Map<String, Object> ejercicio = new HashMap<>();
        try {
            List<String> parts = splitTopLevel(ejeContent, 5);
            if (parts.size() >= 5) {
                ejercicio.put("id",       parts.get(0).trim());
                ejercicio.put("nombre",   parts.get(1).trim().replaceAll("'", ""));
                ejercicio.put("series",   Integer.parseInt(parts.get(2).trim()));
                ejercicio.put("reps",     Integer.parseInt(parts.get(3).trim()));
                ejercicio.put("descanso", Integer.parseInt(parts.get(4).trim().replaceAll("[^0-9]", "0").isEmpty() ? "0" : parts.get(4).trim().replaceAll("[^0-9]", "")));
            }
        } catch (Exception e) {
            logger.error("Error parseando ejercicio '{}': {}", ejeContent, e.getMessage());
        }
        return ejercicio;
    }

    private static boolean isWindows() {
        return System.getProperty("os.name").toLowerCase().contains("win");
    }
}

