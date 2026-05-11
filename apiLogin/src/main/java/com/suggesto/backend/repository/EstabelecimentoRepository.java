package com.suggesto.backend.repository;

import com.suggesto.backend.model.Estabelecimento;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface EstabelecimentoRepository extends JpaRepository<Estabelecimento, Long> {

    // 1. Para o Web App: Traz apenas os ativos gerais
    @Query("SELECT e FROM Estabelecimento e WHERE e.ativo = 1")
    List<Estabelecimento> buscarTodosAtivos();

    // 2. Para o Dashboard Desktop: Traz apenas os ativos daquele gerente
    // Ajustado para 'idGerente' batendo com a sua classe!
    @Query("SELECT e FROM Estabelecimento e WHERE e.idGerente = :idGerente AND e.ativo = 1")
    List<Estabelecimento> buscarPorGerenteAtivos(@Param("idGerente") Long idGerente);

    // (Opcional) Mantém o antigo caso algo mais precise dele
    List<Estabelecimento> findByIdGerente(Long idGerente);
}