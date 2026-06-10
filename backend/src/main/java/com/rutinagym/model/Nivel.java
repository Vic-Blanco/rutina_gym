package com.rutinagym.model;

/**
 * Enum que representa los niveles de dificultad
 */
public enum Nivel {
    INICIAL("Inicial - Principiante"),
    INTERMEDIO("Intermedio - Experimentado"),
    AVANZADO("Avanzado - Experto");
    
    private final String display;
    
    Nivel(String display) {
        this.display = display;
    }
    
    public String getDisplay() {
        return display;
    }
}
