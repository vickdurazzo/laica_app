import 'package:flutter/material.dart';
import '../widgets/card_widget.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/image_widget.dart'; // Importa o componente de imagem

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1A3B),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/background.png',
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Image.asset(
                      'assets/logo.png',
                      height: 50,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Para onde vamos?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ✅ Grid com os CardWidgets usando ImageWidget
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                    physics: const NeverScrollableScrollPhysics(),
                    children: const [
                      CardWidget(
                        child: ImageWidget(
                          image: 'familyPlanet.png',
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      CardWidget(
                        child: ImageWidget(
                          image: 'heartPlanet.png',
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      CardWidget(
                        child: ImageWidget(
                          image: 'funPlanet.png',
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      CardWidget(
                        child: ImageWidget(
                          image: 'emotionsPlanet.png',
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }
}
