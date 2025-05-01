import 'package:flutter/material.dart';
import 'package:laica_app/widgets/app_subtitle.dart';
import '../widgets/primary_button.dart';
import '../widgets/app_title.dart';
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

          
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: screenHeight * 0.04),
                      AppTitle(text: 'Exploradores'),
                      SizedBox(height: screenHeight * 0.01),
                      AppSubtitle(text:'Acessem suas aventuras agora!'),
                     
          
                      SizedBox(height: screenHeight * 0.04),
          
                      // Inputs
                      CustomTextField(
                        controller: _emailController,
                        labelText: 'E-mail',
                        suffixIcon: Icons.email,
                        inputType: 'email',
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      CustomTextField(
                        controller: _passwordController,
                        labelText: 'Senha',
                        suffixIcon: Icons.lock_outline,
                        inputType: 'password',
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
                        child: RichText(
                            textAlign: TextAlign.center,
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
          
                      SizedBox(height: screenHeight * 0.04),
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