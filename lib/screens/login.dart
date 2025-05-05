import 'package:flutter/material.dart';
import 'package:laica_app/widgets/app_subtitle.dart';
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
      //final email = _emailController.text.trim();
      //final password = _passwordController.text;
      /*
      if (email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Preencha todos os campos')),
        );
        return;
      }

      */
      
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        Navigator.pushReplacementNamed(context, '/menu');
      } catch (e) {
        Fluttertoast.showToast(msg: 'Erro: $e');
      }


      /*
      // Simulação de validação
      const mockEmail = 'teste';
      const mockPassword = '123';

      if (email == mockEmail && password == mockPassword) {
        print('Login realizado com sucesso!');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login realizado com sucesso!')),
        );
        Navigator.pushNamed(context, '/menu');
      } else {
        print('Credenciais inválidas.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('E-mail ou senha incorretos')),
        );
      }
      
      */
      
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
                        onPressed:() => _login(context),
                      ),
                      /* SizedBox(height: screenHeight * 0.04),
                      PrimaryButton(
                        text: 'subir atividade',
                        onPressed:uploadActivitiesToFirestore,
                      ),*/
                     
                      
                      
          
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