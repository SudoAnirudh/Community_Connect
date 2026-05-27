class EventModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String time;
  final String venue;
  final double? latitude;
  final double? longitude;
  final String host;
  final String? imageUrl;
  final List<String> attachments; // e.g. PDFs, extra images
  final String createdBy;
  final String status;

  const EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.venue,
    this.latitude,
    this.longitude,
    required this.host,
    this.imageUrl,
    this.attachments = const [],
    required this.createdBy,
    this.status = 'upcoming',
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'time': time,
      'venue': venue,
      'latitude': latitude,
      'longitude': longitude,
      'host': host,
      'imageUrl': imageUrl,
      'attachments': attachments,
      'createdBy': createdBy,
      'status': status,
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map, String documentId) {
    return EventModel(
      id: documentId,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      date: map['date'] != null 
          ? DateTime.parse(map['date']) 
          : DateTime.now(),
      time: map['time'] ?? '',
      venue: map['venue'] ?? '',
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      host: map['host'] ?? '',
      imageUrl: map['imageUrl'],
      attachments: List<String>.from(map['attachments'] ?? []),
      createdBy: map['createdBy'] ?? '',
      status: map['status'] ?? 'upcoming',
    );
  }

  EventModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    String? time,
    String? venue,
    double? latitude,
    double? longitude,
    String? host,
    String? imageUrl,
    List<String>? attachments,
    String? createdBy,
    String? status,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
      venue: venue ?? this.venue,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      host: host ?? this.host,
      imageUrl: imageUrl ?? this.imageUrl,
      attachments: attachments ?? this.attachments,
      createdBy: createdBy ?? this.createdBy,
      status: status ?? this.status,
    );
  }
}
