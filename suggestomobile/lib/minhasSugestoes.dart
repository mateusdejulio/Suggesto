import 'package:flutter/material.dart';

class MinhasSugestoes extends StatefulWidget {
  const MinhasSugestoes({super.key});

  @override
  State<MinhasSugestoes> createState() => _MinhasSugestoesState();
}

class _MinhasSugestoesState extends State<MinhasSugestoes> {

 Widget sugestao({
  required String local,
  required String imagem,
  required String categoria,
  required String texto,
  required String status,
  required String tempo,
  required String pontos,
}) {
  return Container(
    width: 450,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color.fromARGB(104, 47, 4, 116),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // FOTO
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
            imagem,
            width: 95,
            height: 140,
            fit: BoxFit.cover,
          ),
        ),

        const SizedBox(width: 15),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          local,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Syne",
                          ),
                        ),

                        const SizedBox(height: 8),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(
                              80,
                              101,
                              26,
                              177,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            categoria,
                            style: const TextStyle(
                              color: Color.fromARGB(
                                255,
                                147,
                                100,
                                236,
                              ),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Column(
                    children: [

                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {},
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                          size: 22,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        status,
                        style: TextStyle(
                          color: status == "Resolvida"
                              ? Colors.green
                              : Colors.orange,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Text(
                texto,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color.fromARGB(
                    190,
                    255,
                    255,
                    255,
                  ),
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 15),

              Row(
                children: [

                  const Icon(
                    Icons.schedule,
                    color: Colors.white54,
                    size: 16,
                  ),

                  const SizedBox(width: 5),

                  Text(
                    tempo,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                    ),
                  ),

                  const Spacer(),

                  const Icon(
                    Icons.monetization_on,
                    color: Colors.amber,
                    size: 18,
                  ),

                  const SizedBox(width: 4),

                  Text(
                    pontos,
                    style: const TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF12061E),

      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [

              SizedBox(height: 50),

              Text(
                "Minhas Sugestões",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontFamily: "PoppinsSemi",
                ),
              ),

              SizedBox(height: 40),

              sugestao(
                local: "Big Jack Hamburgueria",
                imagem: "https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=800&q=80",
                categoria: "Atendimento",
                texto:
                    "Gostei muito da educação dos funcionários e da rapidez no atendimento.",
                status: "Resolvida",
                tempo: "há 2 dias",
                pontos: "+50 pts",
              ),

              SizedBox(height: 30),

              sugestao(
                local: "Café do Centro",
                imagem: "https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=800&q=80",
                categoria: "Cardápio",
                texto: "Seria interessante adicionar opções para pessoas com restrições alimentares.",
                status: "Em análise",
                tempo: "há 5 dias",
                pontos: "+20 pts",
              ),

              SizedBox(height: 30),

              sugestao(
                local: "Panobianco Academia",
                imagem: "https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800&q=80",
                categoria: "Estrutura",
                texto:"O banheiro masculino está sem tampa em um vaso.",
                status: "Resolvida",
                tempo: "há 1 semana",
                pontos: "+80 pts",
              ),

              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}