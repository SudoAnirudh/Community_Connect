import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/notice_providers.dart';
import '../widgets/notice_card.dart';

class NoticesScreen extends ConsumerWidget {
  const NoticesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noticesAsync = ref.watch(noticesStreamProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notice Board',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: false,
      ),
      body: noticesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (notices) {
          if (notices.isEmpty) {
            return Center(
              child: Text(
                'No notices yet.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 100),
            itemCount: notices.length,
            itemBuilder: (context, index) {
              return NoticeCard(notice: notices[index]);
            },
          );
        },
      ),
    );
  }
}
