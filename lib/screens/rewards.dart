import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:laica_app/widgets/ProductPromoBanner.dart';
import 'package:laica_app/widgets/app_title.dart';
import '../widgets/bottom_nav.dart';


class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  late DateTime _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();

    // Log de visualização da tela
    analytics.logScreenView(
      screenName: 'RewardsScreen',
      screenClass: 'RewardsScreen',
    );

    // Evento customizado ao abrir
    analytics.logEvent(
      name: 'rewards_screen_opened',
    );
  }

  @override
  void dispose() {
    
    final duration = DateTime.now().difference(_startTime);

    // Log do tempo de tela
    analytics.logEvent(
      name: 'tempo_tela',
      parameters: {
        'screen': 'RewardsScreen',
        'seconds': duration.inSeconds,
      },
    );
    super.dispose();
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
                      offset: const Offset(0, -200),
                      child: ProductPromoBanner(
                        title: 'Troque seus pontos por recompensas!',
                        description:
                            'Possibilidade de troca de pontos por prêmios, oportunidades especiais para nossos astronautas exploradores. Avalie sua experiência e entre na lista para receber de antemão os benefícios',
                        buttonText: 'Avaliar',
                        
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