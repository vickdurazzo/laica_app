import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:laica_app/widgets/app_subtitle.dart';
import 'package:laica_app/widgets/app_title.dart';
import '../widgets/card_widget.dart';
import '../widgets/image_widget.dart';
import '../widgets/bottom_nav.dart';
import '../models/planet.dart';
import '../utils/load_planets.dart';
import 'islands.dart'; 

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  late DateTime _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();

    // Log de visualização da tela
    analytics.logScreenView(
      screenName: 'MenuScreen',
      screenClass: 'MenuScreen',
    );

    // Evento customizado ao abrir
    analytics.logEvent(
      name: 'menu_screen_opened',
    );
  }

  @override
  void dispose() {
    
    final duration = DateTime.now().difference(_startTime);

    // Log do tempo de tela
    analytics.logEvent(
      name: 'tempo_tela',
      parameters: {
        'screen': 'MenuScreen',
        'seconds': duration.inSeconds,
      },
    );
    super.dispose();
  }

  void _handleButtonClick(nome, label) {
    analytics.logEvent(
      name: nome+"_button_clicked",
      parameters: {
        'label': label,
      },
    );
  }

  




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
                                _handleButtonClick("planet", planet.name);
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