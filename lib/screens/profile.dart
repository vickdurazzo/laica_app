import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/primary_button.dart';
import '../widgets/profile_option.dart';
import '../models/user.dart';
import 'profile_edit.dart';
import 'support.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await _fetchUserData();
    setState(() => _user = user);
  }

  Future<User> _fetchUserData() async {
    final String response = await rootBundle.loadString('assets/data/user.json');
    final data = json.decode(response);
    return User.fromJson(data);
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
                          _user!.family_name,
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
                            color: Colors.white70,
                            fontFamily: "Poppins",
                            fontSize: 16,
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
          onPressed: () {
            Navigator.pushNamed(context, '/');
          },
        ),
      ],
    );
  }
}
