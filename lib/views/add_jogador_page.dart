import 'package:board_game_manager/basicas/jogador.dart';
import 'package:board_game_manager/repositories/jogador_repository.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class AddJogadorPage extends StatefulWidget {
  final String title;
  const AddJogadorPage({super.key, required this.title});

  @override
  State<StatefulWidget> createState() {
    return _AddJogadorPageState();
  }
}

class _AddJogadorPageState extends State<AddJogadorPage> {
  final JogadorRepository _jogadorRepository = JogadorRepository('Jogador');
  final nomeController = TextEditingController();
  final squadController = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: TextField(
                      autocorrect: true,
                      textCapitalization: TextCapitalization.sentences,
                      controller: nomeController,
                      decoration: const InputDecoration(
                          labelText: "Nome",
                          labelStyle: TextStyle(color: Colors.blueAccent)),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: TextField(
                      autocorrect: true,
                      textCapitalization: TextCapitalization.sentences,
                      controller: squadController,
                      decoration: const InputDecoration(
                          labelText: "Squad",
                          labelStyle: TextStyle(color: Colors.blueAccent)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: FloatingActionButton(
                    onPressed: addJogador,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: _loading ? _circularLoading() : const Text('Salvar'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: FutureBuilder<List<Jogador>>(
                  future: _jogadorRepository.getAll(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Center(
                          child: Container(
                              width: 100,
                              height: 100,
                              child: const CircularProgressIndicator()),
                        );
                      default:
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text("Error..."),
                          );
                        }
                        if (!snapshot.hasData) {
                          return const Center(
                            child: Text("No Data..."),
                          );
                        } else {
                          return ListView.builder(
                              padding: const EdgeInsets.only(
                                  top: 10.0, left: 5.0, right: 5.0),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                //*************************************
                                //Get Parse Object Values
                                final varPlayer = snapshot.data![index];
                                final varNome = varPlayer.nome;
                                final varSquad = varPlayer.squad;
                                //*************************************

                                return Card(
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Colors.green.shade50),
                                      borderRadius:
                                          BorderRadius.circular(15.0)),
                                  child: ListTile(
                                    title: Text(varNome!),
                                    subtitle: Text('Squad: $varSquad'),
                                    leading: const CircleAvatar(
                                      child: Icon(Icons.person_4),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                            onPressed: () async {
                                              await _jogadorRepository
                                                  .delete(varPlayer.id!);
                                              setState(() {
                                                SnackBar snackBar = SnackBar(
                                                  content: const Text(
                                                      'Jogador excluido!'),
                                                  backgroundColor:
                                                      Colors.green.shade400,
                                                  duration: const Duration(
                                                      seconds: 3),
                                                );
                                                ScaffoldMessenger.of(context)
                                                  ..removeCurrentSnackBar()
                                                  ..showSnackBar(snackBar);
                                              });
                                            },
                                            icon: const Icon(Icons.delete))
                                      ],
                                    ),
                                  ),
                                );
                              });
                        }
                    }
                  })),
        ],
      ),
    );
  }

  Future<List<ParseObject>> getJogadores() async {
    QueryBuilder<ParseObject> queryPlayers =
        QueryBuilder<ParseObject>(ParseObject('Jogador'));
    final ParseResponse apiResponse = await queryPlayers.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }

  Widget _circularLoading() {
    return Container(
      height: 15.0,
      width: 15.0,
      child: const CircularProgressIndicator(),
    );
  }

  void addJogador() async {
    if (nomeController.text.trim().isEmpty ||
        squadController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Nome do jogador ou squad vazios"),
        backgroundColor: Colors.red.shade400,
        duration: const Duration(seconds: 3),
      ));
      return;
    }

    await _saveJogador(nomeController.text, squadController.text);
    setState(() {
      nomeController.clear();
      squadController.clear();
    });
  }

  Future<void> _saveJogador(String nome, String squad) async {
    _saving(true);
    final jogador = ParseObject('Jogador')
      ..set('nome', nome)
      ..set('squad', squad);

    await jogador.save();

    _saving(false);
  }

  void _saving(bool enable) {
    setState(() {
      _loading = enable;
    });
  }
}
