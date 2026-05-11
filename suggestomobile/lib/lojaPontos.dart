import 'package:flutter/material.dart';

class LojasPontosPage extends StatefulWidget {
  const LojasPontosPage({super.key});

  @override
  State<LojasPontosPage> createState() => _LojasPontosPageState();
}

class _LojasPontosPageState extends State<LojasPontosPage> {
  int _currentIndex = 2; // Pontos selecionado
  int _faixaSelecionada = 0;

  final int _meusPontos = 20652;

  final List<String> _faixas = [
    'Até 6.000 pts',
    'Até 18.000 pts',
    'Até 25.000 pts',
    'Até 45.000 pts',
  ];

  final List<Map<String, dynamic>> _recompensas = [
    // Até 6.000 pts
    {
      'faixa': 0,
      'titulo': 'Café 200ml',
      'parceiro': 'Starbucks',
      'imagem': 'https://images.unsplash.com/photo-1541167760496-1628856ab772?w=400&q=80',
      'cor': const Color(0xFF00704A),
      'tag': 'CAFÉ',
    },
    {
      'faixa': 0,
      'titulo': '10% OFF',
      'parceiro': 'Coco Bambu',
      'imagem': 'https://images.unsplash.com/photo-1559847844-5315695dadae?w=400&q=80',
      'cor': const Color(0xFF8B1A1A),
      'tag': '10% OFF',
    },
    {
      'faixa': 0,
      'titulo': 'McColoso',
      'parceiro': 'McDonald\'s',
      'imagem': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&q=80',
      'cor': const Color(0xFFDA291C),
      'tag': 'LANCHE',
    },
    // Até 25.000 pts
    {
      'faixa': 2,
      'titulo': 'McFritas',
      'parceiro': 'McDonald\'s',
      'imagem': 'https://images.unsplash.com/photo-1630384060421-cb20d0e0649d?w=400&q=80',
      'cor': const Color(0xFFDA291C),
      'tag': 'LANCHE',
    },
    {
      'faixa': 2,
      'titulo': 'R\$20 OFF',
      'parceiro': 'Zara',
      'imagem': 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400&q=80',
      'cor': const Color(0xFF222222),
      'tag': 'MODA',
    },
    {
      'faixa': 2,
      'titulo': '10% OFF',
      'parceiro': 'Carrefour',
      'imagem': 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400&q=80',
      'cor': const Color(0xFF004A97),
      'tag': '10% OFF',
    },
    // Até 45.000 pts
    {
      'faixa': 3,
      'titulo': '50% OFF',
      'parceiro': 'PokeMania',
      'imagem': 'https://images.unsplash.com/photo-1569050467447-ce54b3bbc37d?w=400&q=80',
      'cor': const Color(0xFF1A3A2A),
      'tag': '50% OFF',
    },
    {
      'faixa': 3,
      'titulo': '60% OFF',
      'parceiro': 'Youcom',
      'imagem': 'https://images.unsplash.com/photo-1441984904996-e0b6ba687e04?w=400&q=80',
      'cor': const Color(0xFF111111),
      'tag': '60% OFF',
    },
    {
      'faixa': 3,
      'titulo': 'Cupom',
      'parceiro': 'BurgerKing',
      'imagem': 'https://images.unsplash.com/photo-1586816001966-79b736744398?w=400&q=80',
      'cor': const Color(0xFF502314),
      'tag': 'CUPOM',
    },
  ];

  // Grupos de faixas exibidas
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
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildPontosDestaque(),
                  const SizedBox(height: 16),
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
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ─────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF1A0A2E),
        border: Border(
          bottom: BorderSide(color: Color(0xFF2A1A4A), width: 1),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Localização
              Text(
                'Sua localização',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 12,
                  fontFamily: 'Syne',
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Color(0xFF9B59D0),
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'RUA ASSIS, VILA LEMOS, Nº 40 – CAMPINAS',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Syne',
                        letterSpacing: 0.2,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Escolher outra localização',
                  style: TextStyle(
                    color: const Color(0xFF9B59D0).withOpacity(0.85),
                    fontSize: 11,
                    decoration: TextDecoration.underline,
                    decorationColor: const Color(0xFF9B59D0),
                    fontFamily: 'Syne',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────
  Widget _buildPontosDestaque() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${_formatarPontos(_meusPontos)} pts.',
            style: const TextStyle(
              color: Color(0xFF9B59D0),
              fontSize: 34,
              fontWeight: FontWeight.bold,
              fontFamily: 'Syne',
              height: 1,
            ),
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              'seus pontos',
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 13,
                fontFamily: 'Syne',
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatarPontos(int pts) {
    // ex: 20652 → 20.652
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

  // ─────────────────────────────────────────────────────────────────
  Widget _buildFaixasTabs() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _faixas.length,
        separatorBuilder: (_, __) => const SizedBox(width: 0),
        itemBuilder: (context, index) {
          final isSelected = _faixaSelecionada == index;
          return GestureDetector(
            onTap: () => setState(() => _faixaSelecionada = index),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    _faixas[index],
                    style: TextStyle(
                      color: isSelected
                          ? const Color(0xFF9B59D0)
                          : Colors.white.withOpacity(0.38),
                      fontSize: 12,
                      fontFamily: 'Syne',
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 2,
                  width: 60,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF9B59D0)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────
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
              fontFamily: 'Syne',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 148,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: lista.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) =>
                _buildRecompensaCard(lista[index]),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildRecompensaCard(Map<String, dynamic> recompensa) {
    return GestureDetector(
      onTap: () => _mostrarDetalhes(recompensa),
      child: Container(
        width: 112,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: const Color(0xFF1E0E32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Imagem
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      recompensa['imagem'],
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: recompensa['cor'] as Color,
                        child: const Center(
                          child: Icon(Icons.card_giftcard,
                              color: Colors.white38, size: 28),
                        ),
                      ),
                    ),
                  ),
                  // Overlay gradiente
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.4),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Tag topo esquerdo
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: (recompensa['cor'] as Color).withOpacity(0.85),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        recompensa['tag'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      recompensa['titulo'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Syne',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      recompensa['parceiro'],
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 10,
                        fontFamily: 'Syne',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────
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
            // Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            // Imagem
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: 160,
                width: double.infinity,
                child: Image.network(
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
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Syne',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        recompensa['parceiro'],
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 14,
                          fontFamily: 'Syne',
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Syne',
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
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Syne',
                  ),
                ),
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
      {
        'icon': Icons.home_outlined,
        'activeIcon': Icons.home,
        'label': 'Início'
      },
      {
        'icon': Icons.chat_bubble_outline,
        'activeIcon': Icons.chat_bubble,
        'label': 'Minhas\nSugestões'
      },
      {
        'icon': Icons.stars_outlined,
        'activeIcon': Icons.stars,
        'label': 'Pontos'
      },
      {
        'icon': Icons.person_outline,
        'activeIcon': Icons.person,
        'label': 'Perfil'
      },
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
                onTap:() {
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
                          fontFamily: 'Syne',
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