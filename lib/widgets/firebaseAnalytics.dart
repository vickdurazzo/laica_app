// Exemplo de como implementar o plano de tagueamento Firebase Analytics
// Aplicável a cada tela do seu app

import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class ExampleScreen extends StatefulWidget {
  const ExampleScreen({super.key});

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  late DateTime _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();

    // Log de visualização da tela
    analytics.logScreenView(
      screenName: 'ExampleScreen',
      screenClass: 'ExampleScreen',
    );

    // Evento customizado ao abrir
    analytics.logEvent(
      name: 'example_screen_opened',
    );
  }

  @override
  void dispose() {
    final duration = DateTime.now().difference(_startTime);

    // Log do tempo de tela
    analytics.logEvent(
      name: 'tempo_tela',
      parameters: {
        'screen': 'ExampleScreen',
        'seconds': duration.inSeconds,
      },
    );
    super.dispose();
  }

  void _handleButtonClick() {
    analytics.logEvent(
      name: 'example_button_clicked',
      parameters: {
        'label': 'botao_exemplo',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exemplo')),
      body: Center(
        child: ElevatedButton(
          onPressed: _handleButtonClick,
          child: const Text('Clique aqui'),
        ),
      ),
    );
  }
}

// Use esse modelo como base para:
// - welcome.dart -> screenName: 'WelcomeScreen'
// - login.dart -> screenName: 'LoginScreen'
// - register.dart -> screenName: 'RegisterScreen'
// - etc...
// Substitua ExampleScreen pelo nome correspondente de cada tela
// Adicione eventos conforme definidos no plano de tagueamento
