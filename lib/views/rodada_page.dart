import 'dart:async';

import 'package:board_game_manager/basicas/campeonato.dart';
import 'package:board_game_manager/basicas/match.dart';
import 'package:board_game_manager/core/board_game_manager.dart';
import 'package:board_game_manager/repositories/campeonato_repository.dart';
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
  final Map<String, TextEditingController> _controllerMap = Map();
  List<Campeonato> listaCampeonatos = <Campeonato>[];
  Campeonato? campeonatoSelecionado;

  @override
  void disponse() {
    _controllerMap.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getCampeonatos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rodadas'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: (Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                top: 10.0, right: 20.0, left: 20.0, bottom: 15.0),
            child: Form(
                child: Column(
              children: [
                buildCampeonatoDropDown(),
                ElevatedButton(onPressed: () {}, child: Text("Nova Rodada"))
              ],
            )),
          ),
          Expanded(
            child: FutureBuilder<List<Match>>(
              future: BoardGameManager('G5aO6VhddK').matchPlayers(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Match>?> snapshot) {
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
                            top: 10.0, left: 10.0, right: 10.0),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final varMatch = snapshot!.data![index];
                          //final varController = _getControllerOf('${varMatch.jogadorA!.nome}vs${varMatch.jogadorB!.nome}');
                          // return ListTile(
                          //   title: Text(
                          //       '${varMatch.jogadorA!.nome} vs ${varMatch.jogadorB!.nome}'),
                          // );
                          return Row(
                            children: <Widget>[
                              Text(
                                varMatch.jogadorA!.nome!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25.0),
                              ),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 30, right: 30, bottom: 10),
                                  child: TextField(
                                    controller: _getControllerOf(
                                        '${varMatch.jogadorA!.nome}vs${varMatch.jogadorB!.nome}-$index'),
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ),
                              const Text(
                                'X',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25.0),
                              ),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 30, right: 30, bottom: 10),
                                  child: TextField(
                                    controller: _getControllerOf(
                                        '${varMatch.jogadorA!.nome}vs${varMatch.jogadorB!.nome}-$index'),
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                varMatch.jogadorB!.nome!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25.0),
                              ),
                            ],
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

  TextEditingController _getControllerOf(String key) {
    var controller = _controllerMap[key];
    if (controller == null) {
      controller = TextEditingController();
      _controllerMap[key] = controller;
    }
    return controller;
  }

  Future<void> getCampeonatos() async {
    final result = await CampeonatoRepository('Campeonato').getAll();
    setState(() {
      listaCampeonatos = result;
    });
  }

  Widget buildCampeonatoDropDown() {
    // listaCampeonatos = await CampeonatoRepository('Campeonato').getAll();

    // dropdownValue = listaCampeonatos.first.nome;

    return DropdownButtonFormField(
      hint: Text("Selecione um campeonato"),
      value: campeonatoSelecionado,
      onChanged: (Campeonato? value) {
        setState(() {
          campeonatoSelecionado = value;
        });
      },
      items: listaCampeonatos.map((Campeonato value) {
        return DropdownMenuItem<Campeonato>(
          value: value,
          child: Text(value.nome),
        );
      }).toList(),
    );
  }
}
