import 'activity.dart';

class Island {
  final String id;
  final String name;
  final String image;
 
  final List<Activity> activities;

  Island({
    required this.id,
    required this.name,
    required this.image,
    required this.activities,
  });

  factory Island.fromJson(Map<String, dynamic> json) {
    return Island(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      activities: (json['activities'] as List)
          .map((activityJson) => Activity.fromJson(activityJson))
          .toList() ?? [],
    );
  }
}
