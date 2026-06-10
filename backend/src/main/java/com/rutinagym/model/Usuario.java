package com.rutinagym.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "usuarios")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Usuario {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false, unique = true)
    private String email;
    
    @Column(nullable = false)
    private String nombre;
    
    @Column(nullable = false)
    private String password;
    
    // ===== Campos del Sistema Experto Prolog =====
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Nivel nivel;
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Objetivo objetivo;
    
    @Column(nullable = false)
    private Integer diasDisponibles;
    
    @ElementCollection(fetch = FetchType.EAGER)
    @Enumerated(EnumType.STRING)
    @CollectionTable(name = "usuario_grupos_musculares", joinColumns = @JoinColumn(name = "usuario_id"))
    @Column(name = "grupo_muscular")
    private List<GrupoMuscular> gruposMusculares;
    
    @Enumerated(EnumType.STRING)
    @Column
    private GrupoMuscular grupoPrioritario;
    
    // ===== Auditoría =====
    
    @Column(nullable = false)
    private LocalDateTime fechaCreacion;
    
    @Column(nullable = false)
    private LocalDateTime ultimaActualizacion;
    
    @PrePersist
    protected void onCreate() {
        fechaCreacion = LocalDateTime.now();
        ultimaActualizacion = LocalDateTime.now();
    }
    
    @PreUpdate
    protected void onUpdate() {
        ultimaActualizacion = LocalDateTime.now();
    }
}
