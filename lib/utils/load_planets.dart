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
import '../models/planet.dart';

Future<List<Planet>> loadPlanets() async {
  try {
    final snapshot = await FirebaseFirestore.instance.collection('activities').get();

    // Debug: Print o raw JSON do Firestore
    for (var doc in snapshot.docs) {
      print('🔥 Documento ${doc.id}: ${doc.data()}');
      print("----------------------------------------------");
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
