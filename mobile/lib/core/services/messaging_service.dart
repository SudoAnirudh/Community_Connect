import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class MessagingService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> init() async {
    try {
      // 1. Request notification permissions (required for iOS and Android 13+)
      NotificationSettings settings = await _fcm.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('FCM: User granted push notification permission.');
      } else {
        debugPrint('FCM: User declined or has not granted push notification permission.');
      }

      // 2. Retrieve initial FCM Token
      String? token = await _fcm.getToken();
      if (token != null) {
        debugPrint('FCM Token: $token');
        await _saveTokenToSupabase(token);
      }

      // 3. Listen for token refreshes
      _fcm.onTokenRefresh.listen((newToken) async {
        debugPrint('FCM Token Refreshed: $newToken');
        await _saveTokenToSupabase(newToken);
      });

      // 4. Configure foreground messaging options to display alerts if app is open
      await _fcm.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // 5. Listen to auth state changes to sync token when user logs in
      FirebaseAuth.instance.authStateChanges().listen((user) async {
        if (user != null) {
          String? currentToken = await _fcm.getToken();
          if (currentToken != null) {
            await _saveTokenToSupabase(currentToken);
          }
        }
      });
    } catch (e) {
      debugPrint('FCM: Error initializing messaging service: $e');
    }
  }

  Future<void> _saveTokenToSupabase(String token) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await Supabase.instance.client
            .from('users')
            .update({'fcm_token': token})
            .eq('uid', user.uid);
        debugPrint('FCM: Successfully registered push token in Supabase database for user ${user.uid}.');
      } catch (e) {
        debugPrint('FCM: Failed to save token to Supabase: $e');
      }
    } else {
      debugPrint('FCM: No logged-in user found. Skipping token database sync.');
    }
  }
}
