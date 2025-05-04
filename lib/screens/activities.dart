import 'package:flutter/material.dart';
import '../models/island.dart';
import 'activity_detail.dart';

class ActivitiesScreen extends StatelessWidget {
  final Island island;

  const ActivitiesScreen({super.key, required this.island});

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
              island.image,
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
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: island.activities.length,
                      itemBuilder: (context, index) {
                        final activity = island.activities[index];
                        final isEven = index % 2 == 0;
                        final isAccessible = activity.status != "blocked";

                        final activityWidget = GestureDetector(
                          onTap: isAccessible
                              ?() {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ActivityDetailScreen(activityTitle: activity.name, activityVideo: activity.video,),
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
                              if(isAccessible)
                                Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text(
                                      activity.name,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Poppins",
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold
                                      ),
                                    )
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
