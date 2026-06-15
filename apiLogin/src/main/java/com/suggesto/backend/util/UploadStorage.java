package com.suggesto.backend.util;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

public class UploadStorage {

    // Define que os arquivos serão salvos em uma pasta chamada "uploads" na raiz do projeto
    private static final String DIRECTORY_NAME = "uploads";

    // Retorna o caminho da pasta de uploads
    public static Path diretorioUploads() {
        return Paths.get(DIRECTORY_NAME);
    }

    // Cria a pasta automaticamente caso ela ainda não exista no computador
    public static void garantirDiretorio() throws IOException {
        Path path = diretorioUploads();
        if (!Files.exists(path)) {
            Files.createDirectories(path);
        }
    }
}