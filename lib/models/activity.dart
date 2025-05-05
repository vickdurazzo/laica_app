class Activity {
  final String id;
  final String name;
  final String video;
  String status;

  Activity({
    required this.id,
    required this.name,
    required this.video,
    this.status = 'locked',
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      video: json['video'] ?? '',
      status: json['status'] ?? 'locked',
    );
  }
}
