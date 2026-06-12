import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../config/routes/route_names.dart';
import '../../../../core/widgets/app_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isOnline = true;
  int _currentNavIndex = 0;

  static const double _overallRating = 3.0;
  static const List<_StarData> _starBreakdown = [
    _StarData(stars: 5, count: 11),
    _StarData(stars: 4, count: 3),
    _StarData(stars: 3, count: 8),
    _StarData(stars: 2, count: 4),
    _StarData(stars: 1, count: 4),
  ];

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Sign Out', style: AppTextStyles.h3),
        content: Text('Are you sure you want to sign out?', style: AppTextStyles.bodySmall),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.go(RouteNames.login);
            },
            style: ElevatedButton.styleFrom(minimumSize: const Size(80, 36)),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // ── Top Bar ──
            _buildTopBar(),

            // ── Technician Profile ──
            _buildProfileSection(),

            const SizedBox(height: 8),

            // ── Rating Card ──
            _buildRatingCard(),

            const SizedBox(height: 8),

            // ── Reactive Maintenance ──
            _buildSectionHeader('REACTIVE MAINTENANCE'),
            _buildReactiveMaintenance(),

            const SizedBox(height: 8),

            // ── Scheduled Maintenance ──
            _buildSectionHeader('SCHEDULED MAINTENANCE'),
            _buildScheduledMaintenance(),

            const SizedBox(height: 8),

            // ── My Team ──
            _buildSectionHeader('MY TEAM'),
            _buildMyTeam(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ── Top Bar ──
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMD,
        vertical: AppDimensions.paddingSM,
      ),
      child: Row(
        children: [
          // Online/Offline pill
          GestureDetector(
            onTap: () => setState(() => _isOnline = !_isOnline),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _isOnline
                    ? AppColors.success.withValues(alpha: 0.1)
                    : AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusChip),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _isOnline ? AppColors.success : AppColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _isOnline ? 'Online' : 'Offline',
                    style: AppTextStyles.caption.copyWith(
                      color: _isOnline ? AppColors.success : AppColors.error,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          // Notification bell with badge
          _HeaderIcon(
            icon: Icons.notifications_outlined,
            badgeCount: 3,
            onTap: () {},
          ),
          const SizedBox(width: 8),
          // Profile icon
          _HeaderIcon(
            icon: Icons.person_outline_rounded,
            onTap: () => context.push(RouteNames.profile),
          ),
          const SizedBox(width: 8),
          // Logout icon
          _HeaderIcon(
            icon: Icons.logout_rounded,
            onTap: _handleLogout,
          ),
        ],
      ),
    );
  }

  // ── Profile Section ──
  Widget _buildProfileSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMD,
        vertical: AppDimensions.paddingSM,
      ),
      child: Row(
        children: [
          // Large green avatar
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                'SS',
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.textOnPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('S Sampath', style: AppTextStyles.h2),
              const SizedBox(height: 2),
              Text(
                'AC Technician',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Rating Card ──
  Widget _buildRatingCard() {
    final maxCount = _starBreakdown.map((s) => s.count).reduce((a, b) => a > b ? a : b);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMD),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingMD),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rating header row
            Row(
              children: [
                Text(
                  '${_overallRating.toStringAsFixed(1)}/5',
                  style: AppTextStyles.h1.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(width: 8),
                // Stars
                ...List.generate(5, (i) {
                  if (_overallRating >= i + 1) {
                    return const Icon(Icons.star_rounded, color: AppColors.warning, size: 20);
                  } else if (_overallRating > i) {
                    return const Icon(Icons.star_half_rounded, color: AppColors.warning, size: 20);
                  }
                  return Icon(Icons.star_rounded, color: Colors.grey.shade300, size: 20);
                }),
                const SizedBox(width: 10),
                Text('Rating (30d)', style: AppTextStyles.bodySmall),
                const SizedBox(width: 4),
                Icon(Icons.info_outline_rounded, size: 16, color: AppColors.textTertiary),
              ],
            ),
            const SizedBox(height: 20),
            // Star breakdown bars
            ..._starBreakdown.map((data) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 14,
                    child: Text(
                      '${data.stars}',
                      style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.star_rounded, color: _starColor(data.stars), size: 14),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Stack(
                      children: [
                        // Background track
                        Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.border,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        // Filled bar
                        FractionallySizedBox(
                          widthFactor: (data.count / maxCount).clamp(0.0, 1.0),
                          child: Container(
                            height: 8,
                            decoration: BoxDecoration(
                              color: _starColor(data.stars),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 24,
                    child: Text(
                      '${data.count}',
                      style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Color _starColor(int stars) {
    if (stars >= 4) return AppColors.primary;
    if (stars == 3) return AppColors.error;
    return AppColors.error;
  }

  // ── Section Header ──
  Widget _buildSectionHeader(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.paddingMD, 16, AppDimensions.paddingMD, 10,
      ),
      child: Text(label, style: AppTextStyles.overline),
    );
  }

  // ── Reactive Maintenance ──
  Widget _buildReactiveMaintenance() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMD),
      child: Row(
        children: [
          Expanded(
            child: _DashCard(
              icon: Icons.assignment_outlined,
              iconColor: AppColors.error,
              iconBg: AppColors.errorLight,
              title: 'RM WO',
              subtitle: 'Work Orders',
              badge: 4,
              onTap: () => context.push('${RouteNames.workOrderList}/rm'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _DashCard(
              icon: Icons.history_rounded,
              iconColor: AppColors.info,
              iconBg: AppColors.infoLight,
              title: 'History RM',
              subtitle: 'Past Work Orders',
              onTap: () => context.push('${RouteNames.workOrderList}/rm?history=true'),
            ),
          ),
        ],
      ),
    );
  }

  // ── Scheduled Maintenance ──
  Widget _buildScheduledMaintenance() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMD),
      child: Row(
        children: [
          Expanded(
            child: _DashCard(
              icon: Icons.event_note_outlined,
              iconColor: AppColors.warning,
              iconBg: AppColors.warningLight,
              title: 'PPM WO',
              badge: 1,
              compact: true,
              onTap: () => context.push('${RouteNames.workOrderList}/ppm'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _DashCard(
              icon: Icons.history_rounded,
              iconColor: AppColors.info,
              iconBg: AppColors.infoLight,
              title: 'History PPM',
              compact: true,
              onTap: () => context.push('${RouteNames.workOrderList}/ppm?history=true'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _DashCard(
              icon: Icons.cleaning_services_outlined,
              iconColor: AppColors.accent,
              iconBg: AppColors.accent.withValues(alpha: 0.12),
              title: 'SS WO',
              compact: true,
              onTap: () => context.push('${RouteNames.workOrderList}/ss'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _DashCard(
              icon: Icons.history_rounded,
              iconColor: AppColors.info,
              iconBg: AppColors.infoLight,
              title: 'History SS',
              compact: true,
              onTap: () => context.push('${RouteNames.workOrderList}/ss?history=true'),
            ),
          ),
        ],
      ),
    );
  }

  // ── My Team ──
  Widget _buildMyTeam() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMD),
      child: Row(
        children: [
          Expanded(
            child: _DashCard(
              icon: Icons.person_add_outlined,
              iconColor: AppColors.primary,
              iconBg: AppColors.primary.withValues(alpha: 0.1),
              title: 'Add Member',
              compact: true,
              onTap: () => context.push(RouteNames.addMember),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _DashCard(
              icon: Icons.person_remove_outlined,
              iconColor: AppColors.error,
              iconBg: AppColors.errorLight,
              title: 'Remove',
              compact: true,
              onTap: () => context.push(RouteNames.removeMember),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _DashCard(
              icon: Icons.groups_outlined,
              iconColor: AppColors.primary,
              iconBg: AppColors.primary.withValues(alpha: 0.1),
              title: 'View Team',
              compact: true,
              onTap: () => context.push(RouteNames.viewTeam),
            ),
          ),
        ],
      ),
    );
  }

  // ── Bottom Navigation ──
  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
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
                isActive: _currentNavIndex == 0,
                onTap: () => setState(() => _currentNavIndex = 0),
              ),
              _NavItem(
                icon: Icons.assignment_outlined,
                label: 'Work Orders',
                isActive: _currentNavIndex == 1,
                onTap: () {
                  setState(() => _currentNavIndex = 1);
                  context.push('${RouteNames.workOrderList}/rm');
                },
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
                isActive: _currentNavIndex == 3,
                badgeCount: 3,
                onTap: () => setState(() => _currentNavIndex = 3),
              ),
              _NavItem(
                icon: Icons.person_outline_rounded,
                label: 'Profile',
                isActive: _currentNavIndex == 4,
                onTap: () {
                  setState(() => _currentNavIndex = 4);
                  context.push(RouteNames.profile);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Header Icon Button ──
class _HeaderIcon extends StatelessWidget {
  final IconData icon;
  final int? badgeCount;
  final VoidCallback onTap;

  const _HeaderIcon({required this.icon, this.badgeCount, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 36,
        height: 36,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, size: 24, color: AppColors.textPrimary),
            if (badgeCount != null && badgeCount! > 0)
              Positioned(
                top: 2,
                right: 0,
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
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Dashboard Card ──
class _DashCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String? subtitle;
  final int? badge;
  final bool compact;
  final VoidCallback onTap;

  const _DashCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    this.subtitle,
    this.badge,
    this.compact = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: EdgeInsets.all(compact ? 12 : AppDimensions.paddingMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Icon with colored background
              Container(
                width: compact ? 40 : 44,
                height: compact ? 40 : 44,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: compact ? 20 : 22),
              ),
              if (badge != null && badge! > 0) ...[
                const Spacer(),
                Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$badge',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: compact ? 10 : 14),
          // Title + chevron row
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: compact ? 12 : 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: AppColors.textTertiary,
              ),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle!,
              style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

// ── Bottom Nav Item ──
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

// ── Data ──
class _StarData {
  final int stars;
  final int count;
  const _StarData({required this.stars, required this.count});
}
