import 'package:flutter/material.dart';
import 'package:statetless_1/paginaInicial.dart';

//função principal que inicia o aplicativo
void main(){
  runApp(home());
}

class home extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: Aplicativo(),
    );
  }
}

//criando minha classe própria
//stateless é estático, não muda, carrega só uma vez
class Aplicativo extends StatelessWidget{
  //apenas para dar identidade ao app
  const Aplicativo({super.key});

  //@override quer dizer que vai sobrescrever a tela
  //build é o widget que vai construir toda tela
  //MaterialApp é o que personaliza o tema
  @override
  Widget build(BuildContext context){
    return Scaffold(
        //appbar é barra superior
        appBar: AppBar(
        
          title: Text('Flutter é divertido!'),
          backgroundColor: Colors.deepPurpleAccent,
        ),
        
        //body é o corpo e Center é centralizar
        body: Center(
          //organiza em colunas
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
           
            //children serve para colocar vários widgets um atras do outro
            children: [
              //container é uma caixa
              Container(
                height: 200,
                width: 200,
                padding: EdgeInsets.only(top: 75),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 52, 52, 91),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),

                child: Text(
                  "Olá Mundo!",
                   textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30),
                ),
               ),

              //widget de linha
               Row(
                //tipo de espaçamento
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //widget com filhos
                children : [
                  Icon(Icons.leaderboard, color: Colors.deepPurpleAccent, size: 50,),
                  Icon(Icons.person, color: Colors.deepPurpleAccent, size: 50,),
                ],
               ),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                  backgroundColor: Colors.red,
                  child: Icon(Icons.add),
                  onPressed:() { 
                      print("Parabéns, Funcionou!");
                    },
                  ),
                ] 
            ),
            ],
          ),
        ),

      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(icon: Icon(Icons.school), label: "Escola"),
        BottomNavigationBarItem(icon: Icon(Icons.add_a_photo), label: "Fotos"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Buscar"),
      ]),

    drawer: Drawer(
      backgroundColor: Colors.deepPurpleAccent,
      child: ListView(
        padding: EdgeInsets.zero, //zerar padding
        children: [
          DrawerHeader(
            child: Text('Texto de Cabeçalho')
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text("Perfil"),
            onTap: () { print("entrou no perfil"); },
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Página Inicial"),
            onTap:() { 
              //fechar menu lateral
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => PaginaInicial()));
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Configurações"),
            onTap: (){ },
          ),
            
        ],
      ),
    ),
      

    
    );
  }
}