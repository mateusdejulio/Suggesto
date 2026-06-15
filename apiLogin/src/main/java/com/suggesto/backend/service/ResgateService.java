package com.suggesto.backend.service;

import com.suggesto.backend.model.Recompensa;
import com.suggesto.backend.model.Resgate;
import com.suggesto.backend.model.Usuario;
import com.suggesto.backend.repository.RecompensaRepository;
import com.suggesto.backend.repository.ResgateRepository;
import com.suggesto.backend.repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.UUID;

@Service
public class ResgateService {

    @Autowired
    private ResgateRepository resgateRepository;

    @Autowired
    private RecompensaRepository recompensaRepository;

    @Autowired
    private UsuarioRepository usuarioRepository; // Necessário para buscar o usuário completo

    public Resgate resgatar(Long usuarioId, Long recompensaId) {
        // 1. Busca o usuário no banco (se não achar, estoura erro)
        Usuario usuario = usuarioRepository.findById(usuarioId)
                .orElseThrow(() -> new IllegalArgumentException("Usuário não encontrado com o ID: " + usuarioId));

        // 2. Busca a recompensa no banco (se não achar, estoura erro)
        Recompensa recompensa = recompensaRepository.findById(recompensaId)
                .orElseThrow(() -> new IllegalArgumentException("Recompensa não encontrada com o ID: " + recompensaId));

        // 3. Monta o objeto de Resgate preenchendo todos os campos obrigatórios
        Resgate resgate = new Resgate();
        resgate.setUsuario(usuario);
        resgate.setRecompensa(recompensa);
        resgate.setDataResgate(LocalDateTime.now()); // Salva o exato momento do resgate

        // 4. Gera um código de cupom aleatório e limpo (ex: "RESG8A2F4B9")
        // Usamos UUID e pegamos os 8 primeiros caracteres para caber com folga no limite de 32 da tabela
        String cupomAleatorio = "RESG-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        resgate.setCodigoCupom(cupomAleatorio);

        // 5. Salva no banco de dados e retorna o resgate concluído
        return resgateRepository.save(resgate);
    }
}