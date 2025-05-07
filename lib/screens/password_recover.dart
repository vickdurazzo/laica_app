import 'package:flutter/material.dart';
import 'package:laica_app/widgets/app_subtitle.dart';
import '../widgets/primary_button.dart';
import '../widgets/app_title.dart';
import '../widgets/form_input.dart';
// Importa o pacote de autenticação do Firebase
import 'package:firebase_auth/firebase_auth.dart';
// Importa o pacote para exibir mensagens rápidas (toasts)
import 'package:fluttertoast/fluttertoast.dart';


class PasswordRecoverScreen extends StatefulWidget {
  const PasswordRecoverScreen({super.key});

  @override
  State<PasswordRecoverScreen> createState() => _PasswordRecoverScreenState();
}

class _PasswordRecoverScreenState extends State<PasswordRecoverScreen> {
  final TextEditingController _emailController = TextEditingController();

  Future<void> resetPassword() async {
        final String email = _emailController.text.trim();

        if (email.isEmpty) {
          Fluttertoast.showToast(msg: "Por favor, insira seu e-mail.");
          return;
        }

        try {
          await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
          Fluttertoast.showToast(
              msg: "Um link para redefinir sua senha foi enviado para $email");
        } on FirebaseAuthException catch (e) {
          String errorMessage = "Erro ao tentar redefinir senha.";
          if (e.code == 'user-not-found') {
            errorMessage = "Nenhuma conta encontrada para esse e-mail.";
          } else if (e.code == 'invalid-email') {
            errorMessage = "E-mail inválido.";
          }

          Fluttertoast.showToast(msg: errorMessage);
        } catch (e) {
          Fluttertoast.showToast(msg: "Ocorreu um erro. Tente novamente.");
        }
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
                      AppTitle(text: 'Sem Problemas'),
                      SizedBox(height: screenHeight * 0.01),
                      AppSubtitle(text:'Coloque o e-mail cadastrado e Laica cuidara do resgate de sua senha'),
                     
          
                      SizedBox(height: screenHeight * 0.04),
          
                      // Inputs
                      CustomTextField(
                        controller: _emailController,
                        labelText: 'E-mail',
                        suffixIcon: Icons.email,
                        inputType: 'email',
                      ),
                      SizedBox(height: screenHeight * 0.02),
                    
                      // Botão
                      PrimaryButton(
                        text: 'Resgatar',
                        onPressed: resetPassword,
                      ),
                      SizedBox(height: screenHeight * 0.04),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Redefiniu ? ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      height: 22 / 14,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Entrar',
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
            ),
          ),

        ],
      ),
    );
  }
}