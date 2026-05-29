import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/mocks/mock_data.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/event_carousel_item.dart';
import '../widgets/notification_list_item.dart';
import '../widgets/quick_action_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 32),
              _buildQuickActions(context),
              const SizedBox(height: 32),
              _buildUpcomingEvents(context),
              const SizedBox(height: 32),
              _buildRecentNotifications(context),
              const SizedBox(height: 100), // Space for floating nav bar
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Morning,',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Anirudh 👋',
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(PhosphorIconsRegular.bell),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1,
          children: [
            QuickActionCard(
              title: 'Create\nInvitation',
              icon: PhosphorIconsRegular.envelopeSimpleOpen,
              iconColor: AppColors.primaryGreen,
              onTap: () {
                context.push('/create-event');
              },
            ),
            QuickActionCard(
              title: 'View\nNotices',
              icon: PhosphorIconsRegular.clipboardText,
              iconColor: AppColors.accentBlue,
              onTap: () {
                context.go('/notices');
              },
            ),
            QuickActionCard(
              title: 'Upcoming\nEvents',
              icon: PhosphorIconsRegular.calendarStar,
              iconColor: AppColors.warning,
              onTap: () {
                context.push('/invitations');
              },
            ),
            QuickActionCard(
              title: 'Community\nAlerts',
              icon: PhosphorIconsRegular.warningCircle,
              iconColor: AppColors.error,
              onTap: () {
                context.go('/notices');
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUpcomingEvents(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Upcoming Events',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            TextButton(
              onPressed: () {},
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: MockData.upcomingEvents.length,
            clipBehavior: Clip.none,
            itemBuilder: (context, index) {
              return EventCarouselItem(event: MockData.upcomingEvents[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentNotifications(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Notices',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: MockData.recentNotifications.length,
          itemBuilder: (context, index) {
            return NotificationListItem(
              notification: MockData.recentNotifications[index],
            );
          },
        ),
      ],
    );
  }
}
