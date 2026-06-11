package com.suggesto.backend.repository;

import com.suggesto.backend.model.LocalSalvo;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface LocalSalvoRepository extends JpaRepository<LocalSalvo, Long> {

    long countByUsuarioId(Long usuarioId);

    List<LocalSalvo> findByUsuarioId(Long usuarioId);

    boolean existsByUsuarioIdAndEstabelecimentoId(Long usuarioId, Long estabelecimentoId);

    Optional<LocalSalvo> findByUsuarioIdAndEstabelecimentoId(Long usuarioId, Long estabelecimentoId);
}
