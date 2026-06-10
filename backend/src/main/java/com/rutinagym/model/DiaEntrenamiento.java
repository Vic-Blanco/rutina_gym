package com.rutinagym.model;

import jakarta.persistence.*;
import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;

@Entity
@Table(name = "dias_entrenamiento")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class DiaEntrenamiento {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @JsonIgnore
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "rutina_id", nullable = false)
    private Rutina rutina;
    
    @Column(nullable = false)
    private Integer numeroDia;
    
    @Column(nullable = false)
    private String descripcion;
    
    // ===== Grupos Musculares del Día (según División) =====
    @ElementCollection(fetch = FetchType.EAGER)
    @Enumerated(EnumType.STRING)
    @CollectionTable(name = "dia_grupos_musculares", joinColumns = @JoinColumn(name = "dia_id"))
    @Column(name = "grupo_muscular")
    private List<GrupoMuscular> gruposMusculares;
    
    @OneToMany(mappedBy = "diaEntrenamiento", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Ejercicio> ejercicios;
}
