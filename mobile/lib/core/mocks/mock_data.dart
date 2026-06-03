import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../theme/app_colors.dart';

class MockData {
  static final List<Map<String, dynamic>> upcomingEvents = [
    {
      'title': 'Onam Celebration',
      'date': 'Sep 15, 2026',
      'venue': 'Community Hall, Ward 4',
      'imageUrl': 'https://images.unsplash.com/photo-1596426462947-f28c5a2c1f06?q=80&w=600&auto=format&fit=crop', // Mock image
    },
    {
      'title': 'Anirudh\'s Wedding',
      'date': 'Oct 12, 2026',
      'venue': 'Sri Krishna Temple',
      'imageUrl': 'https://images.unsplash.com/photo-1519741497674-611481863552?q=80&w=600&auto=format&fit=crop',
    },
    {
      'title': 'Resident Association Meet',
      'date': 'Nov 01, 2026',
      'venue': 'Library Ground',
      'imageUrl': 'https://images.unsplash.com/photo-1511556532299-8f662fc26c06?q=80&w=600&auto=format&fit=crop',
    },
  ];

  static final List<Map<String, dynamic>> recentNotifications = [
    {
      'title': 'Power Cut Scheduled',
      'description': 'Power outage tomorrow from 10 AM to 2 PM in wards 4 and 5 due to maintenance work.',
      'icon': PhosphorIconsRegular.lightning,
      'color': AppColors.warning,
      'time': '2 hrs ago',
      'priority': 'High',
    },
    {
      'title': 'Plastic Collection',
      'description': 'Please keep plastic waste ready by 9 AM tomorrow. Haritha Karma Sena will collect it.',
      'icon': PhosphorIconsRegular.recycle,
      'color': AppColors.primaryGreen,
      'time': '5 hrs ago',
      'priority': 'Medium',
    },
    {
      'title': 'Ward Meeting',
      'description': 'Urgent ward meeting regarding water supply in the local area.',
      'icon': PhosphorIconsRegular.usersThree,
      'color': AppColors.info,
      'time': '1 day ago',
      'priority': 'Medium',
    },
    {
      'title': 'Revenue Collection',
      'description': 'Tax collection camp will be held at the Panchayat office.',
      'icon': PhosphorIconsRegular.receipt,
      'color': AppColors.secondaryGreen,
      'time': '2 days ago',
      'priority': 'Low',
    },
    {
      'title': 'Emergency Alert',
      'description': 'Heavy rain warning. Please avoid traveling near the river.',
      'icon': PhosphorIconsRegular.siren,
      'color': AppColors.error,
      'time': '3 days ago',
      'priority': 'High',
    },
  ];

  static final List<Map<String, dynamic>> invitations = [
    {
      'title': 'Onam Community Feast',
      'date': 'Sep 15, 2026',
      'time': '11:30 AM',
      'venue': 'Community Hall, Ward 4',
      'host': 'Ward Association',
      'imageUrl': 'https://images.unsplash.com/photo-1596426462947-f28c5a2c1f06?q=80&w=600&auto=format&fit=crop',
      'status': 'pending', // 'pending', 'accepted', 'declined'
    },
    {
      'title': 'Anirudh & Meera Wedding',
      'date': 'Oct 12, 2026',
      'time': '10:00 AM',
      'venue': 'Sri Krishna Temple',
      'host': 'Nair Family',
      'imageUrl': 'https://images.unsplash.com/photo-1519741497674-611481863552?q=80&w=600&auto=format&fit=crop',
      'status': 'accepted',
    },
    {
      'title': 'Annual Resident Association Meet',
      'date': 'Nov 01, 2026',
      'time': '04:00 PM',
      'venue': 'Library Ground',
      'host': 'RWA Committee',
      'imageUrl': 'https://images.unsplash.com/photo-1511556532299-8f662fc26c06?q=80&w=600&auto=format&fit=crop',
      'status': 'pending',
    },
  ];

  static final List<Map<String, dynamic>> communityPosts = [
    {
      'id': 'P001',
      'userName': 'Suresh Kumar',
      'userAvatar': 'https://i.pravatar.cc/150?u=suresh',
      'timestamp': '2 hours ago',
      'content': 'Has anyone received the new property tax forms from the Panchayat office? Let me know if the counters are open today.',
      'imageUrl': null,
      'likes': 12,
      'comments': 4,
    },
    {
      'id': 'P002',
      'userName': 'Priya Nair',
      'userAvatar': 'https://i.pravatar.cc/150?u=priya',
      'timestamp': '5 hours ago',
      'content': 'Glimpses from yesterday\'s community cleaning drive! Thanks to everyone who participated. #Ward4Clean',
      'imageUrl': 'https://images.unsplash.com/photo-1618477461853-cf6ed80fbea5?q=80&w=600&auto=format&fit=crop',
      'likes': 45,
      'comments': 8,
    },
    {
      'id': 'P003',
      'userName': 'Rahul M',
      'userAvatar': 'https://i.pravatar.cc/150?u=rahul',
      'timestamp': '1 day ago',
      'content': 'Water supply seems to be disrupted in the North Avenue area since morning. Did anyone get any prior notice?',
      'imageUrl': null,
      'likes': 5,
      'comments': 12,
    },
  ];

  static final Map<String, dynamic> currentFamily = {
    'familyId': 'FAM102',
    'familyName': 'Rahman Family',
    'houseName': 'Noor Mahal',
    'wardNumber': '12',
    'familyAdminId': 'USR201',
    'verificationStatus': 'Approved',
  };

  static final List<Map<String, dynamic>> familyMembers = [
    {
      'userId': 'USR201',
      'name': 'Afsal Rahman',
      'role': 'Family Admin',
      'status': 'Approved',
      'avatar': 'https://i.pravatar.cc/150?u=afsal',
    },
    {
      'userId': 'USR301',
      'name': 'Nadiya Rahman',
      'role': 'Member',
      'status': 'Approved',
      'avatar': 'https://i.pravatar.cc/150?u=nadiya',
    },
    {
      'userId': 'USR302',
      'name': 'Shamil Rahman',
      'role': 'Member',
      'status': 'Approved',
      'avatar': 'https://i.pravatar.cc/150?u=shamil',
    },
  ];

  static final List<Map<String, dynamic>> joinRequests = [
    {
      'requestId': 'REQ001',
      'userId': 'USR401',
      'name': 'Hiba Rahman',
      'avatar': 'https://i.pravatar.cc/150?u=hiba',
      'wardNumber': '12',
      'message': 'Hi, I registered my account today. Please approve my join request to our family group.',
      'requestDate': 'Just now',
    },
    {
      'requestId': 'REQ002',
      'userId': 'USR402',
      'name': 'Mohammed',
      'avatar': 'https://i.pravatar.cc/150?u=mohammed',
      'wardNumber': '12',
      'message': 'Please approve my request.',
      'requestDate': '2 days ago',
    },
  ];

  static final List<Map<String, dynamic>> communityFamilies = [
    {
      'familyId': 'FAM102',
      'familyName': 'Rahman Family',
      'houseName': 'Noor Mahal',
      'wardNumber': '12',
      'members': [
        {'userId': 'USR201', 'name': 'Afsal Rahman', 'role': 'Family Admin'},
        {'userId': 'USR301', 'name': 'Nadiya Rahman', 'role': 'Member'},
        {'userId': 'USR302', 'name': 'Shamil Rahman', 'role': 'Member'},
      ],
    },
    {
      'familyId': 'FAM105',
      'familyName': 'Nair Family',
      'houseName': 'Gokulam',
      'wardNumber': '12',
      'members': [
        {'userId': 'USR501', 'name': 'Priya Nair', 'role': 'Family Admin'},
        {'userId': 'USR502', 'name': 'Kiran Nair', 'role': 'Member'},
      ],
    },
    {
      'familyId': 'FAM108',
      'familyName': 'Kumar Family',
      'houseName': 'Sree Nilayam',
      'wardNumber': '12',
      'members': [
        {'userId': 'USR601', 'name': 'Suresh Kumar', 'role': 'Family Admin'},
        {'userId': 'USR602', 'name': 'Lakshmi Suresh', 'role': 'Member'},
        {'userId': 'USR603', 'name': 'Rahul Kumar', 'role': 'Member'},
        {'userId': 'USR604', 'name': 'Anjali Kumar', 'role': 'Member'},
      ],
    },
  ];
}
