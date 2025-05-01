import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laica_app/widgets/app_title.dart';
import '../widgets/primary_button.dart';
import '../widgets/form_input.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final TextEditingController _familyNameController = TextEditingController();
  final TextEditingController _childNameController = TextEditingController();
  final TextEditingController _childBirthdayController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

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
    return Scaffold(
      backgroundColor: const Color(0xFF1B1A3B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  AppTitle(text: 'Editar Perfil'),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _familyNameController,
                    labelText: 'Nome da Família',
                    suffixIcon: Icons.group,
                    inputType: 'name',
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: _childNameController,
                    labelText: 'Nome ou apelido da criança',
                    suffixIcon: Icons.person,
                    inputType: 'name',
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: _childBirthdayController,
                    labelText: 'Aniversário da criança',
                    suffixIcon: Icons.cake,
                    inputType: 'date',
                    onTap: _showBirthdayPicker,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: _emailController,
                    labelText: 'E-mail',
                    suffixIcon: Icons.email,
                    inputType: 'email',
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: _passwordController,
                    labelText: 'Senha',
                    suffixIcon: Icons.lock,
                    inputType: 'password',
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: _confirmPasswordController,
                    labelText: 'Confirme a senha',
                    suffixIcon: Icons.lock,
                    inputType: 'password',
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
                          'Quero receber atualização e notícias (opcional)',
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              height: 22 / 14,
                              color: Colors.white),
                          
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  PrimaryButton(
                    text: 'Salvar Alterações',
                    onPressed: () {
                     
                      Navigator.pushNamed(context, '/profile');
                    
                    },
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
