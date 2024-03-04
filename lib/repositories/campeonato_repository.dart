import 'package:board_game_manager/basicas/campeonato.dart';
import 'package:board_game_manager/repositories/irepository.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class CampeonatoRepository extends IRepository<Campeonato> {
  final String _className;

  CampeonatoRepository(this._className);

  @override
  Future<void> delete(String id) async {
    var campeonato = ParseObject(_className)..objectId = id;
    await campeonato.delete();
  }

  @override
  Future<List<Campeonato>> getAll() async {
    List<Campeonato> campeonatos = [];
    QueryBuilder<ParseObject> queryBuilder =
        QueryBuilder<ParseObject>(ParseObject(_className));

    final ParseResponse response = await queryBuilder.query();

    if (response.success && response.results != null) {
      var list = response.results as List<ParseObject>;
      for (var element in list) {
        campeonatos.add(Campeonato(element.get<String>('objectId')!,
            element.get<String>('nome')!, element.get<int>('qtdJogadores')!));
      }
    } else {
      return [];
    }

    return campeonatos;
  }

  @override
  Future<Campeonato?> getOneById(String id) async {
    final QueryBuilder<ParseObject> query =
        QueryBuilder<ParseObject>(ParseObject(_className));
    query.whereEquals(id);

    final ParseResponse response = await query.query();

    if (response.success && response.results != null) {
      ParseObject obj = response.results?.first();
      return Campeonato(obj.get<String>('objectId')!, obj.get<String>('nome')!,
          obj.get<int>('qtdJogadores')!);
    }

    return null;
  }

  @override
  Future<void> insert(Campeonato t) async {
    final campeonato = ParseObject(_className)
      ..set('nome', t.nome)
      ..set('qtdJogadores', t.qtdJogadores);

    await campeonato.save();
  }

  @override
  Future<void> update(Campeonato t) async {
    var campeonato = ParseObject(_className)
      ..objectId = t.id
      ..set('nome', t.nome)
      ..set('qtdJogadores', t.qtdJogadores);

    await campeonato.save();
  }
}
