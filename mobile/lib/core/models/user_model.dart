class UserModel {
  final String uid;
  final String phone;
  final String name;
  final String? familyId;
  final String role; // e.g., 'admin', 'member'
  final String? fcmToken;
  final DateTime createdAt;

  const UserModel({
    required this.uid,
    required this.phone,
    required this.name,
    this.familyId,
    this.role = 'member',
    this.fcmToken,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'phone': phone,
      'name': name,
      'familyId': familyId,
      'role': role,
      'fcmToken': fcmToken,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String documentId) {
    return UserModel(
      uid: documentId,
      phone: map['phone'] ?? '',
      name: map['name'] ?? '',
      familyId: map['familyId'],
      role: map['role'] ?? 'member',
      fcmToken: map['fcmToken'],
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt']) 
          : DateTime.now(),
    );
  }

  UserModel copyWith({
    String? uid,
    String? phone,
    String? name,
    String? familyId,
    String? role,
    String? fcmToken,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      familyId: familyId ?? this.familyId,
      role: role ?? this.role,
      fcmToken: fcmToken ?? this.fcmToken,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
