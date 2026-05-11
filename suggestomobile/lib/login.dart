import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(18, 6, 30, 1),


      
      body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [


      ////////TITULO ENTRAR////////

        Text("Entrar", style: TextStyle(
          color: Colors.white,
          fontSize: 30,
          fontFamily: "Syne",),),
          SizedBox(height: 30,),


        ///////CAMPO EMAIL///////

        SizedBox(width: 400,
        child: 
        TextField(
          controller: emailController,
          onChanged: (value){},
          style: TextStyle(color: const Color.fromARGB(186, 255, 255, 255)),

          decoration: InputDecoration(
            labelText: "Email",
            labelStyle: TextStyle(color: const Color.fromARGB(139, 255, 255, 255), fontSize: 14),
            fillColor: const Color.fromARGB(123, 88, 8, 129),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
          ),
          
        ),),

      //////CAMPO SENHA//////////

        SizedBox(height: 20,),

        SizedBox(width: 400,
        child: 
        TextField(
          controller: senhaController,
          onChanged: (value){},
          style: TextStyle(color: const Color.fromARGB(186, 255, 255, 255)),

          decoration: InputDecoration(
            labelText: "Senha",
            labelStyle: TextStyle(color: const Color.fromARGB(139, 255, 255, 255), fontSize: 14),
            fillColor: const Color.fromARGB(123, 88, 8, 129),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
          ),
          
        ),),

      SizedBox(height: 20,),

      ////////BOTAO ENTRAR//////////

        ElevatedButton(onPressed: () {
          Navigator.pushNamed(context, '/cadastro');

          setState(() {
          });
        },child: Text(
          "Entrar", 
          textAlign: TextAlign.center,
          style: TextStyle(color:Color.fromARGB(200, 239, 224, 238), fontFamily: "Syne", fontSize: 15),
        ), style: ElevatedButton.styleFrom(
          fixedSize: const Size(120,40),
          alignment: Alignment.center,
          backgroundColor: const Color.fromARGB(187, 73, 8, 138),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),

        ),),

        SizedBox(height: 50,),

        //////LINHA OU////////

      /*  Row(
  children: <Widget>[
    Expanded(
      child: Divider(
        indent: 200,
        
        color: const Color.fromARGB(255, 255, 255, 255),
        thickness: 1, // Espessura da linha
      ),
    ),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Text("ou", style: TextStyle(color:Colors.white),),
    ),
    Expanded(
      child: Divider(
        
        endIndent: 200,
        color: const Color.fromARGB(255, 255, 255, 255),
        thickness: 1,
      ),
    ),
  ],
),

    SizedBox(height: 30,),

      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage("images/iconegoogle.png",),

        ),
        SizedBox(width: 20,),

        CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage("images/iconefacebook.png",),

        ),
      ],)*/





      ],),),
    );
  }
}