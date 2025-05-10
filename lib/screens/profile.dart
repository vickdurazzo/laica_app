import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/primary_button.dart';
import '../widgets/profile_option.dart';
import '../models/user.dart';
import 'support.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Importa o pacote para exibir mensagens rápidas (toasts)


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  late DateTime _startTime;

  UserModel? _user;

  Future<UserModel?> _fetchUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('Nenhum usuário autenticado.');
        return null;
      }

      final docSnapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (!docSnapshot.exists) {
        print('Documento não encontrado.');
        return null;
      }

      final userData = docSnapshot.data() as Map<String, dynamic>;
      //print('Dados buscados do Firebase: $userData');
      return UserModel.fromJson(userData);
    } catch (e) {
      //print('Erro ao buscar os dados do Firebase: $e');
      return null;
    }
  }

   Future<void> _loadUserData() async {
    final user = await _fetchUserData();
    setState(() => _user = user);
  }

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    _handleButtonClick('logout', 'logout');
    Navigator.pushReplacementNamed(context, '/'); // Redireciona para a tela de login
  }

   String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _startTime = DateTime.now();

    // Log de visualização da tela
    analytics.logScreenView(
      screenName: 'ProfileScreen',
      screenClass: 'ProfileScreen',
    );

    // Evento customizado ao abrir
    analytics.logEvent(
      name: 'profile_screen_opened',
    );
  }

  @override
  void dispose() {
    
    final duration = DateTime.now().difference(_startTime);

    // Log do tempo de tela
    analytics.logEvent(
      name: 'tempo_tela',
      parameters: {
        'screen': 'ProfileScreen',
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

  




  @override
   Widget build(BuildContext context) {
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
            child: _user == null
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Image.asset('assets/images/logo.png', height: 50),
                        ),
                        const SizedBox(height: 20),
                        /*
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: _user!.children.isNotEmpty
                              ? AssetImage(_user!.children.first.avatar)
                              : const AssetImage('assets/images/family_photo.png'),
                        ),
                        */
                        
                        const SizedBox(height: 16),
                        Text(
                          _capitalize(_user!.family_name),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Poppins",
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _user!.children.isNotEmpty
                              ? 'Criança: ${_user!.children.first.name}'
                              : '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: "Poppins",
                            fontSize: 16,
                            fontWeight:FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildProgressContainer(_user!.children.isNotEmpty ? _user!.children.first : null),
                        const SizedBox(height: 24),
                        _buildOptions(context),
                      ],
                    ),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
    );
  }

  Widget _buildProgressContainer(Child? child) {
    int missionsCompleted = child?.progress.missions_completed ?? 0;
    int stars = child?.progress.stars ?? 0;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2E2B5F),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                '$missionsCompleted',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Atividades Feitas',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                '$stars',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Estrelas Coletadas',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOptions(BuildContext context) {
    return Column(
      children: [
        /*ProfileOption(
          icon: Icons.person_outline,
          text: 'Configurações da Conta',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileEditScreen()),
            );
          },
        ),*/
        
        ProfileOption(
          icon: Icons.settings,
          text: 'Suporte',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SupportScreen()),
            );
          },
        ),
        const SizedBox(height: 20),
        PrimaryButton(
          text: 'Sair',
          onPressed:  () => _logout(context),
        ),
      ],
    );
  }
}
