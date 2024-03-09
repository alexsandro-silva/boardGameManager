import 'package:board_game_manager/basicas/match.dart';
import 'package:board_game_manager/repositories/irepository.dart';
import 'package:board_game_manager/repositories/jogador_repository.dart';
import 'package:board_game_manager/repositories/rodada_repository.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../basicas/jogador.dart';
import '../basicas/rodata.dart';

class PartidasJogadoresRepository implements IRepository<Match> {
  final String _className;

  PartidasJogadoresRepository(this._className);

  @override
  Future<void> delete(String id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<Match>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<Match?> getOneById(String id) async {
    final QueryBuilder<ParseObject> query =
        QueryBuilder<ParseObject>(ParseObject(_className))
          ..whereEqualTo('objectId', id);

    final ParseResponse response = await query.query();

    if (response.success && response.results != null) {
      ParseObject obj = response.results?.first;
      //consulta o jogador a
      final String? idJogadorA = obj.get<ParseObject>('jogador_a')?.objectId;
      final Jogador? jogadorA =
          await JogadorRepository('Jogador').getOneById(idJogadorA!);

      //consulta o jogador b
      final String? idJogadorB = obj.get<ParseObject>('jogador_b')?.objectId;
      final Jogador? jogadorB =
          await JogadorRepository('Jogador').getOneById(idJogadorB!);

      //consulta a rodada
      final String? idRodada = obj.get<ParseObject>('rodada')?.objectId;
      final Rodada? rodada =
          await RodadaRepository('Rodada').getOneById(idRodada);

      Match match = Match();
      match.id = obj.get<String>('objectId')!;
      match.jogadorA = jogadorA;
      match.pontosA = obj.get<double>('pontos_a');
      match.jogadorB = jogadorB;
      match.pontosB = obj.get<double>('pontos_b');
      match.rodada = rodada;

      return match;
    }

    return null;
  }

  @override
  Future<void> insert(Match t) async {
    final rodada = ParseObject(_className)
      ..set('jogador_a',
          (ParseObject('Jogador')..objectId = t.jogadorA?.id).toPointer())
      //..set('pontos_a', t.pontosA)
      ..set('jogador_b',
          (ParseObject('Jogador')..objectId = t.jogadorB?.id).toPointer());
    //..set('pontos_b', t.pontosB)
    //..set('rodada',
    //    (ParseObject('Rodada')..objectId = t.rodada?.id).toPointer());

    await rodada.save();
  }

  /**
   * Salva partida e retorna objeto com id
   */
  Future<Match> save(Match t) async {
    final rodada = ParseObject(_className)
      ..set('jogador_a',
          (ParseObject('Jogador')..objectId = t.jogadorA?.id).toPointer())
      ..set('jogador_b',
          (ParseObject('Jogador')..objectId = t.jogadorB?.id).toPointer());

    await rodada.save();
    t.id = rodada.objectId;
    return t;
  }

  @override
  Future<void> update(Match t) async {
    var partida = ParseObject(_className)..objectId = t.id;
    partida.set('jogador_a',
        (ParseObject('Jogador')..objectId = t.jogadorA?.id).toPointer());
    if (t.pontosA != null) {
      partida.set('pontos_a', t.pontosA);
    }
    partida.set('jogador_b',
        (ParseObject('Jogador')..objectId = t.jogadorB?.id).toPointer());
    if (t.pontosB != null) {
      partida.set('pontos_b', t.pontosB);
    }
    partida.set(
        'rodada', (ParseObject('Rodada')..objectId = t.rodada?.id).toPointer());
    await partida.save();
  }

  Future<void> saveResults(Map<dynamic, dynamic> resultados) async {
    var partida = ParseObject(_className)..objectId = resultados['partida'];
    if (resultados['pontosA'] != null) {
      partida.set('pontos_a', resultados['pontosA']);
    }
    if (resultados['pontosB'] != null) {
      partida.set('pontos_b', resultados['pontosB']);
    }
    partida.set('rodada',
        (ParseObject('Rodada')..objectId = resultados['rodada']).toPointer());

    partida.save();
  }
}
