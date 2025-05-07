import 'package:flutter/material.dart';
import 'package:laica_app/models/user.dart';
import 'package:laica_app/utils/userProvider.dart';
import 'package:laica_app/widgets/app_subtitle.dart';
import 'package:provider/provider.dart';
import '../widgets/primary_button.dart';
import '../widgets/app_title.dart';
import '../widgets/form_input.dart';
// Importa o pacote de autenticação do Firebase
import 'package:firebase_auth/firebase_auth.dart';
// Importa o pacote para exibir mensagens rápidas (toasts)
import 'package:fluttertoast/fluttertoast.dart';

import 'package:cloud_firestore/cloud_firestore.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    void _login(BuildContext context) async {
    try {
      final authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

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
    } catch (e) {
      Fluttertoast.showToast(msg: 'Erro ao fazer login: $e');
    }
  }


    



    void uploadActivitiesToFirestore() async {
        final firestore = FirebaseFirestore.instance;

        final activities =[];
 


        for (var activity in activities) {
          await firestore.collection('activities').add(activity);
          print('Atividade "${activity["title"]}" adicionada.');
        }

        print('Upload completo!');
      }


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
                            onPressed: () => _login(context),
                          ),
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