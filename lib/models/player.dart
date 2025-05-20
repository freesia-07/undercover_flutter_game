class Player {
  final String name;
  bool isUndercover;
  bool isEliminated;
  String secretWord;

  Player({
    required this.name,
    this.isUndercover = false,
    this.isEliminated = false,
    this.secretWord = '',
  });
}
