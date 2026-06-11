package com.suggesto.backend.repository;

import com.suggesto.backend.model.Recompensa;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface RecompensaRepository extends JpaRepository<Recompensa, Long> {

    List<Recompensa> findByEstabelecimento_IdEstabelecimentoOrderByCustoPontosAsc(Long idEstabelecimento);
}
