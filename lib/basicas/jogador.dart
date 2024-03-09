class Jogador {
  String? id;
  String? nome;
  String? squad;
  double? missionPoints;
  double? victoryPoints;
  double? sos;
  int? bye;
  double? numVitorias;
  double? numEmpates;
  double? numDerrotas;

  Jogador(
      this.id,
      this.nome,
      this.squad,
      this.missionPoints,
      this.victoryPoints,
      this.sos,
      this.bye,
      this.numVitorias,
      this.numEmpates,
      this.numDerrotas);

  void incrementBye() {
    bye = bye! + 1;
  }

  void setVictoryPoints(double points) {
    victoryPoints = victoryPoints! + points;
  }

  void setMissionPoints(double points) {
    missionPoints = missionPoints! + points;
  }
}
