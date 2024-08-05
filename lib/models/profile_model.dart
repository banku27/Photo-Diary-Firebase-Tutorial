class ProfileModel {
  final String name;
  final String uid;
  final String phone;
  final String? profileUrl;
  final DateTime createdAt;

  ProfileModel({
    required this.name,
    required this.uid,
    required this.phone,
    required this.profileUrl,
    required this.createdAt,
  });

  ProfileModel copyWith({
    String? name,
    String? uid,
    String? phone,
    String? profileUrl,
    DateTime? createdAt,
  }) {
    return ProfileModel(
      name: name ?? this.name,
      uid: uid ?? this.uid,
      phone: phone ?? this.phone,
      profileUrl: profileUrl ?? this.profileUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  bool isProfileCompleted() => profileUrl != "";

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'name': name});
    result.addAll({'uid': uid});
    result.addAll({'phone': phone});
    if (profileUrl != null) {
      result.addAll({'profileUrl': profileUrl});
    }
    result.addAll({'createdAt': createdAt.millisecondsSinceEpoch});

    return result;
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      name: map['name'] ?? '',
      uid: map['uid'] ?? '',
      phone: map['phone'] ?? '',
      profileUrl: map['profileUrl'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }
}
