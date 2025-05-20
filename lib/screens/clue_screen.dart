import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/game_service.dart';
import 'result_screen.dart';
class ClueScreen extends StatefulWidget {
  const ClueScreen({super.key});

  @override
  State<ClueScreen> createState() => _ClueScreenState();
}
class _ClueScreenState extends State<ClueScreen> {
  int _currentSpeakerIndex = 0;
  bool _inVotingPhase = false;
  final Map<int, int> _votes = {}; // Map<playerIndex, voteCount>

  void _nextClue() {
    final game = context.read<GameService>();
    final alive = game.players.where((p) => !p.isEliminated).toList();

    if (_currentSpeakerIndex < alive.length - 1) {
      setState(() {
        _currentSpeakerIndex++;
      });
    } else {
      setState(() {
        _inVotingPhase = true;
      });
    }
  }

  void _voteFor(int votedIndex) {
    _votes[votedIndex] = (_votes[votedIndex] ?? 0) + 1;

    final totalVotes = _votes.values.reduce((a, b) => a + b);
    final aliveCount = context.read<GameService>().players.where((p) => !p.isEliminated).length;

    if (totalVotes >= aliveCount) {
      _processVotingResult();
    } else {
      setState(() {}); // Wait for all votes
    }
  }

  void _processVotingResult() {
    final game = context.read<GameService>();
    final entries = _votes.entries.toList();

    // Find top vote getter(s)
    entries.sort((a, b) => b.value.compareTo(a.value));
    if (entries.length > 1 && entries[0].value == entries[1].value) {
      // Tie: no one is eliminated
    } else {
      final eliminated = game.players.where((p) => !p.isEliminated).toList()[entries[0].key];
      eliminated.isEliminated = true;
    }

    _votes.clear();
    _currentSpeakerIndex = 0;
    _inVotingPhase = false;

    // Check win conditions
    _checkWinCondition();
  }

  void _checkWinCondition() {
  final game = context.read<GameService>();
  final alive = game.players.where((p) => !p.isEliminated).toList();

  final undercovers = alive.where((p) => p.isUndercover).length;

  if (undercovers == 0) {
    _showResult('Citizens Win! The Undercover was eliminated.');
  } else if (alive.length <= 2) {
    _showResult('Undercover Wins! Only two players remain.');
  } else {
    setState(() {
      _currentSpeakerIndex = 0;
    });
  }
}

  void _showResult(String message) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => ResultScreen(message: message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameService>();
    final alive = game.players.where((p) => !p.isEliminated).toList();

    if (!_inVotingPhase) {
      final player = alive[_currentSpeakerIndex];
      return Scaffold(
        appBar: AppBar(title: const Text('Give Your Clue')),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${player.name}, describe your word.',
                  style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _nextClue,
                child: const Text('Done (Next Player)'),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(title: const Text('Vote the Undercover')),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Text(
                'Vote for the player you think is the Undercover:',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              ...List.generate(alive.length, (index) {
                final p = alive[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: ElevatedButton(
                    onPressed: () => _voteFor(index),
                    child: Text(p.name),
                  ),
                );
              }),
              const SizedBox(height: 12),
              Text('Votes cast: ${_votes.values.fold(0, (a, b) => a + b)}'),
            ],
          ),
        ),
      );
    }
  }
}
