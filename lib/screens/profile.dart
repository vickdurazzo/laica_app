import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: const Text('Perfil')),
      body: const Center(
        child: Text('Tela de Perfil', style: TextStyle(fontSize: 24)),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
    );
  }
}
