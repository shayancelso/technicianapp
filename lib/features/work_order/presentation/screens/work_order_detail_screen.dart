import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/constants/enums.dart';
import '../../../../config/routes/route_names.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../core/widgets/priority_badge.dart';

// ── Mock Detail Data ──────────────────────────────────────────────────────────

class _WODetail {
  final String woNumber;
  final WOStatus status;
  final Priority priority;
  final String bookedBy;
  final String rrt;
  final String jct;
  final String appointmentDate;
  final String contract;
  final String paymentStatus;
  final String assets;
  final String location;
  final String description;
  final String specialInstruction;
  final int photosCount;
  final int notesCount;
  final int historyCount;
  final int materialsCount;
  final int estimationCount;

  const _WODetail({
    required this.woNumber,
    required this.status,
    required this.priority,
    required this.bookedBy,
    required this.rrt,
    required this.jct,
    required this.appointmentDate,
    required this.contract,
    required this.paymentStatus,
    required this.assets,
    required this.location,
    required this.description,
    required this.specialInstruction,
    required this.photosCount,
    required this.notesCount,
    required this.historyCount,
    required this.materialsCount,
    required this.estimationCount,
  });
}

const _mockDetail = _WODetail(
  woNumber: 'WO-2024-001847',
  status: WOStatus.workStarted,
  priority: Priority.p1,
  bookedBy: 'Ahmed Al Rashidi — FM Supervisor',
  rrt: '04:00:00',
  jct: '08:00:00',
  appointmentDate: '25 May 2024, 09:00 AM',
  contract: 'DEWA Substations — FM Contract',
  paymentStatus: 'Billable',
  assets: 'MV Switchgear Panel #3',
  location: 'Substation 14B, Al Quoz Industrial, Dubai',
  description:
      'MV Switchgear panel #3 is reporting overcurrent fault on Bus-B, Phase-2. Client reported unusual humming noise and partial blackout in Zone 4. Immediate inspection and remediation required. Ensure safety clearance before proceeding with any work on live components.',
  specialInstruction:
      'LOTO procedure mandatory before accessing switchgear. Coordinate with DEWA shift engineer on site. PPE Level-3 required at all times. Do not proceed without written PTW from site manager.',
  photosCount: 4,
  notesCount: 2,
  historyCount: 7,
  materialsCount: 3,
  estimationCount: 1,
);

// ── Tab Definitions ───────────────────────────────────────────────────────────

const _tabs = [
  'General Info',
  'Location',
  'Service Detail',
  'Description',
  'Special Instruction',
  'Additional Info',
];

// ── Main Screen ───────────────────────────────────────────────────────────────

class WorkOrderDetailScreen extends StatefulWidget {
  final String workOrderId;

  const WorkOrderDetailScreen({super.key, required this.workOrderId});

  @override
  State<WorkOrderDetailScreen> createState() => _WorkOrderDetailScreenState();
}

class _WorkOrderDetailScreenState extends State<WorkOrderDetailScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool _fabExpanded = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // ── WO Header Block ──
          _buildWOHeader(),
          // ── Tab Bar ──
          _buildTabBar(),
          // ── Tab Content ──
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _GeneralInfoTab(detail: _mockDetail),
                _LocationTab(),
                _ServiceDetailTab(),
                _DescriptionTab(detail: _mockDetail),
                _SpecialInstructionTab(detail: _mockDetail),
                _AdditionalInfoTab(detail: _mockDetail),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFAB(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      titleSpacing: 0,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        color: AppColors.textPrimary,
      ),
      title: Text('Work Order Details', style: AppTextStyles.h3),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: AppDimensions.paddingMD),
          child: StatusBadge(status: _mockDetail.status),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: AppColors.border, height: 1),
      ),
    );
  }

  Widget _buildWOHeader() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.paddingMD,
        AppDimensions.paddingMD,
        AppDimensions.paddingMD,
        AppDimensions.paddingMD,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PriorityBadge(priority: _mockDetail.priority),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _mockDetail.woNumber,
              style: AppTextStyles.monoLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppColors.surface,
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            indicatorWeight: 2,
            dividerColor: AppColors.border,
            labelStyle: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
            unselectedLabelStyle: AppTextStyles.bodySmall,
            padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingSM),
            tabs: _tabs.map((t) => Tab(text: t)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFAB(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_fabExpanded) ...[
          _FABAction(
            icon: Icons.swap_horiz_rounded,
            label: 'Change Status',
            onTap: () {
              setState(() => _fabExpanded = false);
              context.push(
                  '${RouteNames.changeStatus}/${widget.workOrderId}');
            },
          ),
          const SizedBox(height: 8),
          _FABAction(
            icon: Icons.camera_alt_outlined,
            label: 'Add Photo',
            onTap: () => setState(() => _fabExpanded = false),
          ),
          const SizedBox(height: 8),
          _FABAction(
            icon: Icons.note_add_outlined,
            label: 'Add Note',
            onTap: () => setState(() => _fabExpanded = false),
          ),
          const SizedBox(height: 8),
          _FABAction(
            icon: Icons.group_add_outlined,
            label: 'Manage Team',
            onTap: () {
              setState(() => _fabExpanded = false);
              context.push(RouteNames.viewTeam);
            },
          ),
          const SizedBox(height: 12),
        ],
        FloatingActionButton.extended(
          onPressed: () => setState(() => _fabExpanded = !_fabExpanded),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(AppDimensions.radiusButton),
          ),
          icon: AnimatedRotation(
            turns: _fabExpanded ? 0.125 : 0,
            duration: AppDimensions.animNormal,
            child: const Icon(Icons.add_rounded),
          ),
          label: Text(
            _fabExpanded ? 'Close' : '+ Actions',
            style: AppTextStyles.button
                .copyWith(color: AppColors.textOnPrimary),
          ),
        ),
      ],
    );
  }
}

class _FABAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _FABAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: AppDimensions.iconMD, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(label,
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.primary)),
          ],
        ),
      ),
    );
  }
}

// ── General Info Tab ──────────────────────────────────────────────────────────

class _GeneralInfoTab extends StatelessWidget {
  final _WODetail detail;

  const _GeneralInfoTab({required this.detail});

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('Booked By', detail.bookedBy),
      ('RRT', detail.rrt),
      ('JCT', detail.jct),
      ('Appointment Date', detail.appointmentDate),
      ('Contract', detail.contract),
      ('Payment Status', detail.paymentStatus),
      ('Priority', detail.priority.label),
      ('Asset', detail.assets),
      ('Location', detail.location),
    ];

    return ListView(
      padding: const EdgeInsets.all(AppDimensions.paddingMD),
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: rows.asMap().entries.map((e) {
              final isLast = e.key == rows.length - 1;
              return _InfoRow(
                label: e.value.$1,
                value: e.value.$2,
                isLast: isLast,
                isTimer: e.value.$1 == 'RRT' || e.value.$1 == 'JCT',
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;
  final bool isTimer;

  const _InfoRow({
    required this.label,
    required this.value,
    this.isLast = false,
    this.isTimer = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingMD,
            vertical: 14,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 130,
                child: Text(
                  label,
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.textTertiary),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  value,
                  style: isTimer
                      ? AppTextStyles.mono.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600)
                      : AppTextStyles.bodySmall
                          .copyWith(color: AppColors.textPrimary),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(
              height: 1, thickness: 1, color: AppColors.divider, indent: 16),
      ],
    );
  }
}

// ── Location Tab ──────────────────────────────────────────────────────────────

class _LocationTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppDimensions.paddingMD),
      children: [
        Container(
          height: 260,
          decoration: BoxDecoration(
            color: AppColors.border,
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
            border: Border.all(color: AppColors.border),
          ),
          child: Stack(
            children: [
              // Fake map grid pattern
              CustomPaint(
                size: const Size.fromHeight(260),
                painter: _MapGridPainter(),
              ),
              const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_on_rounded,
                        size: 48, color: AppColors.error),
                    SizedBox(height: 8),
                    Text('Substation 14B, Al Quoz',
                        style: AppTextStyles.bodyMedium),
                    SizedBox(height: 4),
                    Text('Google Maps Placeholder',
                        style: AppTextStyles.caption),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.paddingMD),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              _InfoRow(
                label: 'Address',
                value: 'Substation 14B, Al Quoz Industrial Area, Dubai, UAE',
              ),
              _InfoRow(
                label: 'Coordinates',
                value: '25.1234° N, 55.2109° E',
                isLast: true,
                isTimer: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.paddingMD),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.navigation_rounded, size: 18),
          label: const Text('Open in Maps'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textOnPrimary,
            elevation: 0,
            minimumSize: const Size.fromHeight(AppDimensions.buttonHeight),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
            ),
            textStyle: AppTextStyles.button,
          ),
        ),
      ],
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.border.withOpacity(0.6)
      ..strokeWidth = 1;
    const spacing = 30.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    final roadPaint = Paint()
      ..color = AppColors.surface
      ..strokeWidth = 8;
    canvas.drawLine(
        Offset(0, size.height * 0.4),
        Offset(size.width, size.height * 0.4),
        roadPaint);
    canvas.drawLine(
        Offset(size.width * 0.35, 0),
        Offset(size.width * 0.35, size.height),
        roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Service Detail Tab ────────────────────────────────────────────────────────

class _ServiceDetailTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final rows = [
      ('Service Category', 'Electrical — MV Systems'),
      ('Trade', 'Electrical Engineer'),
      ('Work Type', 'Reactive Maintenance (RM)'),
      ('Fault Code', 'ELEC-OC-FAULT-B2'),
      ('Task Checklist', '5 tasks / 2 completed'),
      ('Last PM Visit', '14 Apr 2024'),
    ];

    return ListView(
      padding: const EdgeInsets.all(AppDimensions.paddingMD),
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: rows.asMap().entries.map((e) {
              return _InfoRow(
                label: e.value.$1,
                value: e.value.$2,
                isLast: e.key == rows.length - 1,
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: AppDimensions.paddingMD),
        Text(
          'TASK CHECKLIST',
          style: AppTextStyles.overline,
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              _ChecklistRow(
                  task: 'Inspect MV bus bars for visual damage', done: true),
              _ChecklistRow(
                  task: 'Check overcurrent relay settings', done: true),
              _ChecklistRow(
                  task: 'Test phase-2 breaker continuity', done: false),
              _ChecklistRow(
                  task: 'Thermal scan on all bus connections', done: false),
              _ChecklistRow(
                  task: 'Document and report findings', done: false, isLast: true),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChecklistRow extends StatelessWidget {
  final String task;
  final bool done;
  final bool isLast;

  const _ChecklistRow({
    required this.task,
    required this.done,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingMD, vertical: 12),
          child: Row(
            children: [
              Icon(
                done
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                size: 20,
                color: done ? AppColors.success : AppColors.border,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  task,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: done
                        ? AppColors.textTertiary
                        : AppColors.textPrimary,
                    decoration: done ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(
              height: 1, thickness: 1, color: AppColors.divider, indent: 52),
      ],
    );
  }
}

// ── Description Tab ───────────────────────────────────────────────────────────

class _DescriptionTab extends StatelessWidget {
  final _WODetail detail;

  const _DescriptionTab({required this.detail});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppDimensions.paddingMD),
      children: [
        Container(
          padding: const EdgeInsets.all(AppDimensions.paddingMD),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(
            detail.description,
            style: AppTextStyles.body.copyWith(height: 1.7),
          ),
        ),
      ],
    );
  }
}

// ── Special Instruction Tab ───────────────────────────────────────────────────

class _SpecialInstructionTab extends StatelessWidget {
  final _WODetail detail;

  const _SpecialInstructionTab({required this.detail});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppDimensions.paddingMD),
      children: [
        Container(
          padding: const EdgeInsets.all(AppDimensions.paddingMD),
          decoration: BoxDecoration(
            color: AppColors.warningLight,
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
            border: Border.all(color: AppColors.warning.withOpacity(0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.warning_amber_rounded,
                  color: AppColors.warning, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  detail.specialInstruction,
                  style: AppTextStyles.body.copyWith(
                    height: 1.7,
                    color: const Color(0xFF92400E),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Additional Info Tab ───────────────────────────────────────────────────────

class _AdditionalInfoTab extends StatelessWidget {
  final _WODetail detail;

  const _AdditionalInfoTab({required this.detail});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppDimensions.paddingMD),
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              _AdditionalRow(
                icon: Icons.photo_library_outlined,
                label: 'Photos / Videos',
                count: detail.photosCount,
                onTap: () {},
              ),
              _AdditionalRow(
                icon: Icons.sticky_note_2_outlined,
                label: 'Notes',
                count: detail.notesCount,
                onTap: () {},
              ),
              _AdditionalRow(
                icon: Icons.auto_awesome_outlined,
                label: 'AI Assistant',
                onTap: () {},
                isNew: true,
              ),
              _AdditionalRow(
                icon: Icons.history_rounded,
                label: 'Work Order History',
                count: detail.historyCount,
                onTap: () {},
              ),
              _AdditionalRow(
                icon: Icons.inventory_2_outlined,
                label: 'Booked Material',
                count: detail.materialsCount,
                onTap: () {},
              ),
              _AdditionalRow(
                icon: Icons.calculate_outlined,
                label: 'Estimation',
                count: detail.estimationCount,
                onTap: () {},
              ),
              _AdditionalRow(
                icon: Icons.manage_accounts_outlined,
                label: 'Customer History',
                onTap: () {},
                isLast: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AdditionalRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final int? count;
  final VoidCallback onTap;
  final bool isLast;
  final bool isNew;

  const _AdditionalRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.count,
    this.isLast = false,
    this.isNew = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingMD,
              vertical: 14,
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceAlt,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Icon(icon,
                      size: AppDimensions.iconSM, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Row(
                    children: [
                      Text(label, style: AppTextStyles.bodyMedium),
                      if (isNew) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primaryMuted.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'NEW',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.primary,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (count != null && count! > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusChip),
                    ),
                    child: Text(
                      '$count',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right_rounded,
                    color: AppColors.textTertiary,
                    size: AppDimensions.iconMD),
              ],
            ),
          ),
        ),
        if (!isLast)
          const Divider(
              height: 1, thickness: 1, color: AppColors.divider, indent: 64),
      ],
    );
  }
}
