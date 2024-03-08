import 'package:board_game_manager/basicas/jogador.dart';

class Match {
  Jogador? _jogadorA;
  Jogador? _jogadorB;

  Match(this._jogadorA, this._jogadorB);

  Jogador? get jogadorA {
    return _jogadorA;
  }

  Jogador? get jogadorB {
    return _jogadorB;
  }
}
