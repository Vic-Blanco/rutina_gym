package com.rutinagym.dto;

import java.util.List;

public class GenerarRutinaRequest {
    private String nombre;
    private String objetivo;  // Aceptar como String para mayor flexibilidad
    private String nivel;     // INICIAL, INTERMEDIO, AVANZADO
    private Integer diasDisponibles;
    private List<String> gruposMusculares;
    private String grupoPrioritario;
    /** Tipo de entrada en calor para rutina personalizada.
     *  Valores Prolog: cardio_ligero | movilidad_dinamica | activacion_muscular
     *  Null/vacío = selección automática. */
    private String tipoEntradaCalor;

    public GenerarRutinaRequest() {}

    public GenerarRutinaRequest(String nombre, String objetivo, String nivel, Integer diasDisponibles,
                                List<String> gruposMusculares, String grupoPrioritario) {
        this.nombre = nombre;
        this.objetivo = objetivo;
        this.nivel = nivel;
        this.diasDisponibles = diasDisponibles;
        this.gruposMusculares = gruposMusculares;
        this.grupoPrioritario = grupoPrioritario;
    }
    
    public String getNombre() {
        return nombre;
    }
    
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }
    
    public String getObjetivo() {
        return objetivo;
    }
    
    public void setObjetivo(String objetivo) {
        this.objetivo = objetivo;
    }
    
    public String getNivel() {
        return nivel;
    }
    
    public void setNivel(String nivel) {
        this.nivel = nivel;
    }
    
    public Integer getDiasDisponibles() {
        return diasDisponibles;
    }
    
    public void setDiasDisponibles(Integer diasDisponibles) {
        this.diasDisponibles = diasDisponibles;
    }
    
    public List<String> getGruposMusculares() {
        return gruposMusculares;
    }
    
    public void setGruposMusculares(List<String> gruposMusculares) {
        this.gruposMusculares = gruposMusculares;
    }
    
    public String getGrupoPrioritario() {
        return grupoPrioritario;
    }

    public void setGrupoPrioritario(String grupoPrioritario) {
        this.grupoPrioritario = grupoPrioritario;
    }

    public String getTipoEntradaCalor() {
        return tipoEntradaCalor;
    }

    public void setTipoEntradaCalor(String tipoEntradaCalor) {
        this.tipoEntradaCalor = tipoEntradaCalor;
    }
}
