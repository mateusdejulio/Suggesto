import 'package:flutter/material.dart';

class LojasPontosPage extends StatefulWidget {
  const LojasPontosPage({super.key});

  @override
  State<LojasPontosPage> createState() => _LojasPontosPageState();
}

class _LojasPontosPageState extends State<LojasPontosPage> {
  int _currentIndex = 2;
  int _faixaSelecionada = 0;

  final int _meusPontos = 20652;

  final List<String> _faixas = [
    'Até 6.000 pts',
    'Até 18.000 pts',
    'Até 25.000 pts',
    'Até 45.000 pts',
  ];

  final List<Map<String, dynamic>> _recompensas = [
    {
      'faixa': 0,
      'titulo': 'Café 200ml',
      'parceiro': 'Starbucks',
      'imagem': 'assets/images/starbucks.png',
      'cor': const Color(0xFF00704A),
      'pontosTag': '4.000 pts',
    },
    {
      'faixa': 0,
      'titulo': '10% OFF',
      'parceiro': 'Coco Bambu',
      'imagem': 'assets/images/cocobambu.png',
      'cor': const Color(0xFF8B1A1A),
      'pontosTag': '5.000 pts',
    },
    {
      'faixa': 0,
      'titulo': 'McColosso',
      'parceiro': 'McDonald\'s',
      'imagem': 'assets/images/mcColosso.png',
      'cor': const Color(0xFFDA291C),
      'pontosTag': '4.000 pts',
    },
    {
      'faixa': 2,
      'titulo': 'McFritas',
      'parceiro': 'McDonald\'s',
      'imagem': 'assets/images/mcFritas.png',
      'cor': const Color(0xFFDA291C),
      'pontosTag': '20.000 pts',
    },
    {
      'faixa': 2,
      'titulo': 'R\$20 OFF',
      'parceiro': 'Zara',
      'imagem': 'assets/images/zara.jpg',
      'cor': const Color(0xFF222222),
      'pontosTag': '25.000 pts',
    },
    {
      'faixa': 2,
      'titulo': '10% OFF',
      'parceiro': 'Carrefour',
      'imagem': 'assets/images/carrefour.png',
      'cor': const Color(0xFF004A97),
      'pontosTag': '25.000 pts',
    },
    {
      'faixa': 3,
      'titulo': '50% OFF',
      'parceiro': 'PokeMania',
      'imagem': 'assets/images/manapoke.jpg',
      'cor': const Color(0xFF1A3A2A),
      'pontosTag': '30.000 pts',
    },
    {
      'faixa': 3,
      'titulo': '60% OFF',
      'parceiro': 'Youcom',
      'imagem': 'assets/images/youcom.png',
      'cor': const Color(0xFF111111),
      'pontosTag': '45.000 pts',
    },
    {
      'faixa': 3,
      'titulo': 'Cupom',
      'parceiro': 'BurgerKing',
      'imagem': 'assets/images/bk.jpg',
      'cor': const Color(0xFF502314),
      'pontosTag': '45.000 pts',
    },
  ];

  final List<Map<String, dynamic>> _grupos = [
    {'label': 'Até 6.000 pts', 'faixaIndex': 0},
    {'label': 'Até 25.000 pts', 'faixaIndex': 2},
    {'label': 'Até 45.000 pts', 'faixaIndex': 3},
  ];

  List<Map<String, dynamic>> _recompensasDaFaixa(int faixaIndex) {
    return _recompensas.where((r) => r['faixa'] == faixaIndex).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF12061E),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  _buildPontosDestaque(),
                  const SizedBox(height: 24),
                  _buildFaixasTabs(),
                  const SizedBox(height: 24),
                  ..._grupos.map((grupo) => _buildGrupoRecompensas(
                        grupo['label'] as String,
                        grupo['faixaIndex'] as int,
                      )),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: barraNavegacao(),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: const Color(0xFF12061E),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sua localização',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontFamily: 'PoppinsBold',
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E0E32),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: Colors.white54,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'RUA ASSIS, VILA LEMOS, Nº 40 – CAMPINAS',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontFamily: 'PoppinsSemi',
                              letterSpacing: 0.3,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'Escolher outra localização',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 11,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white54,
                          fontFamily: 'Poppins',
                        ),
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

  Widget _buildPontosDestaque() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [Color(0xFF88C3BE), Color(0xFFCED0EA)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ).createShader(bounds),
        child: Text(
          '${_formatarPontos(_meusPontos)} pts.',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontFamily: 'PoppinsBold',
            height: 1,
          ),
        ),
      ),
    );
  }

  String _formatarPontos(int pts) {
    final s = pts.toString();
    if (s.length <= 3) return s;
    final List<String> partes = [];
    int i = s.length;
    while (i > 0) {
      partes.insert(0, s.substring(i - 3 < 0 ? 0 : i - 3, i));
      i -= 3;
    }
    return partes.join('.');
  }

  Widget _buildFaixasTabs() {
    return SizedBox(
      height: 30,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _faixas.length,
        separatorBuilder: (_, __) => const SizedBox(width: 24),
        itemBuilder: (context, index) {
          final isSelected = _faixaSelecionada == index;
          return GestureDetector(
            onTap: () => setState(() => _faixaSelecionada = index),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected ? const Color(0xFF4A2A7A) : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  _faixas[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white.withOpacity(0.4),
                    fontSize: 13,
                    fontFamily: isSelected ? 'PoppinsSemi' : 'Poppins',
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGrupoRecompensas(String label, int faixaIndex) {
    final lista = _recompensasDaFaixa(faixaIndex);
    if (lista.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'PoppinsBold',
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 145,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: lista.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) => _buildRecompensaCard(lista[index]),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildRecompensaCard(Map<String, dynamic> recompensa) {
    return GestureDetector(
      onTap: () => _mostrarDetalhes(recompensa),
      child: SizedBox(
        width: 110,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 110,
              width: 110,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(recompensa['imagem']),
                  fit: BoxFit.cover,
                ),
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: const EdgeInsets.only(top: 6, left: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.65),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.generating_tokens,
                        color: Colors.white,
                        size: 9,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        recompensa['pontosTag'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontFamily: 'PoppinsSemi',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${recompensa['titulo']} - ${recompensa['parceiro']}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontFamily: 'Poppins',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarDetalhes(Map<String, dynamic> recompensa) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1E0E32),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: 160,
                width: double.infinity,
                child: Image.asset(
                  recompensa['imagem'],
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: recompensa['cor'] as Color,
                    child: const Center(
                      child: Icon(Icons.card_giftcard,
                          color: Colors.white38, size: 48),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recompensa['titulo'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'PoppinsBold',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        recompensa['parceiro'],
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9B59D0).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: const Color(0xFF9B59D0).withOpacity(0.4)),
                  ),
                  child: const Text(
                    'Disponível',
                    style: TextStyle(
                      color: Color(0xFF9B59D0),
                      fontSize: 12,
                      fontFamily: 'PoppinsBold',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9B59D0),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Resgatar recompensa',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'PoppinsBold',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

   int paginaAtual = 2;
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