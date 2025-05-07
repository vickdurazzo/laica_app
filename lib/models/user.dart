class UserModel {
  final String user_id;
  final String family_name;
  final String email;
  final String password_hash;
  final bool accepted_terms;
  final bool receive_updates;
  final int cellphone;
  final List<Child> children;
  final String created_at;
  final String last_login;

  UserModel({
    required this.user_id,
    required this.family_name,
    required this.email,
    required this.password_hash,
    required this.accepted_terms,
    required this.receive_updates,
    required this.cellphone,
    required this.children,
    required this.created_at,
    required this.last_login,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      user_id: json['user_id'] ?? '',
      family_name: json['family_name'] ?? '',
      email: json['email'] ?? '',
      password_hash: json['password_hash'] ?? '',
      accepted_terms: json['accepted_terms'] ?? false,
      receive_updates: json['receive_updates'] ?? false,
      cellphone: json['cellphone'] ?? 0,
      children: (json['children'] as List?)?.map((childJson) => Child.fromJson(childJson)).toList() ?? [],
      created_at: json['created_at'] ?? '',
      last_login: json['last_login'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': user_id,
      'family_name': family_name,
      'email': email,
      'password_hash': password_hash,
      'accepted_terms': accepted_terms,
      'receive_updates': receive_updates,
      'cellphone': cellphone,
      'children': children.map((c) => c.toJson()).toList(),
      'created_at': created_at,
      'last_login': last_login,
    };
  }

  UserModel copyWith({
    String? family_name,
    String? email,
    String? password_hash,
    bool? accepted_terms,
    bool? receive_updates,
    int? cellphone,
    List<Child>? children,
    String? created_at,
    String? last_login,
  }) {
    return UserModel(
      user_id: user_id, // geralmente fixo
      family_name: family_name ?? this.family_name,
      email: email ?? this.email,
      password_hash: password_hash ?? this.password_hash,
      accepted_terms: accepted_terms ?? this.accepted_terms,
      receive_updates: receive_updates ?? this.receive_updates,
      cellphone: cellphone ?? this.cellphone,
      children: children ?? this.children,
      created_at: created_at ?? this.created_at,
      last_login: last_login ?? this.last_login,
    );
  }


}

class Child {
  final String child_id;
  final String name;
  final String birthday;
  final String avatar;
  final Progress progress;
  final Map<String, dynamic> activityStatus;

  Child({
    required this.child_id,
    required this.name,
    required this.birthday,
    required this.avatar,
    required this.progress,
    required this.activityStatus,
  });

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      child_id: json['child_id'] ?? '',
      name: json['name'] ?? '',
      birthday: json['birthday'] ?? '',
      avatar: json['avatar'] ?? '',
      progress: json['progress'] != null
          ? Progress.fromJson(json['progress'])
          : Progress(missions_completed: 0, stars: 0),
      activityStatus: json['activity_status'] != null
          ? Map<String, dynamic>.from(json['activity_status'])
          : {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'child_id': child_id,
      'name': name,
      'birthday': birthday,
      'avatar': avatar,
      'progress': progress.toJson(),
      'activity_status': activityStatus,
    };
  }

  Child copyWith({
    String? name,
    String? birthday,
    String? avatar,
    Progress? progress,
    Map<String, dynamic>? activityStatus,
  }) {
    return Child(
      child_id: child_id,
      name: name ?? this.name,
      birthday: birthday ?? this.birthday,
      avatar: avatar ?? this.avatar,
      progress: progress ?? this.progress,
      activityStatus: activityStatus ?? this.activityStatus,
    );
  }
}


class Progress {
  final int missions_completed;
  final int stars;

  Progress({
    required this.missions_completed,
    required this.stars,
  });

  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      missions_completed: json['missions_completed'] ?? 0,
      stars: json['stars'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'missions_completed': missions_completed,
      'stars': stars,
    };
  }

  Progress copyWith({
    int? missions_completed,
    int? stars,
  }) {
    return Progress(
      missions_completed: missions_completed ?? this.missions_completed,
      stars: stars ?? this.stars,
    );
  }
}
