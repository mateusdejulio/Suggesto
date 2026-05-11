import 'package:flutter/material.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController confirmarSenhaController = TextEditingController();

  String _tipoUsuario = 'cliente'; // 'cliente' ou 'administrador'
  bool _senhaVisivel = false;
  bool _confirmarSenhaVisivel = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(18, 6, 30, 1),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFF7B2FBE),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          "?",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Suggesto",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontFamily: "Syne",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 50),

                // Título
                const Text(
                  "Criar conta",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontFamily: "Syne",
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                // Label Email
                SizedBox(
                  width: 300,
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Email:",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Campo Email
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Color.fromARGB(220, 255, 255, 255)),
                    decoration: InputDecoration(
                      hintText: "Digite um email válido",
                      hintStyle: const TextStyle(
                        color: Color.fromARGB(120, 255, 255, 255),
                        fontSize: 13,
                      ),
                      fillColor: const Color.fromARGB(123, 88, 8, 129),
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xFF7B2FBE),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Label Senha
                SizedBox(
                  width: 300,
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Senha:",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Campo Senha
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: senhaController,
                    obscureText: !_senhaVisivel,
                    style: const TextStyle(color: Color.fromARGB(220, 255, 255, 255)),
                    decoration: InputDecoration(
                      hintText: "Crie uma senha de no mínimo 8 dígitos",
                      hintStyle: const TextStyle(
                        color: Color.fromARGB(120, 255, 255, 255),
                        fontSize: 13,
                      ),
                      fillColor: const Color.fromARGB(123, 88, 8, 129),
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xFF7B2FBE),
                          width: 1.5,
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _senhaVisivel ? Icons.visibility : Icons.visibility_off,
                          color: const Color.fromARGB(160, 255, 255, 255),
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _senhaVisivel = !_senhaVisivel;
                          });
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Campo Confirmar Senha
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: confirmarSenhaController,
                    obscureText: !_confirmarSenhaVisivel,
                    style: const TextStyle(color: Color.fromARGB(220, 255, 255, 255)),
                    decoration: InputDecoration(
                      hintText: "Repita a senha",
                      hintStyle: const TextStyle(
                        color: Color.fromARGB(120, 255, 255, 255),
                        fontSize: 13,
                      ),
                      fillColor: const Color.fromARGB(123, 88, 8, 129),
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xFF7B2FBE),
                          width: 1.5,
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _confirmarSenhaVisivel ? Icons.visibility : Icons.visibility_off,
                          color: const Color.fromARGB(160, 255, 255, 255),
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _confirmarSenhaVisivel = !_confirmarSenhaVisivel;
                          });
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Label tipo de usuário
                SizedBox(
                  width: 300,
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Quero me cadastrar como:",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Radio buttons - Cliente / Administrador
                Container(
                  width: 300,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(123, 88, 8, 129),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      // Coluna com os radio buttons
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Cliente
                            Row(
                              children: [
                                Radio<String>(
                                  value: 'cliente',
                                  groupValue: _tipoUsuario,
                                  activeColor: const Color(0xFF9B59D0),
                                  fillColor: WidgetStateProperty.resolveWith((states) {
                                    if (states.contains(WidgetState.selected)) {
                                      return const Color(0xFF9B59D0);
                                    }
                                    return Colors.white.withOpacity(0.5);
                                  }),
                                  onChanged: (value) {
                                    setState(() {
                                      _tipoUsuario = value!;
                                    });
                                  },
                                ),
                                const Text(
                                  "Cliente",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),

                            // Administrador
                            Row(
                              children: [
                                Radio<String>(
                                  value: 'administrador',
                                  groupValue: _tipoUsuario,
                                  activeColor: const Color(0xFF9B59D0),
                                  fillColor: WidgetStateProperty.resolveWith((states) {
                                    if (states.contains(WidgetState.selected)) {
                                      return const Color(0xFF9B59D0);
                                    }
                                    return Colors.white.withOpacity(0.5);
                                  }),
                                  onChanged: (value) {
                                    setState(() {
                                      _tipoUsuario = value!;
                                    });
                                  },
                                ),
                                const Text(
                                  "Administrador",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Ícone de info
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: const Color(0xFF1E0A33),
                              title: const Text(
                                "Tipos de conta",
                                style: TextStyle(color: Colors.white, fontFamily: "Syne"),
                              ),
                              content: const Text(
                                "Cliente: acessa os serviços da plataforma.\n\nAdministrador: gerencia a plataforma e seus usuários.",
                                style: TextStyle(color: Colors.white70),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(
                                    "OK",
                                    style: TextStyle(color: Color(0xFF9B59D0)),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.info_outline,
                          color: Colors.white54,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Botão Criar
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/home_cliente');// lógica de cadastro aqui
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(120, 42),
                    backgroundColor: const Color(0xFF6B21A8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Criar",
                    style: TextStyle(
                      color: Color.fromARGB(220, 239, 224, 238),
                      fontFamily: "Syne",
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Voltar para login
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    "Já tem uma conta? Entrar",
                    style: TextStyle(
                      color: Color(0xFF9B59D0),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xFF9B59D0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}