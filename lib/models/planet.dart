import 'island.dart';

class Planet {
  final String id;
  final String name;
  final String image;
  final String color;
  final List<Island> island;

  Planet({
    required this.id,
    required this.name,
    required this.image,
    required this.color,
    required this.island,
  });

  factory Planet.fromJson(Map<String, dynamic> json) {
    return Planet(
      id: json['id'] ?? 'unknown_id',
      name: json['name'] ?? 'Planeta sem nome',
      image: json['image'] ?? '',
      color: json['color'] ?? '#FFFFFF',
      island: (json['island'] as List)
          .map((islandJson) => Island.fromJson(islandJson))
          .toList() ?? [],
    );
  }
}
