
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:laica_app/widgets/app_subtitle.dart';
import 'package:laica_app/widgets/app_title.dart';
import '../widgets/card_widget.dart';
import '../widgets/image_widget.dart';
import '../widgets/bottom_nav.dart';
import '../models/planet.dart';
import '../utils/load_planets.dart';
import 'islands.dart'; 

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
   Widget build(BuildContext context) {
    // Envia log de visualização da tela
    Future.microtask(() {
      FirebaseAnalytics.instance.logScreenView(
        screenName: 'MenuScreen',
        screenClass: 'MenuScreen',
      );
    });
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
            child: FutureBuilder<List<Planet>>(
              future: loadPlanets(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.white));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                }

                final planets = snapshot.data!;

                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topRight,
                        child: Image.asset(
                          'assets/images/logo.png',
                          height: 50,
                        ),
                      ),
                      const SizedBox(height: 20),
                      AppTitle(text: "Para onde vamos?"),
                      AppSubtitle(text: "Selecione um planeta"),
                      const SizedBox(height: 20),
                      Expanded(
                        child: GridView.builder(
                          itemCount: planets.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1.2,
                          ),
                          itemBuilder: (context, index) {
                            final planet = planets[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => IslandsScreen(planet: planet),
                                  ),
                                );
                              },
                              child: CardWidget(
                                

                                child: ImageWidget(
                                  image: planet.image,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                               
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }
}
