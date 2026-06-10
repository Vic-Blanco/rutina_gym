package com.rutinagym.model;

/**
 * Enum que representa los géneros de los usuarios
 */
public enum Genero {
    MASCULINO("Masculino"),
    FEMENINO("Femenino"),
    OTRO("Otro");
    
    private final String display;
    
    Genero(String display) {
        this.display = display;
    }
    
    public String getDisplay() {
        return display;
    }
}
