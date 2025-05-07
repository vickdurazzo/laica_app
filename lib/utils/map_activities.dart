import 'package:cloud_firestore/cloud_firestore.dart';

/*Future<Map<String, dynamic>> generateActivityStatus() async {
  final firestore = FirebaseFirestore.instance;
  final activitiesSnapshot = await firestore.collection('activities').get();

  final Map<String, dynamic> activityStatus = {};

  for (var doc in activitiesSnapshot.docs) {
    final data = doc.data();

    // Usa o campo 'id' do planeta, que representa o planetId real (ex: 'earth', 'family')
    final planetId = data['id']; 

    if (planetId == null) {
      print('⚠️ Documento ${doc.id} não tem campo "id", ignorando...');
      continue;
    }

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

  print('🧩 activityStatus gerado: $activityStatus');
  return activityStatus;
}
*/
Future<Map<String, dynamic>> generateActivityStatus() async {
  final firestore = FirebaseFirestore.instance;
  final activitiesSnapshot = await firestore.collection('activities').get();

  final Map<String, dynamic> activityStatus = {};

  for (var doc in activitiesSnapshot.docs) {
    final data = doc.data();

    final planetId = data['id'];
    if (planetId == null) {
      print('⚠️ Documento ${doc.id} não tem campo "id", ignorando...');
      continue;
    }

    if (data['island'] != null) {
      final List<dynamic> islands = data['island'];
      final Map<String, dynamic> planetMap = {};

      for (var island in islands) {
        final islandId = island['id'];
        final List<dynamic> activities = island['activities'];

        final Map<String, dynamic> activityMap = {};

        for (int i = 0; i < activities.length; i++) {
          final activity = activities[i];
          final activityId = activity['id'];
          final activityOrder = activity['ordem'];

          activityMap[activityId] = {
            'status': i == 0 ? 'available' : 'locked',
            'ordem': activityOrder ?? i + 1, // usa campo 'ordem' ou posição
          };
        }

        planetMap[islandId] = activityMap;
      }

      activityStatus[planetId] = planetMap;
    }
  }

  print('🧩 activityStatus gerado: $activityStatus');
  return activityStatus;
}
