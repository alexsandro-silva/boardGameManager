import 'package:board_game_manager/basicas/match.dart';
import 'package:board_game_manager/core/board_game_manager.dart';
import 'package:board_game_manager/repositories/irepository.dart';
import 'package:board_game_manager/repositories/rodada_repository.dart';
import 'package:flutter/material.dart';

class RodadaPage extends StatefulWidget {
  const RodadaPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RodadaPage();
  }
}

class _RodadaPage extends State<RodadaPage> {
  int _idRodada = 0;
  List<Match> _matches = <Match>[];
  final IRepository repository = RodadaRepository('Rodada');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rodadas'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: (Column(
        children: <Widget>[
          Expanded(
            child: FutureBuilder<List<Match>>(
              future: BoardGameManager('G5aO6VhddK').matchPlayers(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(
                      child: Container(
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator()),
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
                        padding: const EdgeInsets.only(top: 10.0),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final varMatch = snapshot!.data![index];
                          return ListTile(
                            title: Text(
                                '${varMatch.jogadorA!.nome} vs ${varMatch.jogadorB!.nome}'),
                          );
                        },
                      );
                    }
                }
              },
            ),
          ),
          Expanded(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        BoardGameManager gameManager =
                            BoardGameManager('G5aO6VhddK');
                        _matches = await gameManager.matchPlayers();
                        print(_matches);
                      },
                      child: Text('Gerar Rodada'),
                    ),
                  )))
        ],
      )),
    );
  }
}
