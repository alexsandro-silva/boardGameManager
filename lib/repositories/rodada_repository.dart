import 'package:board_game_manager/basicas/campeonato.dart';
import 'package:board_game_manager/basicas/rodata.dart';
import 'package:board_game_manager/repositories/campeonato_repository.dart';
import 'package:board_game_manager/repositories/irepository.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class RodadaRepository implements IRepository<Rodada> {
  final String _className;

  RodadaRepository(this._className);

  @override
  Future<void> delete(String id) async {
    var rodada = ParseObject(_className)..objectId = id;
    await rodada.delete();
  }

  // @override
  // Future<List<Rodada>> getAll() async {
  //   List<Rodada> rodadas = [];
  //   final QueryBuilder<ParseObject> campeonatoQuery =
  //       QueryBuilder<ParseObject>(ParseObject('Campeonato'))
  //         ..whereEqualTo('objectId', 'G5aO6VhddK');

  //   final ParseResponse pr = await campeonatoQuery.query();
  //   if (pr.success) {
  //     final a = pr.results?.first! as ParseObject;
  //     print('CAMPEONATO ENCONTRADO: ${a.get('nome')}');
  //   }

  //   final QueryBuilder<ParseObject> rodadaQuery =
  //       QueryBuilder<ParseObject>(ParseObject('Rodada'))
  //         ..whereMatchesQuery('id_campeonato', campeonatoQuery);

  //   // QueryBuilder<ParseObject> queryBuilder =
  //   //     QueryBuilder<ParseObject>(ParseObject(_className));

  //   //final ParseResponse response = await queryBuilder.query();
  //   final ParseResponse response = await rodadaQuery.query();

  //   if (response.success && response.results != null) {
  //     var list = response.results as List<ParseObject>;
  //     for (var element in list) {
  //       // var c = QueryBuilder<ParseObject>(ParseObject('Campeonato'))
  //       //   ..whereRelatedTo('id_campeonato', _className, element.objectId!);
  //       // final ParseResponse pr = await c.query();

  //       // var r = (pr.results as List<ParseObject>).first;
  //       print('RODADA: ${element.get<double>('NumRodada')}');
  //       // campeonatos.add(Campeonato(element.get<String>('objectId')!,
  //       //     element.get<String>('nome')!, element.get<int>('qtdJogadores')!));
  //     }
  //   } else {
  //     return [];
  //   }

  //   return [];
  // }

  @override
  Future<List<Rodada>> getAll() async {
    List<Rodada> rodadas = [];

    QueryBuilder<ParseObject> queryBuilder =
        QueryBuilder<ParseObject>(ParseObject(_className));

    final ParseResponse response = await queryBuilder.query();

    if (response.success && response.results != null) {
      var list = response.results as List<ParseObject>;
      for (var element in list) {
        //pega o id do campeonato
        final String? idCampeonato =
            element.get<ParseObject>('id_campeonato')?.objectId;
        //busca o campeonato por id
        final Campeonato? campeonato =
            await CampeonatoRepository('Campeonato').getOneById(idCampeonato!);

        rodadas.add(Rodada(
            element.objectId, element.get<int>('NumRodada'), campeonato));
      }
    } else {
      return [];
    }

    return rodadas;
  }

  @override
  Future<Rodada?> getOneById(String id) async {
    final QueryBuilder<ParseObject> query =
        QueryBuilder<ParseObject>(ParseObject(_className))
          ..whereEqualTo('objectId', id);

    final ParseResponse response = await query.query();

    if (response.success && response.results != null) {
      ParseObject obj = response.results?.first;
      //pega o id do campeonato
      final String? idCampeonato =
          obj.get<ParseObject>('id_campeonato')?.objectId;
      //busca o campeonato por id
      final Campeonato? campeonato =
          await CampeonatoRepository('Campeonato').getOneById(idCampeonato!);

      return Rodada(
          obj.get<String>('objectId')!, obj.get<int>('NumRodada')!, campeonato);
    }

    return null;
  }

  @override
  Future<void> insert(Rodada t) async {
    final rodada = ParseObject(_className)
      ..set('NumRodada', t.numRodada)
      ..set('id_campeonato',
          (ParseObject('Campeonato')..objectId = t.campeonato?.id).toPointer());

    await rodada.save();
  }

  @override
  Future<void> update(Rodada t) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
