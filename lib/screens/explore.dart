import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: const Text('Ajustes')),
      body: const Center(
        child: Text(
          'Nave em ajustes... novas aventuras em breve',
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}
