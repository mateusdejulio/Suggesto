import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'usuarios.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController confirmarSenhaController = TextEditingController();


  String tipoUsuario = 'cliente';
  bool termosAceitos = false;
  bool notificacoes = false;
  bool senhaVisivel = false;
  bool confirmarSenhaVisivel = false;
  String mensagemErro = "";

  void criar() {
    String email = emailController.text.trim();
    String senha = senhaController.text.trim();
    String confirmar = confirmarSenhaController.text.trim();

    if (email.isEmpty || senha.isEmpty || confirmar.isEmpty) {
      setState(() => mensagemErro = "Preencha todos os campos.");
      return;
    }

    if (senha.length < 8) {
      setState(() => mensagemErro = "A senha deve ter no mínimo 8 caracteres.");
      return;
    }

    if (senha != confirmar) {
      setState(() => mensagemErro = "As senhas não coincidem.");
      return;
    }

    if (!termosAceitos) {
      setState(() => mensagemErro = "Você deve aceitar os termos de uso.");
      return;
    }

    // Verifica se email já existe
    for (var u in usuariosCadastrados) {
      if (u['email'] == email) {
        setState(() => mensagemErro = "Este email já está cadastrado.");
        return;
      }
    }

    // Salva no vetor global
    usuariosCadastrados.add({
      'email': email,
      'senha': senha,
      'tipo': tipoUsuario,
      'notificacoes': notificacoes,
      'termosAceitos': termosAceitos,
    });
    
   print("===========================================");
    print("Email: $email");
    print("Senha: $senha");
    print("Tipo de usuário: $tipoUsuario");
    print("Notificações: $notificacoes");
    print("Termos: $termosAceitos");
    print("===========================================");


    setState(() => mensagemErro = "");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Conta criada com sucesso!", style: TextStyle(fontFamily: "Poppins"),),
        backgroundColor: Color(0xFF2D5A27),
      ),
    );

    Navigator.pushNamed(context, '/home_cliente');
  }

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

                // LOGO
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
                      child: Center(
                        child: Text("?", style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Poppins"
                        )),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text("Suggesto", style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontFamily: "PoppinsBold",
                      fontWeight: FontWeight.w600,
                    )),
                  ],
                ),

                SizedBox(height: 50),

                // TITULO
                Text("Criar conta", style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontFamily: "PoppinsBold",
                  fontWeight: FontWeight.bold,
                )),

                SizedBox(height: 30),

                // LABEL EMAIL
                SizedBox(
                  width: 300,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Email:", style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: "Poppins")),
                  ),
                ),
                SizedBox(height: 8),

                // CAMPO EMAIL
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: Color.fromARGB(220, 255, 255, 255)),
                    decoration: InputDecoration(
                      hintText: "Digite um email válido",
                      hintStyle: TextStyle(color: Color.fromARGB(120, 255, 255, 255), fontSize: 13, fontFamily: "Poppins"),
                      fillColor: Color.fromARGB(123, 88, 8, 129),
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xFF7B2FBE), width: 1.5),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // LABEL SENHA
                SizedBox(
                  width: 300,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Senha:", style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: "Poppins")),
                  ),
                ),
                SizedBox(height: 8),

                // CAMPO SENHA
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: senhaController,
                    obscureText: !senhaVisivel,
                    style: TextStyle(color: Color.fromARGB(220, 255, 255, 255)),
                    decoration: InputDecoration(
                      hintText: "Mínimo 8 caracteres",
                      hintStyle: TextStyle(color: Color.fromARGB(120, 255, 255, 255), fontSize: 13, fontFamily: "Poppins"),
                      fillColor: Color.fromARGB(123, 88, 8, 129),
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xFF7B2FBE), width: 1.5),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          senhaVisivel ? Icons.visibility : Icons.visibility_off,
                          color: Color.fromARGB(160, 255, 255, 255),
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            senhaVisivel = !senhaVisivel;
                          });
                        },
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 12),

                // CAMPO CONFIRMAR SENHA
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: confirmarSenhaController,
                    obscureText: !confirmarSenhaVisivel,
                    style: TextStyle(color: Color.fromARGB(220, 255, 255, 255)),
                    decoration: InputDecoration(
                      hintText: "Repita a senha",
                      hintStyle: TextStyle(color: Color.fromARGB(120, 255, 255, 255), fontSize: 13, fontFamily: "Poppins"),
                      fillColor: Color.fromARGB(123, 88, 8, 129),
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xFF7B2FBE), width: 1.5),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          confirmarSenhaVisivel ? Icons.visibility : Icons.visibility_off,
                          color: Color.fromARGB(160, 255, 255, 255),
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            confirmarSenhaVisivel = !confirmarSenhaVisivel;
                          });
                        },
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // TIPO DE USUARIO (RADIO)
                SizedBox(
                  width: 300,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Quero me cadastrar como:", style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Poppins"
                    )),
                  ),
                ),
                SizedBox(height: 8),

                Container(
                  width: 300,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(123, 88, 8, 129),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Radio Cliente
                            Row(
                              children: [
                                Radio<String>(
                                  value: 'cliente',
                                  groupValue: tipoUsuario,
                                  activeColor: Color(0xFF9B59D0),
                                  onChanged: (value) {
                                    setState(() {
                                      tipoUsuario = value!;
                                    });
                                  },
                                ),
                                Text("Cliente", style: TextStyle(color: Colors.white, fontFamily: "Poppins")),
                              ],
                            ),
                            // Radio Administrador
                            Row(
                              children: [
                                Radio<String>(
                                  value: 'administrador',
                                  groupValue: tipoUsuario,
                                  activeColor: Color(0xFF9B59D0),
                                  onChanged: (value) {
                                    setState(() {
                                      tipoUsuario = value!;
                                    });
                                  },
                                ),
                                Text("Administrador", style: TextStyle(color: Colors.white, fontFamily: "Poppins")),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Botão de info
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: Color(0xFF1E0A33),
                              title: Text("Tipos de conta", style: TextStyle(color: Colors.white, fontFamily: "PoppinsBold")),
                              content: Text(
                                "Cliente: acessa os serviços da plataforma.\n\nAdministrador: gerencia a plataforma e seus usuários.",
                                style: TextStyle(color: Colors.white70, fontFamily: "Poppins"),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("OK", style: TextStyle(color: Color(0xFF9B59D0), fontFamily: "Poppins")),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: Icon(Icons.info_outline, color: Colors.white54, size: 22),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16),

                // SWITCH NOTIFICAÇÕES
                SizedBox(
                  width: 300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Receber notificações", style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: "Poppins")),
                      Switch(
                        value: notificacoes,
                        activeColor: Color(0xFF9B59D0),
                        onChanged: (value) {
                          setState(() {
                            notificacoes = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 8),

                // CHECKBOX TERMOS
                SizedBox(
                  width: 300,
                  child: Row(
                    children: [
                      Checkbox(
                        value: termosAceitos,
                        activeColor: Color(0xFF9B59D0),
                        onChanged: (value) {
                          setState(() {
                            termosAceitos = value!;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          "Aceito os termos de uso",
                          style: TextStyle(color: Colors.white70, fontSize: 13, fontFamily: "Poppins"),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 10),

                // MENSAGEM DE ERRO
                if (mensagemErro.isNotEmpty)
                  Text(mensagemErro, style: TextStyle(color: Colors.redAccent, fontSize: 13)),

                SizedBox(height: 20),

                // BOTAO CRIAR
                ElevatedButton(
                  onPressed: criar,
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(120, 42),
                    backgroundColor: Color(0xFF6B21A8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text("Criar", style: TextStyle(
                    color: Color.fromARGB(220, 239, 224, 238),
                    fontFamily: "PoppinsBold",
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  )),
                ),

                SizedBox(height: 20),

                // VOLTAR PARA LOGIN
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Text(
                    "Já tem uma conta? Entrar",
                    style: TextStyle(
                      color: Color(0xFF9B59D0),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xFF9B59D0),
                      fontFamily: "Poppins"
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