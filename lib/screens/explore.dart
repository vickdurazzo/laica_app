import 'package:flutter/material.dart';
import 'package:laica_app/widgets/app_title.dart';


import '../widgets/bottom_nav.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      backgroundColor: const Color(0xFF1B1A3B),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[    
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: AppTitle(text:'Nave em ajustes...Em breve aventuras perto de você!'),
                    ),
                  
                  const SizedBox(height: 20),
                  Center(
                    child: Image.asset(
                      "assets/images/naveQuebrada.png",
                      width: 400,
                      height: 400,
                    ),
                  ),
                  const SizedBox(height: 20),

                 
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}
