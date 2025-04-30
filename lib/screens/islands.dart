import 'package:flutter/material.dart';
import '../models/planet.dart';
import 'activities.dart'; // ajuste o caminho se necessário


class IslandsScreen extends StatelessWidget {
  final Planet planet;

  const IslandsScreen({Key? key, required this.planet}) : super(key: key);

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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Image.asset(
              planet.image,
              height: 120,
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Fundo estrelado (coloque uma imagem de fundo se quiser)
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  
                  

                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: planet.island.length,
                      itemBuilder: (context, index) {
                        final island = planet.island[index];
                        final isEven = index % 2 == 0;

                        final islandWidget = GestureDetector(
                     
                          onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ActivitiesScreen(island: island),
                                ),
                              );
                            },

                          child: Column(
                            children: [
                              ClipOval(
                                child: Image.asset(
                                  island.image,
                                  fit: BoxFit.cover,
                                  width: 180,
                                  height: 180,
                                ),
                              ),
                              //const SizedBox(height: 8),
                              
                            ],
                          ),
                        );

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: isEven
                                ? [
                                    Expanded(child: islandWidget),
                                    const Expanded(child: SizedBox()),
                                  ]
                                : [
                                    const Expanded(child: SizedBox()),
                                    Expanded(child: islandWidget),
                                  ],
                          ),
                        );
                      },
                    ),
                  ),

                ],
              ),
              
            )
            
          ),
        ],
      ),
    );
  }
}
