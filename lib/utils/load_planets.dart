/*
import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/planet.dart';

Future<List<Planet>> loadPlanets() async {
  final String response = await rootBundle.loadString('assets/data/planets.json');
  final List<dynamic> data = json.decode(response);
  return data.map((json) => Planet.fromJson(json)).toList();
}

*/


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/planet.dart';
/*
Future<List<Planet>> loadPlanets() async {
  try {
    final snapshot = await FirebaseFirestore.instance.collection('activities').get();

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) throw Exception("Usuário não autenticado");

    // 2. Busca os dados do usuário
    final userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final userData = userSnapshot.data();
    print('🧾 userData:\n${const JsonEncoder.withIndent('  ').convert(userData)}');

    // Debug: Print o raw JSON do Firestore
    for (var doc in snapshot.docs) {
      final prettyJson = const JsonEncoder.withIndent('  ').convert(doc.data());
      print('🔥 Documento ${doc.id}:\n$prettyJson');
      print('----------------------------------------------');
    }

    final planets = snapshot.docs.map((doc) => Planet.fromJson(doc.data())).toList();

    // Debug: Print os objetos Planet já convertidos
    for (var planet in planets) {
      print('🌍 Planet carregado: ${planet.name}');
    }

    return planets;
  } catch (e) {
    print('❌ Erro ao carregar planetas do Firestore: $e');
    rethrow;
  }
}

*/

Future<List<Planet>> loadPlanets() async {
  try {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) throw Exception("Usuário não autenticado");

    // 1. Busca os dados das atividades (planetas)
    final snapshot = await FirebaseFirestore.instance.collection('activities').get();

    // 2. Busca os dados do usuário
    final userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final userData = userSnapshot.data();

    if (userData == null) throw Exception("Dados do usuário não encontrados");

    final List<dynamic> children = userData['children'] ?? [];
    if (children.isEmpty) throw Exception("Usuário sem filhos cadastrados");

    // Pega o primeiro filho por padrão (ajuste se necessário)
    final child = children.first;
    final Map<String, dynamic> activityStatuses = Map<String, dynamic>.from(child['activity_status'] ?? {});

    // 3. Converte os documentos em Planet e atualiza o status das atividades
    final planets = snapshot.docs.map((doc) {
      final planet = Planet.fromJson(doc.data());

      for (var island in planet.island) {
        for (var activity in island.activities) {
          // Status default
          String status = 'locked';

          // Busca usando a hierarquia correta: planetId > islandId > activityId
          if (activityStatuses.containsKey(planet.id)) {
            //print('🌍 Encontrado planetId: ${planet.id}');
            final islandMap = activityStatuses[planet.id] as Map<String, dynamic>;

            if (islandMap.containsKey(island.id)) {
              //print('🏝️ Encontrado islandId: ${island.id}');
              final activityMap = islandMap[island.id] as Map<String, dynamic>;

              if (activityMap.containsKey(activity.id)) {
                status = activityMap[activity.id];
                //print('✅ Status encontrado para activityId ${activity.id}: $status');
              } else {
                //print('🚫 activityId ${activity.id} não encontrado em ${island.id}');
              }
            } else {
              //print('🚫 islandId ${island.id} não encontrado em ${planet.id}');
            }
          } else {
            //print('🚫 planetId ${planet.id} não encontrado no activityStatuses');
          }

          activity.status = status;
        }
        
      }

      return planet;
    }).toList();

    return planets;
  } catch (e) {
    print('❌ Erro ao carregar planetas do Firestore: $e');
    rethrow;
  }
}



