import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/player.dart';
import '../utils/word_pairs.dart';

class GameService extends ChangeNotifier {
  List<Player> players = [];
  late String citizenWord;
  late String undercoverWord;

  void setPlayers(List<String> names) {
    players = names.map((name) => Player(name: name)).toList();
    _assignRolesAndWords();
    notifyListeners();
  }

  void _assignRolesAndWords() {
    final pair = WordPairs.getRandomPair();
    citizenWord = pair.citizen;
    undercoverWord = pair.undercover;

    final random = Random();
    int undercoverIndex = random.nextInt(players.length);

    for (int i = 0; i < players.length; i++) {
      players[i].isUndercover = i == undercoverIndex;
      players[i].isEliminated = false;
      players[i].secretWord = i == undercoverIndex ? undercoverWord : citizenWord;
    }
  }

  List<Player> get alivePlayers => players.where((p) => !p.isEliminated).toList();

  bool isGameOver() {
    final alive = alivePlayers;
    final undercovers = alive.where((p) => p.isUndercover).length;

    return undercovers == 0 || alive.length <= 2;
  }

  String getGameResultMessage() {
    final alive = alivePlayers;
    final undercovers = alive.where((p) => p.isUndercover).length;

    if (undercovers == 0) {
      return "Citizens Win! The Undercover was eliminated.";
    } else if (alive.length <= 2) {
      return "Undercover Wins! Only two players remain.";
    }
    return '';
  }

  void eliminatePlayer(Player player) {
    player.isEliminated = true;
    notifyListeners();
  }

  void resetGame() {
    players.clear();
    citizenWord = '';
    undercoverWord = '';
    notifyListeners();
  }
}
