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
    return Scaffold(
      backgroundColor:  const Color(0xFF1B1A3B),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 20,
            left: 20,
            child: Image.asset(
              'assets/images/logo.png',
              height: 50,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              'assets/images/planet1.png',
              height: 200,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              'assets/images/planet2.png',
              height: 150,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 190,
                   child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        child: Text(
                        'Exploradores',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ),
                      Align(
                       child: Text(
                        'Acessem sua aventuras agora !',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      ),
                    ],
                  ),
                ),
                  
                  CustomTextField(
                    controller: _emailController,
                    labelText: 'E-mail',
                    suffixIcon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  CustomTextField(
                    controller: _passwordController,
                    labelText: 'Senha',
                    suffixIcon: Icons.lock_outline,
                    keyboardType: TextInputType.visiblePassword,


                    ),
                    PrimaryButton(
                      text: 'Decolar',
                      onPressed: () {
                        Navigator.pushNamed(context, '/menu');
                      },
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: const Text(
                        'Nova astronauta ? Cadastre-sem',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}