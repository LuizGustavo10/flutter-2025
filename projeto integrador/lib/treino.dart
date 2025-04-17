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
          if (widget.tipoExercicioFiltro == null || valor['tipo'] == widget.tipoExercicioFiltro) {
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
        return exercicios.toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Falha ao carregar os exercícios');
    }
  }

  Future<void> deletarExercicio(String exercicioId) async {
    final url = Uri.parse(
        "https://senac2025-1a776-default-rtdb.firebaseio.com/exercicios/${widget.username}/$exercicioId.json");
    final response = await http.delete(url);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Exercício deletado com sucesso!')),
      );
      setState(() {}); // Atualiza a tela
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao deletar exercício.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tipoExercicioFiltro != null
            ? 'Exercícios de ${widget.tipoExercicioFiltro}'
            : 'Todos os Exercícios'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: buscarExercicios(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Erro ao carregar exercícios!"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Nenhum exercício cadastrado para este tipo."));
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
                      Text(
                        exercicio['nome'],
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text('Tipo: ${exercicio['tipo']}'),
                      SizedBox(height: 8),
                      Text('Séries: ${exercicio['series']}'),
                      SizedBox(height: 8),
                      Text('Repetições: ${exercicio['repeticoes']}'),
                      SizedBox(height: 16),
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
      ),
    );
  }
}

class MenuExercicios extends StatelessWidget {
  final String username;
  MenuExercicios({required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu de Exercícios'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Cadastrar Exercício'),
            leading: Icon(Icons.add, color: Colors.orange),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CadastrarExercicio(username: username)),
              );
            },
          ),
          Divider(),
          ListTile(
            title: Text('Ver Todos os Exercícios'),
            leading: Icon(Icons.fitness_center, color: Colors.orange),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VerExercicios(username: username)),
              );
            },
          ),
          Divider(),
          ListTile(
            title: Text('Exercícios de Peito'),
            leading: Icon(Icons.bolt, color: Colors.orange), // Ícone de peito (pode precisar de um pacote de ícones personalizado)
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VerExercicios(username: username, tipoExercicioFiltro: 'Peito')),
              );
            },
          ),
          Divider(),
          ListTile(
            title: Text('Exercícios de Braço'),
            leading: Icon(Icons.boy_rounded, color: Colors.orange),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VerExercicios(username: username, tipoExercicioFiltro: 'Braço')),
              );
            },
          ),
          Divider(),
          ListTile(
            title: Text('Exercícios de Perna'),
            leading: Icon(Icons.directions_run, color: Colors.orange),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VerExercicios(username: username, tipoExercicioFiltro: 'Perna')),
              );
            },
          ),
        ],
      ),
    );
  }
}