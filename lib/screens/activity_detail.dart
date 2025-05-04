import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laica_app/widgets/primary_button.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class ActivityDetailScreen extends StatefulWidget {
  final String activityTitle;
  final String activityVideo;

  const ActivityDetailScreen({
    super.key,
    required this.activityTitle,
    required this.activityVideo,
  });

  @override
  State<ActivityDetailScreen> createState() => _ActivityDetailScreenState();
}

class _ActivityDetailScreenState extends State<ActivityDetailScreen> {
  File? _selectedFile;
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.activityVideo));
    await _videoController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoController,
      autoPlay: true,
      looping: true,
      allowFullScreen: true,
      allowPlaybackSpeedChanging: true,
      allowMuting: true,
    );

    setState(() {});
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> _pickMedia() async {
    final picker = ImagePicker();

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
              )
            ],
          ),
        );
      },
    );

    if (pickedFile != null) {
      setState(() {
        _selectedFile = File(pickedFile.path);
      });

      await Future.delayed(const Duration(seconds: 2));

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Atividade concluída"),
          content: const Text("Envio realizado com sucesso!\nA próxima atividade será desbloqueada em breve."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  if (_chewieController != null && _videoController.value.isInitialized)
                    AspectRatio(
                      aspectRatio: _videoController.value.aspectRatio,
                      child: Chewie(controller: _chewieController!),
                    )
                  else
                    const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
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
