package com.rutinagym.repository;

import com.rutinagym.model.Rutina;
import com.rutinagym.model.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface RutinaRepository extends JpaRepository<Rutina, Long> {
    List<Rutina> findByUsuario(Usuario usuario);
    List<Rutina> findByUsuarioId(Long usuarioId);
}
