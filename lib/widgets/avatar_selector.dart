import 'dart:math';
import 'package:flutter/material.dart';

class AvatarSelector extends StatefulWidget {
  final void Function(String) onAvatarSelected;
  

  const AvatarSelector({super.key, required this.onAvatarSelected});

  @override
  State<AvatarSelector> createState() => _AvatarSelectorState();
}

class _AvatarSelectorState extends State<AvatarSelector> {
  final List<String> avatarPaths = [
    'assets/images/avatar/avatar1.png',
    'assets/images/avatar/avatar2.png',
  ];

  late String selectedAvatar;
  late int lastIndex;

  @override
  void initState() {
    super.initState();
    selectedAvatar = avatarPaths[0]; // valor inicial
    lastIndex = 0;
  }

  void _shuffleAvatar() {
    final random = Random();
    int newIndex;
    do {
      newIndex = random.nextInt(avatarPaths.length);
    } while (newIndex == lastIndex);
    lastIndex = newIndex;
    setState(() {
      selectedAvatar = avatarPaths[newIndex];
    });
    widget.onAvatarSelected(selectedAvatar);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
      
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
