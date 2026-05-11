import 'package:flutter/material.dart';
import 'package:suggestomobile/cadastro.dart';
import 'package:suggestomobile/infoLocal.dart';
import 'package:suggestomobile/inicialcli.dart';
//import 'package:suggestomobile/inicialcli.dart';
import 'package:suggestomobile/inicio.dart';
import 'package:suggestomobile/locaisSalvos.dart';
import 'package:suggestomobile/login.dart';
import 'package:suggestomobile/lojaPontos.dart';
import 'package:suggestomobile/perfilClie.dart';
import 'package:suggestomobile/sugerir.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {  
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Suggesto',
      theme: ThemeData(
        
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),

      initialRoute: '/login', 
      
      // O seu "mapa" de navegação
      routes: {
        '/login': (context) => Login(),
        '/cadastro': (context) => Cadastro(),
        '/inicio': (context) => Inicio(),
        '/home_cliente': (context) => HomePage(),
        '/perfil': (context) => PerfilCliPage(),
        '/sugerir': (context) => SugerirPage(),
        '/locais_salvos': (context) => LocaisSalvosPage(),
        '/loja': (context) => LojasPontosPage(),
        '/info_local': (context) => InfoLocalPage(local: {},),
      },
    );
  }
}

