package com.rutinagym.model;

/**
 * Enum que representa el patrón de movimiento del ejercicio
 */
public enum Patron {
    EMPUJE("Empuje - Movimiento de empuje horizontal o vertical"),
    TIRON("Tirón - Movimiento de tracción hacia el cuerpo"),
    ESTATICO("Estático - Contracción isométrica");
    
    private final String display;
    
    Patron(String display) {
        this.display = display;
    }
    
    public String getDisplay() {
        return display;
    }
}
