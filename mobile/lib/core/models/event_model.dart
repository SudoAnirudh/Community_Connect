class EventModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String time;
  final String venue;
  final String host;
  final String? imageUrl;
  final String createdBy;
  final String status;

  const EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.venue,
    required this.host,
    this.imageUrl,
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
      'host': host,
      'imageUrl': imageUrl,
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
      host: map['host'] ?? '',
      imageUrl: map['imageUrl'],
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
    String? host,
    String? imageUrl,
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
      host: host ?? this.host,
      imageUrl: imageUrl ?? this.imageUrl,
      createdBy: createdBy ?? this.createdBy,
      status: status ?? this.status,
    );
  }
}
