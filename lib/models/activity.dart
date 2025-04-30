class Activity {
  final String id;
  final String name;
  final String video;
  final String status;

  Activity({
    required this.id,
    required this.name,
    required this.video,
    required this.status,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      name: json['name'],
      video: json['video'],
      status: json['status'],
    );
  }
}
