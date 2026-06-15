import 'package:flutter/material.dart';
import 'package:suggestomobile/buscarEstabelecimento.dart';
import 'infoLocal.dart';
import 'models/local.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // 1. Atualizar a lista locais para usar assets temporários
  final List<Map<String, dynamic>> locais = [
    {
      'nome': 'Big Jack Hamburgueria',
      'bairro': 'Bairro Castelo, Campinas',
      'categoria': 'Restaurante',
      'nota': 4.5,
      'imagem': 'assets/images/bigjack.jpg',
      'lat': -22.88981704589304,
      'lng': -47.07628634133093,
      'endereco': 'R. Oliveira Cardoso, 376 - Jardim Chapadão, Campinas - SP, 13070-148',
      'horario': '11h - 23h',
      'telefone': '(19) 3212-3025',
    },
    {
      'nome': 'PanoBianco Academia',
      'bairro': 'Centro, Campinas',
      'categoria': 'Academia',
      'nota': 4.8,
      'imagem': 'assets/images/panobianco.png', // ASSET TEMPORÁRIO
      'lat': -22.905673074198525,
      'lng': -47.05910106144178,
      'endereco': 'Av Francisco Glicério 964 Sobre loja - Centro, Campinas - SP, 13012-100',
      'horario': '6h - 22h',
      'telefone': '(19) 99202-4114',
    },
    {
      'nome': 'Café do Centro',
      'bairro': 'Centro, Campinas',
      'categoria': 'Café',
      'nota': 4.2,
      'imagem': 'assets/images/cafeteria.jpg', 
      'lat': -22.902932790424725,
      'lng': -47.059543363884586,
      'endereco': 'Rua Barão de Jaguara, 1302 - Centro, Campinas - SP, 13015-002',
      'horario': '7h - 20h',
      'telefone': '(19) 3231-4079',
    },
    {
      'nome': 'COTIL',
      'bairro': 'Jardim Nova Italia, Limeira',
      'categoria': 'Escola',
      'nota': 4.7,
      'imagem': 'assets/images/cotil.jpg', 
      'lat': -22.562159,
      'lng': -47.4262152,
      'endereco': 'R. Paschoal Marmo, 1888 - Jardim Nova Italia, Limeira - SP, 13484-431',
      'horario': '7h - 22h',
      'telefone': '(19)2113-3303',
    },

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF12061E),
      // ── Agora a tela inteira é rolável ─────────────────────────────
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero, 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header agora rola junto com o restante ──────────────────
            _buildHeader(),

            /*const SizedBox(height: 16),

            // Botão "Solicitar algo"
            _buildSolicitarAlgo(),*/

            const SizedBox(height: 24),

            // Título + filtro
            _buildDescubraHeader(),

            const SizedBox(height: 12),

            // Lista de locais
            ...locais.map((local) => _buildLocalCard(local)),

            const SizedBox(height: 20),
          ],
        ),
      ),

      // ── Bottom Navigation Bar ─────────────────────────────────────
      bottomNavigationBar: barraNavegacao(),
    );
  }

  // ─────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft, 
          end: Alignment.centerRight,
          colors: [
            Color(0xFF88C3BE), 
            Color(0xFF839DCF), 
            Color(0xFFA6AADF), 
            Color(0xFFA9ADDA), 
            Color(0xFFB9BCE1), 
            Color(0xFFCED0EA), 
            Color(0xFFCED0EA), 
          ],
          stops: [0.0, 0.36, 0.51, 0.62, 0.73, 0.81, 0.89],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(24, 32, 140, 28), 
                  child: Text(
                    'Algo te desagradou?\nSugira uma melhoria!',
                    style: TextStyle(
                      color: Color(0xFF1A1A1A), 
                      fontSize: 22,
                      fontFamily: 'PoppinsBold',
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                ),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.35),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                      bottomLeft: Radius.circular(36),
                      bottomRight: Radius.circular(36),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fazer sugestão',
                        style: TextStyle(
                          color: const Color(0xFF1A1A1A).withOpacity(0.85),
                          fontSize: 15,
                          fontWeight: FontWeight.w800, 
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 56,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.65),
                                borderRadius: BorderRadius.circular(28),
                              ),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                size: 26,
                                color: Color(0xFF2D2D2D),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                        Expanded(
                            //Envolvemos o Container com um GestureDetector
                            child: GestureDetector( 
                              //Adicionamos a ação de toque (onTap)
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    // Substitua "BuscarEstabelecimentoPage" pelo nome exato da sua tela
                                    builder: (context) => BuscarEstabelecimento(locais: locais), 
                                  ),
                                );
                              },
                              //Seu Container original continua intacto aqui dentro
                              child: Container(
                                height: 56,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.65),
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                child: const Icon(
                                  Icons.search_rounded,
                                  size: 26,
                                  color: Color(0xFF2D2D2D),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Positioned(
              right: 0,
              bottom: 80, 
              child: SizedBox(
                width: 175,
                height: 175,
                child: Image.asset(
                  'assets/images/imagemInicio.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────
  /*Widget _buildSolicitarAlgo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFF2A1A4A),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFF4A2A7A),
            width: 1,
          ),
        ),
        child: const Row(
          children: [
            SizedBox(width: 16),
            Icon(
              Icons.notifications_outlined,
              color: Color(0xFFFFD700),
              size: 22,
            ),
            SizedBox(width: 10),
            Text(
              'Solicitar algo',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }*/

  // ─────────────────────────────────────────────────────────────────
  Widget _buildDescubraHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Descubra Novos Locais',
            style: TextStyle(
              color: Color.fromARGB(171, 255, 255, 255),
              fontSize: 18,
              fontFamily: 'PoppinsBold',
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF2A1A4A),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.tune,
              color: Colors.white,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────
  Widget _buildLocalCard(Map<String, dynamic> local) {
    return GestureDetector(
      onTap: () {
        print("CLICOU NO CARD");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => InfoLocalPage(local: local),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E0E32),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem
            Stack(
              children: [
                SizedBox(
                  height: 160,
                  width: double.infinity,
                  child: Image.asset( // 2. Mudar de Image.network para Image.asset
                    local['imagem'], 
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.5),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Infos
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nome e bairro
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          local['nome'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '| ${local['bairro']}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.55),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Coluna direita
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3A1A6A),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          local['categoria'],
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2D5A27),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star,
                                    color: Color(0xFF4CAF50), size: 12),
                                const SizedBox(width: 2),
                                Text(
                                  local['nota'].toString(),
                                  style: const TextStyle(
                                    color: Color(0xFF4CAF50),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.bookmark_border,
                            color: Colors.white54,
                            size: 18,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────
  int paginaAtual = 0;
  Widget barraNavegacao() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF12061E),
        border: Border(top: BorderSide(color: Color(0xFF1E0E32), width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() => paginaAtual = 0);
                  Navigator.pushNamed(context, '/home_cliente');
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.home_filled,
                      color: paginaAtual == 0 ? Colors.white : Colors.white54,
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Início",
                      style: TextStyle(
                        color: paginaAtual == 0 ? Colors.white : Colors.white54,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),

              GestureDetector(
                onTap: () {
                  setState(() => paginaAtual = 1);
                  Navigator.pushNamed(context, '/minhasSugestoes');
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.forum,
                      color: paginaAtual == 1 ? Colors.white : Colors.white54,
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Minhas\nSugestões",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: paginaAtual == 1 ? Colors.white : Colors.white54,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),

              GestureDetector(
                onTap: () {
                  setState(() => paginaAtual = 2);
                  Navigator.pushNamed(context, '/loja');
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.monetization_on,
                      color: paginaAtual == 2 ? Colors.white : Colors.white54,
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Pontos",
                      style: TextStyle(
                        color: paginaAtual == 2 ? Colors.white : Colors.white54,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),

              GestureDetector(
                onTap: () {
                  setState(() => paginaAtual = 3);
                  Navigator.pushNamed(context, '/perfil');
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person,
                      color: paginaAtual == 3 ? Colors.white : Colors.white54,
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Perfil",
                      style: TextStyle(
                        color: paginaAtual == 3 ? Colors.white : Colors.white54,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}