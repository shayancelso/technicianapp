import { useMemo, useRef, useState } from 'react';
import { FlatList, Pressable, StyleSheet, Text, View } from 'react-native';
import { MaterialIcons } from '@expo/vector-icons';
import { router } from 'expo-router';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { ScreenHeader } from '@/components/ScreenHeader';
import { mockCurrentTeam } from '@/data/mockTeam';
import { colors, fonts, radii, sizes, spacing, typography } from '@/theme';
import { MemberRow } from '../components/MemberRow';
import { RemoveConfirmDialog } from '../components/RemoveConfirmDialog';
import { Snackbar } from '../components/Snackbar';
import { TeamSearchBar } from '../components/TeamSearchBar';

const SNACKBAR_DURATION = 1200;

export default function RemoveMemberScreen() {
  const insets = useSafeAreaInsets();
  const [members, setMembers] = useState(mockCurrentTeam);
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedIds, setSelectedIds] = useState<Set<string>>(new Set());
  const [dialogOpen, setDialogOpen] = useState(false);
  const [snackbar, setSnackbar] = useState<string | null>(null);
  const backTimer = useRef<ReturnType<typeof setTimeout> | null>(null);

  const filtered = useMemo(() => {
    if (searchQuery.length === 0) return members;
    const q = searchQuery.toLowerCase();
    return members.filter(
      (m) =>
        m.name.toLowerCase().includes(q) ||
        m.empId.toLowerCase().includes(q) ||
        m.designation.toLowerCase().includes(q),
    );
  }, [members, searchQuery]);

  const selectedMembers = members.filter((m) => selectedIds.has(m.id));

  const toggleMember = (id: string) => {
    setSelectedIds((current) => {
      const next = new Set(current);
      if (next.has(id)) {
        next.delete(id);
      } else {
        next.add(id);
      }
      return next;
    });
  };

  const toggleSelectAll = () => {
    setSelectedIds((current) => {
      if (current.size === filtered.length) return new Set<string>();
      const next = new Set(current);
      filtered.forEach((m) => next.add(m.id));
      return next;
    });
  };

  const onDialogConfirm = (punchOut: boolean) => {
    const count = selectedIds.size;
    setDialogOpen(false);
    // Removal updates local state only (no backend).
    setMembers((current) => current.filter((m) => !selectedIds.has(m.id)));
    setSelectedIds(new Set());
    setSnackbar(
      punchOut
        ? `${count} member(s) removed and punched out`
        : `${count} member(s) removed from team`,
    );
    if (backTimer.current != null) clearTimeout(backTimer.current);
    backTimer.current = setTimeout(() => router.back(), SNACKBAR_DURATION);
  };

  const count = selectedIds.size;

  return (
    <View style={styles.screen}>
      <ScreenHeader
        title="Remove Member"
        trailing={
          count > 0 ? (
            <Pressable
              style={({ pressed }) => [styles.deselectAction, pressed && styles.pressed]}
              onPress={() => setSelectedIds(new Set())}
              hitSlop={8}
            >
              <Text style={styles.deselectLabel}>Deselect All</Text>
            </Pressable>
          ) : undefined
        }
      />
      <View style={styles.headerBorder} />
      {/* ── Search Bar ── */}
      <View style={styles.searchHeader}>
        <TeamSearchBar
          value={searchQuery}
          onChangeText={setSearchQuery}
          placeholder="Search team members…"
        />
      </View>
      <View style={styles.headerBorder} />
      {/* ── Team count + select-all ── */}
      <View style={styles.countRow}>
        <Text style={typography.caption}>{members.length} team members</Text>
        <Pressable onPress={toggleSelectAll} hitSlop={8}>
          <Text style={styles.selectAllLabel}>
            {selectedIds.size === filtered.length ? 'Deselect All' : 'Select All'}
          </Text>
        </Pressable>
      </View>
      {/* ── List ── */}
      <FlatList
        data={filtered}
        keyExtractor={(m) => m.id}
        contentContainerStyle={styles.listContent}
        ItemSeparatorComponent={() => <View style={styles.separator} />}
        renderItem={({ item }) => (
          <MemberRow
            member={item}
            isSelected={selectedIds.has(item.id)}
            onPress={() => toggleMember(item.id)}
          />
        )}
      />
      {/* ── Bottom Bar ── */}
      <View style={[styles.bottomBar, { paddingBottom: spacing.md + insets.bottom }]}>
        <Pressable
          style={({ pressed }) => [
            styles.removeButton,
            { backgroundColor: count > 0 ? colors.errorLight : colors.surface },
            pressed && count > 0 && styles.pressed,
          ]}
          onPress={() => setDialogOpen(true)}
          disabled={count === 0}
        >
          <MaterialIcons
            name="person-remove"
            size={sizes.iconSM}
            color={count > 0 ? colors.error : colors.textTertiary}
          />
          <Text
            style={[
              typography.button,
              { color: count > 0 ? colors.error : colors.textTertiary },
            ]}
          >
            {count > 0 ? `Remove ${count} Member${count > 1 ? 's' : ''}` : 'Remove Member'}
          </Text>
        </Pressable>
      </View>
      {/* ── Remove Confirmation Dialog ── */}
      {dialogOpen && selectedMembers.length > 0 && (
        <RemoveConfirmDialog
          members={selectedMembers}
          onConfirm={onDialogConfirm}
          onDismiss={() => setDialogOpen(false)}
        />
      )}
      {/* ── Snackbar feedback ── */}
      {snackbar != null && (
        <Snackbar
          message={snackbar}
          backgroundColor={colors.error}
          bottomOffset={sizes.buttonHeight + spacing.md * 2 + spacing.sm + insets.bottom}
        />
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  screen: {
    flex: 1,
    backgroundColor: colors.scaffoldBg,
  },
  headerBorder: {
    height: 1,
    backgroundColor: colors.border,
  },
  deselectAction: {
    paddingHorizontal: 8,
    paddingVertical: 8,
  },
  deselectLabel: {
    ...typography.buttonSmall,
    color: colors.textSecondary,
  },
  pressed: {
    opacity: 0.7,
  },
  searchHeader: {
    backgroundColor: colors.surface,
    padding: spacing.md,
  },
  countRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: spacing.md,
    paddingTop: spacing.sm,
  },
  selectAllLabel: {
    ...typography.caption,
    fontFamily: fonts.semiBold,
    color: colors.primary,
  },
  listContent: {
    paddingHorizontal: spacing.md,
    paddingTop: spacing.sm,
    paddingBottom: spacing.lg,
  },
  separator: {
    height: spacing.xs,
  },
  bottomBar: {
    backgroundColor: colors.surface,
    borderTopWidth: 1,
    borderTopColor: colors.border,
    paddingHorizontal: spacing.md,
    paddingTop: spacing.md,
  },
  removeButton: {
    height: sizes.buttonHeight,
    borderRadius: radii.button,
    borderWidth: 1.5,
    borderColor: colors.error,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 8,
  },
});
