import { ReactNode, useState } from 'react';
import { Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { MaterialIcons } from '@expo/vector-icons';
import { router, useLocalSearchParams } from 'expo-router';
import { PriorityBadge, ScreenHeader, StatusBadge } from '@/components';
import { DetailTabs } from '../components/DetailTabs';
import { FabMenu } from '../components/FabMenu';
import { mockWorkOrderDetail } from '@/data/mockWorkOrders';
import { PRIORITY_LABELS } from '@/constants/enums';
import { colors, fonts, radii, sizes, spacing, typography } from '@/theme';

// ── Tab Definitions ───────────────────────────────────────────────────────────

const TABS = [
  'General Info',
  'Location',
  'Service Detail',
  'Description',
  'Special Instruction',
  'Additional Info',
];

const detail = mockWorkOrderDetail;

// ── Main Screen ───────────────────────────────────────────────────────────────

export default function WorkOrderDetailScreen() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const [activeTab, setActiveTab] = useState(0);

  return (
    <View style={styles.screen}>
      <ScreenHeader title="Work Order Details" trailing={<StatusBadge status={detail.status} />} />
      <View style={styles.headerBorder} />

      {/* ── WO Header Block ── */}
      <View style={styles.woHeader}>
        <PriorityBadge priority={detail.priority} />
        <Text style={styles.woNumber} numberOfLines={1}>
          {detail.woNumber}
        </Text>
      </View>

      {/* ── Tab Bar ── */}
      <DetailTabs tabs={TABS} activeIndex={activeTab} onTabPress={setActiveTab} />

      {/* ── Tab Content ── */}
      <View style={styles.tabContent}>
        {activeTab === 0 && <GeneralInfoTab />}
        {activeTab === 1 && <LocationTab />}
        {activeTab === 2 && <ServiceDetailTab />}
        {activeTab === 3 && <DescriptionTab />}
        {activeTab === 4 && <SpecialInstructionTab />}
        {activeTab === 5 && <AdditionalInfoTab />}
      </View>

      {/* ── FAB ── */}
      <FabMenu
        actions={[
          {
            icon: 'swap-horiz',
            label: 'Change Status',
            onPress: () => router.push(`/change-status/${id}`),
          },
          { icon: 'camera-alt', label: 'Add Photo', onPress: () => {} },
          { icon: 'note-add', label: 'Add Note', onPress: () => {} },
          { icon: 'group-add', label: 'Manage Team', onPress: () => router.push('/team/view') },
        ]}
      />
    </View>
  );
}

// ── Shared Rows ───────────────────────────────────────────────────────────────

function InfoRow({
  label,
  value,
  isLast = false,
  isTimer = false,
}: {
  label: string;
  value: string;
  isLast?: boolean;
  isTimer?: boolean;
}) {
  return (
    <View>
      <View style={styles.infoRow}>
        <Text style={styles.infoLabel}>{label}</Text>
        <Text style={[styles.infoValue, isTimer && styles.infoValueTimer]}>{value}</Text>
      </View>
      {!isLast && <View style={styles.rowDivider} />}
    </View>
  );
}

function CardContainer({ children }: { children: ReactNode }) {
  return <View style={styles.card}>{children}</View>;
}

// ── General Info Tab ──────────────────────────────────────────────────────────

function GeneralInfoTab() {
  const rows: [string, string][] = [
    ['Booked By', detail.bookedBy],
    ['RRT', detail.rrt],
    ['JCT', detail.jct],
    ['Appointment Date', detail.appointmentDate],
    ['Contract', detail.contract],
    ['Payment Status', detail.paymentStatus],
    ['Priority', PRIORITY_LABELS[detail.priority]],
    ['Asset', detail.assets],
    ['Location', detail.location],
  ];

  return (
    <ScrollView contentContainerStyle={styles.tabScroll}>
      <CardContainer>
        {rows.map(([label, value], i) => (
          <InfoRow
            key={label}
            label={label}
            value={value}
            isLast={i === rows.length - 1}
            isTimer={label === 'RRT' || label === 'JCT'}
          />
        ))}
      </CardContainer>
    </ScrollView>
  );
}

// ── Location Tab ──────────────────────────────────────────────────────────────

const GRID_SPACING = 30;
const GRID_LINES = 20;

function LocationTab() {
  return (
    <ScrollView contentContainerStyle={styles.tabScroll}>
      {/* Fake map placeholder with grid pattern */}
      <View style={styles.map}>
        {Array.from({ length: GRID_LINES }).map((_, i) => (
          <View key={`v${i}`} style={[styles.mapGridV, { left: i * GRID_SPACING }]} />
        ))}
        {Array.from({ length: GRID_LINES }).map((_, i) => (
          <View key={`h${i}`} style={[styles.mapGridH, { top: i * GRID_SPACING }]} />
        ))}
        <View style={styles.mapRoadH} />
        <View style={styles.mapRoadV} />
        <View style={styles.mapCenter}>
          <MaterialIcons name="location-on" size={48} color={colors.error} />
          <Text style={[typography.bodyMedium, { marginTop: 8 }]}>Substation 14B, Al Quoz</Text>
          <Text style={[typography.caption, { marginTop: 4 }]}>Google Maps Placeholder</Text>
        </View>
      </View>

      <View style={{ height: spacing.md }} />
      <CardContainer>
        <InfoRow label="Address" value="Substation 14B, Al Quoz Industrial Area, Dubai, UAE" />
        <InfoRow label="Coordinates" value="25.1234° N, 55.2109° E" isLast isTimer />
      </CardContainer>

      <View style={{ height: spacing.md }} />
      <Pressable style={({ pressed }) => [styles.mapsButton, pressed && { opacity: 0.85 }]}>
        <MaterialIcons name="navigation" size={18} color={colors.textOnPrimary} />
        <Text style={[typography.button, { color: colors.textOnPrimary, marginLeft: 8 }]}>
          Open in Maps
        </Text>
      </Pressable>
    </ScrollView>
  );
}

// ── Service Detail Tab ────────────────────────────────────────────────────────

const SERVICE_ROWS: [string, string][] = [
  ['Service Category', 'Electrical — MV Systems'],
  ['Trade', 'Electrical Engineer'],
  ['Work Type', 'Reactive Maintenance (RM)'],
  ['Fault Code', 'ELEC-OC-FAULT-B2'],
  ['Task Checklist', '5 tasks / 2 completed'],
  ['Last PM Visit', '14 Apr 2024'],
];

const CHECKLIST: { task: string; done: boolean }[] = [
  { task: 'Inspect MV bus bars for visual damage', done: true },
  { task: 'Check overcurrent relay settings', done: true },
  { task: 'Test phase-2 breaker continuity', done: false },
  { task: 'Thermal scan on all bus connections', done: false },
  { task: 'Document and report findings', done: false },
];

function ServiceDetailTab() {
  return (
    <ScrollView contentContainerStyle={styles.tabScroll}>
      <CardContainer>
        {SERVICE_ROWS.map(([label, value], i) => (
          <InfoRow key={label} label={label} value={value} isLast={i === SERVICE_ROWS.length - 1} />
        ))}
      </CardContainer>

      <View style={{ height: spacing.md }} />
      <Text style={typography.overline}>TASK CHECKLIST</Text>
      <View style={{ height: 8 }} />
      <CardContainer>
        {CHECKLIST.map(({ task, done }, i) => (
          <View key={task}>
            <View style={styles.checklistRow}>
              <MaterialIcons
                name={done ? 'check-circle' : 'radio-button-unchecked'}
                size={20}
                color={done ? colors.success : colors.border}
              />
              <Text
                style={[
                  styles.checklistText,
                  done && {
                    color: colors.textTertiary,
                    textDecorationLine: 'line-through',
                  },
                ]}
              >
                {task}
              </Text>
            </View>
            {i < CHECKLIST.length - 1 && <View style={[styles.rowDivider, { marginLeft: 52 }]} />}
          </View>
        ))}
      </CardContainer>
    </ScrollView>
  );
}

// ── Description Tab ───────────────────────────────────────────────────────────

function DescriptionTab() {
  return (
    <ScrollView contentContainerStyle={styles.tabScroll}>
      <View style={[styles.card, { padding: spacing.md }]}>
        <Text style={[typography.body, { lineHeight: 15 * 1.7 }]}>{detail.description}</Text>
      </View>
    </ScrollView>
  );
}

// ── Special Instruction Tab ───────────────────────────────────────────────────

function SpecialInstructionTab() {
  return (
    <ScrollView contentContainerStyle={styles.tabScroll}>
      <View style={styles.instructionCard}>
        <MaterialIcons name="warning-amber" size={20} color={colors.warning} />
        <Text style={styles.instructionText}>{detail.specialInstruction}</Text>
      </View>
    </ScrollView>
  );
}

// ── Additional Info Tab ───────────────────────────────────────────────────────

interface AdditionalRowDef {
  icon: keyof typeof MaterialIcons.glyphMap;
  label: string;
  count?: number;
  isNew?: boolean;
}

const ADDITIONAL_ROWS: AdditionalRowDef[] = [
  { icon: 'photo-library', label: 'Photos / Videos', count: detail.photosCount },
  { icon: 'sticky-note-2', label: 'Notes', count: detail.notesCount },
  { icon: 'auto-awesome', label: 'AI Assistant', isNew: true },
  { icon: 'history', label: 'Work Order History', count: detail.historyCount },
  { icon: 'inventory', label: 'Booked Material', count: detail.materialsCount },
  { icon: 'calculate', label: 'Estimation', count: detail.estimationCount },
  { icon: 'manage-accounts', label: 'Customer History' },
];

function AdditionalInfoTab() {
  return (
    <ScrollView contentContainerStyle={styles.tabScroll}>
      <CardContainer>
        {ADDITIONAL_ROWS.map((row, i) => (
          <View key={row.label}>
            <Pressable
              style={({ pressed }) => [styles.additionalRow, pressed && { opacity: 0.7 }]}
              onPress={() => {}}
            >
              <View style={styles.additionalIconBox}>
                <MaterialIcons name={row.icon} size={sizes.iconSM} color={colors.primary} />
              </View>
              <View style={styles.additionalLabelWrap}>
                <Text style={typography.bodyMedium}>{row.label}</Text>
                {row.isNew && (
                  <View style={styles.newBadge}>
                    <Text style={styles.newBadgeText}>NEW</Text>
                  </View>
                )}
              </View>
              {row.count != null && row.count > 0 && (
                <View style={styles.countChip}>
                  <Text style={styles.countChipText}>{row.count}</Text>
                </View>
              )}
              <MaterialIcons
                name="chevron-right"
                size={sizes.iconMD}
                color={colors.textTertiary}
                style={{ marginLeft: 8 }}
              />
            </Pressable>
            {i < ADDITIONAL_ROWS.length - 1 && (
              <View style={[styles.rowDivider, { marginLeft: 64 }]} />
            )}
          </View>
        ))}
      </CardContainer>
    </ScrollView>
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
  woHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: colors.surface,
    padding: spacing.md,
  },
  woNumber: {
    ...typography.monoLarge,
    color: colors.primary,
    flex: 1,
    marginLeft: 12,
  },
  tabContent: {
    flex: 1,
  },
  tabScroll: {
    padding: spacing.md,
    paddingBottom: spacing.lg + 64,
  },
  card: {
    backgroundColor: colors.surface,
    borderRadius: radii.card,
    borderWidth: sizes.borderWidth,
    borderColor: colors.border,
    overflow: 'hidden',
  },
  infoRow: {
    flexDirection: 'row',
    alignItems: 'flex-start',
    paddingHorizontal: spacing.md,
    paddingVertical: 14,
  },
  infoLabel: {
    ...typography.bodySmall,
    color: colors.textTertiary,
    width: 130,
  },
  infoValue: {
    ...typography.bodySmall,
    color: colors.textPrimary,
    flex: 1,
    marginLeft: 8,
    textAlign: 'right',
  },
  infoValueTimer: {
    fontFamily: fonts.mono,
    fontSize: 13,
    lineHeight: 18.2,
  },
  rowDivider: {
    height: 1,
    backgroundColor: colors.divider,
    marginLeft: 16,
  },
  // ── Location tab ──
  map: {
    height: 260,
    backgroundColor: colors.border,
    borderRadius: radii.card,
    borderWidth: sizes.borderWidth,
    borderColor: colors.border,
    overflow: 'hidden',
  },
  mapGridV: {
    position: 'absolute',
    top: 0,
    bottom: 0,
    width: 1,
    backgroundColor: 'rgba(232, 238, 235, 0.6)',
  },
  mapGridH: {
    position: 'absolute',
    left: 0,
    right: 0,
    height: 1,
    backgroundColor: 'rgba(232, 238, 235, 0.6)',
  },
  mapRoadH: {
    position: 'absolute',
    left: 0,
    right: 0,
    top: '40%',
    height: 8,
    backgroundColor: colors.surface,
  },
  mapRoadV: {
    position: 'absolute',
    top: 0,
    bottom: 0,
    left: '35%',
    width: 8,
    backgroundColor: colors.surface,
  },
  mapCenter: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    alignItems: 'center',
    justifyContent: 'center',
  },
  mapsButton: {
    height: sizes.buttonHeight,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: colors.primary,
    borderRadius: radii.button,
  },
  // ── Service detail tab ──
  checklistRow: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: spacing.md,
    paddingVertical: 12,
  },
  checklistText: {
    ...typography.bodySmall,
    color: colors.textPrimary,
    flex: 1,
    marginLeft: 12,
  },
  // ── Special instruction tab ──
  instructionCard: {
    flexDirection: 'row',
    alignItems: 'flex-start',
    padding: spacing.md,
    backgroundColor: colors.warningLight,
    borderRadius: radii.card,
    borderWidth: sizes.borderWidth,
    borderColor: 'rgba(217, 119, 6, 0.3)',
  },
  instructionText: {
    ...typography.body,
    lineHeight: 15 * 1.7,
    color: '#92400E',
    flex: 1,
    marginLeft: 10,
  },
  // ── Additional info tab ──
  additionalRow: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: spacing.md,
    paddingVertical: 14,
  },
  additionalIconBox: {
    width: 36,
    height: 36,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: colors.surfaceAlt,
    borderRadius: radii.small,
    borderWidth: sizes.borderWidth,
    borderColor: colors.border,
  },
  additionalLabelWrap: {
    flex: 1,
    flexDirection: 'row',
    alignItems: 'center',
    marginLeft: 12,
  },
  newBadge: {
    paddingHorizontal: 6,
    paddingVertical: 2,
    marginLeft: 6,
    backgroundColor: 'rgba(82, 183, 136, 0.15)',
    borderRadius: 4,
  },
  newBadgeText: {
    fontFamily: fonts.bold,
    fontSize: 9,
    lineHeight: 12,
    color: colors.primary,
  },
  countChip: {
    paddingHorizontal: 8,
    paddingVertical: 3,
    backgroundColor: 'rgba(27, 67, 50, 0.08)',
    borderRadius: radii.chip,
  },
  countChipText: {
    ...typography.caption,
    fontFamily: fonts.bold,
    color: colors.primary,
  },
});
