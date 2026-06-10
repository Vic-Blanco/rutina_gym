package com.rutinagym.model;

/**
 * Enum que representa el tipo de ejercicio
 */
public enum TipoEjercicio {
    COMPUESTO("Compuesto - Trabaja múltiples articulaciones"),
    AISLADO("Aislado - Trabaja una articulación");
    
    private final String display;
    
    TipoEjercicio(String display) {
        this.display = display;
    }
    
    public String getDisplay() {
        return display;
    }
}
