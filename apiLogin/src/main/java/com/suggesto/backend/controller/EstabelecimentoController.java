package com.suggesto.backend.controller;

import com.suggesto.backend.model.Estabelecimento;
import com.suggesto.backend.repository.EstabelecimentoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;

@RestController
@RequestMapping("api/estabelecimentos")
public class EstabelecimentoController {

    @Autowired
    private EstabelecimentoRepository repository;

    @GetMapping("/{id}")
    public ResponseEntity<?> buscarPorId(@PathVariable Long id) {
        try {
            return repository.findById(id)
                    .map(estab -> ResponseEntity.ok(estab))
                    .orElse(ResponseEntity.notFound().build());
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Erro ao buscar detalhes: " + e.getMessage());
        }
    }

    @PostMapping(consumes = {"multipart/form-data"})
    public ResponseEntity<?> cadastrar(
            @RequestPart("estabelecimento") Estabelecimento novoEstabelecimento,
            @RequestPart(value = "foto", required = false) MultipartFile arquivo) {

        try {
            // Se o estabelecimento for novo, garante que ele nasça ativo (1)
            if (novoEstabelecimento.getAtivo() == null) {
                novoEstabelecimento.setAtivo(1);
            }

            if (arquivo != null && !arquivo.isEmpty()) {
                Path diretorio = Paths.get("uploads");
                if (!Files.exists(diretorio)) {
                    Files.createDirectories(diretorio);
                }
                String nomeArquivo = System.currentTimeMillis() + "_" + arquivo.getOriginalFilename();
                Path caminho = diretorio.resolve(nomeArquivo);
                Files.copy(arquivo.getInputStream(), caminho, StandardCopyOption.REPLACE_EXISTING);
                novoEstabelecimento.setFotoPath(nomeArquivo);
            }

            Estabelecimento salvo = repository.save(novoEstabelecimento);
            return ResponseEntity.ok(salvo);

        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Erro ao salvar estabelecimento: " + e.getMessage());
        }
    }

    // MUDANÇA AQUI: Agora usa buscarPorGerenteAtivos()
    @GetMapping("/gerente/{id}")
    public ResponseEntity<?> buscarPorGerente(@PathVariable Long id) {
        try {
            List<Estabelecimento> lista = repository.buscarPorGerenteAtivos(id);
            return ResponseEntity.ok(lista);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Erro ao buscar estabelecimento: " + e.getMessage());
        }
    }

    @PostMapping("/{id}/foto")
    public ResponseEntity<?> uploadFoto(@PathVariable Long id, @RequestParam("foto") MultipartFile arquivo) {
        try {
            Estabelecimento estab = repository.findById(id).orElseThrow(() -> new RuntimeException("Não encontrado"));

            String nomeArquivo = "estabelecimento_" + id + "_" + arquivo.getOriginalFilename();
            Path caminho = Paths.get("uploads").resolve(nomeArquivo);
            Files.copy(arquivo.getInputStream(), caminho, StandardCopyOption.REPLACE_EXISTING);

            estab.setFotoPath(nomeArquivo);
            repository.save(estab);

            return ResponseEntity.ok("Foto salva com sucesso!" + nomeArquivo);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Erro ao salvar estabelecimento: " + e.getMessage());
        }
    }

    // MUDANÇA AQUI: Corrigido repository ao invés de estabelecimentoRepository
    @DeleteMapping("/{id}")
    public ResponseEntity<?> inativarEstabelecimento(@PathVariable Long id) {
        return repository.findById(id).map(estab -> {
            estab.setAtivo(0); // Inativa!
            repository.save(estab);
            return ResponseEntity.ok().build();
        }).orElse(ResponseEntity.notFound().build());
    }

    // MUDANÇA AQUI: Agora usa buscarTodosAtivos()
    @GetMapping
    public ResponseEntity<List<Estabelecimento>> listarTodos() {
        try {
            List<Estabelecimento> lista = repository.buscarTodosAtivos();
            return ResponseEntity.ok(lista);
        } catch (Exception e) {
            return ResponseEntity.status(500).build();
        }
    }
}