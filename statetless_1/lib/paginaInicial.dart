import 'package:flutter/material.dart';

//método principal que inicia o app
void main(){
  //roda o que tiver dentro de PaginaInicial
  runApp(PaginaInicial());
}
//A classe pagina inicial vai se referir a todo contexto do app
//essa classe vai herdar o comportamente de StatelessWidget
//isso quer dizer que o app é estático, não muda nada na tela
class PaginaInicial extends StatelessWidget {
  const PaginaInicial({super.key});

  //função que vai construir as telas do app
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home:Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text("Página Inicial"),
        ),

        body: Center(
          child: Column(
            children: [
              Image.network('https://www.softwebsolutions.com/wp-content/uploads/2020/09/Flutter-App-development.jpg',
               width: 300, height: 300,),

               SizedBox(height: 20,),
                Text("O que é Flutter?", style: TextStyle(fontSize: 20),),
                
                Text('''Flutter é um framework do Google para criar aplicativos multiplataforma.\n 
                Serve para Android, IOS, Web, Desktop, entre outros, usando a linguagem DART.\n
         Possui Widgets, que são blocos de construção da interface no flutter, toda tela é um widget.
        Desde botões e textos até layouts mais complexos. Eles pode ser:
                ''', textAlign: TextAlign.center,),

                ListTile(leading: Icon(Icons.arrow_circle_right_outlined),
                 title: Text("Statefull: Com estado dinâmico, a tela muda!"),),

                 ListTile(leading: Icon(Icons.arrow_circle_right_outlined),
                 title: Text("Stateless: Imutável, a tela sempre é a mesma!"),),
            ],
          ),
        ),
      ),

    );
  }
}