import 'package:flutter/material.dart';

class Planet {
  final String id;
  final String name;
  final String image;
  final Color color;
  final List<dynamic> island;

  Planet({
    required this.id,
    required this.name,
    required this.image,
    required this.color,
    required this.island,
  });

  factory Planet.fromJson(Map<String, dynamic> json) {
    return Planet(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      color: Color(int.parse(json['color'].replaceFirst('#', '0xff'))),
      island: json['island'] ?? [],
    );
  }
}
