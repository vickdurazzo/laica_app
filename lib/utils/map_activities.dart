import 'package:cloud_firestore/cloud_firestore.dart';
Future<Map<String, dynamic>> generateActivityStatus() async {
        final firestore = FirebaseFirestore.instance;
        final activitiesSnapshot = await firestore.collection('activities').get();

        final Map<String, dynamic> activityStatus = {};

        for (var doc in activitiesSnapshot.docs) {
          final planetId = doc.id;
          final data = doc.data();

          if (data['island'] != null) {
            final List<dynamic> islands = data['island'];

            final Map<String, dynamic> planetMap = {};

            for (var island in islands) {
              final islandId = island['id'];
              final List<dynamic> activities = island['activities'];

              final Map<String, String> activityMap = {};

              for (var activity in activities) {
                final activityId = activity['id'];
                activityMap[activityId] = 'locked';
              }

              planetMap[islandId] = activityMap;
            }

            activityStatus[planetId] = planetMap;
          }
        }
        print(activityStatus);
        return activityStatus;
        
      }