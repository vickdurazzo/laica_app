import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: const Text('Em Desenvolvimento')),
      body: const Center(
        child: Text(
          'Desenvolvimento em andamento...',
          style: TextStyle(fontSize: 20),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }
}
