import 'package:flutter/material.dart';
import 'package:laica_app/widgets/secondary_button.dart';
import 'package:laica_app/widgets/primary_button.dart';

class ActivityDetailScreen extends StatelessWidget {
  final String activityTitle;

  const ActivityDetailScreen({super.key, required this.activityTitle});

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
          activityTitle,
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
                        Image.asset('assets/images/sample_video.png'), // placeholder
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
                  SecondaryButton(
                    text: 'Lista de materiais',
                    onPressed: () {
                     
                      Navigator.pushNamed(context, '/menu');
                    
                    },
                  ),
                  const SizedBox(height: 16),
                   PrimaryButton(
                    text: 'Concluir atividade',
                    onPressed: () {
                     
                      Navigator.pushNamed(context, '/menu');
                    
                    },
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
