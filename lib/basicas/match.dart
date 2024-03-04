import 'package:board_game_manager/basicas/jogador.dart';

class Match {
  Jogador? jogadorA;
  Jogador? jogadorB;

  Match(this.jogadorA, this.jogadorB);

  Jogador? get _jogadorA {
    return jogadorA;
  }

  Jogador? get _jogadorB {
    return jogadorB;
  }
}
