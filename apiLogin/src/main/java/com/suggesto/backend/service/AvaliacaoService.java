package com.suggesto.backend.service;

import com.suggesto.backend.dto.AvaliacaoRequestDTO;
import com.suggesto.backend.model.*;
import com.suggesto.backend.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
public class AvaliacaoService {

    @Autowired
    private AvaliacaoRepository avaliacaoRepository;

    @Autowired
    private EstabelecimentoRepository estabelecimentoRepository;

    @Autowired
    private CategoriaRepository categoriaRepository;

    // AQUI: Adicionamos o repositório do Usuário que estava faltando!
    @Autowired
    private UsuarioRepository usuarioRepository;

    @Transactional
    public void registrarNovaAvaliacao(AvaliacaoRequestDTO dto) {

        // 1. Busca o Usuário pelo ID que veio do HTML
        Usuario usuario = usuarioRepository.findById(dto.getIdUsuario())
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado. ID: " + dto.getIdUsuario()));

        // 2. Busca o Estabelecimento
        Estabelecimento est = estabelecimentoRepository.findById(dto.getIdEstabelecimento())
                .orElseThrow(() -> new RuntimeException("Estabelecimento não encontrado. ID: " + dto.getIdEstabelecimento()));

        // 3. Busca a Categoria pelo ID
        Categoria categoria = categoriaRepository.findById(dto.getIdCategoria())
                .orElseThrow(() -> new RuntimeException("Categoria não encontrada com o ID: " + dto.getIdCategoria()));

        // 4. Criamos a entidade Avaliacao
        Avaliacao avaliacao = new Avaliacao();

        // Mapeando os campos do DTO para a Entidade
        avaliacao.setTipo(dto.getTipo());
        avaliacao.setNota(dto.getNota());
        avaliacao.setComentario(dto.getComentario()); // Usando getComentario() igual deixamos no DTO
        avaliacao.setDataAvaliacao(LocalDateTime.now());

        // AQUI: O Status padrão para a tela de "Minhas Sugestões" saber que está em análise
        avaliacao.setStatus("analise");

        // Pendurando as conexões no objeto
        avaliacao.setEstabelecimento(est);
        avaliacao.setCategoria(categoria); // Corrigido de 'cat' para 'categoria'
        avaliacao.setUsuario(usuario);     // Conectando o usuário na avaliação

        // 5. Salva no banco de dados!
        avaliacaoRepository.save(avaliacao);
    }
}