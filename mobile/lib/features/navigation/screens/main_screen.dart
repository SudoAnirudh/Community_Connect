import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/theme/app_colors.dart';

class MainScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScreen({super.key, required this.navigationShell});

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      extendBody: true, // Needed for floating bottom nav bar
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BottomNavigationBar(
              currentIndex: navigationShell.currentIndex,
              onTap: (index) => _onTap(context, index),
              backgroundColor: Colors.transparent,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppColors.primaryGreen,
              unselectedItemColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              unselectedLabelStyle: const TextStyle(fontSize: 12),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(PhosphorIconsRegular.house),
                  activeIcon: Icon(PhosphorIconsFill.house),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(PhosphorIconsRegular.envelopeSimpleOpen),
                  activeIcon: Icon(PhosphorIconsFill.envelopeSimpleOpen),
                  label: 'Invites',
                ),
                BottomNavigationBarItem(
                  icon: Icon(PhosphorIconsRegular.bellRinging),
                  activeIcon: Icon(PhosphorIconsFill.bellRinging),
                  label: 'Notices',
                ),
                BottomNavigationBarItem(
                  icon: Icon(PhosphorIconsRegular.usersThree),
                  activeIcon: Icon(PhosphorIconsFill.usersThree),
                  label: 'Community',
                ),
                BottomNavigationBarItem(
                  icon: Icon(PhosphorIconsRegular.userCircle),
                  activeIcon: Icon(PhosphorIconsFill.userCircle),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
