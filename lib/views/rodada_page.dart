import 'dart:async';

import 'package:board_game_manager/basicas/campeonato.dart';
import 'package:board_game_manager/basicas/jogador.dart';
import 'package:board_game_manager/basicas/match.dart';
import 'package:board_game_manager/basicas/rodata.dart';
import 'package:board_game_manager/core/board_game_manager.dart';
import 'package:board_game_manager/repositories/campeonato_repository.dart';
import 'package:board_game_manager/repositories/irepository.dart';
import 'package:board_game_manager/repositories/jogador_repository.dart';
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
  int _round = 0;
  final List<Match> _matches = <Match>[];
  final RodadaRepository repository = RodadaRepository('Rodada');
  final IRepository jogadorRepository = JogadorRepository('Jogador');
  final Map<String, TextEditingController> _controllerMap = Map();
  List<Match> matches = <Match>[];
  List<Campeonato> listaCampeonatos = <Campeonato>[];
  Campeonato? campeonatoSelecionado;
  Rodada? rodadaAtual;

  @override
  void dispose() {
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
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                      onPressed: campeonatoSelecionado == null
                          ? null
                          : () async {
                              setState(() {
                                _round++;
                              });
                              Rodada rodada =
                                  Rodada("", _round, campeonatoSelecionado);
                              rodadaAtual =
                                  await repository.saveAndReturn(rodada);
                            },
                      child: const Text("Nova Rodada")),
                )
              ],
            )),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: _round > 0
                ? Text(
                    "Rodada $_round",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20.0),
                  )
                : null,
          ),
          Expanded(
            child: FutureBuilder<List<Match>>(
              future:
                  newRound(), //BoardGameManager('G5aO6VhddK').matchPlayers(),
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
                          final varMatch = snapshot.data![index];
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
                                        '${varMatch.jogadorA!.id}'),
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
                                        '${varMatch.jogadorB!.id}'),
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
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      onPressed: _round == 0
                          ? null
                          : () async {
                              // BoardGameManager gameManager =
                              //     BoardGameManager('G5aO6VhddK');
                              // _matches = await gameManager.matchPlayers();
                              // print(_matches);
                              _controllerMap.forEach((key, controller) {
                                if (_controllerMap[key]?.text.trim() == "") {
                                  SnackBar snackBar = const SnackBar(
                                    content: Text(
                                        'Todos os resultados devem ser preenchidos!'),
                                    backgroundColor: Colors.red,
                                    duration: Duration(seconds: 3),
                                  );
                                  ScaffoldMessenger.of(context)
                                    ..removeCurrentSnackBar()
                                    ..showSnackBar(snackBar);
                                  return;
                                }
                              });
                              salvaResultados();
                            },
                      child: const Text('Salvar Resultados'),
                    ),
                  )))
        ],
      )),
    );
  }

  SnackBar _showSnackBar({String? message, Color? color}) {
    SnackBar snackBar = SnackBar(
      content: Text(message!),
      backgroundColor: color,
      duration: const Duration(seconds: 3),
    );
    return snackBar;
  }

  void salvaResultados() {
    _controllerMap.forEach((key, controller) async {
      print('$key - ${_controllerMap[key]?.text}');
      Jogador jogador = await jogadorRepository.getOneById(key);
      jogador.setVictoryPoints(double.parse(controller.text.trim()));
      jogador.setMissionPoints(double.parse(controller.text.trim()));
      JogadorRepository('Jogador').update(jogador).then((value) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(_showSnackBar(
              message: 'Resultados salvos!', color: Colors.green));
      }).catchError((e) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
              _showSnackBar(message: 'Algo saiu errado', color: Colors.red));
      });
    });
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

  Future<List<Match>> newRound() async {
    if (_round == 0) {
      return matches;
    }

    return await BoardGameManager(campeonatoSelecionado?.id).matchPlayers();
  }

  Jogador getPlayerFromMatchList(String id) {
    Match match = _matches.firstWhere(
        (element) => element.jogadorA?.id == id || element.jogadorB?.id == id);
    return match.jogadorA?.id == id ? match.jogadorA! : match.jogadorB!;
  }

  Widget buildCampeonatoDropDown() {
    // listaCampeonatos = await CampeonatoRepository('Campeonato').getAll();

    // dropdownValue = listaCampeonatos.first.nome;

    return DropdownButtonFormField(
      hint: const Text("Selecione um campeonato"),
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
