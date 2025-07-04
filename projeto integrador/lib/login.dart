import 'package:carousel_slider/carousel_slider.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:navegacao/main.dart';

void main(){
  runApp(Preconfiguracao());
}

class Preconfiguracao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
  @override
  LoginEstado createState() => LoginEstado();
}

class LoginEstado extends State<Login>{
  final emailControle = TextEditingController();
  final senhaControle = TextEditingController();
  bool estaCarregando = false;
  String mensagemErro ='';
  bool ocultado = true;
  
  Future<void> logar() async {
    //inicia animação de carregamento 
    setState(() {
      estaCarregando = true;
      mensagemErro = '';
    });

    final url = Uri.parse('https://senac2025-1a776-default-rtdb.firebaseio.com/usuario.json');
    final resposta = await http.get(url);
    //se tudo estiver certo...
    if(resposta.statusCode == 200){
      final Map<String, dynamic>? dados = jsonDecode(resposta.body);

      if(dados != null){
        bool usuarioValido = false;
        String nomeUsuario = ''; 
        dados.forEach((key, valor){ 
          if(valor['email'] == emailControle.text && 
          valor['senha'] == senhaControle.text ){
            usuarioValido = true;
            nomeUsuario = valor['nome'];
          }
         });
        //se o usuario for valido, ou seja, se tiver no banco
         if(usuarioValido == true){
          Navigator.pushReplacement(context, 
          MaterialPageRoute(builder: (context) => Aplicativo(nomeUsuario:nomeUsuario)));
         }else{
          setState(() {
            mensagemErro = "Email ou senha inválidos";
            estaCarregando = false;
          });
          
         }
      }
    }else{
      setState(() { mensagemErro = 'Erro de conexão'; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tela de Login'), 
      backgroundColor: Colors.lightBlue, foregroundColor: Colors.white,),

      body: Padding(
        padding: EdgeInsets.all(50.0),
        child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeInImage(
              placeholder: AssetImage('imagens/carregamento.gif'),
              image: AssetImage('imagens/foto.png'),
              fadeInDuration: Duration(seconds: 3),
              fadeOutDuration: Duration(seconds: 9),
              width: 200,
            ),



   
      CarouselSlider(
        options: CarouselOptions(height: 200.0, autoPlay: true),
        items: [
          'imagens/foto.png',
          'imagens/foto.png',
          'imagens/foto.png',
        ].map((i) {
          return Builder(
            builder: (BuildContext context) {
              return ElevatedButton(onPressed: null, child: Text("Teste"));
            },
          );
        }).toList(),
      ),
    
  







            // Image.asset('imagens/foto.png', width: 200
            // ),

            SizedBox(height: 20,),
            TextField(
              controller: emailControle,
              decoration: InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
                prefixIconColor: Colors.blue,
              ),
            ),
            SizedBox(height: 20,),
            TextField(
              controller: senhaControle,
              obscureText: ocultado,
              decoration: InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
                prefixIconColor: Colors.blue,
                suffixIcon: IconButton(
                  icon: Icon(ocultado ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      ocultado = !ocultado; 
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 30,),

            estaCarregando ? CircularProgressIndicator() : 
            ElevatedButton( onPressed: logar, child: Text('Entrar')),
            SizedBox(height: 30,),
            TextButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Cadastro()));
            } , child: Text('Não tem uma conta? Cadastre-se'),),

            mensagemErro.isNotEmpty ? Text(mensagemErro,
             style: TextStyle(color: Colors.red),):
             SizedBox(),

          ],
        ),
      ),
    );
  }
}


class Cadastro extends StatefulWidget {
  @override
  CadastroEstado createState() => CadastroEstado();
}

class CadastroEstado extends State<Cadastro> {
  final nomeControle = TextEditingController();
  final emailControle = TextEditingController();
  final senhaControle = TextEditingController();
  bool estaCarregando = false;
  String erro= '';
  bool ocultado = true;

  Future<void> cadastrar() async {
    //iniciar variavel de carregamento
    setState(() { estaCarregando = true; });
    final nome = nomeControle.text;
    final email = emailControle.text;
    final senha = senhaControle.text;

    final url = Uri.parse('https://senac2025-1a776-default-rtdb.firebaseio.com/usuario.json');
    final resposta = await http.post(
      url,
      body:jsonEncode({
        'nome': nome,
        'email': email,
        'senha': senha
      }),
      headers: {'Content-Type':'application/json'},
    );
    if(resposta.statusCode == 200){
      Navigator.pop(context);
    }else{
      setState(() {
        erro = "Erro ao cadastrar usuário";
      });
      setState(() { estaCarregando = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro de novo usuário'),
       backgroundColor: Colors.blue, foregroundColor: Colors.white,),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [ 
            Icon(Icons.person_add, size: 100, color: Colors.blue,),
            SizedBox(height: 20,),
            TextField(
              controller: nomeControle,
              decoration: InputDecoration(
                labelText: 'Seu nome',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
                prefixIconColor: Colors.blue,
              ),
            ),
            SizedBox(height: 20,),
            TextField(
              controller: emailControle,
              decoration: InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
                prefixIconColor: Colors.blue,
              ),
            ),
            SizedBox(height: 20,),
            TextField(
              controller: senhaControle,
              obscureText: ocultado,
              decoration: InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
                prefixIconColor: Colors.blue,
                suffixIcon: IconButton(
                  icon: Icon(ocultado ? Icons.visibility : Icons.visibility_off),
                  onPressed: () { setState(() {ocultado = !ocultado; });},
                ),
              ),
            ),
            SizedBox(height: 30,),
            estaCarregando ? CircularProgressIndicator() : ElevatedButton(
              onPressed: cadastrar, child: Text('Cadastrar'),
            ),
            erro.isNotEmpty ? Text(erro, style: TextStyle(color: Colors.red)): SizedBox(),
          ],
        ),
      ),
    );
  }
}