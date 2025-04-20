import 'package:flutter/material.dart';
import '../widgets/primary_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: screenHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.08,
                      vertical: screenHeight * 0.03,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Image.asset(
                            'assets/images/logo.png',
                            height: screenHeight * 0.05,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.04),

                        // Imagem do foguete
                        Center(
                          child: Image.asset(
                            'assets/images/rocket_dog.png',
                            height: screenHeight * 0.3,
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.05),

                        // Título
                        Text(
                          'Bem-vindos a\nmissão Laica',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.08,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.015),

                        // Subtítulo
                        Text(
                          'Prontos para embarcar no foguete ?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.045,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.04),

                        // Botão
                        PrimaryButton(
                          text: 'Embarcar',
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          },
                        ),
                        SizedBox(height: screenHeight * 0.02),

                        // Link de cadastro
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: Text(
                            'Novos astronautas ? Cadastre-se',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.035,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        const Spacer(), // Preenche o espaço restante se sobrar
                      ],
                    ),
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
