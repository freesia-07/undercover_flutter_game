import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/game_service.dart';
import 'setup_screen.dart';
class ResultScreen extends StatelessWidget {
  final String message;

  const ResultScreen({super.key, required this.message});

  void _restartGame(BuildContext context) {
    context.read<GameService>().resetGame();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const SetupScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final players = context.watch<GameService>().players;

    return Scaffold(
      appBar: AppBar(title: const Text('Game Over')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              message,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            const Text(
              'Player Roles:',
              style: TextStyle(fontSize: 18, decoration: TextDecoration.underline),
            ),
            const SizedBox(height: 12),

            ...players.map((player) => ListTile(
                  title: Text(player.name),
                  trailing: Text(
                    player.isUndercover ? 'Undercover' : 'Citizen',
                    style: TextStyle(
                      color: player.isUndercover ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),

            const Spacer(),

            ElevatedButton(
              onPressed: () => _restartGame(context),
              child: const Text('Play Again'),
            ),
          ],
        ),
      ),
    );
  }
}
