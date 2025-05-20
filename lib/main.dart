import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/setup_screen.dart';
import 'services/game_service.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => GameService(),
      child: const UndercoverApp(),
    ),
  );
}

class UndercoverApp extends StatelessWidget {
  const UndercoverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Undercover Game',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SetupScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
