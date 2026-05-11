package com.suggesto.backend.repository;


import com.suggesto.backend.model.Categoria;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface CategoriaRepository extends JpaRepository<Categoria, Long> {

    // Aqui dizemos: "Spring, quando eu chamar findByNome, procure na coluna nomeCategoria"
    @Query("SELECT c FROM Categoria c WHERE c.nomeCategoria = :nome")
    Optional<Categoria> findByNome(@Param("nome") String nome);
}