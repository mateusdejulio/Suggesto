package com.suggesto.backend.config;



import com.suggesto.backend.util.UploadStorage;

import org.springframework.context.annotation.Configuration;

import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;

import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;



import java.io.IOException;

import java.nio.file.Path;



@Configuration

public class WebConfig implements WebMvcConfigurer {



    @Override

    public void addResourceHandlers(ResourceHandlerRegistry registry) {

        try {

            UploadStorage.garantirDiretorio();

        } catch (IOException e) {

            throw new IllegalStateException("Não foi possível criar a pasta de uploads da API.", e);

        }



        Path uploadDir = UploadStorage.diretorioUploads().toAbsolutePath().normalize();

        String location = uploadDir.toUri().toString();

        if (!location.endsWith("/")) {

            location += "/";

        }



        registry.addResourceHandler("/uploads/**")

                .addResourceLocations(location);

    }

}

