package com.rutinagym.model;

/**
 * Enum que representa los grupos musculares disponibles
 */
public enum GrupoMuscular {
    PECHO("Pecho"),
    ESPALDA("Espalda"),
    HOMBROS("Hombros"),
    BICEPS("Bíceps"),
    TRICEPS("Tríceps"),
    ANTEBRAZO("Antebrazo"),
    CUADRICEPS("Cuádriceps"),
    ISQUIOTIBIAL("Isquiotibial"),
    GLUTEOS("Glúteos"),
    PANTORRILLA("Pantorrilla"),
    PIERNAS("Piernas"),
    CORE("Core"),
    CARDIO("Cardio"),
    FLEXIBILIDAD("Flexibilidad");
    
    private final String display;
    
    GrupoMuscular(String display) {
        this.display = display;
    }
    
    public String getDisplay() {
        return display;
    }
}
