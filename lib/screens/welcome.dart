import 'package:flutter/material.dart';
import 'package:laica_app/widgets/app_subtitle.dart';

import 'package:laica_app/widgets/app_title.dart';
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
        children: [
          // Background
          Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
          ),

          // Logo at the top right
          Positioned(
            top: screenHeight * 0.05,
            right: screenWidth * 0.08,
            child: Image.asset(
              'assets/images/logo.png',
              height: screenHeight * 0.05,
            ),
          ),

          // Central content with rocket + overlapping text
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

                    // Title text OVERLAPPING the bottom of the image
                    Positioned(
                      bottom: -screenHeight * 0.06,
                      child: AppTitle(text: 'Bem-vindos à\nmissão Laica'),
                      
                    ),
                  ],
                ),

                const SizedBox(height: 40), // Enough to space subtitle from rocket
                AppSubtitle(text: 'Prontos para embarcar no foguete ?'),
               
                const SizedBox(height: 30),

                SizedBox(
                  width: screenWidth * 0.8,
                  child: PrimaryButton(
                    text: 'Embarcar',
                    onPressed: () {
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
                Navigator.pushNamed(context, '/register');
              },
              child: Center(
                child: RichText(
                  text: TextSpan(
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
