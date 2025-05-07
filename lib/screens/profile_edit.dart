import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laica_app/widgets/app_title.dart';
import '../widgets/primary_button.dart';
import '../widgets/form_input.dart';
import '../models/user.dart'; 



class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  UserModel? _user;

  final TextEditingController _familyNameController = TextEditingController();
  final TextEditingController _childNameController = TextEditingController();
  final TextEditingController _childBirthdayController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cellphoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _updatesSubscribed = false;
  String _selectedAvatar = '';


  @override
  void initState() {
    super.initState();
    _loadUserData();
  }
    Future<void> _loadUserData() async {
    try {
      final String data = await rootBundle.loadString('assets/data/user.json');
      final Map<String, dynamic> jsonResult = json.decode(data);
      setState(() {
        _user = UserModel.fromJson(jsonResult);
        _updateControllersWithUserData();
      });
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  void _updateControllersWithUserData() {
    if (_user == null) return;

  _familyNameController.text = _user?.family_name ?? '';
  _emailController.text = _user?.email ?? '';
  _cellphoneController.text = _user!.cellphone.toString();
  _passwordController.text = '';
  _confirmPasswordController.text = '';
  _updatesSubscribed = _user!.receive_updates;

  if (_user!.children.isNotEmpty) {
    final child = _user!.children[0];
    _childNameController.text = child.name;
    _childBirthdayController.text = child.birthday;
  }
  _selectedAvatar = _user!.children.isNotEmpty ? _user!.children[0].avatar : '';
}


  Future<void> _saveChanges() async {
      if (_user == null) return;

     _user = UserModel(
  user_id: _user!.user_id,
  family_name: _familyNameController.text,
  email: _emailController.text,
  password_hash: _user!.password_hash,
  accepted_terms: _user!.accepted_terms,
  receive_updates: _updatesSubscribed,
  cellphone: int.tryParse(_cellphoneController.text) ?? 0,
  children: [
    Child(
      child_id: _user!.children.isNotEmpty ? _user!.children[0].child_id : '',
      name: _childNameController.text,
      birthday: _childBirthdayController.text,
      avatar: _selectedAvatar,
      progress: _user!.children.isNotEmpty
          ? _user!.children[0].progress
          : Progress(missions_completed: 0, stars: 0),
      activityStatus: _user!.children.isNotEmpty
          ? _user!.children[0].activityStatus
          : {}, // Inicializa com um mapa vazio ou com valor herdado
    ),
  ],
  created_at: _user!.created_at,
  last_login: _user!.last_login,
);


      // Exibe os dados atualizados como JSON no terminal
      final String updatedJson = jsonEncode(_user!.toJson());
      print('Dados atualizados do usuário:\n$updatedJson');

      // Opcional: também pode exibir uma confirmação visual no app
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dados atualizados com sucesso!')),
      );
    }



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
    _cellphoneController.dispose();
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
                  
                  /*
                   AvatarSelector(
                    onAvatarSelected: (avatarPath) {
                      setState(() {
                        _selectedAvatar = avatarPath;
                      });
                    },
                  ),
                  */
                 
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
                  GestureDetector(
                    onTap: _showBirthdayPicker,
                    child: AbsorbPointer(
                      child: CustomTextField(
                        controller: _childBirthdayController,
                        labelText: 'Aniversário da criança',
                        suffixIcon: Icons.cake,
                        inputType: 'date',
                        
                      ),
                    ),
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
                    controller: _cellphoneController,
                    labelText: 'Celular',
                    suffixIcon: Icons.phone,
                    inputType: 'cellphone',
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
                    onPressed: () async {
                      await _saveChanges();
                      Navigator.pushNamed(context, '/profile');
                    }
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

