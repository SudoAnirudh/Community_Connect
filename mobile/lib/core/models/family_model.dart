class FamilyModel {
  final String id;
  final String name;
  final String houseName;
  final String wardNumber;
  final String adminUid;
  final List<String> memberUids;
  final String verificationStatus; // 'pending', 'approved', 'rejected'

  const FamilyModel({
    required this.id,
    required this.name,
    required this.houseName,
    required this.wardNumber,
    required this.adminUid,
    required this.memberUids,
    this.verificationStatus = 'pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'houseName': houseName,
      'wardNumber': wardNumber,
      'adminUid': adminUid,
      'memberUids': memberUids,
      'verificationStatus': verificationStatus,
    };
  }

  factory FamilyModel.fromMap(Map<String, dynamic> map, String documentId) {
    return FamilyModel(
      id: documentId,
      name: map['name'] ?? '',
      houseName: map['houseName'] ?? '',
      wardNumber: map['wardNumber'] ?? '',
      adminUid: map['adminUid'] ?? '',
      memberUids: List<String>.from(map['memberUids'] ?? []),
      verificationStatus: map['verificationStatus'] ?? 'pending',
    );
  }

  FamilyModel copyWith({
    String? id,
    String? name,
    String? houseName,
    String? wardNumber,
    String? adminUid,
    List<String>? memberUids,
    String? verificationStatus,
  }) {
    return FamilyModel(
      id: id ?? this.id,
      name: name ?? this.name,
      houseName: houseName ?? this.houseName,
      wardNumber: wardNumber ?? this.wardNumber,
      adminUid: adminUid ?? this.adminUid,
      memberUids: memberUids ?? this.memberUids,
      verificationStatus: verificationStatus ?? this.verificationStatus,
    );
  }
}
