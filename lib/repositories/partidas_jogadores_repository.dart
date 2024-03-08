import 'package:board_game_manager/basicas/match.dart';
import 'package:board_game_manager/repositories/irepository.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

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
  Future<Match?> getOneById(String id) {
    // TODO: implement getOneById
    throw UnimplementedError();
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
    var partida = ParseObject(_className)
      ..objectId = t.id
      ..set('jogador_a',
          (ParseObject('Jogador')..objectId = t.jogadorA?.id).toPointer())
      ..set('pontos_a', t.pontosA)
      ..set('jogador_b',
          (ParseObject('Jogador')..objectId = t.jogadorB?.id).toPointer())
      ..set('pontos_b', t.pontosB)
      ..set('rodada',
          (ParseObject('Rodada')..objectId = t.rodada?.id).toPointer());

    await partida.save();
  }
}
