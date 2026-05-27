import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/mocks/mock_data.dart';
import '../widgets/invitation_card.dart';
import 'package:flutter_animate/flutter_animate.dart';

class InvitationsScreen extends StatelessWidget {
  const InvitationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Invitations',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: false,
      ),
      body: MockData.invitations.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/empty_events.png',
                    height: 200,
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
                    'No Upcoming Events\nor Invitations',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                  ).animate().fade(delay: 300.ms, duration: 600.ms).slideY(begin: 0.1, end: 0),
                  const SizedBox(height: 48),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 100),
              itemCount: MockData.invitations.length,
              itemBuilder: (context, index) {
                return InvitationCard(invitation: MockData.invitations[index])
                    .animate()
                    .fade(delay: (index * 100).ms, duration: 400.ms)
                    .slideX(begin: 0.1, end: 0, curve: Curves.easeOutQuad);
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
    );
  }
}
