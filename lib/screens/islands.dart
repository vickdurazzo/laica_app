import 'package:flutter/material.dart';
import 'package:laica_app/widgets/app_title.dart';
import '../models/planet.dart';
import 'activities.dart'; // ajuste o caminho se necessário


class IslandsScreen extends StatelessWidget {
  final Planet planet;

  const IslandsScreen({super.key, required this.planet});

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
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Add future static widgets here
                        AppTitle(text: "Escolha uma ilha para explorar",fontSize: 25,),
                        const SizedBox(height: 5),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7, // Restrict ListView height
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: planet.island.length,
                            itemBuilder: (context, index) {
                              final island = planet.island[index];
                              final planetId = planet.id;
                              //print("TELA DO PLANETA PARA ILHA");
                              //print(planetId);

                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ActivitiesScreen(island: island, planetId: planetId,),
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
                                        const SizedBox(height: 15),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        // Add more widgets below the list here if needed
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
          ),

        ],
      ),
    );
  }
}
