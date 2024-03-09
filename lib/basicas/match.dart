import 'package:board_game_manager/basicas/jogador.dart';
import 'package:board_game_manager/basicas/rodata.dart';

class Match {
  String? _id;
  Jogador? _jogadorA;
  double? _pontosA;
  Jogador? _jogadorB;
  double? _pontosB;
  Rodada? _rodada;

  Match([this._jogadorA, this._jogadorB]);

  Rodada? get rodada => _rodada;

  set rodada(Rodada? value) {
    _rodada = value;
  }

  double? get pontosB => _pontosB;

  set pontosB(double? value) {
    _pontosB = value;
  }

  Jogador? get jogadorB => _jogadorB;

  set jogadorB(Jogador? value) {
    _jogadorB = value;
  }

  double? get pontosA => _pontosA;

  set pontosA(double? value) {
    _pontosA = value;
  }

  Jogador? get jogadorA => _jogadorA;

  set jogadorA(Jogador? value) {
    _jogadorA = value;
  }

  String? get id => _id;

  set id(String? value) {
    _id = value;
  }
}
