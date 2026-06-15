package com.suggesto.backend.util;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import org.springframework.util.StringUtils;

public class UploadStorage {

    private static final String DIRECTORY_NAME = "uploads";

    public static Path diretorioUploads() {
        return Paths.get(DIRECTORY_NAME);
    }

    public static void garantirDiretorio() throws IOException {
        Path path = diretorioUploads();
        if (!Files.exists(path)) {
            Files.createDirectories(path);
        }
    }

    public static Path resolverArquivo(String nomeArquivo) {
        return diretorioUploads().resolve(nomeArquivo);
    }

    public static String normalizarNomeArquivo(String nomeArquivo) {
        String limpo = StringUtils.cleanPath(nomeArquivo);
        if (limpo.contains("..")) {
            throw new IllegalArgumentException("Nome de arquivo inválido: " + nomeArquivo);
        }
        return limpo.replaceAll("\\s+", "_");
    }
}