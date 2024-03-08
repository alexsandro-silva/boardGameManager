import 'package:board_game_manager/basicas/jogador.dart';
import 'package:board_game_manager/basicas/rodata.dart';

class PartidasJogadores {
  String? id;
  Jogador? jogadorA;
  double? pontosA;
  Jogador? jogadorB;
  double? pontosB;
  Rodada? rodada;

  PartidasJogadores(this.id, this.jogadorA, this.pontosA, this.jogadorB,
      this.pontosB, this.rodada);
}
