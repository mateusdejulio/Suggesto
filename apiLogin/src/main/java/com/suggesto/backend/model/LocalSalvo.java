package com.suggesto.backend.model;

import jakarta.persistence.*;

import java.time.LocalDateTime;

@Entity
@Table(
        name = "local_salvo",
        uniqueConstraints = @UniqueConstraint(columnNames = {"usuario_id", "estabelecimento_id"})
)
public class LocalSalvo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "usuario_id", nullable = false)
    private Long usuarioId;

    @Column(name = "estabelecimento_id", nullable = false)
    private Long estabelecimentoId;

    @Column(name = "data_salvo", nullable = false)
    private LocalDateTime dataSalvo;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getUsuarioId() {
        return usuarioId;
    }

    public void setUsuarioId(Long usuarioId) {
        this.usuarioId = usuarioId;
    }

    public Long getEstabelecimentoId() {
        return estabelecimentoId;
    }

    public void setEstabelecimentoId(Long estabelecimentoId) {
        this.estabelecimentoId = estabelecimentoId;
    }

    public LocalDateTime getDataSalvo() {
        return dataSalvo;
    }

    public void setDataSalvo(LocalDateTime dataSalvo) {
        this.dataSalvo = dataSalvo;
    }
}
