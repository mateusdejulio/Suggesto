import 'package:flutter/material.dart';

class SugerirPage extends StatefulWidget {
  final Map<String, dynamic>? local;

  const SugerirPage({super.key, this.local});

  @override
  State<SugerirPage> createState() => _SugerirPageState();
}

class _SugerirPageState extends State<SugerirPage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  final TextEditingController _controller = TextEditingController();
  final int _maxChars = 500;
  String? _categoriaSelecionada;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  bool _enviado = false;

  final List<String> _categorias = [
    'Atendimento',
    'Qualidade do produto',
    'Preço',
    'Estrutura',
    'Ambiente',
    'Higiene',
    'Cardápio',
    'Outro',
  ];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    _animController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _animController.dispose();
    super.dispose();
  }

  bool get _podeEnviar =>
      _controller.text.trim().isNotEmpty &&
      _categoriaSelecionada != null &&
      !_enviado;

  void _enviar() {
    if (!_podeEnviar) return;
    setState(() => _enviado = true);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF2D5A27),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Color(0xFF4CAF50)),
            SizedBox(width: 10),
            Text(
              'Sugestão enviada com sucesso!',
              style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );

    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final local =
        widget.local ??
        {
          'nome': 'BigJack',
          'imagem':
              'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=800&q=80',
        };

    return Scaffold(
      backgroundColor: const Color(0xFF12061E),
      body: Column(
        children: [
          _buildAppBar(context),
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      _buildLocalInfo(local),
                      const SizedBox(height: 20),
                      _buildTextArea(),
                      const SizedBox(height: 24),
                      _buildCategoriasSection(),
                      const SizedBox(height: 32),
                      _buildEnviarButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: barraNavegacao(),
    );
  }

  // ─── AppBar ────────────────────────────────────────────────────────
  Widget _buildAppBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A0A2E),
        boxShadow: [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 56,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const Expanded(
                child: Text(
                  'Nova Sugestão',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'PoppinsBold',
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              // Espaço para balancear o botão de voltar
              const SizedBox(width: 48),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Local Info ────────────────────────────────────────────────────
  Widget _buildLocalInfo(Map<String, dynamic> local) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E0E32),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF3A1A6A), width: 1),
      ),
      child: Row(
        children: [
          // Logo/Imagem do local
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: local['imagem'] != null
                ? Image.network(
                    local['imagem'],
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholderLogo(),
                  )
                : _placeholderLogo(),
          ),
          const SizedBox(width: 14),
          // Nome
          Expanded(
            child: Text(
              local['nome'] ?? 'Local',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'PoppinsSemiBold',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholderLogo() {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFF2A1A4A),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(Icons.storefront, color: Colors.white38, size: 28),
    );
  }

  // ─── Text Area ─────────────────────────────────────────────────────
  Widget _buildTextArea() {
    final charCount = _controller.text.length;
    final isNearLimit = charCount > (_maxChars * 0.8);

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E0E32),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _controller.text.isNotEmpty
                  ? const Color(0xFF9B59D0)
                  : const Color(0xFF3A1A6A),
              width: 1.2,
            ),
          ),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                maxLength: _maxChars,
                maxLines: 6,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  height: 1.5,
                ),
                decoration: InputDecoration(
                  hintText: 'Digite aqui sua sugestão.',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.3),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                  counterText: '',
                ),
              ),
              // Contador de caracteres
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '$charCount/$_maxChars',
                      style: TextStyle(
                        color: isNearLimit
                            ? const Color(0xFFFF6B6B)
                            : Colors.white.withOpacity(0.3),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Categorias ────────────────────────────────────────────────────
  Widget _buildCategoriasSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sua sugestão diz respeito a',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'PoppinsSemiBold',
          ),
        ),
        const SizedBox(height: 14),
        // Grid de categorias 2 colunas
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 3.2,
          ),
          itemCount: _categorias.length,
          itemBuilder: (_, i) => _buildCategoriaChip(_categorias[i]),
        ),
      ],
    );
  }

  Widget _buildCategoriaChip(String label) {
    final isSelected = _categoriaSelecionada == label;

    return GestureDetector(
      onTap: () => setState(() {
        _categoriaSelecionada = isSelected ? null : label;
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6B2FA0) : const Color(0xFF2A1A4A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF9B59D0)
                : const Color(0xFF3A1A6A),
            width: 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF9B59D0).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white60,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ),
    );
  }

  // ─── Botão Enviar ──────────────────────────────────────────────────
  Widget _buildEnviarButton() {
    return AnimatedOpacity(
      opacity: _podeEnviar ? 1.0 : 0.45,
      duration: const Duration(milliseconds: 200),
      child: GestureDetector(
        onTap: _enviar,
        child: Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF7B2FBE), Color(0xFF9B59D0)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: _podeEnviar
                ? [
                    BoxShadow(
                      color: const Color(0xFF9B59D0).withOpacity(0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: _enviado
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : const Text(
                    'Enviar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'PoppinsSemiBold',
                      letterSpacing: 0.5,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  // ─── Bottom Nav ────────────────────────────────────────────────────
   int paginaAtual = 1;
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
