import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/game_service.dart';
import 'clue_screen.dart';
class RoleScreen extends StatefulWidget {
  const RoleScreen({super.key});

  @override
  State<RoleScreen> createState() => _RoleScreenState();
}
class _RoleScreenState extends State<RoleScreen> {
  int _currentPlayerIndex = 0;
  bool _isRevealed = false;

  void _next() {
    if (_isRevealed) {
      // Go to next player or next screen
      if (_currentPlayerIndex < context.read<GameService>().players.length - 1) {
        setState(() {
          _currentPlayerIndex++;
          _isRevealed = false;
        });
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ClueScreen()),
        );
      }
    } else {
      setState(() {
        _isRevealed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final player = context.watch<GameService>().players[_currentPlayerIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('Role Assignment')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Player ${_currentPlayerIndex + 1}: ${player.name}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),

              if (_isRevealed)
                Column(
                  children: [
                    Text(
                      player.isUndercover ? 'You are the Undercover!' : 'You are a Citizen!',
                      style: TextStyle(
                        fontSize: 22,
                        color: player.isUndercover ? Colors.red : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Your word is:',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      player.secretWord,
                      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              else
                const Text(
                  'Tap the button to reveal your role.',
                  style: TextStyle(fontSize: 16),
                ),

              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _next,
                child: Text(_isRevealed ? 'Next Player' : 'Reveal Role'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
