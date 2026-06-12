import { Pressable, StyleSheet, Text, View } from 'react-native';
import { MaterialIcons } from '@expo/vector-icons';
import { TeamMember } from '@/types/models';
import { colors, fonts, radii, sizes, spacing, typography } from '@/theme';
import { PSBadge } from './PSBadge';

const PRIMARY_10 = '#1B43321A'; // colors.primary @ 10%
const ERROR_10 = '#DC26261A'; // colors.error @ 10%
const ERROR_LIGHT_50 = '#FEE2E280'; // colors.errorLight @ 50%

const initialsOf = (name: string) =>
  name
    .split(' ')
    .map((w) => w[0])
    .slice(0, 2)
    .join('');

interface MemberRowProps {
  member: TeamMember;
  isSelected: boolean;
  onPress: () => void;
}

/** Selectable team member row on the Remove Member screen, parity with Flutter _MemberRow. */
export function MemberRow({ member, isSelected, onPress }: MemberRowProps) {
  return (
    <Pressable onPress={onPress}>
      <View
        style={[
          styles.row,
          {
            backgroundColor: isSelected ? ERROR_LIGHT_50 : colors.surface,
            borderColor: isSelected ? colors.error : colors.border,
            borderWidth: isSelected ? sizes.borderWidthFocused : sizes.borderWidth,
          },
        ]}
      >
        {/* Checkbox */}
        <View
          style={[
            styles.checkbox,
            {
              backgroundColor: isSelected ? colors.error : colors.surface,
              borderColor: isSelected ? colors.error : colors.border,
            },
          ]}
        >
          {isSelected && <MaterialIcons name="check" size={14} color="#FFFFFF" />}
        </View>
        {/* Avatar */}
        <View style={[styles.avatar, { backgroundColor: isSelected ? ERROR_10 : PRIMARY_10 }]}>
          <Text
            style={[styles.avatarText, { color: isSelected ? colors.error : colors.primary }]}
          >
            {initialsOf(member.name)}
          </Text>
        </View>
        {/* Info */}
        <View style={styles.info}>
          <View style={styles.nameRow}>
            <Text
              style={[
                typography.bodyMedium,
                styles.name,
                { color: isSelected ? colors.error : colors.textPrimary },
              ]}
              numberOfLines={1}
            >
              {member.name}
            </Text>
            <PSBadge type={member.memberType} />
          </View>
          <View style={styles.metaRow}>
            <Text style={[typography.caption, styles.tertiary]}>{member.empId}</Text>
            <Text style={[typography.caption, styles.tertiary]}>{'  ·  '}</Text>
            <Text style={typography.caption}>{member.designation}</Text>
          </View>
          <View style={styles.punchRow}>
            <View
              style={[
                styles.punchDot,
                { backgroundColor: member.isPunchedIn ? colors.success : colors.border },
              ]}
            />
            <Text
              style={[
                styles.punchText,
                { color: member.isPunchedIn ? colors.success : colors.textTertiary },
              ]}
            >
              {member.isPunchedIn ? `Punched in — ${member.joinedAt}` : 'Not punched in'}
            </Text>
          </View>
        </View>
      </View>
    </Pressable>
  );
}

const styles = StyleSheet.create({
  row: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: spacing.md,
    borderRadius: radii.card,
  },
  checkbox: {
    width: 22,
    height: 22,
    borderRadius: 5,
    borderWidth: 2,
    alignItems: 'center',
    justifyContent: 'center',
    marginRight: 12,
  },
  avatar: {
    width: 40,
    height: 40,
    borderRadius: 20,
    alignItems: 'center',
    justifyContent: 'center',
    marginRight: 12,
  },
  avatarText: {
    fontFamily: fonts.bold,
    fontSize: 13,
    lineHeight: 17,
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
  tertiary: {
    color: colors.textTertiary,
  },
  punchRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginTop: 2,
  },
  punchDot: {
    width: 6,
    height: 6,
    borderRadius: 3,
    marginRight: 4,
  },
  punchText: {
    ...typography.caption,
    fontSize: 10,
    lineHeight: 14,
  },
});
