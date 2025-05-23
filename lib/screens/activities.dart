import 'package:laica_app/widgets/app_title.dart';
import 'package:provider/provider.dart';
import '../models/planet.dart';
import 'activities.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:laica_app/utils/userProvider.dart';
import 'package:laica_app/widgets/ProductPromoBanner.dart';
import '../models/island.dart';
import 'activity_detail.dart';








class ActivitiesScreen extends StatefulWidget {

  final Island island;
  final String planetId;
  final String childId;


  const ActivitiesScreen({
    super.key,
    required this.island,
    required this.planetId,
    required this.childId,
    
   
  });

  

  

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  late DateTime _startTime;

  
  @override
  void initState() {
    super.initState();
  
    _startTime = DateTime.now();

    // Log de visualização da tela
    analytics.logScreenView(
      screenName: 'ActivitiesScreen',
      screenClass: 'ActivitiesScreen',
    );

    // Evento customizado ao abrir
    analytics.logEvent(
      name: 'Activities_screen_opened',
    );
  }

  @override
  void dispose() {
   
    
    final duration = DateTime.now().difference(_startTime);

    // Log do tempo de tela
    analytics.logEvent(
      name: 'tempo_tela',
      parameters: {
        'screen': 'ActivitiesScreen',
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
            padding: const EdgeInsets.only(right: 12.0, top: 12.0),
            child: Image.asset(
              widget.island.image,
              height: 120,
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
  child: Consumer<UserProvider>(
    builder: (context, userProvider, _) {
      final user = userProvider.user;
      final activityStatus = user?.children.firstWhere(
      (c) => c.child_id == widget.childId).activityStatus;

    final updatedActivities = widget.island.activities.map((activity) {
      final status = activityStatus?[widget.planetId]?[widget.island.id]?[activity.id]?['status'] ?? "locked";
      return activity.copyWith(status: status);
    }).toList();
      final hasCompletedActivity = updatedActivities.any((activity) => activity.status == 'completed');


      return Column(
  children: [
    Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: updatedActivities.length,
        itemBuilder: (context, index) {
          final activity = updatedActivities[index];
          final isEven = index % 2 == 0;
          final isAccessible = activity.status != "locked";

          final activityWidget = GestureDetector(
            onTap: isAccessible
                ? () {
                  _handleButtonClick('activities', activity.name);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ActivityDetailScreen(
                          activityTitle: activity.name,
                          activityVideo: activity.video,
                          planetId: widget.planetId,
                          islandId: widget.island.id,
                          activityId: activity.id,
                        ),
                      ),
                    );
                  }
                : null,
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/images/${activity.status}.png',
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ],
                ),
                if (isAccessible)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      activity.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: "Poppins",
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          );

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: isEven
                  ? [
                      Expanded(child: activityWidget),
                      const Expanded(child: SizedBox()),
                    ]
                  : [
                      const Expanded(child: SizedBox()),
                      Expanded(child: activityWidget),
                    ],
            ),
          );
        },
      ),
    ),
    if (hasCompletedActivity) ProductPromoBanner(title: 'A Laica precisa de você!',
                        description:
                            'Estamos só começando... e sua opinião pode transformar essa jornada! Que tal nos contar o que achou até aqui?',
                        buttonText: 'Avaliar',),
  ],
);
    },
  ),
)

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
