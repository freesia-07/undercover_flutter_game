import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/game_service.dart';
import 'role_screen.dart';
class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}
class _SetupScreenState extends State<SetupScreen> {
  final _formKey = GlobalKey<FormState>();
  int _playerCount = 3;
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_playerCount, (_) => TextEditingController());
  }

  void _updatePlayerCount(int newCount) {
    setState(() {
      _playerCount = newCount;
      _controllers = List.generate(newCount, (i) {
        return i < _controllers.length
            ? _controllers[i]
            : TextEditingController();
      });
    });
  }

  void _startGame() {
    if (_formKey.currentState!.validate()) {
      final names = _controllers.map((c) => c.text.trim()).toList();
      context.read<GameService>().setPlayers(names);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const RoleScreen()),
      );
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Player Setup')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Player count input
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Number of Players:'),
                  DropdownButton<int>(
                    value: _playerCount,
                    items: List.generate(
                      10,
                      (index) => DropdownMenuItem(
                        value: index + 3,
                        child: Text('${index + 3}'),
                      ),
                    ),
                    onChanged: (val) {
                      if (val != null) _updatePlayerCount(val);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Player name inputs
              Expanded(
                child: ListView.builder(
                  itemCount: _playerCount,
                  itemBuilder: (_, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: TextFormField(
                        controller: _controllers[index],
                        decoration: InputDecoration(
                          labelText: 'Player ${index + 1} Name',
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Required' : null,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),

              // Start Game button
              ElevatedButton(
                onPressed: _startGame,
                child: const Text('Start Game'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
