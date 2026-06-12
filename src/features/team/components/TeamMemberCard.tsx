import { StyleSheet, Text, View } from 'react-native';
import { MaterialIcons } from '@expo/vector-icons';
import { TeamMemberDetail } from '@/types/models';
import { colors, fonts, radii, sizes, spacing, typography } from '@/theme';
import { PSBadge } from './PSBadge';

const PRIMARY_06 = '#1B43320F'; // colors.primary @ 6%
const PRIMARY_10 = '#1B43321A'; // colors.primary @ 10%
const PRIMARY_20 = '#1B433233'; // colors.primary @ 20%
const PRIMARY_30 = '#1B43324D'; // colors.primary @ 30%
const WARNING_15 = '#D9770626'; // colors.warning @ 15%
const WARNING_40 = '#D9770666'; // colors.warning @ 40%
const SUCCESS_30 = '#0596694D'; // colors.success @ 30%

const initialsOf = (name: string) =>
  name
    .split(' ')
    .map((w) => w[0])
    .slice(0, 2)
    .join('');

interface TeamMemberCardProps {
  member: TeamMemberDetail;
  rank: number;
}

/** Team member card on the View Team screen, parity with Flutter _TeamMemberCard. */
export function TeamMemberCard({ member, rank }: TeamMemberCardProps) {
  const isFirst = rank === 1;

  return (
    <View style={styles.card}>
      <View style={styles.topRow}>
        {/* Rank badge */}
        <View
          style={[
            styles.rankBadge,
            {
              backgroundColor: isFirst ? WARNING_15 : colors.surfaceAlt,
              borderColor: isFirst ? WARNING_40 : colors.border,
            },
          ]}
        >
          <Text
            style={[styles.rankText, { color: isFirst ? colors.warning : colors.textTertiary }]}
          >
            {rank}
          </Text>
        </View>
        {/* Avatar */}
        <View
          style={[
            styles.avatar,
            {
              backgroundColor: member.isPunchedIn ? PRIMARY_10 : colors.surfaceAlt,
              borderColor: member.isPunchedIn ? PRIMARY_30 : colors.border,
            },
          ]}
        >
          <Text
            style={[
              styles.avatarText,
              { color: member.isPunchedIn ? colors.primary : colors.textTertiary },
            ]}
          >
            {initialsOf(member.name)}
          </Text>
        </View>
        {/* Main info */}
        <View style={styles.info}>
          <View style={styles.nameRow}>
            <Text style={[typography.bodyMedium, styles.name]} numberOfLines={1}>
              {member.name}
            </Text>
            <PSBadge type={member.memberType} />
          </View>
          <View style={styles.metaRow}>
            <Text style={styles.empId}>{member.empId}</Text>
            <Text style={styles.dotSeparator}>{'  ·  '}</Text>
            <Text style={typography.caption}>{member.designation}</Text>
          </View>
        </View>
      </View>
      {/* Bottom row: active time + punch status */}
      <View style={styles.bottomRow}>
        <View style={styles.activeBadge}>
          <MaterialIcons name="schedule" size={12} color={colors.success} />
          <Text style={styles.activeText}>
            Active: {member.activeDays}d {member.activeHours}h
          </Text>
        </View>
        <View
          style={[
            styles.punchChip,
            {
              backgroundColor: member.isPunchedIn ? PRIMARY_06 : colors.surfaceAlt,
              borderColor: member.isPunchedIn ? PRIMARY_20 : colors.border,
            },
          ]}
        >
          <View
            style={[
              styles.punchDot,
              { backgroundColor: member.isPunchedIn ? colors.success : colors.border },
            ]}
          />
          <Text
            style={[
              styles.punchText,
              { color: member.isPunchedIn ? colors.primary : colors.textTertiary },
            ]}
          >
            {member.isPunchedIn ? `In — ${member.punchInTime}` : 'Off duty'}
          </Text>
        </View>
      </View>
      {member.currentTask.length > 0 && (
        <View style={styles.taskBox}>
          <MaterialIcons name="build-circle" size={13} color={colors.textTertiary} />
          <Text style={[typography.caption, styles.taskText]} numberOfLines={1}>
            {member.currentTask}
          </Text>
        </View>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  card: {
    padding: spacing.md,
    backgroundColor: colors.surface,
    borderRadius: radii.card,
    borderWidth: sizes.borderWidth,
    borderColor: colors.border,
  },
  topRow: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  rankBadge: {
    width: 22,
    height: 22,
    borderRadius: radii.small,
    borderWidth: 1,
    alignItems: 'center',
    justifyContent: 'center',
    marginRight: 10,
  },
  rankText: {
    fontFamily: fonts.bold,
    fontSize: 9,
    lineHeight: 12,
  },
  avatar: {
    width: 44,
    height: 44,
    borderRadius: 22,
    borderWidth: 2,
    alignItems: 'center',
    justifyContent: 'center',
    marginRight: 12,
  },
  avatarText: {
    fontFamily: fonts.bold,
    fontSize: 14,
    lineHeight: 18,
  },
  info: {
    flex: 1,
  },
  nameRow: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  name: {
    flex: 1,
    marginRight: 6,
  },
  metaRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginTop: 2,
  },
  empId: {
    ...typography.mono,
    fontSize: 11,
    lineHeight: 15.4,
    color: colors.textTertiary,
  },
  dotSeparator: {
    ...typography.caption,
    color: colors.textTertiary,
  },
  bottomRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginTop: 12,
  },
  activeBadge: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 10,
    paddingVertical: 5,
    backgroundColor: colors.successLight,
    borderRadius: radii.chip,
    borderWidth: 1,
    borderColor: SUCCESS_30,
    marginRight: 8,
  },
  activeText: {
    fontFamily: fonts.semiBold,
    fontSize: 11,
    lineHeight: 15.4,
    color: colors.success,
    marginLeft: 4,
  },
  punchChip: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 8,
    paddingVertical: 5,
    borderRadius: radii.chip,
    borderWidth: 1,
  },
  punchDot: {
    width: 6,
    height: 6,
    borderRadius: 3,
    marginRight: 4,
  },
  punchText: {
    fontFamily: fonts.medium,
    fontSize: 11,
    lineHeight: 15.4,
  },
  taskBox: {
    flexDirection: 'row',
    alignItems: 'center',
    width: '100%',
    paddingHorizontal: 10,
    paddingVertical: 7,
    backgroundColor: colors.surfaceAlt,
    borderRadius: radii.small,
    borderWidth: 1,
    borderColor: colors.border,
    marginTop: 8,
  },
  taskText: {
    flex: 1,
    color: colors.textSecondary,
    marginLeft: 6,
  },
});
