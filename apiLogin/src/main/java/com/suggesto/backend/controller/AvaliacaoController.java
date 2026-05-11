package com.suggesto.backend.controller;

import com.suggesto.backend.dto.AvaliacaoRequestDTO; // Importe o DTO
import com.suggesto.backend.model.Avaliacao;
import com.suggesto.backend.repository.AvaliacaoRepository;
import com.suggesto.backend.service.AvaliacaoService; // Importe o Service
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/avaliacoes")
@CrossOrigin(origins = "*") // Permite que o seu site (HTML) acesse a API
public class AvaliacaoController {

    @Autowired
    private AvaliacaoRepository avaliacaoRepository;

    @Autowired
    private AvaliacaoService avaliacaoService; // Injetando o "gerente"

    // --- Mantenha o seu GET para testes ---
    @GetMapping("/estabelecimento/{id}")
    public List<Avaliacao> listarPorEstabelecimento(@PathVariable Long id) {
        // Mude para o novo nome que criamos acima
        return avaliacaoRepository.findByEstabelecimentoId(id);
    }

    @PostMapping
    public ResponseEntity<?> receberAvaliacao(@RequestBody AvaliacaoRequestDTO dto) {
        try {
            // Processa o DTO (que agora deve ter os nomes: mensagem e categoria)
            avaliacaoService.registrarNovaAvaliacao(dto);

            // Retorno limpo em formato de mapa para evitar erros de JSON manual
            Map<String, String> sucesso = new HashMap<>();
            sucesso.put("mensagem", "Feedback registrado com sucesso!");
            return ResponseEntity.ok(sucesso);

        } catch (Exception e) {
            // IMPRIME O ERRO NO TERMINAL (Crucial para ver por que deu 400 ou 500)
            e.printStackTrace();

            Map<String, String> erro = new HashMap<>();
            erro.put("erro", e.getMessage());
            return ResponseEntity.badRequest().body(erro);
        }
    }

    @GetMapping("/usuario/{usuarioId}")
    public ResponseEntity<List<Avaliacao>> listarPorUsuario(@PathVariable Long usuarioId) {
        try {
            // Usando o método exato que criamos no Repositório
            List<Avaliacao> minhasAvaliacoes = avaliacaoRepository.buscarPorUsuario(usuarioId);
            return ResponseEntity.ok(minhasAvaliacoes);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }
}