import 'package:board_game_manager/basicas/jogador.dart';
import 'package:board_game_manager/repositories/irepository.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class JogadorRepository extends IRepository<Jogador> {
  final String _className;

  JogadorRepository(this._className);
  @override
  Future<void> delete(String id) async {
    var jogador = ParseObject(_className)..objectId = id;
    await jogador.delete();
  }

  @override
  Future<List<Jogador>> getAll() async {
    List<Jogador> jogadores = [];
    QueryBuilder<ParseObject> queryBuilder =
        QueryBuilder<ParseObject>(ParseObject(_className));

    final ParseResponse response = await queryBuilder.query();

    if (response.success && response.results != null) {
      var list = response.results as List<ParseObject>;
      for (var element in list) {
        jogadores.add(Jogador(
            element.objectId,
            element.get<String>('nome'),
            element.get<String>('squad'),
            element.get<double>('missionPoints'),
            element.get<double>('victoryPoints'),
            element.get<double>('sos'),
            element.get<int>('bye')));
      }
    } else {
      return [];
    }

    return jogadores;
  }

  @override
  Future<Jogador?> getOneById(String id) async {
    final QueryBuilder<ParseObject> query =
        QueryBuilder<ParseObject>(ParseObject(_className));
    query.whereEquals(id);

    final ParseResponse response = await query.query();

    if (response.success && response.results != null) {
      ParseObject obj = response.results?.first();
      return Jogador(
          obj.objectId,
          obj.get<String>('nome'),
          obj.get<String>('squad'),
          obj.get<double>('missionPoints'),
          obj.get<double>('victoryPoints'),
          obj.get<double>('sos'),
          obj.get<int>('bye'));
    }

    return null;
  }

  @override
  Future<void> insert(Jogador t) async {
    final jogador = ParseObject(_className)
      ..set('nome', t.nome)
      ..set('squad', t.squad);

    await jogador.save();
  }

  @override
  Future<void> update(Jogador t) async {
    var jogador = ParseObject(_className)
      ..objectId = t.id
      ..set('nome', t.nome)
      ..set('squad', t.squad)
      ..set('missionPoints', t.missionPoints)
      ..set('victoryPoints', t.victoryPoints)
      ..set('sos', t.sos)
      ..set('bye', t.bye);

    await jogador.save();
  }
}
