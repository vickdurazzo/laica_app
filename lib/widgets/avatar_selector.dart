import 'dart:math';
import 'package:flutter/material.dart';

class AvatarSelector extends StatefulWidget {
  final void Function(String) onAvatarSelected;
  
  const AvatarSelector({super.key, required this.onAvatarSelected,required this.selectedAvatar});

  @override
  State<AvatarSelector> createState() => _AvatarSelectorState();
}

class _AvatarSelectorState extends State<AvatarSelector> {
  final List<String> avatars = [
    'assets/images/avatars/avatar1.png',
    'assets/images/avatars/avatar2.png',
    
  ];

  late String selectedAvatar;

  @override
  void initState() {
    super.initState();
    selectedAvatar = avatars[0]; // valor inicial
  }

  void _shuffleAvatar() {
    final random = Random();
    setState(() {
      selectedAvatar = avatars[random.nextInt(avatars.length)];
    });
    widget.onAvatarSelected(selectedAvatar);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Escolha um avatar:',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        const SizedBox(height: 10),
        CircleAvatar(
          backgroundImage: AssetImage(selectedAvatar),
          radius: 40,
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: _shuffleAvatar,
          icon: const Icon(Icons.shuffle),
          label: const Text('Sortear Avatar'),
        ),
      ],
    );
  }
}
