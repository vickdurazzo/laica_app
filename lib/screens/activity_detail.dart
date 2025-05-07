import 'dart:convert';
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
    print('Progresso atualizado com sucesso!');

    return {
      'missions_completed': newMissionsCompleted,
      'stars': newStars,
      'earned_stars': 5,
    };
  }
  Future<XFile?> _selecionarImagem() async {
  final picker = ImagePicker();
  return await showModalBottomSheet<XFile?>(
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
}

Future<void> _uploadImagemAtividade(XFile pickedFile) async {
  final planetId = widget.planetId;
  final islandId = widget.islandId;
  final activityId = widget.activityId;
  final userId = FirebaseAuth.instance.currentUser?.uid ?? 'anon';
  final fileExtension = path.extension(pickedFile.name);
  final fileName = '$planetId+$islandId+$activityId+$userId$fileExtension';
  final filePath = 'atividadesFeitas/$fileName';
  final ref = FirebaseStorage.instance.ref().child(filePath);

  if (kIsWeb) {
    final data = await pickedFile.readAsBytes();
    await ref.putData(data, SettableMetadata(contentType: _getContentType(fileExtension)));
  } else {
    final file = File(pickedFile.path);
    await ref.putFile(file, SettableMetadata(contentType: _getContentType(fileExtension)));
  }
}
void _atualizarProgressoLocal(UserProvider userProvider, UserModel user, String childId, Map<String, dynamic> result) {
  final updatedChildren = user.children.map((child) {
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
}

Future<void> _desbloquearProximaAtividade(String childId) async {
  print("🔓 Iniciando _desbloquearProximaAtividade para childId: $childId");

  final userProvider = Provider.of<UserProvider>(context, listen: false);
  final user = userProvider.user;

  final userId = FirebaseAuth.instance.currentUser?.uid;
  final child = user?.children.firstWhere((c) => c.child_id == childId);

  if (userId == null || child == null) {
    print("❌ Usuário ou filho não encontrado.");
    return;
  }

  print("👤 userId: $userId");
  print("👶 Child encontrado: ${child.name}");

  final planetId = widget.planetId;
  final islandId = widget.islandId;
  final activityId = widget.activityId;

  print("🪐 planetId: $planetId | 🏝️ islandId: $islandId | 🎯 activityId: $activityId");

  final planetDoc = await FirebaseFirestore.instance
      .collection('activities')
      .where('id', isEqualTo: planetId)
      .get();

  if (planetDoc.docs.isEmpty) {
    print("❌ Documento do planeta não encontrado.");
    return;
  }

  final planetData = planetDoc.docs.first.data();
  final islands = List<Map<String, dynamic>>.from(planetData['island']);
  print("📦 Total de ilhas encontradas: ${islands.length}");

  final island = islands.firstWhere((i) => i['id'] == islandId);
  final activities = List<Map<String, dynamic>>.from(island['activities']);
  print("🎯 Total de atividades na ilha: ${activities.length}");

  final currentActivity = activities.firstWhere((a) => a['id'] == activityId, orElse: () => {});
  if (currentActivity.isEmpty) {
    print("❌ Atividade atual não encontrada.");
    return;
  }

  final int currentOrder = currentActivity['ordem'] ?? 0;
  final int nextOrder = currentOrder + 1;
  print("✅ Atividade atual encontrada (ordem: $currentOrder), próxima será $nextOrder");

  final updatedActivityStatus = Map<String, dynamic>.from(child.activityStatus);

  // Marca como concluída
  updatedActivityStatus[planetId] ??= {};
  updatedActivityStatus[planetId][islandId] ??= {};
  updatedActivityStatus[planetId][islandId][activityId] = {
    'status': 'completed',
    'ordem': currentOrder,
  };
  print("✅ Marcou atividade $activityId como 'completed'");

  // Desbloqueia a próxima
  final nextActivity = activities.firstWhere(
    (a) => a['ordem'] == nextOrder,
    orElse: () => {},
  );

  if (nextActivity.isNotEmpty) {
    final nextActivityId = nextActivity['id'];
    updatedActivityStatus[planetId][islandId][nextActivityId] = {
      'status': 'available',
      'ordem': nextOrder,
    };
    print("🟢 Desbloqueou próxima atividade: $nextActivityId (ordem $nextOrder)");
  } else {
    print("ℹ️ Nenhuma próxima atividade com ordem $nextOrder encontrada.");
  }

  // Atualiza o filho no Firestore com .set()
  final updatedChild = child.copyWith(activityStatus: updatedActivityStatus);
  print("✅ Criado updatedChild com nova activityStatus");
  print("📤 updatedChild.toJson(): ${jsonEncode(updatedChild.toJson())}");

  final updatedChildren = user?.children.map((c) {
    return c.child_id == child.child_id ? updatedChild.toJson() : c.toJson();
  }).toList();

  await FirebaseFirestore.instance.collection('users').doc(userId).set({
    'children': updatedChildren,
  }, SetOptions(merge: true));

  print("✅ Dados atualizados com .set() no Firestore");

  // Atualiza localmente
  final updatedChildrenObjects = user?.children.map((c) {
    return c.child_id == child.child_id ? updatedChild : c;
  }).toList();

  userProvider.setUser(user!.copyWith(children: updatedChildrenObjects));
  print("✅ Atualização concluída no provider local");
}





Future<void> _mostrarDialogoSucesso(int earnedStars) async {
  await Future.delayed(const Duration(seconds: 1));
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Atividade concluída"),
      content: Text("Envio realizado com sucesso!\nVocê ganhou $earnedStars estrelas!"),
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
}

void _mostrarErroEnvio() {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Erro ao enviar imagem ou atualizar progresso. Tente novamente.'),
    ),
  );
}






  Future<void> _concluirAtividadeComImagem() async {
     // final pickedFile = await _selecionarImagem();
      //if (pickedFile == null) return;

      try {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final user = userProvider.user;
        final userId = FirebaseAuth.instance.currentUser?.uid ?? 'anon';
        final childId = user?.children.first.child_id ?? 'sem_id';

        //await _uploadImagemAtividade(pickedFile);

        final result = await updateUserProgress(userId, childId);
        _atualizarProgressoLocal(userProvider, user!, childId, result);

        await _desbloquearProximaAtividade(childId);

        await _mostrarDialogoSucesso(result['earned_stars']);
      } catch (e) {
        debugPrint('Erro ao concluir atividade: $e');
        _mostrarErroEnvio();
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
