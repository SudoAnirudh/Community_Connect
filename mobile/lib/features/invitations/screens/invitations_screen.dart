import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/providers/event_providers.dart';
import '../../../../core/providers/family_providers.dart';
import '../widgets/invitation_card.dart';

class InvitationsScreen extends ConsumerWidget {
  const InvitationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsStreamProvider);
    final currentUserAsync = ref.watch(currentUserModelProvider);
    
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Invitations',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          centerTitle: false,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Received'),
              Tab(text: 'Sent'),
            ],
          ),
        ),
        body: currentUserAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => const Center(child: Text('Error loading user')),
          data: (user) {
            return eventsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
              data: (events) {
                // Sent events: where createdBy == currentUser.uid
                final sentEvents = events.where((e) => e.createdBy == user?.uid).toList();
                // Received events: where createdBy != currentUser.uid (or any criteria for invited)
                final receivedEvents = events.where((e) => e.createdBy != user?.uid).toList();

                return TabBarView(
                  children: [
                    _buildEventsList(context, receivedEvents, isSent: false),
                    _buildEventsList(context, sentEvents, isSent: true),
                  ],
                );
              },
            );
          },
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 80),
          child: FloatingActionButton(
            onPressed: () => context.push('/create-event'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildEventsList(BuildContext context, List events, {required bool isSent}) {
    if (events.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/empty_events.png',
                height: 200,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.event_busy, size: 80),
              ).animate().fade(duration: 600.ms).scale(begin: const Offset(0.9, 0.9)),
              const SizedBox(height: 24),
              Text(
                'ALL CAUGHT UP!',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ).animate().fade(delay: 200.ms, duration: 600.ms).slideY(begin: 0.1, end: 0),
              const SizedBox(height: 8),
              Text(
                isSent ? 'No Sent Invitations' : 'No Received Invitations',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
              ).animate().fade(delay: 300.ms, duration: 600.ms).slideY(begin: 0.1, end: 0),
              const SizedBox(height: 48),
            ],
          ),
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 100),
      itemCount: events.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            InvitationCard(invitation: events[index])
                .animate()
                .fade(delay: (index * 100).ms, duration: 400.ms)
                .slideX(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
            if (isSent)
               // Simple RSVP stats mockup
               Padding(
                 padding: const EdgeInsets.only(bottom: 16),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: [
                     _buildStatChip(context, 'Accepted', '12', Colors.green),
                     _buildStatChip(context, 'Declined', '2', Colors.red),
                     _buildStatChip(context, 'Maybe', '5', Colors.orange),
                   ],
                 ),
               ),
          ],
        );
      },
    );
  }

  Widget _buildStatChip(BuildContext context, String label, String count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        '$label: $count',
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}
