class JoinRequestModel {
  final String id;
  final String familyId;
  final String userId;
  final String userName;
  final String userPhone;
  final String status; // 'pending', 'approved', 'rejected'
  final DateTime createdAt;

  const JoinRequestModel({
    required this.id,
    required this.familyId,
    required this.userId,
    required this.userName,
    required this.userPhone,
    this.status = 'pending',
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'familyId': familyId,
      'userId': userId,
      'userName': userName,
      'userPhone': userPhone,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory JoinRequestModel.fromMap(Map<String, dynamic> map, String documentId) {
    return JoinRequestModel(
      id: documentId,
      familyId: map['familyId'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userPhone: map['userPhone'] ?? '',
      status: map['status'] ?? 'pending',
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt']) 
          : DateTime.now(),
    );
  }
}
