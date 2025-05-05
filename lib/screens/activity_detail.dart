import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laica_app/widgets/primary_button.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'dart:typed_data'; // necessário para Uint8List
import 'package:flutter/foundation.dart' show kIsWeb;

class ActivityDetailScreen extends StatefulWidget {
  final String activityTitle;
  final String activityVideo;
  final String planetId;
  final String islandId;
  final String activityId;

  const ActivityDetailScreen({
    super.key,
    required this.activityTitle,
    required this.activityVideo,
    required this.planetId,
    required this.islandId,
    required this.activityId,
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
            ),
          ],
        ),
      );
    },
  );

  if (pickedFile != null) {
    try {
      // IDs fictícios (substitua pelos reais)
      final String planetId = widget.planetId;
      final String islandId = widget.islandId;
      final String activityId = widget.activityId;
      final String userId = FirebaseAuth.instance.currentUser?.uid ?? 'anon';

      // Obtem extensão (ex: .jpg)
      final fileExtension = path.extension(pickedFile.name);
      final fileName = '$planetId+$islandId+$activityId+$userId$fileExtension';
      final filePath = 'atividadesFeitas/$fileName';

      final ref = FirebaseStorage.instance.ref().child(filePath);

      if (kIsWeb) {
        // Flutter Web: usa Uint8List
        Uint8List data = await pickedFile.readAsBytes();

        await ref.putData(
          data,
          SettableMetadata(contentType: _getContentType(fileExtension)),
        );
      } else {
        // Mobile: usa File
        final file = File(pickedFile.path);
        await ref.putFile(
          file,
          SettableMetadata(contentType: _getContentType(fileExtension)),
        );
      }

      // Diálogo de sucesso
      await Future.delayed(const Duration(seconds: 1));
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
    } catch (e) {
      debugPrint('Erro ao enviar imagem: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao enviar imagem. Tente novamente.')),
      );
    }
  }
}

// Função auxiliar para definir contentType correto
String _getContentType(String extension) {
  switch (extension.toLowerCase()) {
    case '.png':
      return 'image/png';
    case '.jpg':
    case '.jpeg':
      return 'image/jpeg';
    case '.gif':
      return 'image/gif';
    default:
      return 'application/octet-stream'; // padrão
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
