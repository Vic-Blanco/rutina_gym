package com.rutinagym.dto;

import com.rutinagym.model.DiaEntrenamiento;
import java.util.List;
import java.util.Map;

/**
 * DTO para respuesta del sistema experto Prolog
 * Coincide con la estructura retornada por generar_rutina_completa/1
 */
public class RutinaExpertaResponse {
    private String division;
    private List<DiaEntrenamiento> diasEntrenamiento;
    private Map<String, Object> validaciones;
    private List<String> recomendaciones;
    private String explicacion;
    private Map<String, Object> estadisticas;
    
    public RutinaExpertaResponse() {}
    
    public RutinaExpertaResponse(String division, List<DiaEntrenamiento> diasEntrenamiento,
                                 Map<String, Object> validaciones, List<String> recomendaciones,
                                 String explicacion, Map<String, Object> estadisticas) {
        this.division = division;
        this.diasEntrenamiento = diasEntrenamiento;
        this.validaciones = validaciones;
        this.recomendaciones = recomendaciones;
        this.explicacion = explicacion;
        this.estadisticas = estadisticas;
    }
    
    public String getDivision() {
        return division;
    }
    
    public void setDivision(String division) {
        this.division = division;
    }
    
    public List<DiaEntrenamiento> getDiasEntrenamiento() {
        return diasEntrenamiento;
    }
    
    public void setDiasEntrenamiento(List<DiaEntrenamiento> diasEntrenamiento) {
        this.diasEntrenamiento = diasEntrenamiento;
    }
    
    public Map<String, Object> getValidaciones() {
        return validaciones;
    }
    
    public void setValidaciones(Map<String, Object> validaciones) {
        this.validaciones = validaciones;
    }
    
    public List<String> getRecomendaciones() {
        return recomendaciones;
    }
    
    public void setRecomendaciones(List<String> recomendaciones) {
        this.recomendaciones = recomendaciones;
    }
    
    public String getExplicacion() {
        return explicacion;
    }
    
    public void setExplicacion(String explicacion) {
        this.explicacion = explicacion;
    }
    
    public Map<String, Object> getEstadisticas() {
        return estadisticas;
    }
    
    public void setEstadisticas(Map<String, Object> estadisticas) {
        this.estadisticas = estadisticas;
    }
}
