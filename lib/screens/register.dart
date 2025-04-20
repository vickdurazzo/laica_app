import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _childBirthdayController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void _showBirthdayPicker() {
    _selectDate(context);
  }

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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF1B1A3B),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
          ),
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
              height: screenHeight * 0.2,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: screenHeight * 0.04),
                  Text(
                    'Cadastro de Exploradores',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.075,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  CustomTextField(
                    controller: _familyNameController,
                    labelText: 'Nome da Família',
                    suffixIcon: Icons.group,
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  CustomTextField(
                    controller: _childNameController,
                    labelText: 'Nome ou apelido da criança',
                    suffixIcon: Icons.person,
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  CustomTextField(
                    controller: _childBirthdayController,
                    labelText: 'Aniversário da criança',
                    suffixIcon: Icons.cake,
                    keyboardType: TextInputType.number,
                    onTap: _showBirthdayPicker,
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  CustomTextField(
                    controller: _emailController,
                    labelText: 'E-mail',
                    suffixIcon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  CustomTextField(
                    controller: _passwordController,
                    labelText: 'Senha',
                    suffixIcon: Icons.lock,
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  CustomTextField(
                    controller: _confirmPasswordController,
                    labelText: 'Confirme a senha',
                    suffixIcon: Icons.lock,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _termsAgreed,
                        onChanged: (bool? value) {
                          setState(() {
                            _termsAgreed = value ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          'Eu concordo com termos e políticas de privacidade',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.038,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _updatesSubscribed,
                        onChanged: (bool? value) {
                          setState(() {
                            _updatesSubscribed = value ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          'Quero receber atualizações e notícias (opcional)',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.038,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  PrimaryButton(
                    text: 'Começar a Aventura',
                    onPressed: () {
                      // Implementar lógica de cadastro
                    },
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Text(
                      'Já tem cadastro na aventura? Entrar no foguete',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.043,
                        decoration: TextDecoration.underline,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
