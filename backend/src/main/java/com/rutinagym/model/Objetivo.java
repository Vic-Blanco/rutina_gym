package com.rutinagym.model;

import com.fasterxml.jackson.annotation.JsonCreator;

/**
 * Enum que representa los objetivos de entrenamiento
 */
public enum Objetivo {
    HIPERTROFIA("Hipertrofia - Ganar masa muscular"),
    FUERZA("Fuerza - Aumentar capacidad de levantamiento"),
    DEFINICION("Definición - Reducir grasa y marcar músculo"),
    HIBRIDO("Híbrido - Mezcla de fuerza y resistencia");
    
    private final String display;
    
    Objetivo(String display) {
        this.display = display;
    }
    
    public String getDisplay() {
        return display;
    }
    
    @JsonCreator
    public static Objetivo fromString(String value) {
        if (value == null) {
            return null;
        }
        try {
            return Objetivo.valueOf(value.toUpperCase());
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException("Objetivo no válido: " + value);
        }
    }
}
