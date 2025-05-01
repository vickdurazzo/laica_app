import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laica_app/widgets/primary_button.dart';

class ActivityDetailScreen extends StatefulWidget {
  final String activityTitle;

  const ActivityDetailScreen({super.key, required this.activityTitle});

  @override
  State<ActivityDetailScreen> createState() => _ActivityDetailScreenState();
}

class _ActivityDetailScreenState extends State<ActivityDetailScreen> {
  File? _selectedFile;

  Future<void> _pickMedia() async {
    final ImagePicker picker = ImagePicker();

    final XFile? pickedFile = await showModalBottomSheet<XFile?>(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Selecionar Imagem'),
                onTap: () async {
                  final file = await picker.pickImage(source: ImageSource.gallery);
                  Navigator.pop(context, file);
                },
              ),
              ListTile(
                leading: const Icon(Icons.videocam),
                title: const Text('Selecionar Vídeo'),
                onTap: () async {
                  final file = await picker.pickVideo(source: ImageSource.gallery);
                  Navigator.pop(context, file);
                },
              ),
            ],
          ),
        );
      },
    );

    if (pickedFile != null) {
      setState(() {
        _selectedFile = File(pickedFile.path);
      });

      // Simula o envio (você pode implementar upload real depois)
      await Future.delayed(const Duration(seconds: 2));

      // Mostra popup de sucesso
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Atividade concluída"),
          content: const Text("Envio realizado com sucesso!\nA próxima atividade será desbloqueada em breve."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Fecha popup
                Navigator.pop(context); // Volta para a tela anterior
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
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
        title: Text(
          widget.activityTitle,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Image.asset('assets/images/sample_video.png'),
                        const SizedBox(height: 8),
                        Slider(
                          value: 0.5,
                          onChanged: (value) {},
                          activeColor: Colors.purpleAccent,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Icon(Icons.play_arrow, color: Colors.black),
                            Icon(Icons.fullscreen, color: Colors.black),
                            Icon(Icons.volume_up, color: Colors.black),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  PrimaryButton(
                    text: 'Concluir atividade',
                    onPressed: _pickMedia,
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
