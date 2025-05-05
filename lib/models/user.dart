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
}

class Child {
  final String child_id;
  final String name;
  final String birthday;
  final String avatar;
  final Progress progress;

  Child({
    required this.child_id,
    required this.name,
    required this.birthday,
    required this.avatar,
    required this.progress,
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'child_id': child_id,
      'name': name,
      'birthday': birthday,
      'avatar': avatar,
      'progress': progress.toJson(),
    };
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
}
