import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/planet.dart';

Future<List<Planet>> loadPlanets() async {
  final String jsonString = await rootBundle.loadString('assets/data/planets.json');
  final List<dynamic> data = json.decode(jsonString);
  return data.map((item) => Planet.fromJson(item)).toList();
}
