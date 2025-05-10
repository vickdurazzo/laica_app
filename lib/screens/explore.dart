import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:laica_app/widgets/app_title.dart';
import '../widgets/bottom_nav.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  late DateTime _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();

    // Log de visualização da tela
    analytics.logScreenView(
      screenName: 'ExploreScreen',
      screenClass: 'ExploreScreen',
    );

    // Evento customizado ao abrir
    analytics.logEvent(
      name: 'explore_screen_opened',
    );
  }

  @override
  void dispose() {
    
    final duration = DateTime.now().difference(_startTime);

    // Log do tempo de tela
    analytics.logEvent(
      name: 'tempo_tela',
      parameters: {
        'screen': 'ExploreScreen',
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
