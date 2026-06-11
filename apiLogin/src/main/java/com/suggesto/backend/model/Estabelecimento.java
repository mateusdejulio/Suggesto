package com.suggesto.backend.model;

import jakarta.persistence.*;

@Entity
@Table(name = "estabelecimento")
public class Estabelecimento {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_estabelecimento")
    private long idEstabelecimento;

    @Column(name = "ativo")
    private Integer ativo = 1;

    @Column(name = "nome_estabelecimento", nullable = false)
    private String nome;

    @Column(name = "cnpj", nullable = false, unique = true)
    private String cnpj;

    @Column(name = "endereco", nullable = false)
    private String endereco;

    @Column(name = "categoria", nullable = false)
    private String categoria;

    @Column(name = "telefone")
    private String telefone;

    @Column(name = "id_gerente", nullable = false)
    private long  idGerente;

    public long getIdEstabelecimento() {
        return idEstabelecimento;
    }

    public void setIdEstabelecimento(long idEstabelecimento) {
        this.idEstabelecimento = idEstabelecimento;
    }


    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    private String fotoPath;

    public String getFotoPath() {
        if (fotoPath == null || fotoPath.isBlank()) {
            return fotoPath;
        }
        String limpo = fotoPath.replace('\\', '/').trim();
        if (limpo.contains(":/") || limpo.startsWith("/")) {
            int idx = limpo.lastIndexOf("/uploads/");
            if (idx >= 0) {
                return limpo.substring(idx + "/uploads/".length());
            }
            int barra = limpo.lastIndexOf('/');
            return barra >= 0 ? limpo.substring(barra + 1) : limpo;
        }
        if (limpo.startsWith("uploads/")) {
            return limpo.substring("uploads/".length());
        }
        return limpo;
    }

    public void setFotoPath(String fotoPath) {
        if (fotoPath == null || fotoPath.isBlank()) {
            this.fotoPath = fotoPath;
            return;
        }
        String limpo = fotoPath.replace('\\', '/').trim();
        if (limpo.contains(":/")) {
            int idx = limpo.lastIndexOf("/uploads/");
            if (idx >= 0) {
                limpo = limpo.substring(idx + "/uploads/".length());
            } else {
                int barra = limpo.lastIndexOf('/');
                limpo = barra >= 0 ? limpo.substring(barra + 1) : limpo;
            }
        }
        if (limpo.startsWith("uploads/")) {
            limpo = limpo.substring("uploads/".length());
        }
        this.fotoPath = limpo;
    }


    public String getCnpj() {
        return cnpj;
    }

    public void setCnpj(String cnpj) {
        this.cnpj = cnpj;
    }

    public String getEndereco() {
        return endereco;
    }

    public void setEndereco(String endereco) {
        this.endereco = endereco;
    }

    public String getCategoria() {
        return categoria;
    }

    public void setCategoria(String categoria) {
        this.categoria = categoria;
    }

    public String getTelefone() {
        return telefone;
    }

    public void setTelefone(String telefone) {
        this.telefone = telefone;
    }

    public long getIdGerente() {
        return idGerente;
    }

    public void setIdGerente(long idGerente) {
        this.idGerente = idGerente;
    }

    public Integer getAtivo() {
        return ativo;
    }

    public void setAtivo(Integer ativo) {
        this.ativo = ativo;
    }
}
