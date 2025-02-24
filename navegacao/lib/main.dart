import 'package:flutter/material.dart';
import 'package:navegacao/Tela1.dart';
import 'package:navegacao/Tela2.dart';
import 'package:navegacao/Tela3.dart';
import 'package:navegacao/Tela4.dart';

//classe principal inicia o projeto
void main() => runApp(Aplicativo());

//Classe pai que configura todo nosso app herda tipo stateless
class Aplicativo extends StatelessWidget {
  final List<Pessoa> pessoas = [];
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menu Principal',
      theme: ThemeData.dark(),
      home: Menu(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/tela1': (context) => Cadastro(pessoas:pessoas),
        '/tela2': (context) => TabelaPai(),
        '/tela3': (context) => Tela3(),
        '/tela4': (context) => Tela4(),
      },
    );
  }
}

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Principal', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Center(
        child: GridView.count(
          crossAxisCount: 2,
          children: <Widget> [
            botao(texto: 'Cadastrar', rota:'/tela1', icone: Icons.person_add_alt_1, cor: Colors.white),
            botao(texto: 'Listar', rota:'/tela2', icone: Icons.list, cor: Colors.white),
            botao(texto: 'Sobre', rota:'/tela3', icone: Icons.not_listed_location, cor: Colors.white),
            botao(texto: 'Contato', rota:'/tela4', icone: Icons.phone_in_talk_sharp, cor: Colors.white),

          ],
        ),
      ),
    );
  }
}   

class botao extends StatelessWidget {
  //variáveis que configuram um botão novo personalizado
  final String texto;
  final String rota;
  final IconData icone;
  final Color cor;

  const botao({Key? key, required this.texto, required this.rota,
  required this.icone, required this.cor});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      //espaçamento interno
      padding: EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurpleAccent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        ),
        onPressed: () { Navigator.pushNamed(context, rota);  },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icone, color: cor, size: 70),
            Text(texto, style: TextStyle(color: cor, fontSize: 20.0),)
          ],
        ),
      ),
    );
  }
}
