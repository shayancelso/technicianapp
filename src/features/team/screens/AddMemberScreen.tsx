import { useMemo, useRef, useState } from 'react';
import { FlatList, Pressable, StyleSheet, Text, View } from 'react-native';
import { MaterialIcons } from '@expo/vector-icons';
import { router } from 'expo-router';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { ScreenHeader } from '@/components/ScreenHeader';
import { clientFilters, contractFilters, mockTechnicians } from '@/data/mockTechnicians';
import { Technician } from '@/types/models';
import { colors, radii, sizes, spacing, typography } from '@/theme';
import { DropdownField } from '../components/DropdownField';
import { PunchInDialog } from '../components/PunchInDialog';
import { Snackbar } from '../components/Snackbar';
import { TeamSearchBar } from '../components/TeamSearchBar';
import { TechnicianRow } from '../components/TechnicianRow';

const PRIMARY_06 = '#1B43320F'; // colors.primary @ 6%
const ERROR_30 = '#DC26264D'; // colors.error @ 30%

const SNACKBAR_DURATION = 1200;

export default function AddMemberScreen() {
  const insets = useSafeAreaInsets();
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedTechId, setSelectedTechId] = useState<string | null>(null);
  const [filtersExpanded, setFiltersExpanded] = useState(false);
  const [selectedClient, setSelectedClient] = useState('All Clients');
  const [selectedContract, setSelectedContract] = useState('All Contracts');
  const [dialogTech, setDialogTech] = useState<Technician | null>(null);
  const [snackbar, setSnackbar] = useState<string | null>(null);
  const backTimer = useRef<ReturnType<typeof setTimeout> | null>(null);

  const filtered = useMemo(() => {
    const q = searchQuery.toLowerCase();
    return mockTechnicians.filter((t) => {
      const matchesSearch =
        q.length === 0 ||
        t.name.toLowerCase().includes(q) ||
        t.empId.toLowerCase().includes(q) ||
        t.trade.toLowerCase().includes(q);
      const matchesClient = selectedClient === 'All Clients' || t.client === selectedClient;
      const matchesContract =
        selectedContract === 'All Contracts' || t.contract === selectedContract;
      return matchesSearch && matchesClient && matchesContract;
    });
  }, [searchQuery, selectedClient, selectedContract]);

  const hasActiveFilter = selectedClient !== 'All Clients' || selectedContract !== 'All Contracts';

  const onAddMember = () => {
    if (selectedTechId == null) return;
    const tech = mockTechnicians.find((t) => t.id === selectedTechId);
    if (tech == null) return;
    setDialogTech(tech);
  };

  const onDialogConfirm = (punchIn: boolean) => {
    const tech = dialogTech;
    setDialogTech(null);
    if (tech == null) return;
    setSnackbar(punchIn ? `${tech.name} added and punched in` : `${tech.name} added to team`);
    if (backTimer.current != null) clearTimeout(backTimer.current);
    backTimer.current = setTimeout(() => router.back(), SNACKBAR_DURATION);
  };

  const filterActive = hasActiveFilter || filtersExpanded;
  const filterColor = filterActive ? colors.primary : colors.textSecondary;

  return (
    <View style={styles.screen}>
      <ScreenHeader title="Add New Member" />
      <View style={styles.headerBorder} />
      {/* ── Search + Filter Header ── */}
      <View style={styles.searchHeader}>
        <TeamSearchBar
          value={searchQuery}
          onChangeText={setSearchQuery}
          placeholder="Search by name, ID or trade…"
        />
        <View style={styles.filtersRow}>
          <Pressable
            style={[
              styles.filterChip,
              {
                backgroundColor: filterActive ? PRIMARY_06 : colors.surfaceAlt,
                borderColor: filterActive ? colors.primary : colors.border,
              },
            ]}
            onPress={() => setFiltersExpanded((e) => !e)}
          >
            <MaterialIcons
              name={filtersExpanded ? 'tune' : 'filter-list'}
              size={14}
              color={filterColor}
            />
            <Text style={[styles.filterLabel, { color: filterColor }]}>
              {hasActiveFilter ? 'Filters (active)' : 'Filters'}
            </Text>
            <MaterialIcons
              name={filtersExpanded ? 'keyboard-arrow-up' : 'keyboard-arrow-down'}
              size={14}
              color={filterColor}
            />
          </Pressable>
          {hasActiveFilter && (
            <Pressable
              style={styles.clearChip}
              onPress={() => {
                setSelectedClient('All Clients');
                setSelectedContract('All Contracts');
              }}
            >
              <Text style={styles.clearLabel}>Clear</Text>
            </Pressable>
          )}
        </View>
        {filtersExpanded && (
          <View style={styles.advancedFilters}>
            <DropdownField
              label="Client"
              value={selectedClient}
              items={clientFilters}
              onChanged={setSelectedClient}
            />
            <View style={styles.dropdownSpacer} />
            <DropdownField
              label="Contract"
              value={selectedContract}
              items={contractFilters}
              onChanged={setSelectedContract}
            />
          </View>
        )}
      </View>
      <View style={styles.headerBorder} />
      {/* ── Result count ── */}
      <Text style={[typography.caption, styles.resultCount]}>
        {filtered.length} technicians available
      </Text>
      {/* ── List ── */}
      <FlatList
        data={filtered}
        keyExtractor={(t) => t.id}
        contentContainerStyle={styles.listContent}
        ItemSeparatorComponent={() => <View style={styles.separator} />}
        renderItem={({ item }) => (
          <TechnicianRow
            tech={item}
            isSelected={selectedTechId === item.id}
            onPress={() =>
              setSelectedTechId((current) => (current === item.id ? null : item.id))
            }
          />
        )}
      />
      {/* ── Bottom Bar ── */}
      <View style={[styles.bottomBar, { paddingBottom: spacing.md + insets.bottom }]}>
        <Pressable
          style={({ pressed }) => [
            styles.addButton,
            selectedTechId == null && styles.addButtonDisabled,
            pressed && selectedTechId != null && styles.pressed,
          ]}
          onPress={onAddMember}
          disabled={selectedTechId == null}
        >
          <MaterialIcons
            name="person-add"
            size={sizes.iconSM}
            color={selectedTechId != null ? colors.textOnPrimary : colors.textTertiary}
          />
          <Text
            style={[
              typography.button,
              { color: selectedTechId != null ? colors.textOnPrimary : colors.textTertiary },
            ]}
          >
            Add Member
          </Text>
        </Pressable>
      </View>
      {/* ── Punch-In Confirmation Dialog ── */}
      {dialogTech != null && (
        <PunchInDialog
          technician={dialogTech}
          onConfirm={onDialogConfirm}
          onDismiss={() => setDialogTech(null)}
        />
      )}
      {/* ── Snackbar feedback ── */}
      {snackbar != null && (
        <Snackbar
          message={snackbar}
          backgroundColor={colors.success}
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
  searchHeader: {
    backgroundColor: colors.surface,
    padding: spacing.md,
  },
  filtersRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginTop: spacing.sm,
  },
  filterChip: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 12,
    paddingVertical: 7,
    borderRadius: radii.chip,
    borderWidth: 1,
    gap: 4,
  },
  filterLabel: {
    ...typography.buttonSmall,
    fontSize: 12,
    lineHeight: 16,
  },
  clearChip: {
    paddingHorizontal: 10,
    paddingVertical: 7,
    backgroundColor: colors.errorLight,
    borderRadius: radii.chip,
    borderWidth: 1,
    borderColor: ERROR_30,
    marginLeft: 8,
  },
  clearLabel: {
    ...typography.buttonSmall,
    fontSize: 12,
    lineHeight: 16,
    color: colors.error,
  },
  advancedFilters: {
    marginTop: spacing.sm,
  },
  dropdownSpacer: {
    height: spacing.xs,
  },
  resultCount: {
    paddingHorizontal: spacing.md,
    paddingTop: spacing.sm,
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
  addButton: {
    height: sizes.buttonHeight,
    borderRadius: radii.button,
    backgroundColor: colors.primary,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 8,
  },
  addButtonDisabled: {
    backgroundColor: colors.border,
  },
  pressed: {
    opacity: 0.85,
  },
});
