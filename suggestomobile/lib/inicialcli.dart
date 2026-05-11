import 'package:flutter/material.dart';
import 'infoLocal.dart';
import 'models/local.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> locais = [
    {
      'nome': 'Big Jack Hamburgueria',
      'bairro': 'Bairro Castelo, Campinas',
      'categoria': 'Restaurante',
      'nota': 4.5,
      'imagem': 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=800&q=80',

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
      'imagem': 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800&q=80',

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
      'imagem': 'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=800&q=80',

      'lat': -22.902932790424725,
      'lng': -47.059543363884586,
      'endereco': 'Rua Barão de Jaguara, 1302 - Centro, Campinas - SP, 13015-002',
      'horario': '7h - 20h',
      'telefone': '(19) 3231-4079',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF12061E),
      body: Column(
        children: [
          // ── Header com gradiente ──────────────────────────────────
          _buildHeader(),

          // ── Conteúdo rolável ──────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // Botão "Solicitar algo"
                  _buildSolicitarAlgo(),

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
          ),
        ],
      ),

      // ── Bottom Navigation Bar ─────────────────────────────────────
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ─────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFB8C8E8),
            Color(0xFFD4A8D8),
            Color(0xFFE8D0F0),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título + ilustração
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Texto
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        'Algo te desagradou?\nSugira uma melhoria!',
                        style: TextStyle(
                          color: Color(0xFF1A0A2E),
                          fontSize: 22,
                          fontFamily: 'Syne',
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ),

                  // Ilustração placeholder
                  Container(
                    width: 110,
                    height: 100,
                    child: Stack(
                      children: [
                        // Estrelas
                        Positioned(
                          top: 0,
                          right: 10,
                          child: Row(
                            children: List.generate(
                              5,
                              (i) => Icon(
                                Icons.star,
                                size: 12,
                                color: i < 4
                                    ? const Color(0xFFFFB800)
                                    : Colors.white.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),
                        // Pessoas ilustração (emoji placeholder)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 100,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text('👥', style: TextStyle(fontSize: 36)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Barra de busca
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 14),
                    Text(
                      'Fazer sugestão',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.4),
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),

                    // Ícone câmera
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        size: 20,
                        color: Color(0xFF555555),
                      ),
                    ),

                    // Ícone busca
                    Container(
                      margin: const EdgeInsets.only(top: 8, bottom: 8, right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.search,
                        size: 20,
                        color: Color(0xFF555555),
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

  // ─────────────────────────────────────────────────────────────────
  Widget _buildSolicitarAlgo() {
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
        child: Row(
          children: [
            const SizedBox(width: 16),
            const Icon(
              Icons.notifications_outlined,
              color: Color(0xFFFFD700),
              size: 22,
            ),
            const SizedBox(width: 10),
            const Text(
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
  }

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
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'Syne',
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
                child: Image.network(
                  local['imagem'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: const Color(0xFF2A1A4A),
                    child: const Center(
                      child: Icon(Icons.image_not_supported,
                          color: Colors.white38, size: 40),
                    ),
                  ),
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
  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.home_outlined, 'activeIcon': Icons.home, 'label': 'Início'},
      {'icon': Icons.chat_bubble_outline, 'activeIcon': Icons.chat_bubble, 'label': 'Minhas\nSugestões'},
      {'icon': Icons.stars_outlined, 'activeIcon': Icons.stars, 'label': 'Pontos'},
      {'icon': Icons.person_outline, 'activeIcon': Icons.person, 'label': 'Perfil'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A0A2E),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final isSelected = _currentIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() => _currentIndex = index);

                  if (index == 0) Navigator.pushNamed(context, '/home_cliente');
                  if (index == 2) Navigator.pushNamed(context, '/loja');
                  if (index == 3) Navigator.pushNamed(context, '/perfil');
                },
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  width: 70,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isSelected
                            ? items[index]['activeIcon'] as IconData
                            : items[index]['icon'] as IconData,
                        color: isSelected
                            ? const Color(0xFF9B59D0)
                            : Colors.white38,
                        size: 24,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        items[index]['label'] as String,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected
                              ? const Color(0xFF9B59D0)
                              : Colors.white38,
                          fontSize: 10,
                          height: 1.2,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}