class Activity {
  final String id;
  final String name;
  final String video;
  String status;
  int ordem;

  Activity({
    required this.id,
    required this.name,
    required this.video,
    this.status = 'locked',
    this.ordem = 0,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      video: json['video'] ?? '',
      status: json['status'] ?? 'locked',
      ordem: json['ordem'] ?? 0,
    );
  }
}
