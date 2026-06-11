package com.suggesto.backend.repository;

import com.suggesto.backend.model.Resgate;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ResgateRepository extends JpaRepository<Resgate, Long> {

    long countByUsuario_Id(Long usuarioId);
}
