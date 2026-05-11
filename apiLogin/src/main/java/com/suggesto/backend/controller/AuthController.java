package com.suggesto.backend.controller;

import com.suggesto.backend.model.Usuario;
import com.suggesto.backend.model.TipoUsuario;
import com.suggesto.backend.repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api")
public class AuthController {

    @Autowired
    private UsuarioRepository repository;

    /**
     * LOGIN GERAL (Web)
     */
    @PostMapping("/login")
    public ResponseEntity<?> loginGeral(@RequestBody Map<String, String> dados) {
        return realizarAutenticacao(dados, false);
    }

    /**
     * LOGIN ADMINISTRATIVO (Desktop/Electron)
     */
    @PostMapping("/login/admin")
    public ResponseEntity<?> loginAdmin(@RequestBody Map<String, String> dados) {
        return realizarAutenticacao(dados, true);
    }

    @PostMapping("/cadastro")
    public ResponseEntity<?> cadastrarUsuario(@RequestBody Usuario novoUsuario) {
        try {
            // 1. Verifica se o e-mail já está cadastrado no banco
            if (repository.findByEmail(novoUsuario.getEmail()).isPresent()) {
                return ResponseEntity.badRequest().body(Map.of(
                        "success", false,
                        "message", "Este e-mail já está em uso."
                ));
            }

            // 2. Salva o usuário no banco de dados
            repository.save(novoUsuario);

            // 3. Retorna sucesso
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", "Cadastro realizado com sucesso!"
            ));

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of(
                    "success", false,
                    "message", "Erro interno ao cadastrar: " + e.getMessage()
            ));
        }
    }

    /**
     * Método de autenticação com tratamento de erros para evitar Status 500
     */
    private ResponseEntity<?> realizarAutenticacao(Map<String, String> dados, boolean exigirAdmin) {
        try {
            String email = dados.get("email");
            String senha = dados.get("senha");

            if (email == null || senha == null) {
                return ResponseEntity.badRequest().body(Map.of(
                        "success", false,
                        "message", "E-mail e senha são obrigatórios."
                ));
            }

            Optional<Usuario> usuarioOpt = repository.findByEmail(email);

            if (usuarioOpt.isPresent()) {
                Usuario usuario = usuarioOpt.get();

                // Verifica se a senha no banco não está nula e bate com a digitada
                if (usuario.getSenha() != null && usuario.getSenha().trim().equals(senha.trim())) {

                    // SEGURANÇA: Verifica se o tipo do usuário existe no banco
                    if (usuario.getTipoUsuario() == null) {
                        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of(
                                "success", false,
                                "message", "Erro: Tipo de usuário não definido no sistema."
                        ));
                    }

                    boolean isAdmin = usuario.getTipoUsuario() == TipoUsuario.Administrador;

                    // Bloqueio para o endpoint de Admin
                    if (exigirAdmin && !isAdmin) {
                        return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of(
                                "success", false,
                                "message", "Acesso negado: Apenas administradores."
                        ));
                    }

                    // Sucesso total
                    return ResponseEntity.ok(Map.of(
                            "success", true,
                            "message", "Login autorizado",
                            "nome", usuario.getNome() != null ? usuario.getNome() : "Usuário",
                            "idUsuario", usuario.getId(),
                            "tipoUsuario", usuario.getTipoUsuario().name()
                    ));
                }
            }

            // Falha na autenticação (E-mail não existe ou senha errada)
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of(
                    "success", false,
                    "message", "E-mail ou senha incorretos."
            ));

        } catch (Exception e) {
            // Em caso de qualquer erro inesperado, imprime no log do IntelliJ e avisa o front
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of(
                    "success", false,
                    "message", "Erro interno no servidor: " + e.getMessage()
            ));
        }
    }
}