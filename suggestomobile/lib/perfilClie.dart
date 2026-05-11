import 'package:flutter/material.dart';

class PerfilCliPage extends StatefulWidget {
  const PerfilCliPage({super.key});

  @override
  State<PerfilCliPage> createState() => _PerfilCliPageState();
}

class _PerfilCliPageState extends State<PerfilCliPage> {
  int _currentIndex = 3; // Perfil selecionado

  // Dados do usuário (mock)
  final String _nome = 'Manuela';
  final String _email = 'manuela@gmail.com';
  final String _nivel = 'Ouro';
  final String _fotoUrl =
      'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=200&q=80';

  final List<Map<String, dynamic>> _menuItems = [
    {
      'icon': Icons.bookmark_outlined,
      'label': 'Locais Salvos',
      'route': '/locais_salvos',
    },
    {
      'icon': Icons.chat_bubble_outline,
      'label': 'Minhas Sugestões',
    },
    {
      'icon': Icons.bar_chart,
      'label': 'Contribuição',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF12061E),
      body: Column(
        children: [
          // Ícones topo direito (notificação + config)
          _buildTopBar(),

          // Conteúdo rolável
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  _buildPerfilHeader(),
                  const SizedBox(height: 32),
                  _buildMenuList(),
                  const SizedBox(height: 32),
                  _buildSairButton(),
                  const SizedBox(height: 32),
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
  Widget _buildTopBar() {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildIconButton(Icons.notifications_outlined, onTap: () {}),
            const SizedBox(width: 10),
            _buildIconButton(Icons.settings_outlined, onTap: () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF1E0E32),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF2A1A4A), width: 1),
        ),
        child: Icon(icon, color: Colors.white70, size: 20),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────
  Widget _buildPerfilHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF9B59D0),
                width: 2.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF9B59D0).withOpacity(0.3),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipOval(
              child: Image.network(
                _fotoUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFF2A1A4A),
                  child: const Icon(Icons.person,
                      color: Colors.white38, size: 40),
                ),
              ),
            ),
          ),

          const SizedBox(width: 18),

          // Nome, email e nível
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _nome,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Syne',
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _email,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.45),
                  fontSize: 13,
                  fontFamily: 'Syne',
                ),
              ),
              const SizedBox(height: 8),
              // Badge nível
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF3A1A6A),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: const Color(0xFF9B59D0).withOpacity(0.4),
                      width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _nivel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Syne',
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text('🏅', style: TextStyle(fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────
  Widget _buildMenuList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E0E32),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFF2A1A4A), width: 1),
        ),
        child: Column(
          children: List.generate(_menuItems.length, (index) {
            final item = _menuItems[index];
            final isLast = index == _menuItems.length - 1;

            return Column(
              children: [
                _buildMenuItem(
                  icon: item['icon'] as IconData,
                  label: item['label'] as String,
                  onTap: () {
                    Navigator.pushNamed(context, item['route']);
                  },
                ),
                if (!isLast)
                  Divider(
                    height: 1,
                    color: Colors.white.withOpacity(0.06),
                    indent: 20,
                    endIndent: 20,
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
        child: Row(
          children: [
            Icon(icon, color: Colors.white70, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontFamily: 'Syne',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white38, size: 20),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────
  Widget _buildSairButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          // lógica de logout
        },
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.redAccent.withOpacity(0.4),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.logout, color: Colors.redAccent, size: 18),
              SizedBox(width: 8),
              Text(
                'Sair da conta',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 14,
                  fontFamily: 'Syne',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
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

