import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laica_app/utils/userProvider.dart';
import 'package:laica_app/widgets/primary_button.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'dart:typed_data'; // necessário para Uint8List
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:laica_app/models/user.dart';

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

    // Acessa o estado global do usuário depois que o build estiver disponível
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = Provider.of<UserProvider>(context, listen: false).user;

      if (user != null && user.children.isNotEmpty) {
        final firstChild = user.children[0];
        print("Child ID: ${firstChild.child_id}");
        print("Stars: ${firstChild.progress.stars}");
      } else {
        print("Usuário ou lista de filhos vazia");
      }
    });
  }

  Future<void> _initializePlayer() async {
    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(widget.activityVideo),
    );
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

  Future<Map<String, dynamic>> updateUserProgress(
    String userId,
    String childId,
  ) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
    final userSnapshot = await userDoc.get();

    if (!userSnapshot.exists) throw Exception('Usuário não encontrado');

    final userData = userSnapshot.data();
    final children = userData?['children'] as List<dynamic>;

    // Encontrar a criança correta
    final childIndex = children.indexWhere(
      (child) => child['child_id'] == childId,
    );
    if (childIndex == -1) throw Exception('Criança não encontrada');

    final child = children[childIndex];
    final currentProgress =
        child['progress'] ?? {'missions_completed': 0, 'stars': 0};

    final newMissionsCompleted =
        (currentProgress['missions_completed'] ?? 0) + 1;
    final newStars = (currentProgress['stars'] ?? 0) + 5;

    // Atualizar o progresso da criança no array
    children[childIndex]['progress'] = {
      'missions_completed': newMissionsCompleted,
      'stars': newStars,
    };

    await userDoc.update({'children': children});

    return {
      'missions_completed': newMissionsCompleted,
      'stars': newStars,
      'earned_stars': 5,
    };
  }

  Future<void> _concluirAtividadeComImagem() async {
    final picker = ImagePicker();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;

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
                  final file = await picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  Navigator.pop(context, file);
                },
              ),
            ],
          ),
        );
      },
    );

    if (pickedFile == null) return;

    try {
      final String planetId = widget.planetId;
      final String islandId = widget.islandId;
      final String activityId = widget.activityId;

      final String userId = FirebaseAuth.instance.currentUser?.uid ?? 'anon';
      final String childId = user?.children.first.child_id ?? 'sem_id';

      final fileExtension = path.extension(pickedFile.name);
      final fileName = '$planetId+$islandId+$activityId+$userId$fileExtension';
      final filePath = 'atividadesFeitas/$fileName';
      final ref = FirebaseStorage.instance.ref().child(filePath);

      if (kIsWeb) {
        Uint8List data = await pickedFile.readAsBytes();
        await ref.putData(
          data,
          SettableMetadata(contentType: _getContentType(fileExtension)),
        );
      } else {
        final file = File(pickedFile.path);
        await ref.putFile(
          file,
          SettableMetadata(contentType: _getContentType(fileExtension)),
        );
      }

      // Atualiza progresso no Firestore
      final result = await updateUserProgress(userId, childId);

      // Atualiza o provider local com o novo progresso
      final updatedChildren =
          user!.children.map((child) {
            if (child.child_id == childId) {
              final updatedProgress = child.progress.copyWith(
                missions_completed: result['missions_completed'],
                stars: result['stars'],
              );
              return child.copyWith(progress: updatedProgress);
            }
            return child;
          }).toList();

      final updatedUser = user.copyWith(children: updatedChildren);
      userProvider.setUser(updatedUser);
    

      // ➕ Novo passo: desbloquear próxima atividade
      final firestore = FirebaseFirestore.instance;
      final atividadesSnapshot =
          await firestore
              .collection('planetas')
              .doc(planetId)
              .collection('ilhas')
              .doc(islandId)
              .collection('atividades')
              .orderBy(
                'ordem',
              ) // assumindo campo 'ordem' para definir sequência
              .get();

      print(atividadesSnapshot);

      bool foundCurrent = false;
      for (final doc in atividadesSnapshot.docs) {
        if (doc.id == activityId) {
          // ✅ Atualiza o status da atividade atual para "completed"
          await doc.reference.update({'status': 'completed'});
          foundCurrent = true;
          continue;
        }

        if (foundCurrent && doc['status'] == 'locked') {
          // ✅ Desbloqueia a próxima atividade
          await doc.reference.update({'status': 'available'});
          break;
        }
      }

      // Feedback visual ao usuário
      await Future.delayed(const Duration(seconds: 1));
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text("Atividade concluída"),
              content: Text(
                "Envio realizado com sucesso!\nVocê ganhou ${result['earned_stars']} estrelas!",
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Fecha o AlertDialog
                    Navigator.pop(context); // Volta uma tela
                  },
                  child: const Text("OK"),
                ),
              ],
            ),
      );
    } catch (e) {
      debugPrint('Erro ao concluir atividade: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Erro ao enviar imagem ou atualizar progresso. Tente novamente.',
          ),
        ),
      );
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
                  if (_chewieController != null &&
                      _videoController.value.isInitialized)
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
                    onPressed: _concluirAtividadeComImagem,
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
