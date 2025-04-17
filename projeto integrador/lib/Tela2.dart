import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:navegacao/Tela1.dart';
import 'package:navegacao/Detalhes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class TabelaPai extends StatefulWidget{
  @override
  Tabela createState() => Tabela();
}

class Tabela extends State<TabelaPai> {
  //método que roda quando abre a tela
  @override
  void initState(){
    super.initState();
    buscarEmpresas();
  }

  final List<Empresa> empresas = [];
  //Tabela({required this.empresas});

  //construindo método de exclusão
  Future<void> excluir(String id) async {
    final url = Uri.parse(
      "https://senac2025-1a776-default-rtdb.firebaseio.com/empresa/$id.json");
    final resposta = await http.delete(url);
    if(resposta.statusCode == 200){
      setState(() {
        empresas.clear();
        buscarEmpresas();
      });
    }
  }

  //método para buscar todos os clientes do banco
  Future<void> buscarEmpresas() async {
    final url = Uri.parse("https://senac2025-1a776-default-rtdb.firebaseio.com/empresa.json");
    final resposta = await http.get(url);
    //decodificando o arquivo json que recebemos
    final Map<String, dynamic> ? dados = jsonDecode(resposta.body);
    //se os dados da lista não forem nulos
    if(dados != null){
      //foreach é o loop de repetição que lista um a um
      dados.forEach((id, dadosEmpresa){
        //aqui vai atualizar a lista e adicionar uma empresa por vês
        setState(() { 
            Empresa empresaNova = Empresa(
               id,
               dadosEmpresa["nome"] ?? '',
               dadosEmpresa["email"] ?? '',
               dadosEmpresa["cnpj"] ?? '',
               dadosEmpresa["telefone"] ?? '',
               dadosEmpresa["endereco"] ?? '',
               dadosEmpresa["cidade"] ?? '',
               dadosEmpresa["qtdFuncionarios"] ?? '',
               dadosEmpresa["vaga"] ?? ''
               );
               empresas.add(empresaNova);
          });
      });
    }
  }

  Future<void> abrirWhats(String telefone) async {
  final url = Uri.parse('https://wa.me/$telefone');
  if (!await launchUrl(url)) {
    throw Exception('Não pode iniciar $url');
    }
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Contatos"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding:  EdgeInsets.all(16.0),
        //construindo lista
        child: ListView.builder(
          itemCount: empresas.length, //quantidade de itens da lista
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.person),
              title: Text(empresas[index].nome),
              subtitle: Text(
              "Email: " + empresas[index].email
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                  onPressed: () => abrirWhats(empresas[index].telefone),
                  icon: Icon(Icons.message, color:Colors.green,)
                  ),

                  IconButton(
                  onPressed: () => excluir(empresas[index].id),
                  icon: Icon(Icons.delete_rounded, color:Colors.red,)
                  ),

                ],
              ),
              //quando clicar no item da lista (onTap)
              onTap: () {
                Navigator.push(context , 
                MaterialPageRoute(builder: (context) => Detalhes(empresa:empresas[index])));
              },
  
            );
          }
        ),
      ),
    );
  }
}