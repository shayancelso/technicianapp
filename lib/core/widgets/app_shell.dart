import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme/app_colors.dart';
import '../../config/routes/route_names.dart';

/// Persistent bottom navigation shell that wraps all main pages.
class AppShell extends StatefulWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Update index based on current route
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/dashboard')) {
      _currentIndex = 0;
    } else if (location.startsWith('/work-orders')) {
      _currentIndex = 1;
    } else if (location.startsWith('/notifications')) {
      _currentIndex = 3;
    } else if (location.startsWith('/profile')) {
      _currentIndex = 4;
    }

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 64,
            child: Row(
              children: [
                _NavItem(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  isActive: _currentIndex == 0,
                  onTap: () => context.go(RouteNames.dashboard),
                ),
                _NavItem(
                  icon: Icons.assignment_outlined,
                  label: 'Work Orders',
                  isActive: _currentIndex == 1,
                  onTap: () => context.push('${RouteNames.workOrderList}/rm'),
                ),
                // Center FAB
                Expanded(
                  child: GestureDetector(
                    onTap: () {},
                    child: Center(
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add_rounded,
                          color: AppColors.textOnPrimary,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
                _NavItem(
                  icon: Icons.notifications_outlined,
                  label: 'Notifications',
                  isActive: _currentIndex == 3,
                  badgeCount: 3,
                  onTap: () {},
                ),
                _NavItem(
                  icon: Icons.person_outline_rounded,
                  label: 'Profile',
                  isActive: _currentIndex == 4,
                  onTap: () => context.push(RouteNames.profile),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final int? badgeCount;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    this.badgeCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: isActive ? AppColors.primary : AppColors.textTertiary,
                ),
                if (badgeCount != null && badgeCount! > 0)
                  Positioned(
                    top: -4,
                    right: -8,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$badgeCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive ? AppColors.primary : AppColors.textTertiary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
