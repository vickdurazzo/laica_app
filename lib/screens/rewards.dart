import 'package:flutter/material.dart';
import 'package:laica_app/widgets/app_title.dart';
import 'package:laica_app/widgets/ProductPromoBanner.dart';



import '../widgets/bottom_nav.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

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
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: AppTitle(text: 'Recompensas estelares a caminho!'),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Image.asset(
                        "assets/images/recompensas.png",
                        width: 400,
                        height: 400,
                      ),
                    ),
                    // 👇 Esse espaçamento será negativo para o banner "subir"
                    Transform.translate(
                      offset: const Offset(0, -100),
                      child: ProductPromoBanner(
                        title: 'Desbloqueie mais aventuras!',
                        description:
                            'Adquira agora para liberar conteúdos exclusivos e fortalecer laços com seus filhos.',
                        buttonText: 'Comprar agora',
                        url: 'https://www.instagram.com/laicasolutions/',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: const BottomNavBar(currentIndex: 2),
      );


  }
}
