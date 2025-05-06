//import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laica_app/widgets/app_title.dart';
import '../widgets/primary_button.dart';
import '../widgets/form_input.dart';
//import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
// Importa o pacote de autenticação do Firebase
import 'package:firebase_auth/firebase_auth.dart';
// Importa o pacote para exibir mensagens rápidas (toasts)
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laica_app/utils/map_activities.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _familyNameController = TextEditingController();
  final TextEditingController _childNameController = TextEditingController();
  final TextEditingController _childBirthdayController =
      TextEditingController();
  final TextEditingController _cellphoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

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

  void _handleRegister() async {
    if (_familyNameController.text.isEmpty ||
        _childNameController.text.isEmpty ||
        _childBirthdayController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _cellphoneController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos.')),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('As senhas não coincidem.')));
      return;
    }

    if (!_termsAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Você precisa aceitar os termos e políticas.'),
        ),
      );
      return;
    }

    try {
      // 1. Cadastra o usuário no Firebase Auth
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );

      final uid = credential.user!.uid;
      final uuid = const Uuid();
      final now = DateTime.now().toIso8601String();

      final activityStatus = await generateActivityStatus();

      // 2. Monta o objeto com os dados completos
      final userData = {
        "user_id": uid, // usa o uid do Firebase Auth
        "family_name": _familyNameController.text,
        "email": _emailController.text,
        "accepted_terms": _termsAgreed,
        "receive_updates": _updatesSubscribed,
        "cellphone": int.tryParse(_cellphoneController.text) ?? 0,
        "children": [
          {
            "child_id": uuid.v4(),
            "name": _childNameController.text,
            "birthday": _childBirthdayController.text,
            "avatar": "",
            "activity_status": activityStatus,
            "progress": {"missions_completed": 0, "stars": 0},
          },
        ],
        "created_at": now,
        "last_login": now,
      };

      print(userData);

      try {
        // 3. Salva no Firestore (coleção "users")
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set(userData);
      } catch (e) {
        print(e);
      }

      Fluttertoast.showToast(msg: 'Cadastro realizado com sucesso');
      Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Erro ao cadastrar: $e');
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
    _cellphoneController.dispose();
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
          Image.asset('assets/images/background.png', fit: BoxFit.cover),

          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: screenHeight * 0.04),
                  AppTitle(text: 'Cadastro de Exploradores'),
                  SizedBox(height: screenHeight * 0.03),
                  CustomTextField(
                    controller: _familyNameController,
                    labelText: 'Nome da Família',
                    suffixIcon: Icons.group,
                    inputType: 'name',
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  CustomTextField(
                    controller: _childNameController,
                    labelText: 'Nome ou apelido da criança',
                    suffixIcon: Icons.person,
                    inputType: 'name',
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  CustomTextField(
                    controller: _childBirthdayController,
                    labelText: 'Aniversário da criança',
                    suffixIcon: Icons.cake,
                    inputType: 'date',
                    onTap: _showBirthdayPicker,
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  CustomTextField(
                    controller: _emailController,
                    labelText: 'E-mail',
                    suffixIcon: Icons.email,
                    inputType: 'email',
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  CustomTextField(
                    controller: _cellphoneController,
                    labelText: 'Celular',
                    suffixIcon: Icons.phone,
                    inputType: 'cellphone',
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  CustomTextField(
                    controller: _passwordController,
                    labelText: 'Senha',
                    suffixIcon: Icons.lock,
                    inputType: 'password',
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  CustomTextField(
                    controller: _confirmPasswordController,
                    labelText: 'Confirme a senha',
                    suffixIcon: Icons.lock,
                    inputType: 'password',
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Center(
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Checkbox(
                              value: _termsAgreed,
                              onChanged: (bool? value) {
                                setState(() {
                                  _termsAgreed = value ?? false;
                                });
                              },
                            ),
                            GestureDetector(
                              onTap: () {
                                print("tap");
                                final Uri uri = Uri.parse(
                                  "https://drive.google.com/file/d/1UfVwHeDIcve32QSZH_d3EivgU636EWT4/view",
                                );
                                launchUrl(
                                    uri,
                                    mode: LaunchMode.platformDefault, // ou LaunchMode.externalApplication
                                  );
                              },
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Eu concordo com os ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                        height: 22 / 14,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'termos e políticas de privacidade',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  PrimaryButton(
                    text: 'Começar a Aventura',
                    onPressed: _handleRegister,
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Já tem cadastro ? ',
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
