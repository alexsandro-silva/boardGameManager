import 'package:board_game_manager/basicas/campeonato.dart';
import 'package:board_game_manager/repositories/campeonato_repository.dart';
import 'package:board_game_manager/views/add_campeonato_page.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class Inicio extends StatefulWidget {
  final String title;
  const Inicio({super.key, required this.title});

  @override
  State<StatefulWidget> createState() {
    return _Inicio();
  }
}

class _Inicio extends State<Inicio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                'Campeonatos',
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              ),
            ),
            buildListaCampeonatos(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddCampeonatoPage()))
              .then((value) => getCampeonatos())
        },
        tooltip: 'Novo Campeonato',
        child: const Icon(Icons.add),
      ),
    );
  }

  // Future<List<ParseObject>> getCampeonatos() async {
  //   QueryBuilder<ParseObject> queryBuilder =
  //       QueryBuilder<ParseObject>(ParseObject('Campeonato'));
  //   final ParseResponse apiResponse = await queryBuilder.query();

  //   if (apiResponse.success && apiResponse.results != null) {
  //     return apiResponse.results as List<ParseObject>;
  //   } else {
  //     return [];
  //   }
  // }

  Future<List<Campeonato>> getCampeonatos() async {
    return await CampeonatoRepository('Campeonato').getAll();
  }

  Widget buildListaCampeonatos() {
    return Expanded(
        child: FutureBuilder<List<Campeonato>>(
      future: getCampeonatos(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Container(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(),
              ),
            );
          default:
            if (snapshot.hasError) {
              return const Center(
                child: Text('Error...'),
              );
            }

            if (!snapshot.hasData) {
              return const Center(
                child: Text("Sem Campeonatos"),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                // final varCampeonato = snapshot.data![index];
                // final varNome = varCampeonato.get<String>('nome')!;
                // final varQtdJogadores = varCampeonato.get<int>('qtdJogadores')!;

                final varCampeonato = snapshot.data![index];
                final varNome = varCampeonato.nome;
                final varQtdJogadores = varCampeonato.qtdJogadores;

                return Card(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.green.shade50),
                      borderRadius: BorderRadius.circular(15.0)),
                  child: ListTile(
                    title: Text(varNome),
                    subtitle: Text(
                        'Jogadores: $varQtdJogadores\nStatus: em andamento'),
                    leading: const CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Icon(Icons.emoji_events),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {}, icon: const Icon(Icons.group_add))
                      ],
                    ),
                  ),
                );
                // return ListTile(
                //   title: Text(varNome),
                //   subtitle: Text('Jogadores: $varQtdJogadores'),
                //   leading: const CircleAvatar(
                //     backgroundColor: Colors.white,
                //     child: Icon(Icons.emoji_events),
                //   ),
                //   shape: Border(
                //     top: BorderSide(),
                //     bottom: BorderSide(),
                //   ),
                // );
              },
            );
        }
      },
    ));
  }
}
