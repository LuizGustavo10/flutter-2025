import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CadastrarExercicio extends StatefulWidget {
  final String username;
  CadastrarExercicio({required this.username});
  @override
  CadastrarExercicioEstado createState() => CadastrarExercicioEstado();
}

class CadastrarExercicioEstado extends State<CadastrarExercicio> {
  final TextEditingController nomeExercicioController = TextEditingController();
  final TextEditingController seriesController = TextEditingController();
  final TextEditingController repeticoesController = TextEditingController();
  String? tipoExercicioSelecionado;

  Future<void> cadastrarExercicio() async {
    final nomeExercicio = nomeExercicioController.text;
    final series = seriesController.text;
    final repeticoes = repeticoesController.text;

    if (nomeExercicio.isNotEmpty &&
        series.isNotEmpty &&
        repeticoes.isNotEmpty &&
        tipoExercicioSelecionado != null) {
      final url = Uri.parse(
          "https://senac2025-1a776-default-rtdb.firebaseio.com/exercicios/${widget.username}.json");
      final resposta = await http.post(
        url,
        body: jsonEncode({
          'nome': nomeExercicio,
          'series': series,
          'repeticoes': repeticoes,
          'tipo': tipoExercicioSelecionado,
          'autor': widget.username,
          'dataCadastro': DateTime.now().toIso8601String(),
        }),
      );
      if (resposta.statusCode == 200) {
        nomeExercicioController.clear();
        seriesController.clear();
        repeticoesController.clear();
        setState(() {
          tipoExercicioSelecionado = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Exercício cadastrado com sucesso!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao cadastrar exercício.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha todos os campos e selecione o tipo.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar Exercício'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nomeExercicioController,
              decoration: InputDecoration(labelText: 'Nome do Exercício'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: seriesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Séries'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: repeticoesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Repetições'),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Tipo de Exercício'),
              value: tipoExercicioSelecionado,
              items: <String>['Peito', 'Braço', 'Perna']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  tipoExercicioSelecionado = newValue;
                });
              },
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: cadastrarExercicio,
              child: Text("Salvar Exercício"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VerExercicios extends StatefulWidget {
  final String username;
  final String? tipoExercicioFiltro;

  VerExercicios({required this.username, this.tipoExercicioFiltro});

  @override
  _VerExerciciosState createState() => _VerExerciciosState();
}

class _VerExerciciosState extends State<VerExercicios> {
  Future<List<Map<String, dynamic>>> buscarExercicios() async {
    final url = Uri.parse(
        'https://senac2025-1a776-default-rtdb.firebaseio.com/exercicios/${widget.username}.json');
    final resposta = await http.get(url);

    if (resposta.statusCode == 200) {
      final Map<String, dynamic>? dados =
          jsonDecode(resposta.body) as Map<String, dynamic>?;
      if (dados != null) {
        final List<Map<String, dynamic>> exercicios = [];
        dados.forEach((key, valor) {
          if (widget.tipoExercicioFiltro == null ||
              valor['tipo'] == widget.tipoExercicioFiltro) {
            exercicios.add({
              'id': key,
              'nome': valor['nome'],
              'series': valor['series'],
              'repeticoes': valor['repeticoes'],
              'tipo': valor['tipo'],
              'autor': valor['autor'],
              'dataCadastro': valor['dataCadastro'],
            });
          }
        });
        return exercicios;
      }
    }
    throw Exception('Falha ao carregar os exercícios');
  }

  Future<void> deletarExercicio(String exercicioId) async {
    final url = Uri.parse(
        "https://senac2025-1a776-default-rtdb.firebaseio.com/exercicios/${widget.username}/$exercicioId.json");
    final response = await http.delete(url);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Exercício deletado com sucesso!')),
      );
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao deletar exercício.')),
      );
    }
  }

  Widget buildFiltroInicial() {
    return Column(
      children: [
        SizedBox(height: 24),
        Text("Escolha o tipo de exercício", style: TextStyle(fontSize: 20)),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            filtroCard('Braço', Icons.fitness_center),
            filtroCard('Peito', Icons.bolt),
            filtroCard('Perna', Icons.directions_run),
          ],
        ),
      ],
    );
  }

  Widget filtroCard(String tipo, IconData icone) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => VerExercicios(
              username: widget.username,
              tipoExercicioFiltro: tipo,
            ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        color: Colors.orange.shade100,
        child: Container(
          width: 100,
          height: 100,
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icone, size: 36, color: Colors.orange),
              SizedBox(height: 8),
              Text(tipo, style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildListaExercicios() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: buscarExercicios(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Erro ao carregar exercícios!"));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
              child: Text("Nenhum exercício encontrado para este tipo."));
        }

        final exercicios = snapshot.data!;
        return ListView.builder(
          itemCount: exercicios.length,
          itemBuilder: (context, index) {
            final exercicio = exercicios[index];
            return Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(exercicio['nome'],
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('Tipo: ${exercicio['tipo']}'),
                    Text('Séries: ${exercicio['series']}'),
                    Text('Repetições: ${exercicio['repeticoes']}'),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            deletarExercicio(exercicio['id']);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tipoExercicioFiltro != null
            ? 'Exercícios de ${widget.tipoExercicioFiltro}'
            : 'Filtrar Exercícios'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: widget.tipoExercicioFiltro == null
          ? buildFiltroInicial()
          : buildListaExercicios(),
    );
  }
}