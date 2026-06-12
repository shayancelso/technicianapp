import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/constants/enums.dart';
import '../../../../config/routes/route_names.dart';

// ── Mock Team Members (sorted by longest-serving) ────────────────────────────

class _TeamMemberDetail {
  final String id;
  final String name;
  final String empId;
  final String designation;
  final String trade;
  final MemberType memberType;
  final int activeDays;
  final int activeHours;
  final bool isPunchedIn;
  final String punchInTime;
  final String currentTask;

  const _TeamMemberDetail({
    required this.id,
    required this.name,
    required this.empId,
    required this.designation,
    required this.trade,
    required this.memberType,
    required this.activeDays,
    required this.activeHours,
    required this.isPunchedIn,
    required this.punchInTime,
    required this.currentTask,
  });
}

// Sorted by activeDays descending (longest-serving first)
const _teamMembers = [
  _TeamMemberDetail(
    id: 'm1',
    name: 'Mohammed Al Hamdan',
    empId: 'EMP-0041',
    designation: 'Senior Technician',
    trade: 'Electrical',
    memberType: MemberType.primary,
    activeDays: 127,
    activeHours: 6,
    isPunchedIn: true,
    punchInTime: '08:00 AM',
    currentTask: 'MV Switchgear Inspection',
  ),
  _TeamMemberDetail(
    id: 'm2',
    name: 'Ibrahim Al Sayed',
    empId: 'EMP-0023',
    designation: 'Lead Technician',
    trade: 'HVAC',
    memberType: MemberType.primary,
    activeDays: 98,
    activeHours: 3,
    isPunchedIn: true,
    punchInTime: '08:15 AM',
    currentTask: 'Cooling Tower PM',
  ),
  _TeamMemberDetail(
    id: 'm3',
    name: 'Ravi Kumar Singh',
    empId: 'EMP-0067',
    designation: 'Technician',
    trade: 'Mechanical',
    memberType: MemberType.secondary,
    activeDays: 74,
    activeHours: 11,
    isPunchedIn: true,
    punchInTime: '09:00 AM',
    currentTask: 'Fan Coil Unit Replacement',
  ),
  _TeamMemberDetail(
    id: 'm4',
    name: 'Faisal Bin Khalid',
    empId: 'EMP-0112',
    designation: 'BMS Specialist',
    trade: 'BMS',
    memberType: MemberType.primary,
    activeDays: 52,
    activeHours: 9,
    isPunchedIn: false,
    punchInTime: '',
    currentTask: 'BMS Controller Diagnostics',
  ),
  _TeamMemberDetail(
    id: 'm5',
    name: 'Arun Prakash Nair',
    empId: 'EMP-0089',
    designation: 'Technician',
    trade: 'Plumbing',
    memberType: MemberType.secondary,
    activeDays: 41,
    activeHours: 2,
    isPunchedIn: true,
    punchInTime: '09:45 AM',
    currentTask: 'Hot Water Line Repair',
  ),
  _TeamMemberDetail(
    id: 'm6',
    name: 'Hamad Al Mansouri',
    empId: 'EMP-0058',
    designation: 'Senior Technician',
    trade: 'Civil',
    memberType: MemberType.secondary,
    activeDays: 30,
    activeHours: 7,
    isPunchedIn: true,
    punchInTime: '08:30 AM',
    currentTask: 'Structural Inspection B2',
  ),
  _TeamMemberDetail(
    id: 'm7',
    name: 'Dilnoza Yusupova',
    empId: 'EMP-0077',
    designation: 'Instrument Tech',
    trade: 'Instrumentation',
    memberType: MemberType.secondary,
    activeDays: 22,
    activeHours: 4,
    isPunchedIn: false,
    punchInTime: '',
    currentTask: 'Flow Meter Calibration',
  ),
  _TeamMemberDetail(
    id: 'm8',
    name: 'Suresh Babu Reddy',
    empId: 'EMP-0134',
    designation: 'Junior Technician',
    trade: 'Electrical',
    memberType: MemberType.secondary,
    activeDays: 14,
    activeHours: 1,
    isPunchedIn: true,
    punchInTime: '10:15 AM',
    currentTask: 'Panel Wiring Check',
  ),
];

// ── Main Screen ───────────────────────────────────────────────────────────────

class ViewTeamScreen extends StatefulWidget {
  const ViewTeamScreen({super.key});

  @override
  State<ViewTeamScreen> createState() => _ViewTeamScreenState();
}

class _ViewTeamScreenState extends State<ViewTeamScreen> {
  final int _punchedInCount =
      _teamMembers.where((m) => m.isPunchedIn).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: AppColors.textPrimary,
        ),
        title: Text('View Team', style: AppTextStyles.h3),
        actions: [
          TextButton.icon(
            onPressed: () => context.push(RouteNames.addMember),
            icon: const Icon(Icons.person_add_outlined, size: 16),
            label: const Text('Add'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              textStyle: AppTextStyles.buttonSmall,
            ),
          ),
          const SizedBox(width: 4),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.border, height: 1),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // ── Stats Header ──
          SliverToBoxAdapter(child: _buildStatsHeader()),
          // ── Section Label ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.paddingMD,
                AppDimensions.paddingMD,
                AppDimensions.paddingMD,
                AppDimensions.paddingXS,
              ),
              child: Text(
                'SORTED BY LONGEST SERVING',
                style: AppTextStyles.overline,
              ),
            ),
          ),
          // ── Team List ──
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.paddingMD,
              0,
              AppDimensions.paddingMD,
              AppDimensions.paddingLG + 16,
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final member = _teamMembers[i];
                  return Padding(
                    padding: const EdgeInsets.only(
                        bottom: AppDimensions.paddingXS),
                    child: _StaggeredItem(
                      delay: Duration(milliseconds: i * 60),
                      child: _TeamMemberCard(
                        member: member,
                        rank: i + 1,
                      ),
                    ),
                  );
                },
                childCount: _teamMembers.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsHeader() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.all(AppDimensions.paddingMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Total Members',
                  value: '${_teamMembers.length}',
                  icon: Icons.group_rounded,
                  iconColor: AppColors.primary,
                  bgColor: AppColors.primary.withOpacity(0.06),
                ),
              ),
              const SizedBox(width: AppDimensions.paddingSM),
              Expanded(
                child: _StatCard(
                  label: 'Punched In',
                  value: '$_punchedInCount',
                  icon: Icons.login_rounded,
                  iconColor: AppColors.success,
                  bgColor: AppColors.successLight,
                ),
              ),
              const SizedBox(width: AppDimensions.paddingSM),
              Expanded(
                child: _StatCard(
                  label: 'Off Duty',
                  value:
                      '${_teamMembers.length - _punchedInCount}',
                  icon: Icons.logout_rounded,
                  iconColor: AppColors.textSecondary,
                  bgColor: AppColors.surfaceAlt,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: AppDimensions.iconMD, color: iconColor),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.h2.copyWith(color: iconColor),
          ),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}

// ── Team Member Card ──────────────────────────────────────────────────────────

class _TeamMemberCard extends StatelessWidget {
  final _TeamMemberDetail member;
  final int rank;

  const _TeamMemberCard({required this.member, required this.rank});

  @override
  Widget build(BuildContext context) {
    final isPrimary = member.memberType == MemberType.primary;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMD),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Rank badge
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: rank == 1
                      ? AppColors.warning.withOpacity(0.15)
                      : AppColors.surfaceAlt,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                  border: Border.all(
                    color: rank == 1
                        ? AppColors.warning.withOpacity(0.4)
                        : AppColors.border,
                  ),
                ),
                child: Center(
                  child: Text(
                    '$rank',
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: rank == 1
                          ? AppColors.warning
                          : AppColors.textTertiary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Avatar
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: member.isPunchedIn
                      ? AppColors.primary.withOpacity(0.1)
                      : AppColors.surfaceAlt,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: member.isPunchedIn
                        ? AppColors.primary.withOpacity(0.3)
                        : AppColors.border,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    member.name
                        .split(' ')
                        .map((w) => w[0])
                        .take(2)
                        .join(),
                    style: AppTextStyles.caption.copyWith(
                      color: member.isPunchedIn
                          ? AppColors.primary
                          : AppColors.textTertiary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Main info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            member.name,
                            style: AppTextStyles.bodyMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        // P/S Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isPrimary
                                ? AppColors.primary.withOpacity(0.1)
                                : AppColors.info.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            isPrimary ? 'P' : 'S',
                            style: AppTextStyles.caption.copyWith(
                              color: isPrimary
                                  ? AppColors.primary
                                  : AppColors.info,
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          member.empId,
                          style: AppTextStyles.mono.copyWith(
                            fontSize: 11,
                            color: AppColors.textTertiary,
                          ),
                        ),
                        Text(
                          '  ·  ',
                          style: AppTextStyles.caption.copyWith(
                              color: AppColors.textTertiary),
                        ),
                        Text(
                          member.designation,
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Bottom row: active time + punch status + current task
          Row(
            children: [
              // Active duration badge
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusChip),
                  border: Border.all(
                      color: AppColors.success.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.schedule_rounded,
                        size: 12, color: AppColors.success),
                    const SizedBox(width: 4),
                    Text(
                      'Active: ${member.activeDays}d ${member.activeHours}h',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Punch in/out indicator
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: member.isPunchedIn
                      ? AppColors.primary.withOpacity(0.06)
                      : AppColors.surfaceAlt,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusChip),
                  border: Border.all(
                    color: member.isPunchedIn
                        ? AppColors.primary.withOpacity(0.2)
                        : AppColors.border,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: member.isPunchedIn
                            ? AppColors.success
                            : AppColors.border,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      member.isPunchedIn
                          ? 'In — ${member.punchInTime}'
                          : 'Off duty',
                      style: AppTextStyles.caption.copyWith(
                        color: member.isPunchedIn
                            ? AppColors.primary
                            : AppColors.textTertiary,
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (member.currentTask.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusSmall),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.build_circle_outlined,
                      size: 13, color: AppColors.textTertiary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      member.currentTask,
                      style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Staggered Fade-in ─────────────────────────────────────────────────────────

class _StaggeredItem extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const _StaggeredItem({required this.child, required this.delay});

  @override
  State<_StaggeredItem> createState() => _StaggeredItemState();
}

class _StaggeredItemState extends State<_StaggeredItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: AppDimensions.animSlow);
    _opacity = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

    Future.delayed(widget.delay, () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}
