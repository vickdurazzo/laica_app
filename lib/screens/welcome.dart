// Exemplo de como implementar o plano de tagueamento Firebase Analytics
// Aplicável a cada tela do seu app
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:laica_app/widgets/app_subtitle.dart';
import 'package:laica_app/widgets/app_title.dart';
import '../widgets/primary_button.dart';
import '../utils/device_utils.dart'; // Import the helper

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  late DateTime _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();

    // Log de visualização da tela
    analytics.logScreenView(
      screenName: 'WelcomeScreen',
      screenClass: 'WelcomeScreen',
    );

    // Evento customizado ao abrir
    analytics.logEvent(
      name: 'welcome_screen_opened',
    );
  }

  @override
  void dispose() {
    final duration = DateTime.now().difference(_startTime);

    // Log do tempo de tela
    analytics.logEvent(
      name: 'tempo_tela',
      parameters: {
        'screen': 'WelcomeScreen',
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final bool isMobile = DeviceUtils.isMobile();

    return Scaffold(
      backgroundColor: const Color(0xFF1B1A3B),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background
          Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
          ),

          // Show banner if NOT mobile
          if (!isMobile)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: const Center(
                  child: Text(
                    'Esta aplicação funciona melhor em dispositivos móveis.',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

          // Logo
          Positioned(
            top: screenHeight * 0.05 + (isMobile ? 0 : 30), // offset banner if shown
            right: screenWidth * 0.08,
            child: Image.asset(
              'assets/images/logo.png',
              height: screenHeight * 0.05,
            ),
          ),

          // Central content
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    // Rocket
                    Image.asset(
                      'assets/images/rocket_dog.png',
                      height: screenHeight * 0.35,
                      fit: BoxFit.contain,
                    ),

                    // Title text overlapping
                    Positioned(
                      bottom: -screenHeight * 0.06,
                      child: AppTitle(text: 'Bem-vindos à\nmissão Laica'),
                    ),
                  ],
                ),

                const SizedBox(height: 60),
                AppSubtitle(text: 'Prontos para embarcar no foguete ?'),
                const SizedBox(height: 30),

                SizedBox(
                  width: screenWidth * 0.8,
                  child: PrimaryButton(
                    text: 'Embarcar',
                    onPressed: () {
                      _handleButtonClick('embarcar', 'botao_embarcar');
                      Navigator.pushNamed(context, '/login');
                    },
                  ),
                ),
              ],
            ),
          ),

          // Bottom link
          Positioned(
            bottom: screenHeight * 0.03,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                _handleButtonClick('register', 'register_button');
                Navigator.pushNamed(context, '/register');
              },
              child: Center(
                child: RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Novos astronautas ? ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          height: 22 / 14,
                        ),
                      ),
                      TextSpan(
                        text: 'Cadastrem-se',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          height: 22 / 14,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

