import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: const Text('Menu')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: () {}, child: const Text('Botão 1')),
            ElevatedButton(onPressed: () {}, child: const Text('Botão 2')),
            ElevatedButton(onPressed: () {}, child: const Text('Botão 3')),
            ElevatedButton(onPressed: () {}, child: const Text('Botão 4')),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }
}
