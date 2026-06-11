import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class InfoLocalPage extends StatefulWidget {
  final Map<String, dynamic> local;

  const InfoLocalPage({super.key, required this.local});

  @override
  State<InfoLocalPage> createState() => _InfoLocalPageState();
}

class _InfoLocalPageState extends State<InfoLocalPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  bool _isFavorito = false;

  late LatLng _localCoords;

  late String _nome;
  late String _bairro;
  late String _imagem;
  late String _endereco;
  late String _horario;
  late String _telefone;
  late String _descricao;
  late List<String> _tags;

  @override
  void initState() {
    super.initState();

    final local = widget.local;

    _nome = local['nome'] ?? 'Local';
    _bairro = local['bairro'] ?? 'Campinas, SP';
    _imagem = local['imagem'] ?? '';
    _endereco = local['endereco'] ?? 'Endereço não informado';
    _horario = local['horario'] ?? 'Horário não informado';
    _telefone = local['telefone'] ?? 'Telefone não informado';
    _descricao = local['descricao'] ??
        'Um dos estabelecimentos mais bem avaliados da região.';
    _tags =
        (local['tags'] as List<String>?) ?? ['Wi-Fi', 'Estacionamento'];

    final lat = (local['lat'] ?? -22.9000).toDouble();
    final lng = (local['lng'] ?? -47.0600).toDouble();
    _localCoords = LatLng(lat, lng);

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fadeAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeOut);

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(_fadeAnim);

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF12061E),
      body: Stack(
        children: [
          _buildMap(),

          // painel por cima
          Align(
            alignment: Alignment.bottomCenter,
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: _buildInfoPanel(),
              ),
            ),
          ),

          // botão voltar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A0A2E).withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMap() {
  final adjustedCenter = LatLng(
    _localCoords.latitude - 0.0055,
    _localCoords.longitude,
  );

  return SizedBox(
    height: MediaQuery.of(context).size.height,
    child: FlutterMap(
      options: MapOptions(
        initialCenter: adjustedCenter,
        initialZoom: 15.5,
      ),
      children: [
        TileLayer(
          urlTemplate:
              "https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/{z}/{x}/{y}{r}.png",
          userAgentPackageName: 'com.example.app',
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: _localCoords,
              width: 60,
              height: 60,
              child: const Icon(
                Icons.location_on,
                color: Color(0xFF9B59D0),
                size: 44,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

  Widget _buildInfoPanel() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.55,
      decoration: const BoxDecoration(
        color: Color(0xFF1A0A2E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // puxador
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            _buildTopInfoRow(),
            const Divider(color: Color(0xFF2A1A4A)),

            _buildDetalhesList(),
            _buildDescricao(),
            _buildTagsRow(),
            _buildBotoes(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTopInfoRow() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _imagem.isNotEmpty
                ? Image.network(_imagem,
                    width: 60, height: 60, fit: BoxFit.cover)
                : _logoPlaceholder(),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_nome,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold, fontFamily: "PoppinsSemi")),
                Text(_bairro,
                    style:
                        const TextStyle(color: Colors.white54, fontSize: 13, fontFamily: "Poppins")),
              ],
            ),
          ),
          IconButton(
            onPressed: () =>
                setState(() => _isFavorito = !_isFavorito),
            icon: Icon(
              _isFavorito ? Icons.bookmark : Icons.bookmark_border,
              color: const Color(0xFF9B59D0),
            ),
          )
        ],
      ),
    );
  }

  Widget _logoPlaceholder() {
    return Container(
      width: 60,
      height: 60,
      color: const Color(0xFF2A1A4A),
      child: const Icon(Icons.storefront, color: Colors.white38),
    );
  }

  Widget _buildDetalhesList() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_endereco, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 6),
          Text(_horario, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 6),
          Text(_telefone, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildDescricao() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(_descricao,
          style: const TextStyle(color: Colors.white60),),
    );
  }

  Widget _buildTagsRow() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 8,
        children: _tags
            .map((e) => Chip(
                  label: Text(e),
                  backgroundColor: const Color(0xFF2A1A4A),
                  labelStyle: const TextStyle(color: Colors.white70),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildBotoes() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 57, 0, 103),
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/sugerir');
        },
        child: const Text(
          "Fazer Sugestão",
          style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(229, 212, 212, 212), fontFamily: "Poppins"),
        ),
      ),
    );
  }
}
