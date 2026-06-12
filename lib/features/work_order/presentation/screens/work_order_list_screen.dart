import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/constants/enums.dart';
import '../../../../config/routes/route_names.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../core/widgets/priority_badge.dart';

// ── Mock Data Model ──────────────────────────────────────────────────────────

class _WOMock {
  final String id;
  final String woNumber;
  final Priority priority;
  final WOStatus status;
  final String contractName;
  final String location;
  final String assetName;
  final String aptTimer;
  final String rrtTimer;
  final String jctTimer;

  const _WOMock({
    required this.id,
    required this.woNumber,
    required this.priority,
    required this.status,
    required this.contractName,
    required this.location,
    required this.assetName,
    required this.aptTimer,
    required this.rrtTimer,
    required this.jctTimer,
  });
}

const _mockWorkOrders = [
  _WOMock(
    id: '1',
    woNumber: 'WO-2024-001847',
    priority: Priority.p1,
    status: WOStatus.assigned,
    contractName: 'DEWA Substations — FM Contract',
    location: 'Substation 14B, Al Quoz Industrial',
    assetName: 'MV Switchgear Panel #3',
    aptTimer: '02:14:33',
    rrtTimer: '04:00:00',
    jctTimer: '08:00:00',
  ),
  _WOMock(
    id: '2',
    woNumber: 'WO-2024-001848',
    priority: Priority.p2,
    status: WOStatus.tripStarted,
    contractName: 'Emaar Malls — Retail FM',
    location: 'Dubai Mall, Level 2 East Wing',
    assetName: 'AHU Unit #12',
    aptTimer: '00:45:12',
    rrtTimer: '06:00:00',
    jctTimer: '12:00:00',
  ),
  _WOMock(
    id: '3',
    woNumber: 'WO-2024-001849',
    priority: Priority.p1,
    status: WOStatus.siteAttended,
    contractName: 'ADNOC Refinery — MEP Services',
    location: 'Ruwais Plant, Block C',
    assetName: 'Cooling Tower CT-07',
    aptTimer: '01:30:00',
    rrtTimer: '02:00:00',
    jctTimer: '06:00:00',
  ),
  _WOMock(
    id: '4',
    woNumber: 'WO-2024-001850',
    priority: Priority.p3,
    status: WOStatus.workStarted,
    contractName: 'Dubai Health Authority — Hospitals',
    location: 'Rashid Hospital, Floor 4',
    assetName: 'BMS Controller Node 4-C',
    aptTimer: '05:22:47',
    rrtTimer: '08:00:00',
    jctTimer: '16:00:00',
  ),
  _WOMock(
    id: '5',
    woNumber: 'WO-2024-001851',
    priority: Priority.p2,
    status: WOStatus.delayed,
    contractName: 'RTA Metro — Infrastructure',
    location: 'Union Metro Station, Platform B',
    assetName: 'Escalator ESC-B04',
    aptTimer: '00:00:00',
    rrtTimer: '00:30:00',
    jctTimer: '04:00:00',
  ),
  _WOMock(
    id: '6',
    woNumber: 'WO-2024-001852',
    priority: Priority.p4,
    status: WOStatus.assigned,
    contractName: 'Nakheel Properties — FM Services',
    location: 'Palm Jumeirah, Villa 47',
    assetName: 'Split AC Unit — Master Bedroom',
    aptTimer: '12:00:00',
    rrtTimer: '24:00:00',
    jctTimer: '48:00:00',
  ),
  _WOMock(
    id: '7',
    woNumber: 'WO-2024-001853',
    priority: Priority.p1,
    status: WOStatus.onHold,
    contractName: 'ADDC Distribution — Electrical',
    location: 'Al Ain City, Feeder Station 9',
    assetName: 'LV Distribution Board DB-09',
    aptTimer: '00:05:10',
    rrtTimer: '01:00:00',
    jctTimer: '03:00:00',
  ),
  _WOMock(
    id: '8',
    woNumber: 'WO-2024-001854',
    priority: Priority.p3,
    status: WOStatus.workCompleted,
    contractName: 'Majid Al Futtaim — Retail Group',
    location: 'Mall of Emirates, Basement P2',
    assetName: 'Fire Suppression Panel FP-22',
    aptTimer: '00:00:00',
    rrtTimer: '00:00:00',
    jctTimer: '00:00:00',
  ),
  _WOMock(
    id: '9',
    woNumber: 'WO-2024-001855',
    priority: Priority.p2,
    status: WOStatus.tripStarted,
    contractName: 'Etisalat HQ — Data Center',
    location: 'Internet City, Building 6',
    assetName: 'UPS Module #2 (60kVA)',
    aptTimer: '01:05:44',
    rrtTimer: '03:00:00',
    jctTimer: '08:00:00',
  ),
  _WOMock(
    id: '10',
    woNumber: 'WO-2024-001856',
    priority: Priority.p4,
    status: WOStatus.workStarted,
    contractName: 'DIFC — Commercial Properties',
    location: 'Gate District, Tower 10',
    assetName: 'Plumbing — Hot Water Line B',
    aptTimer: '06:00:00',
    rrtTimer: '12:00:00',
    jctTimer: '24:00:00',
  ),
];

// ── Filter Chip Data ──────────────────────────────────────────────────────────

enum _FilterOption { all, assigned, inProgress, completed }

extension _FilterLabel on _FilterOption {
  String get label => switch (this) {
    _FilterOption.all => 'All',
    _FilterOption.assigned => 'Assigned',
    _FilterOption.inProgress => 'In Progress',
    _FilterOption.completed => 'Completed',
  };
}

// ── Main Screen ───────────────────────────────────────────────────────────────

class WorkOrderListScreen extends StatefulWidget {
  final String woType;
  final bool isHistory;

  const WorkOrderListScreen({
    super.key,
    required this.woType,
    this.isHistory = false,
  });

  @override
  State<WorkOrderListScreen> createState() => _WorkOrderListScreenState();
}

class _WorkOrderListScreenState extends State<WorkOrderListScreen> {
  final TextEditingController _searchController = TextEditingController();
  _FilterOption _selectedFilter = _FilterOption.all;
  final Set<String> _expandedIds = {};
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String get _title {
    final suffix = widget.isHistory ? ' History' : '';
    return switch (widget.woType) {
      'ppm' => 'PPM Work Orders$suffix',
      'ss' => 'SS Work Orders$suffix',
      _ => 'RM Work Orders$suffix',
    };
  }

  List<_WOMock> get _filtered {
    var list = _mockWorkOrders.where((wo) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        return wo.woNumber.toLowerCase().contains(q) ||
            wo.contractName.toLowerCase().contains(q) ||
            wo.location.toLowerCase().contains(q) ||
            wo.assetName.toLowerCase().contains(q);
      }
      return true;
    }).toList();

    if (_selectedFilter == _FilterOption.assigned) {
      list = list.where((wo) => wo.status == WOStatus.assigned).toList();
    } else if (_selectedFilter == _FilterOption.inProgress) {
      list = list
          .where((wo) =>
              wo.status == WOStatus.tripStarted ||
              wo.status == WOStatus.siteAttended ||
              wo.status == WOStatus.workStarted)
          .toList();
    } else if (_selectedFilter == _FilterOption.completed) {
      list = list.where((wo) => wo.status.isTerminal).toList();
    }

    return list;
  }

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
        title: Text(_title, style: AppTextStyles.h3),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.border, height: 1),
        ),
      ),
      body: Column(
        children: [
          // ── Search Bar ──
          _buildSearchBar(),
          // ── Filter Chips ──
          _buildFilterChips(),
          // ── List ──
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.paddingMD,
                AppDimensions.paddingMD,
                AppDimensions.paddingMD,
                AppDimensions.paddingLG + 16,
              ),
              itemCount: _filtered.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppDimensions.paddingSM),
              itemBuilder: (context, index) {
                return _StaggeredItem(
                  delay: Duration(milliseconds: index * 50),
                  child: _WOCard(
                    wo: _filtered[index],
                    isExpanded: _expandedIds.contains(_filtered[index].id),
                    onExpandToggle: () {
                      setState(() {
                        final id = _filtered[index].id;
                        if (_expandedIds.contains(id)) {
                          _expandedIds.remove(id);
                        } else {
                          _expandedIds.add(id);
                        }
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.paddingMD,
        AppDimensions.paddingMD,
        AppDimensions.paddingMD,
        AppDimensions.paddingSM,
      ),
      child: Container(
        height: AppDimensions.inputHeight,
        decoration: BoxDecoration(
          color: AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
          border: Border.all(color: AppColors.border),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (v) => setState(() => _searchQuery = v),
          style: AppTextStyles.body,
          decoration: InputDecoration(
            hintText: 'Search WO #, contract, location…',
            hintStyle:
                AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: AppColors.textTertiary,
              size: AppDimensions.iconMD,
            ),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                    icon: const Icon(Icons.close_rounded,
                        size: AppDimensions.iconSM),
                    color: AppColors.textTertiary,
                  )
                : null,
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.only(
        bottom: AppDimensions.paddingSM,
        left: AppDimensions.paddingMD,
      ),
      child: SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _FilterOption.values.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, i) {
            final opt = _FilterOption.values[i];
            final selected = opt == _selectedFilter;
            return GestureDetector(
              onTap: () => setState(() => _selectedFilter = opt),
              child: AnimatedContainer(
                duration: AppDimensions.animNormal,
                curve: Curves.easeInOut,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : AppColors.surfaceAlt,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusChip),
                  border: Border.all(
                    color:
                        selected ? AppColors.primary : AppColors.border,
                  ),
                ),
                child: Text(
                  opt.label,
                  style: AppTextStyles.caption.copyWith(
                    color: selected
                        ? AppColors.textOnPrimary
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ── Staggered Fade-in Wrapper ─────────────────────────────────────────────────

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
      vsync: this,
      duration: AppDimensions.animSlow,
    );
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

// ── WO Card ───────────────────────────────────────────────────────────────────

class _WOCard extends StatelessWidget {
  final _WOMock wo;
  final bool isExpanded;
  final VoidCallback onExpandToggle;

  const _WOCard({
    required this.wo,
    required this.isExpanded,
    required this.onExpandToggle,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          // ── Header Row ──
          GestureDetector(
            onTap: onExpandToggle,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingMD),
              child: Row(
                children: [
                  PriorityBadge(priority: wo.priority, compact: true),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      wo.woNumber,
                      style: AppTextStyles.mono.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  StatusBadge(status: wo.status),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: AppDimensions.animNormal,
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.textTertiary,
                      size: AppDimensions.iconMD,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ── Expanded Section ──
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity, height: 0),
            secondChild: _ExpandedContent(wo: wo),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: AppDimensions.animSlow,
            sizeCurve: Curves.easeInOut,
          ),
        ],
      ),
    );
  }
}

// ── Expanded Content ──────────────────────────────────────────────────────────

class _ExpandedContent extends StatelessWidget {
  final _WOMock wo;

  const _ExpandedContent({required this.wo});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 1,
          color: AppColors.divider,
          margin: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMD),
        ),
        Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingMD),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contract Name
              Row(
                children: [
                  const Icon(Icons.business_outlined,
                      size: 14, color: AppColors.textTertiary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      wo.contractName,
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Location
              Row(
                children: [
                  const Icon(Icons.location_on_outlined,
                      size: 14, color: AppColors.textTertiary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      wo.location,
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Asset Name
              Row(
                children: [
                  const Icon(Icons.settings_outlined,
                      size: 14, color: AppColors.textTertiary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      wo.assetName,
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // SLA Timers
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceAlt,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    _TimerChip(label: 'APT', value: wo.aptTimer),
                    _VerticalDivider(),
                    _TimerChip(label: 'RRT', value: wo.rrtTimer),
                    _VerticalDivider(),
                    _TimerChip(label: 'JCT', value: wo.jctTimer),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context
                          .push('${RouteNames.workOrderDetail}/${wo.id}'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radiusButton),
                        ),
                        minimumSize:
                            const Size.fromHeight(AppDimensions.buttonHeight),
                        textStyle: AppTextStyles.buttonSmall,
                      ),
                      child: const Text('View Info'),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.paddingSM),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => context
                          .push('${RouteNames.changeStatus}/${wo.id}'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.textOnPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radiusButton),
                        ),
                        minimumSize:
                            const Size.fromHeight(AppDimensions.buttonHeight),
                        textStyle: AppTextStyles.buttonSmall,
                      ),
                      child: Text(wo.status == WOStatus.assigned
                          ? 'Start Trip'
                          : 'Change Status'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TimerChip extends StatelessWidget {
  final String label;
  final String value;

  const _TimerChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final isZero = value == '00:00:00';
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: AppTextStyles.overline.copyWith(fontSize: 9),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppTextStyles.mono.copyWith(
              fontSize: 12,
              color: isZero ? AppColors.textTertiary : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 28,
      color: AppColors.border,
      margin: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}
