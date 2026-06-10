package com.rutinagym.model;

import jakarta.persistence.*;
import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "ejercicios")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Ejercicio {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String nombre;
    
    @Column(columnDefinition = "TEXT")
    private String descripcion;
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private GrupoMuscular grupoMuscular;
    
    // ===== Campos del Sistema Experto Prolog =====
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TipoEjercicio tipo;
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Patron patron;
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Nivel nivelDificultadMinima;
    
    // ===== Parámetros de Entrenamiento (valores por defecto) =====
    
    @Column(nullable = false)
    private Integer series;
    
    @Column(nullable = false)
    private Integer repeticiones;
    
    @Column
    private Integer descansoSegundos;
    
    // ===== Relación con Rutina =====
    
    @JsonIgnore
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "dia_entrenamiento_id", nullable = false)
    private DiaEntrenamiento diaEntrenamiento;
}
