import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:laica_app/models/user.dart';
import 'package:laica_app/utils/device_utils.dart';
import 'package:laica_app/utils/userProvider.dart';
import 'package:laica_app/widgets/app_subtitle.dart';
import 'package:provider/provider.dart';
import '../widgets/primary_button.dart';
import '../widgets/app_title.dart';
import '../widgets/form_input.dart';
// Importa o pacote de autenticação do Firebase
import 'package:firebase_auth/firebase_auth.dart';
// Importa o pacote para exibir mensagens rápidas (toasts)


import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  late DateTime _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();

    // Log de visualização da tela
    analytics.logScreenView(
      screenName: 'LoginScreen',
      screenClass: 'LoginScreen',
    );

    // Evento customizado ao abrir
    analytics.logEvent(
      name: 'login_screen_opened',
    );
  }

  @override
  void dispose() {
     _emailController.dispose();
    _passwordController.dispose();
    final duration = DateTime.now().difference(_startTime);

    // Log do tempo de tela
    analytics.logEvent(
      name: 'tempo_tela',
      parameters: {
        'screen': 'LoginScreen',
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

  void _login(BuildContext context) async {
    try {
          final authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );

          if (!authResult.user!.emailVerified) {
            final user = FirebaseAuth.instance.currentUser;
            await user?.sendEmailVerification();
            await FirebaseAuth.instance.signOut();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Verifique seu e-mail antes de continuar.'),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }

          final uid = authResult.user?.uid;
          if (uid == null) throw Exception('Erro ao obter UID do usuário.');

          // Buscar dados no Firestore
          final docSnapshot = await FirebaseFirestore.instance
              .collection('users') // ou 'user', dependendo da sua coleção
              .doc(uid)
              .get();

          if (!docSnapshot.exists) throw Exception('Usuário não encontrado no Firestore.');

          final userData = docSnapshot.data();
          final userModel = UserModel.fromJson(userData!);

          // Salvar no estado global
          Provider.of<UserProvider>(context, listen: false).setUser(userModel);

          // Navegar para o menu
          Navigator.pushReplacementNamed(context, '/menu');
      } on FirebaseAuthException catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.message ?? 'Erro de autenticação.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }




  @override
 Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;
    final screenWidth = size.width;
    final bool isMobile = DeviceUtils.isMobile();

    return Scaffold(
      backgroundColor: const Color(0xFF1B1A3B),
      body: Stack(
        fit: StackFit.expand,
        children: [
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
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: screenHeight * 0.04),
                          AppTitle(text: 'Exploradores'),
                          SizedBox(height: screenHeight * 0.01),
                          AppSubtitle(text: 'Acessem suas aventuras agora!'),
                          SizedBox(height: screenHeight * 0.04),
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
                          PrimaryButton(
                            text: 'Decolar',
                            onPressed: () {
                              _handleButtonClick('login', 'Decolar');
                              _login(context);
                            },
                          ),
                          /*PrimaryButton(
                            text: 'enviar',
                            onPressed: () => uploadActivitiesToFirestore(),
                          ),*/
                          SizedBox(height: screenHeight * 0.04),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/password_recover');
                            },
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Esqueceu a senha ? ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      height: 22 / 14,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Recuperar senha',
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
                        ],
                      ),
                    ),
                  ),
                  // Cadastrem-se fixo no rodapé
                  Padding(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                    child: GestureDetector(
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

