import { ComponentProps, ReactNode } from 'react';
import { Alert, Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { MaterialIcons } from '@expo/vector-icons';
import { router } from 'expo-router';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { InitialsAvatar } from '@/components';
import { useConnectivity } from '@/context/ConnectivityContext';
import { mockOverallRating, mockStarBreakdown, mockUser } from '@/data/mockUser';
import { colors, fonts, spacing, typography } from '@/theme';
import { DashCard } from '../components/DashCard';
import { RatingCard } from '../components/RatingCard';

type IconName = ComponentProps<typeof MaterialIcons>['name'];

export default function DashboardScreen() {
  const insets = useSafeAreaInsets();
  const { isOnline, toggle } = useConnectivity();

  const handleLogout = () => {
    Alert.alert('Sign Out', 'Are you sure you want to sign out?', [
      { text: 'Cancel', style: 'cancel' },
      { text: 'Sign Out', onPress: () => router.replace('/login') },
    ]);
  };

  return (
    <ScrollView
      style={styles.root}
      contentContainerStyle={{ paddingTop: insets.top, paddingBottom: 24 }}
    >
      {/* ── Top Bar ── */}
      <View style={styles.topBar}>
        {/* Online/Offline pill */}
        <Pressable onPress={toggle} style={[styles.pill, isOnline ? styles.pillOnline : styles.pillOffline]}>
          <View style={[styles.pillDot, { backgroundColor: isOnline ? colors.success : colors.error }]} />
          <Text style={[styles.pillText, { color: isOnline ? colors.success : colors.error }]}>
            {isOnline ? 'Online' : 'Offline'}
          </Text>
        </Pressable>
        <View style={styles.spacer} />
        {/* Notification bell with badge */}
        <HeaderIcon icon="notifications-none" badgeCount={3} onPress={() => {}} />
        {/* Profile icon */}
        <HeaderIcon icon="person-outline" onPress={() => router.push('/profile')} />
        {/* Logout icon */}
        <HeaderIcon icon="logout" onPress={handleLogout} />
      </View>

      {/* ── Technician Profile ── */}
      <View style={styles.profileRow}>
        <InitialsAvatar initials={mockUser.initials} size={56} />
        <View style={styles.profileText}>
          <Text style={typography.h2}>{mockUser.displayName}</Text>
          <Text style={styles.designation}>{mockUser.designation}</Text>
        </View>
      </View>

      {/* ── Rating Card ── */}
      <View style={[styles.hPad, { marginTop: spacing.xs }]}>
        <RatingCard overallRating={mockOverallRating} starBreakdown={mockStarBreakdown} />
      </View>

      {/* ── Reactive Maintenance ── */}
      <SectionHeader label="REACTIVE MAINTENANCE" />
      <View style={[styles.hPad, styles.cardRow]}>
        <View style={styles.flex1}>
          <DashCard
            icon="assignment"
            iconColor={colors.error}
            iconBg={colors.errorLight}
            title="RM WO"
            subtitle="Work Orders"
            badge={4}
            onPress={() => router.push('/work-orders/rm')}
          />
        </View>
        <View style={{ width: 12 }} />
        <View style={styles.flex1}>
          <DashCard
            icon="history"
            iconColor={colors.info}
            iconBg={colors.infoLight}
            title="History RM"
            subtitle="Past Work Orders"
            onPress={() => router.push('/work-orders/rm?history=true')}
          />
        </View>
      </View>

      {/* ── Scheduled Maintenance ── */}
      <SectionHeader label="SCHEDULED MAINTENANCE" />
      <View style={[styles.hPad, styles.cardRow]}>
        <View style={styles.flex1}>
          <DashCard
            icon="event-note"
            iconColor={colors.warning}
            iconBg={colors.warningLight}
            title="PPM WO"
            badge={1}
            compact
            onPress={() => router.push('/work-orders/ppm')}
          />
        </View>
        <View style={{ width: 8 }} />
        <View style={styles.flex1}>
          <DashCard
            icon="history"
            iconColor={colors.info}
            iconBg={colors.infoLight}
            title="History PPM"
            compact
            onPress={() => router.push('/work-orders/ppm?history=true')}
          />
        </View>
        <View style={{ width: 8 }} />
        <View style={styles.flex1}>
          <DashCard
            icon="cleaning-services"
            iconColor={colors.accent}
            iconBg="rgba(64, 145, 108, 0.12)"
            title="SS WO"
            compact
            onPress={() => router.push('/work-orders/ss')}
          />
        </View>
        <View style={{ width: 8 }} />
        <View style={styles.flex1}>
          <DashCard
            icon="history"
            iconColor={colors.info}
            iconBg={colors.infoLight}
            title="History SS"
            compact
            onPress={() => router.push('/work-orders/ss?history=true')}
          />
        </View>
      </View>

      {/* ── My Team ── */}
      <SectionHeader label="MY TEAM" />
      <View style={[styles.hPad, styles.cardRow]}>
        <View style={styles.flex1}>
          <DashCard
            icon="person-add"
            iconColor={colors.primary}
            iconBg="rgba(27, 67, 50, 0.1)"
            title="Add Member"
            compact
            onPress={() => router.push('/team/add')}
          />
        </View>
        <View style={{ width: 8 }} />
        <View style={styles.flex1}>
          <DashCard
            icon="person-remove"
            iconColor={colors.error}
            iconBg={colors.errorLight}
            title="Remove"
            compact
            onPress={() => router.push('/team/remove')}
          />
        </View>
        <View style={{ width: 8 }} />
        <View style={styles.flex1}>
          <DashCard
            icon="groups"
            iconColor={colors.primary}
            iconBg="rgba(27, 67, 50, 0.1)"
            title="View Team"
            compact
            onPress={() => router.push('/team/view')}
          />
        </View>
      </View>
    </ScrollView>
  );
}

// ── Header Icon Button ──
function HeaderIcon({
  icon,
  badgeCount,
  onPress,
}: {
  icon: IconName;
  badgeCount?: number;
  onPress: () => void;
}) {
  return (
    <Pressable onPress={onPress} style={styles.headerIcon} hitSlop={4}>
      <MaterialIcons name={icon} size={24} color={colors.textPrimary} />
      {badgeCount != null && badgeCount > 0 && (
        <View style={styles.headerBadge}>
          <Text style={styles.headerBadgeText}>{badgeCount}</Text>
        </View>
      )}
    </Pressable>
  );
}

// ── Section Header ──
function SectionHeader({ label }: { label: string }): ReactNode {
  return <Text style={styles.sectionHeader}>{label}</Text>;
}

const styles = StyleSheet.create({
  root: {
    flex: 1,
    backgroundColor: colors.surface,
  },
  hPad: {
    paddingHorizontal: spacing.md,
  },
  flex1: {
    flex: 1,
  },
  spacer: {
    flex: 1,
  },

  // ── Top bar ──
  topBar: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.sm,
  },
  pill: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 20,
  },
  pillOnline: {
    backgroundColor: 'rgba(5, 150, 105, 0.1)',
  },
  pillOffline: {
    backgroundColor: 'rgba(220, 38, 38, 0.1)',
  },
  pillDot: {
    width: 8,
    height: 8,
    borderRadius: 4,
    marginRight: 6,
  },
  pillText: {
    ...typography.caption,
    fontFamily: fonts.semiBold,
    fontSize: 12,
  },
  headerIcon: {
    width: 36,
    height: 36,
    alignItems: 'center',
    justifyContent: 'center',
    marginLeft: 8,
  },
  headerBadge: {
    position: 'absolute',
    top: 2,
    right: 0,
    minWidth: 15,
    height: 15,
    borderRadius: 8,
    paddingHorizontal: 3,
    backgroundColor: colors.error,
    alignItems: 'center',
    justifyContent: 'center',
  },
  headerBadgeText: {
    fontFamily: fonts.bold,
    fontSize: 9,
    color: '#FFFFFF',
  },

  // ── Profile section ──
  profileRow: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.sm,
  },
  profileText: {
    marginLeft: 14,
  },
  designation: {
    ...typography.bodySmall,
    fontFamily: fonts.medium,
    color: colors.accent,
    marginTop: 2,
  },

  // ── Sections ──
  sectionHeader: {
    ...typography.overline,
    paddingHorizontal: spacing.md,
    paddingTop: 16,
    paddingBottom: 10,
    marginTop: spacing.xs,
  },
  cardRow: {
    flexDirection: 'row',
  },
});
