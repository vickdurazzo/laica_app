import 'package:flutter/material.dart';
import '../widgets/primary_button.dart';
import '../widgets/form_input.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _familyNameController = TextEditingController();
  final TextEditingController _childNameController = TextEditingController();
  final TextEditingController _childBirthdayController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _termsAgreed = false;
  bool _updatesSubscribed = false;

  @override
  void dispose() {
    _familyNameController.dispose();
    _childNameController.dispose();
    _childBirthdayController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
            'assets/background.png',
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 20,
            left: 20,
            child: Image.asset(
              'assets/logo.png',
              height: 50,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              'assets/planet1.png',
              height: 200,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 20), // Espaçamento superior
                  const Text(
                    'Cadastro de Exploradores',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _familyNameController,
                    labelText: 'Nome da Família',
                    suffixIcon: Icons.group,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: _childNameController,
                    labelText: 'Nome ou apelido da criança',
                    suffixIcon: Icons.person,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: _childBirthdayController,
                    labelText: 'Aniversário da criança',
                    suffixIcon: Icons.cake,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: _emailController,
                    labelText: 'E-mail',
                    suffixIcon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: _passwordController,
                    labelText: 'Senha',
                    suffixIcon: Icons.lock,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: _confirmPasswordController,
                    labelText: 'Confirme a senha',
                    suffixIcon: Icons.lock,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Checkbox(
                        value: _termsAgreed,
                        onChanged: (bool? value) {
                          setState(() {
                            _termsAgreed = value ?? false;
                          });
                        },
                      ),
                      const Expanded(
                        child: Text(
                          'Eu concordo com termos e politicas de privacidade',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                   const SizedBox(height: 10),
                   Row(
                    children: [
                      Checkbox(
                        value: _updatesSubscribed,
                        onChanged: (bool? value) {
                          setState(() {
                            _updatesSubscribed = value ?? false;
                          });
                        },
                      ),
                      const Expanded(
                        child: Text(
                          'Quero receber atualização e noticias (opcional)',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                   const SizedBox(height: 10),
                  PrimaryButton(
                    text: 'Começar a Aventura',
                    onPressed: () {
                      // Implemente a lógica para iniciar a aventura aqui
                    },
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text(
                      'Já tem cadastro na aventura ? Entrar no foguete',
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