import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/constants/enums.dart';

// ── Mock Technician Data ──────────────────────────────────────────────────────

class _Technician {
  final String id;
  final String name;
  final String empId;
  final String trade;
  final String designation;
  final MemberType memberType;
  final String client;
  final String contract;
  final bool isOnDuty;

  const _Technician({
    required this.id,
    required this.name,
    required this.empId,
    required this.trade,
    required this.designation,
    required this.memberType,
    required this.client,
    required this.contract,
    required this.isOnDuty,
  });
}

const _mockTechnicians = [
  _Technician(
    id: 't1',
    name: 'Mohammed Al Hamdan',
    empId: 'EMP-0041',
    trade: 'Electrical',
    designation: 'Senior Technician',
    memberType: MemberType.primary,
    client: 'DEWA',
    contract: 'DEWA Substations — FM',
    isOnDuty: true,
  ),
  _Technician(
    id: 't2',
    name: 'Ravi Kumar Singh',
    empId: 'EMP-0067',
    trade: 'Mechanical',
    designation: 'Technician',
    memberType: MemberType.secondary,
    client: 'Emaar',
    contract: 'Emaar Malls — Retail FM',
    isOnDuty: false,
  ),
  _Technician(
    id: 't3',
    name: 'Ibrahim Al Sayed',
    empId: 'EMP-0023',
    trade: 'HVAC',
    designation: 'Lead Technician',
    memberType: MemberType.primary,
    client: 'ADNOC',
    contract: 'ADNOC Refinery — MEP',
    isOnDuty: true,
  ),
  _Technician(
    id: 't4',
    name: 'Arun Prakash Nair',
    empId: 'EMP-0089',
    trade: 'Plumbing',
    designation: 'Technician',
    memberType: MemberType.secondary,
    client: 'DHA',
    contract: 'Dubai Health Authority',
    isOnDuty: true,
  ),
  _Technician(
    id: 't5',
    name: 'Faisal Bin Khalid',
    empId: 'EMP-0112',
    trade: 'BMS',
    designation: 'BMS Specialist',
    memberType: MemberType.primary,
    client: 'Nakheel',
    contract: 'Nakheel Properties — FM',
    isOnDuty: false,
  ),
  _Technician(
    id: 't6',
    name: 'Suresh Babu Reddy',
    empId: 'EMP-0134',
    trade: 'Electrical',
    designation: 'Junior Technician',
    memberType: MemberType.secondary,
    client: 'RTA',
    contract: 'RTA Metro Infrastructure',
    isOnDuty: true,
  ),
  _Technician(
    id: 't7',
    name: 'Hamad Al Mansouri',
    empId: 'EMP-0058',
    trade: 'Civil',
    designation: 'Senior Technician',
    memberType: MemberType.primary,
    client: 'DIFC',
    contract: 'DIFC Commercial Properties',
    isOnDuty: false,
  ),
  _Technician(
    id: 't8',
    name: 'Dilnoza Yusupova',
    empId: 'EMP-0077',
    trade: 'Instrumentation',
    designation: 'Instrument Tech',
    memberType: MemberType.secondary,
    client: 'ADNOC',
    contract: 'ADNOC Refinery — MEP',
    isOnDuty: true,
  ),
];

const _clients = [
  'All Clients',
  'DEWA',
  'Emaar',
  'ADNOC',
  'DHA',
  'Nakheel',
  'RTA',
  'DIFC',
];

const _contracts = [
  'All Contracts',
  'DEWA Substations — FM',
  'Emaar Malls — Retail FM',
  'ADNOC Refinery — MEP',
  'Dubai Health Authority',
  'Nakheel Properties — FM',
  'RTA Metro Infrastructure',
  'DIFC Commercial Properties',
];

// ── Main Screen ───────────────────────────────────────────────────────────────

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({super.key});

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedTechId;
  bool _filtersExpanded = false;
  String _selectedClient = 'All Clients';
  String _selectedContract = 'All Contracts';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_Technician> get _filtered {
    return _mockTechnicians.where((t) {
      final q = _searchQuery.toLowerCase();
      final matchesSearch = q.isEmpty ||
          t.name.toLowerCase().contains(q) ||
          t.empId.toLowerCase().contains(q) ||
          t.trade.toLowerCase().contains(q);
      final matchesClient =
          _selectedClient == 'All Clients' || t.client == _selectedClient;
      final matchesContract = _selectedContract == 'All Contracts' ||
          t.contract == _selectedContract;
      return matchesSearch && matchesClient && matchesContract;
    }).toList();
  }

  void _onAddMember() {
    if (_selectedTechId == null) return;
    final tech =
        _mockTechnicians.firstWhere((t) => t.id == _selectedTechId);

    showDialog(
      context: context,
      builder: (_) => _PunchInDialog(
        technician: tech,
        onConfirm: (punchIn) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                punchIn
                    ? '${tech.name} added and punched in'
                    : '${tech.name} added to team',
                style: AppTextStyles.bodySmall,
              ),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusButton),
              ),
            ),
          );
          context.pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

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
        title: Text('Add New Member', style: AppTextStyles.h3),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.border, height: 1),
        ),
      ),
      body: Column(
        children: [
          // ── Search + Filter Header ──
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.all(AppDimensions.paddingMD),
            child: Column(
              children: [
                _buildSearchBar(),
                const SizedBox(height: AppDimensions.paddingSM),
                _buildFiltersRow(),
                if (_filtersExpanded) ...[
                  const SizedBox(height: AppDimensions.paddingSM),
                  _buildAdvancedFilters(),
                ],
              ],
            ),
          ),
          Container(height: 1, color: AppColors.border),
          // ── Result count ──
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.paddingMD,
              AppDimensions.paddingSM,
              AppDimensions.paddingMD,
              0,
            ),
            child: Row(
              children: [
                Text(
                  '${filtered.length} technicians available',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          // ── List ──
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.paddingMD,
                AppDimensions.paddingSM,
                AppDimensions.paddingMD,
                AppDimensions.paddingLG + 80,
              ),
              itemCount: filtered.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppDimensions.paddingXS),
              itemBuilder: (context, i) {
                final tech = filtered[i];
                return _TechnicianRow(
                  tech: tech,
                  isSelected: _selectedTechId == tech.id,
                  onTap: () => setState(
                    () => _selectedTechId =
                        _selectedTechId == tech.id ? null : tech.id,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomSheet: _buildBottomBar(),
    );
  }

  Widget _buildSearchBar() {
    return Container(
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
          hintText: 'Search by name, ID or trade…',
          hintStyle: AppTextStyles.bodySmall
              .copyWith(color: AppColors.textTertiary),
          prefixIcon: const Icon(Icons.search_rounded,
              color: AppColors.textTertiary, size: AppDimensions.iconMD),
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
    );
  }

  Widget _buildFiltersRow() {
    final hasActiveFilter = _selectedClient != 'All Clients' ||
        _selectedContract != 'All Contracts';

    return Row(
      children: [
        GestureDetector(
          onTap: () =>
              setState(() => _filtersExpanded = !_filtersExpanded),
          child: AnimatedContainer(
            duration: AppDimensions.animNormal,
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: hasActiveFilter || _filtersExpanded
                  ? AppColors.primary.withOpacity(0.06)
                  : AppColors.surfaceAlt,
              borderRadius:
                  BorderRadius.circular(AppDimensions.radiusChip),
              border: Border.all(
                color: hasActiveFilter || _filtersExpanded
                    ? AppColors.primary
                    : AppColors.border,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _filtersExpanded
                      ? Icons.tune_rounded
                      : Icons.filter_list_rounded,
                  size: 14,
                  color: hasActiveFilter || _filtersExpanded
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  hasActiveFilter ? 'Filters (active)' : 'Filters',
                  style: AppTextStyles.caption.copyWith(
                    color: hasActiveFilter || _filtersExpanded
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  _filtersExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: 14,
                  color: hasActiveFilter || _filtersExpanded
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
        if (hasActiveFilter) ...[
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => setState(() {
              _selectedClient = 'All Clients';
              _selectedContract = 'All Contracts';
            }),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusChip),
                border: Border.all(
                    color: AppColors.error.withOpacity(0.3)),
              ),
              child: Text(
                'Clear',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAdvancedFilters() {
    return Column(
      children: [
        _DropdownField(
          label: 'Client',
          value: _selectedClient,
          items: _clients,
          onChanged: (v) => setState(() => _selectedClient = v!),
        ),
        const SizedBox(height: AppDimensions.paddingXS),
        _DropdownField(
          label: 'Contract',
          value: _selectedContract,
          items: _contracts,
          onChanged: (v) => setState(() => _selectedContract = v!),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      padding: EdgeInsets.fromLTRB(
        AppDimensions.paddingMD,
        AppDimensions.paddingMD,
        AppDimensions.paddingMD,
        AppDimensions.paddingMD +
            MediaQuery.of(context).padding.bottom,
      ),
      child: SizedBox(
        width: double.infinity,
        height: AppDimensions.buttonHeight,
        child: ElevatedButton.icon(
          onPressed: _selectedTechId != null ? _onAddMember : null,
          icon: const Icon(Icons.person_add_rounded,
              size: AppDimensions.iconSM),
          label: const Text('Add Member'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textOnPrimary,
            disabledBackgroundColor: AppColors.border,
            disabledForegroundColor: AppColors.textTertiary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(AppDimensions.radiusButton),
            ),
            textStyle: AppTextStyles.button,
          ),
        ),
      ),
    );
  }
}

// ── Technician Row ────────────────────────────────────────────────────────────

class _TechnicianRow extends StatelessWidget {
  final _Technician tech;
  final bool isSelected;
  final VoidCallback onTap;

  const _TechnicianRow({
    required this.tech,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppDimensions.animNormal,
        padding: const EdgeInsets.all(AppDimensions.paddingMD),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.04)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected
                ? AppDimensions.borderWidthFocused
                : AppDimensions.borderWidth,
          ),
        ),
        child: Row(
          children: [
            // Radio Circle
            AnimatedContainer(
              duration: AppDimensions.animNormal,
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      isSelected ? AppColors.primary : AppColors.border,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check_rounded,
                      color: Colors.white, size: 12)
                  : null,
            ),
            const SizedBox(width: 12),
            // Avatar
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  tech.name
                      .split(' ')
                      .map((w) => w[0])
                      .take(2)
                      .join(),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          tech.name,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      _PSBadge(type: tech.memberType),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      _InfoChip(label: tech.empId),
                      const SizedBox(width: 4),
                      _InfoChip(label: tech.trade),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(tech.designation, style: AppTextStyles.caption),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // On-duty dot
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: tech.isOnDuty
                    ? AppColors.success
                    : AppColors.border,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PSBadge extends StatelessWidget {
  final MemberType type;

  const _PSBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    final isPrimary = type == MemberType.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isPrimary
            ? AppColors.primary.withOpacity(0.1)
            : AppColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        isPrimary ? 'P' : 'S',
        style: AppTextStyles.caption.copyWith(
          color: isPrimary ? AppColors.primary : AppColors.info,
          fontWeight: FontWeight.w700,
          fontSize: 10,
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;

  const _InfoChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          fontSize: 10,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

// ── Dropdown Field ────────────────────────────────────────────────────────────

class _DropdownField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButton<String>(
        value: value,
        onChanged: onChanged,
        isExpanded: true,
        underline: const SizedBox(),
        icon: const Icon(Icons.keyboard_arrow_down_rounded,
            size: 20, color: AppColors.textSecondary),
        style: AppTextStyles.bodySmall
            .copyWith(color: AppColors.textPrimary),
        items: items
            .map(
              (item) => DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.textPrimary),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

// ── Punch-In Confirmation Dialog ──────────────────────────────────────────────

class _PunchInDialog extends StatelessWidget {
  final _Technician technician;
  final void Function(bool punchIn) onConfirm;

  const _PunchInDialog({
    required this.technician,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLG),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: AppColors.successLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_rounded,
                      color: AppColors.success, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Member Added', style: AppTextStyles.h3),
                      Text(
                        technician.name,
                        style: AppTextStyles.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingMD),
            // Prompt
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusSmall),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time_rounded,
                      size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Would you like to punch in ${technician.name.split(' ').first} for this work order?',
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.paddingLG),
            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => onConfirm(false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side:
                          const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            AppDimensions.radiusButton),
                      ),
                      minimumSize: const Size.fromHeight(
                          AppDimensions.buttonHeight),
                      textStyle: AppTextStyles.buttonSmall,
                    ),
                    child: const Text('Skip'),
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingSM),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => onConfirm(true),
                    icon:
                        const Icon(Icons.login_rounded, size: 16),
                    label: const Text('Punch In'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textOnPrimary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            AppDimensions.radiusButton),
                      ),
                      minimumSize: const Size.fromHeight(
                          AppDimensions.buttonHeight),
                      textStyle: AppTextStyles.buttonSmall,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
