import 'package:board_game_manager/basicas/partidas_jogadores.dart';
import 'package:board_game_manager/repositories/irepository.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class PartidasJogadoresRepository implements IRepository<PartidasJogadores> {
  final String _className;

  PartidasJogadoresRepository(this._className);

  @override
  Future<void> delete(String id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<PartidasJogadores>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<PartidasJogadores?> getOneById(String id) {
    // TODO: implement getOneById
    throw UnimplementedError();
  }

  @override
  Future<void> insert(PartidasJogadores t) async {
    final rodada = ParseObject(_className)
      ..set('jogador_a',
          (ParseObject('Jogador')..objectId = t.jogadorA?.id).toPointer())
      ..set('pontos_a', t.pontosA)
      ..set('jogador_b',
          (ParseObject('Jogador')..objectId = t.jogadorB?.id).toPointer())
      ..set('pontos_b', t.pontosB)
      ..set('rodada',
          (ParseObject('Rodada')..objectId = t.rodada?.id).toPointer());

    await rodada.save();
  }

  @override
  Future<void> update(PartidasJogadores t) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
