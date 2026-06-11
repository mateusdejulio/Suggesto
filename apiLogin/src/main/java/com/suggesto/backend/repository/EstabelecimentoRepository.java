package com.suggesto.backend.repository;

import com.suggesto.backend.model.Estabelecimento;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface EstabelecimentoRepository extends JpaRepository<Estabelecimento, Long> {

    @Query("SELECT e FROM Estabelecimento e WHERE e.ativo = 1")
    List<Estabelecimento> buscarTodosAtivos();

    @Query("SELECT e FROM Estabelecimento e WHERE e.idGerente = :idGerente AND e.ativo = 1")
    List<Estabelecimento> buscarPorGerenteAtivos(@Param("idGerente") Long idGerente);

    List<Estabelecimento> findByIdGerente(Long idGerente);
}