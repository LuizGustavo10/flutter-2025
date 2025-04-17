import 'dart:convert';
import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



//criando a classe empresa - que vai fabricar empresas
class Empresa {
  String id;
  String nome;
  String cnpj;
  String email;
  String telefone;
  String endereco;
  String cidade;
  String qtdFuncionarios;
  String vaga;
  Empresa(this.id, this.nome, this.cnpj, this.email, this.telefone,  this.endereco,
   this.cidade, this.qtdFuncionarios, this.vaga);
}




//criando a tela de cadastro
class Cadastro extends StatefulWidget {
  final List<Empresa> empresas;
  //cadastro vai receber empresas
  Cadastro({required this.empresas});
  
  @override
  _CadastroState createState() => _CadastroState();
}
//classe que tem quantas alterações em tela forem necessárias
class _CadastroState extends State<Cadastro>{
  //controles dos inputs do formulário
  final nomeControle = TextEditingController();
  final cnpjControle = TextEditingController();
  final emailControle = TextEditingController();
  final telefoneControle = TextEditingController();
  final enderecoControle = TextEditingController();
  final cidadeControle = TextEditingController();
  final qtdFuncControle = TextEditingController();
  final vagaControle = TextEditingController();

  //criando método de CADASTRO - método API de POST
  Future<void> cadastrarempresa(Empresa empresa) async {
    final url = Uri.parse("https://senac2025-1a776-default-rtdb.firebaseio.com/empresa.json");
    final resposta = await http.post( url, body: jsonEncode({ 
      "nome": empresa.nome,
      "cnpj": empresa.cnpj,
      "email": empresa.email,
      "telefone": empresa.telefone,
      "endereco" : empresa.endereco,
      "cidade" : empresa.cidade,
      "qtdFuncionarios" : empresa.qtdFuncionarios,
      "vaga" : empresa.vaga,
     }));
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Cadastro de empresas"),
       backgroundColor: Colors.green,
    ),
    body: Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text("Cadastro de Contato", style: TextStyle(fontSize: 30),),
          TextField(controller: nomeControle, decoration: InputDecoration(labelText: 'Nome')),
          TextField(controller: cnpjControle, decoration: InputDecoration(labelText: 'Cnpj')),
          TextField(controller: emailControle, decoration: InputDecoration(labelText: 'Email')),
          TextField(controller: telefoneControle, decoration: InputDecoration(labelText: 'Telefone')),
          TextField(controller: enderecoControle, decoration: InputDecoration(labelText: 'Endereço')),
          TextField(controller: cidadeControle, decoration: InputDecoration(labelText: 'Cidade')),
          TextField(controller: qtdFuncControle, decoration: InputDecoration(labelText: 'Qtd funcionários')),
          TextField(controller: vagaControle, decoration: InputDecoration(labelText: 'vaga')),
          SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              //setState atualiza toda tela na hora
              setState(() { 
                //criação de um novo objeto empresa "Ex: Seu Arlindo"
                Empresa empresaNova = Empresa(
                  "",
                  nomeControle.text,
                  emailControle.text,
                  cnpjControle.text,
                  telefoneControle.text,
                  enderecoControle.text,
                  cidadeControle.text,
                  qtdFuncControle.text,
                  vagaControle.text
              );
                //adicionando empresa na lista "Ex: Seu Arlindo"
                //widget.empresas.add(empresaNova);
                cadastrarempresa(empresaNova);
                
                //limpar os campos
                nomeControle.clear();
                emailControle.clear();
                telefoneControle.clear();
                enderecoControle.clear();
                cidadeControle.clear();
                cnpjControle.clear();
                qtdFuncControle.clear();
                vagaControle.clear();
              });
            },
            child: Text("Salvar"), 
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white
            ),
            
          ),
        ],
      ),
    ),
  );
}
}