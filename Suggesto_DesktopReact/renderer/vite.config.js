// Configuração do Vite: define raiz, porta do servidor e plugin React
import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

export default defineConfig({
  root: "./renderer",
  plugins: [react()],
  server: {
    port: 5173
  }
});