import 'package:board_game_manager/basicas/jogador.dart';
import 'package:board_game_manager/basicas/match.dart';
import 'package:board_game_manager/repositories/jogador_repository.dart';
import 'package:board_game_manager/repositories/partidas_jogadores_repository.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class BoardGameManager {
  List<Jogador> players = [];
  List<Match> matches = [];
  String? idCampeonato;
  PartidasJogadoresRepository repository =
      PartidasJogadoresRepository('RodadasJogadores');

  BoardGameManager(this.idCampeonato);

  Set<String> matchedPairs =
      Set(); // Conjunto para armazenar pares já emparelhados

  void addPlayer(Jogador player) {
    players.add(player);
  }

  Future<void> addMatch(Match match) async {
    Match m = await repository.save(match);
    matches.add(m);
  }

  Future<void> giveByeToSomePlayer() async {
    for (var i = 0; i < players.length; i++) {
      if (players[i].bye == 0) {
        final byePlayer = ParseObject('Jogador')
          ..objectId = players[i].id
          ..set('bye', 1);
        await byePlayer.save();

        players.removeAt(i);
        return;
      } else {
        continue;
      }
    }
  }

  Future<String?> createRound() async {
    final rodada = ParseObject('Rodadas')
      ..set('data', DateTime.now())
      ..set('campeonato',
          (ParseObject('Campeonato')..objectId = idCampeonato).toPointer());

    await rodada.save();

    return rodada.objectId;
  }

  Future<List<Match>> matchPlayers() async {
    // RodadaRepository('Rodada').getAll();
    await getPlayers();

    print('MOD: ${players.length % 2}');
    if (players.length % 2 != 0) {
      final Jogador jogador = players.removeLast();
      if (jogador.bye! < 2) {
        jogador.incrementBye();
        jogador.setVictoryPoints(18);
      }
      await JogadorRepository('Jogador').update(jogador);

      //await giveByeToSomePlayer();
      print('Número ímpar de jogadores. Aguarde por um próximo jogo.');
      //return;
    }

    print('QUANTIDADE JOGADORES: ${players.length}');

    // players.sort((a, b) => a.skillLevel.compareTo(b.skillLevel));

    for (int i = 0; i < players.length; i += 2) {
      String pair = '${players[i].nome}-${players[i + 1].nome}';
      if (!matchedPairs.contains(pair)) {
        print('${players[i].nome} vs ${players[i + 1].nome}');
        matchedPairs.add(pair);

        await addMatch(Match(players[i], players[i + 1]));

        print(
            'Pareamento ${players[i].nome} vs ${players[i + 1].nome} realizado.');
      } else {
        print(
            'Pareamento ${players[i].nome} vs ${players[i + 1].nome} já ocorreu.');
      }
    }

    return matches;
  }

  Future<void> getPlayers() async {
    QueryBuilder<ParseObject> queryPlayers =
        QueryBuilder<ParseObject>(ParseObject('Jogador'));
    final ParseResponse apiResponse = await queryPlayers.query();

    if (apiResponse.success && apiResponse.results != null) {
      for (var element in apiResponse.results!) {
        addPlayer(Jogador(
            element.get<String>('objectId'),
            element.get<String>('nome'),
            element.get<String>('squad'),
            element.get<double>('missionPoints'),
            element.get<double>('victoryPoints'),
            element.get<double>('sos'),
            element.get<int>('bye')));
      }
      // return jogadores; //apiResponse.results as List<ParseObject>;
      // } else {
      //   return [];
    }
  }
}

// void main() {
//   var boardGameManager = BoardGameManager();

//   // Adicionando jogadores
//   boardGameManager.addPlayer(Player('Jogador 1', Random().nextInt(100)));
//   boardGameManager.addPlayer(Player('Jogador 2', Random().nextInt(100)));
//   boardGameManager.addPlayer(Player('Jogador 3', Random().nextInt(100)));
//   boardGameManager.addPlayer(Player('Jogador 4', Random().nextInt(100)));

//   // Emparelhando os jogadores e iniciando o jogo
//   boardGameManager.matchPlayers();
// }
