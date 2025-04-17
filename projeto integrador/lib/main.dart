import 'package:flutter/material.dart';
import 'package:navegacao/Postagem.dart';
import 'package:navegacao/Tela1.dart';
import 'package:navegacao/Tela2.dart';
import 'package:navegacao/Tela3.dart';
import 'package:navegacao/Tela4.dart';
import 'package:navegacao/treino.dart';


//Classe pai que configura todo nosso app herda tipo stateless
class Aplicativo extends StatelessWidget {
  final List<Empresa> empresas = [];
  final String nomeUsuario;
  Aplicativo({required this.nomeUsuario});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Projeto Integrador',
      theme: ThemeData.light(),
      home: Menu(nomeUsuario:nomeUsuario),
      debugShowCheckedModeBanner: false,
      routes: {
        '/tela1': (context) => Cadastro(empresas:empresas),
        '/tela2': (context) => TabelaPai(),
        '/tela3': (context) => CadastrarPostagem(username:nomeUsuario),
        '/tela4': (context) => VerPostagens(),
        '/tela5': (context) => MinhasPostagens(username:nomeUsuario),
        '/tela6': (context) => CadastrarExercicio(username:nomeUsuario),
        '/tela7': (context) => VerExercicios(username: nomeUsuario),
      },
    );
  }
}
class Menu extends StatelessWidget {
  final String nomeUsuario;
  Menu({required this.nomeUsuario});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bem-vindo $nomeUsuario', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue, centerTitle: true,
      ),
      body: Center(
        child: GridView.count(
          crossAxisCount: 2,
          children: <Widget> [
            botao(texto: 'Cadastrar', rota:'/tela1', icone: Icons.person_add_alt_1, cor: Colors.white),
            botao(texto: 'Listar', rota:'/tela2', icone: Icons.list, cor: Colors.white),
            botao(texto: 'Criar Postagem', rota:'/tela3', icone: Icons.post_add, cor: Colors.white),
            botao(texto: 'Ver Postagens', rota:'/tela4', icone: Icons.list_rounded, cor: Colors.white),
            botao(texto: 'Minhas Postagens', rota:'/tela5', icone: Icons.person_search_rounded, cor: Colors.white),
            botao(texto: 'Cadastrar Treino', rota:'/tela6', icone: Icons.person_search_rounded, cor: Colors.white),
            botao(texto: 'Ver Treinos', rota:'/tela7', icone: Icons.person_search_rounded, cor: Colors.white),

          ],
        ),
      ),

       bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.black,
        unselectedItemColor: Colors.black,
       
        onTap: (index) {
          if (index == 1) {

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CadastrarPostagem(username: nomeUsuario,)),
            );


          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VerPostagens()),
            );
          }
          else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MinhasPostagens(username: nomeUsuario,)),
            );
          }
          else if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MinhasPostagens(username: nomeUsuario,)),
            );
          }
           else if (index == 5) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VerPostagens()),
            );
          }
          
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Postagens',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_sharp),
            label: 'Outro',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_sharp),
            label: 'Outro',
          ),
        ],
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
          backgroundColor: Colors.blue,
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
