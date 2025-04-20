import 'package:flutter/material.dart';
import '../widgets/primary_button.dart';
import '../widgets/form_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;
    final screenWidth = size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF1B1A3B),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
          ),

          // Elementos decorativos
          Positioned(
            top: screenHeight * 0.03,
            left: screenWidth * 0.05,
            child: Image.asset(
              'assets/images/logo.png',
              height: screenHeight * 0.05,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              'assets/images/planet1.png',
              height: screenHeight * 0.20,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              'assets/images/planet2.png',
              height: screenHeight * 0.15,
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.06),

                    // Título e subtítulo
                    Text(
                      'Exploradores',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.08,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      'Acessem sua aventuras agora!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.045,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.04),

                    // Inputs
                    CustomTextField(
                      controller: _emailController,
                      labelText: 'E-mail',
                      suffixIcon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    CustomTextField(
                      controller: _passwordController,
                      labelText: 'Senha',
                      suffixIcon: Icons.lock_outline,
                      keyboardType: TextInputType.visiblePassword,
                    ),

                    SizedBox(height: screenHeight * 0.04),

                    // Botão
                    PrimaryButton(
                      text: 'Decolar',
                      onPressed: () {
                        Navigator.pushNamed(context, '/menu');
                      },
                    ),

                    SizedBox(height: screenHeight * 0.04),

                    // Cadastro
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Text(
                        'Nova astronauta? Cadastre-se',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.045,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.05),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
