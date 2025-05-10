import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:laica_app/utils/userProvider.dart';
import 'package:laica_app/widgets/app_title.dart';
import 'package:provider/provider.dart';
import '../models/planet.dart';
import 'activities.dart';





class IslandsScreen extends StatefulWidget {

  const IslandsScreen({super.key, required this.planet});

  final Planet planet;

  @override
  State<IslandsScreen> createState() => _IslandsScreenState();
}

class _IslandsScreenState extends State<IslandsScreen> {
  
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  late DateTime _startTime;

  
  @override
  void initState() {
    super.initState();
   
    _startTime = DateTime.now();

    // Log de visualização da tela
    analytics.logScreenView(
      screenName: 'IslandsScreen',
      screenClass: 'IslandsScreen',
    );

    // Evento customizado ao abrir
    analytics.logEvent(
      name: 'islands_screen_opened',
    );
  }

  @override
  void dispose() {
   
    
    final duration = DateTime.now().difference(_startTime);

    // Log do tempo de tela
    analytics.logEvent(
      name: 'tempo_tela',
      parameters: {
        'screen': 'IslandsScreen',
        'seconds': duration.inSeconds,
      },
    );
    super.dispose();
  }

  void _handleButtonClick(nome, label) {
    analytics.logEvent(
      name: nome+"_button_clicked",
      parameters: {
        'label': label,
      },
    );
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Image.asset(
              widget.planet.image,
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
                            itemCount: widget.planet.island.length,
                            itemBuilder: (context, index) {
                              final island = widget.planet.island[index];
                              final planetId = widget.planet.id;
                              final userProvider = Provider.of<UserProvider>(context, listen: false);
                              final childId = userProvider.user?.children.first.child_id ?? '';
                              //print("TELA DO PLANETA PARA ILHA");
                              //print(planetId);

                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      _handleButtonClick('island', island.name);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ActivitiesScreen(island: island, planetId: planetId,childId: childId),
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





  