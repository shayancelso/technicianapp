import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/constants/enums.dart';

// ── Mock Current Team Members ─────────────────────────────────────────────────

class _TeamMember {
  final String id;
  final String name;
  final String empId;
  final String designation;
  final MemberType memberType;
  final String joinedAt;
  final bool isPunchedIn;

  const _TeamMember({
    required this.id,
    required this.name,
    required this.empId,
    required this.designation,
    required this.memberType,
    required this.joinedAt,
    required this.isPunchedIn,
  });
}

const _teamMembers = [
  _TeamMember(
    id: 'm1',
    name: 'Mohammed Al Hamdan',
    empId: 'EMP-0041',
    designation: 'Senior Technician',
    memberType: MemberType.primary,
    joinedAt: '09:15 AM',
    isPunchedIn: true,
  ),
  _TeamMember(
    id: 'm2',
    name: 'Ravi Kumar Singh',
    empId: 'EMP-0067',
    designation: 'Technician',
    memberType: MemberType.secondary,
    joinedAt: '09:30 AM',
    isPunchedIn: true,
  ),
  _TeamMember(
    id: 'm3',
    name: 'Ibrahim Al Sayed',
    empId: 'EMP-0023',
    designation: 'Lead Technician',
    memberType: MemberType.primary,
    joinedAt: '10:00 AM',
    isPunchedIn: false,
  ),
  _TeamMember(
    id: 'm4',
    name: 'Arun Prakash Nair',
    empId: 'EMP-0089',
    designation: 'Technician',
    memberType: MemberType.secondary,
    joinedAt: '10:20 AM',
    isPunchedIn: true,
  ),
  _TeamMember(
    id: 'm5',
    name: 'Dilnoza Yusupova',
    empId: 'EMP-0077',
    designation: 'Instrument Tech',
    memberType: MemberType.secondary,
    joinedAt: '11:05 AM',
    isPunchedIn: false,
  ),
];

// ── Main Screen ───────────────────────────────────────────────────────────────

class RemoveMemberScreen extends StatefulWidget {
  const RemoveMemberScreen({super.key});

  @override
  State<RemoveMemberScreen> createState() => _RemoveMemberScreenState();
}

class _RemoveMemberScreenState extends State<RemoveMemberScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final Set<String> _selectedIds = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_TeamMember> get _filtered {
    if (_searchQuery.isEmpty) return _teamMembers;
    final q = _searchQuery.toLowerCase();
    return _teamMembers.where((m) {
      return m.name.toLowerCase().contains(q) ||
          m.empId.toLowerCase().contains(q) ||
          m.designation.toLowerCase().contains(q);
    }).toList();
  }

  void _onRemove() {
    if (_selectedIds.isEmpty) return;
    final selectedMembers = _teamMembers
        .where((m) => _selectedIds.contains(m.id))
        .toList();

    showDialog(
      context: context,
      builder: (_) => _RemoveConfirmDialog(
        members: selectedMembers,
        onConfirm: (punchOut) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                punchOut
                    ? '${_selectedIds.length} member(s) removed and punched out'
                    : '${_selectedIds.length} member(s) removed from team',
                style: AppTextStyles.bodySmall,
              ),
              backgroundColor: AppColors.error,
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
        title: Text('Remove Member', style: AppTextStyles.h3),
        actions: [
          if (_selectedIds.isNotEmpty)
            TextButton(
              onPressed: () => setState(() => _selectedIds.clear()),
              child: Text(
                'Deselect All',
                style: AppTextStyles.buttonSmall
                    .copyWith(color: AppColors.textSecondary),
              ),
            ),
          const SizedBox(width: 4),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.border, height: 1),
        ),
      ),
      body: Column(
        children: [
          // ── Search Bar ──
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.all(AppDimensions.paddingMD),
            child: _buildSearchBar(),
          ),
          Container(height: 1, color: AppColors.border),
          // ── Team count + select-all ──
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.paddingMD,
              AppDimensions.paddingSM,
              AppDimensions.paddingMD,
              0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_teamMembers.length} team members',
                  style: AppTextStyles.caption,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_selectedIds.length == filtered.length) {
                        _selectedIds.clear();
                      } else {
                        _selectedIds
                            .addAll(filtered.map((m) => m.id));
                      }
                    });
                  },
                  child: Text(
                    _selectedIds.length == filtered.length
                        ? 'Deselect All'
                        : 'Select All',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
                final member = filtered[i];
                final isSelected = _selectedIds.contains(member.id);
                return _MemberRow(
                  member: member,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedIds.remove(member.id);
                      } else {
                        _selectedIds.add(member.id);
                      }
                    });
                  },
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
          hintText: 'Search team members…',
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

  Widget _buildBottomBar() {
    final count = _selectedIds.length;

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
        child: OutlinedButton.icon(
          onPressed: count > 0 ? _onRemove : null,
          icon: const Icon(Icons.person_remove_rounded,
              size: AppDimensions.iconSM),
          label: Text(
            count > 0
                ? 'Remove $count Member${count > 1 ? 's' : ''}'
                : 'Remove Member',
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.error,
            side: const BorderSide(color: AppColors.error, width: 1.5),
            backgroundColor:
                count > 0 ? AppColors.errorLight : AppColors.surface,
            disabledForegroundColor: AppColors.textTertiary,
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

// ── Member Row ────────────────────────────────────────────────────────────────

class _MemberRow extends StatelessWidget {
  final _TeamMember member;
  final bool isSelected;
  final VoidCallback onTap;

  const _MemberRow({
    required this.member,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isPrimary = member.memberType == MemberType.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppDimensions.animNormal,
        padding: const EdgeInsets.all(AppDimensions.paddingMD),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.errorLight.withOpacity(0.5)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          border: Border.all(
            color: isSelected ? AppColors.error : AppColors.border,
            width: isSelected
                ? AppDimensions.borderWidthFocused
                : AppDimensions.borderWidth,
          ),
        ),
        child: Row(
          children: [
            // Checkbox
            AnimatedContainer(
              duration: AppDimensions.animNormal,
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.error : AppColors.surface,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: isSelected ? AppColors.error : AppColors.border,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check_rounded,
                      color: Colors.white, size: 14)
                  : null,
            ),
            const SizedBox(width: 12),
            // Avatar
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.error.withOpacity(0.1)
                    : AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  member.name
                      .split(' ')
                      .map((w) => w[0])
                      .take(2)
                      .join(),
                  style: AppTextStyles.caption.copyWith(
                    color: isSelected
                        ? AppColors.error
                        : AppColors.primary,
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
                          member.name,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: isSelected
                                ? AppColors.error
                                : AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
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
                        style: AppTextStyles.caption.copyWith(
                            color: AppColors.textTertiary),
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
                  const SizedBox(height: 2),
                  Row(
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
                            ? 'Punched in — ${member.joinedAt}'
                            : 'Not punched in',
                        style: AppTextStyles.caption.copyWith(
                          color: member.isPunchedIn
                              ? AppColors.success
                              : AppColors.textTertiary,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Remove Confirmation Dialog ────────────────────────────────────────────────

class _RemoveConfirmDialog extends StatefulWidget {
  final List<_TeamMember> members;
  final void Function(bool punchOut) onConfirm;

  const _RemoveConfirmDialog({
    required this.members,
    required this.onConfirm,
  });

  @override
  State<_RemoveConfirmDialog> createState() => _RemoveConfirmDialogState();
}

class _RemoveConfirmDialogState extends State<_RemoveConfirmDialog> {
  bool _punchOut = false;

  bool get _hasPunchedInMembers =>
      widget.members.any((m) => m.isPunchedIn);

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
                  decoration: BoxDecoration(
                    color: AppColors.errorLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person_remove_rounded,
                      color: AppColors.error, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Remove Member', style: AppTextStyles.h3),
                      Text(
                        '${widget.members.length} member${widget.members.length > 1 ? 's' : ''} selected',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingMD),
            // Member list preview
            ...widget.members.take(3).map((m) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: m.isPunchedIn
                              ? AppColors.success
                              : AppColors.border,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${m.name} — ${m.empId}',
                          style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textPrimary),
                        ),
                      ),
                    ],
                  ),
                )),
            if (widget.members.length > 3)
              Text(
                '+ ${widget.members.length - 3} more',
                style: AppTextStyles.caption,
              ),
            const SizedBox(height: AppDimensions.paddingMD),
            // Divider
            const Divider(height: 1, color: AppColors.border),
            const SizedBox(height: AppDimensions.paddingMD),
            // Option 1: Remove only from team
            _OptionTile(
              isSelected: !_punchOut,
              icon: Icons.group_remove_outlined,
              iconColor: AppColors.textSecondary,
              title: 'Remove only from team',
              subtitle: 'Member stays in system, not in this WO',
              onTap: () => setState(() => _punchOut = false),
            ),
            const SizedBox(height: 8),
            // Option 2: Punch out this person
            _OptionTile(
              isSelected: _punchOut,
              icon: Icons.logout_rounded,
              iconColor:
                  _hasPunchedInMembers ? AppColors.error : AppColors.border,
              title: 'Remove and punch out',
              subtitle: _hasPunchedInMembers
                  ? 'End their shift for this work order'
                  : 'No punched-in members selected',
              onTap: _hasPunchedInMembers
                  ? () => setState(() => _punchOut = true)
                  : null,
              disabled: !_hasPunchedInMembers,
            ),
            const SizedBox(height: AppDimensions.paddingLG),
            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            AppDimensions.radiusButton),
                      ),
                      minimumSize: const Size.fromHeight(
                          AppDimensions.buttonHeight),
                      textStyle: AppTextStyles.buttonSmall,
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingSM),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => widget.onConfirm(_punchOut),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            AppDimensions.radiusButton),
                      ),
                      minimumSize: const Size.fromHeight(
                          AppDimensions.buttonHeight),
                      textStyle: AppTextStyles.buttonSmall,
                    ),
                    child: const Text('Confirm'),
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

class _OptionTile extends StatelessWidget {
  final bool isSelected;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool disabled;

  const _OptionTile({
    required this.isSelected,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppDimensions.animNormal,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: disabled
              ? AppColors.surfaceAlt
              : isSelected
                  ? AppColors.errorLight.withOpacity(0.5)
                  : AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
          border: Border.all(
            color: disabled
                ? AppColors.border
                : isSelected
                    ? AppColors.error
                    : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: disabled ? AppColors.border : iconColor),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: disabled
                          ? AppColors.textTertiary
                          : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: disabled
                          ? AppColors.textTertiary
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: AppDimensions.animNormal,
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: isSelected && !disabled
                    ? AppColors.error
                    : AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected && !disabled
                      ? AppColors.error
                      : AppColors.border,
                  width: 2,
                ),
              ),
              child: isSelected && !disabled
                  ? const Icon(Icons.check_rounded,
                      color: Colors.white, size: 10)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
