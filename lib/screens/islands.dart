// island_screen.dart
import 'package:flutter/material.dart';
import '../models/planet.dart';

class IslandScreen extends StatelessWidget {
  final Planet planet;

  const IslandScreen({super.key, required this.planet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1A3B),
      appBar: AppBar(
        title: Text(planet.name),
        backgroundColor: const Color(0xFF1B1A3B),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text(
          'Ilhas do planeta: ${planet.name}',
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
