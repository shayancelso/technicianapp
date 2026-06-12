import { Pressable, StyleSheet, Text, View } from 'react-native';
import { MaterialIcons } from '@expo/vector-icons';
import { Technician } from '@/types/models';
import { colors, fonts, radii, sizes, spacing, typography } from '@/theme';
import { PSBadge } from './PSBadge';

const PRIMARY_04 = '#1B43320A'; // colors.primary @ 4%
const PRIMARY_10 = '#1B43321A'; // colors.primary @ 10%

const initialsOf = (name: string) =>
  name
    .split(' ')
    .map((w) => w[0])
    .slice(0, 2)
    .join('');

function InfoChip({ label }: { label: string }) {
  return (
    <View style={styles.infoChip}>
      <Text style={styles.infoChipText}>{label}</Text>
    </View>
  );
}

interface TechnicianRowProps {
  tech: Technician;
  isSelected: boolean;
  onPress: () => void;
}

/** Selectable technician row on the Add Member screen, parity with Flutter _TechnicianRow. */
export function TechnicianRow({ tech, isSelected, onPress }: TechnicianRowProps) {
  return (
    <Pressable onPress={onPress}>
      <View
        style={[
          styles.row,
          {
            backgroundColor: isSelected ? PRIMARY_04 : colors.surface,
            borderColor: isSelected ? colors.primary : colors.border,
            borderWidth: isSelected ? sizes.borderWidthFocused : sizes.borderWidth,
          },
        ]}
      >
        {/* Radio circle */}
        <View
          style={[
            styles.radio,
            {
              backgroundColor: isSelected ? colors.primary : colors.surface,
              borderColor: isSelected ? colors.primary : colors.border,
            },
          ]}
        >
          {isSelected && <MaterialIcons name="check" size={12} color="#FFFFFF" />}
        </View>
        {/* Avatar */}
        <View style={styles.avatar}>
          <Text style={styles.avatarText}>{initialsOf(tech.name)}</Text>
        </View>
        {/* Info */}
        <View style={styles.info}>
          <View style={styles.nameRow}>
            <Text style={[typography.bodyMedium, styles.name]} numberOfLines={1}>
              {tech.name}
            </Text>
            <PSBadge type={tech.memberType} />
          </View>
          <View style={styles.chipsRow}>
            <InfoChip label={tech.empId} />
            <InfoChip label={tech.trade} />
          </View>
          <Text style={[typography.caption, styles.designation]}>{tech.designation}</Text>
        </View>
        {/* On-duty dot */}
        <View
          style={[
            styles.dutyDot,
            { backgroundColor: tech.isOnDuty ? colors.success : colors.border },
          ]}
        />
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
  radio: {
    width: 22,
    height: 22,
    borderRadius: 11,
    borderWidth: 2,
    alignItems: 'center',
    justifyContent: 'center',
    marginRight: 12,
  },
  avatar: {
    width: 40,
    height: 40,
    borderRadius: 20,
    backgroundColor: PRIMARY_10,
    alignItems: 'center',
    justifyContent: 'center',
    marginRight: 12,
  },
  avatarText: {
    fontFamily: fonts.bold,
    fontSize: 13,
    lineHeight: 17,
    color: colors.primary,
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
  chipsRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginTop: 3,
    gap: 4,
  },
  designation: {
    marginTop: 2,
  },
  infoChip: {
    paddingHorizontal: 6,
    paddingVertical: 2,
    backgroundColor: colors.surfaceAlt,
    borderRadius: 4,
    borderWidth: 1,
    borderColor: colors.border,
  },
  infoChipText: {
    ...typography.caption,
    fontSize: 10,
    lineHeight: 14,
    color: colors.textSecondary,
  },
  dutyDot: {
    width: 8,
    height: 8,
    borderRadius: 4,
    marginLeft: 8,
  },
});
