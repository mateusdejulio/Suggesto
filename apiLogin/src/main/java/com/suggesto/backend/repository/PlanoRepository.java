package com.suggesto.backend.repository;

import com.suggesto.backend.model.Plano;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface PlanoRepository extends JpaRepository<Plano, Long> {

    Optional<Plano> findByNome(String nome);
}
