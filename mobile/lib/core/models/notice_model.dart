import 'package:flutter/material.dart';

class NoticeModel {
  final String id;
  final String title;
  final String description;
  final String icon; // Store as string representation or predefined icon name
  final String colorHex; 
  final DateTime createdAt;
  final String priority;

  const NoticeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.colorHex,
    required this.createdAt,
    this.priority = 'Medium',
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'icon': icon,
      'colorHex': colorHex,
      'createdAt': createdAt.toIso8601String(),
      'priority': priority,
    };
  }

  factory NoticeModel.fromMap(Map<String, dynamic> map, String documentId) {
    return NoticeModel(
      id: documentId,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      icon: map['icon'] ?? 'info',
      colorHex: map['colorHex'] ?? '#000000',
      createdAt: map['createdAt'] != null 
          ? (map['createdAt'].runtimeType.toString() == 'Timestamp' 
              ? map['createdAt'].toDate() 
              : DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now())
          : DateTime.now(),
      priority: map['priority'] ?? 'Medium',
    );
  }
}
