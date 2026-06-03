import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/services/messaging_service.dart';
import 'core/widgets/offline_banner_wrapper.dart';
import 'core/config/supabase_config.dart';

void main() async {
  // Ensure Flutter bindings are initialized before Supabase
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  // Initialize Messaging
  final messagingService = MessagingService();
  await messagingService.init();
  
  runApp(
    const ProviderScope(
      child: CommunityConnectApp(),
    ),
  );
}

class CommunityConnectApp extends ConsumerWidget {
  const CommunityConnectApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'CommunityConnect',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Automatically switch based on device settings
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) => OfflineBannerWrapper(child: child!),
    );
  }
}
