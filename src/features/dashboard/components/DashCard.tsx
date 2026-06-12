import { ComponentProps } from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { MaterialIcons } from '@expo/vector-icons';
import { AppCard } from '@/components';
import { colors, fonts, typography } from '@/theme';

type IconName = ComponentProps<typeof MaterialIcons>['name'];

interface DashCardProps {
  icon: IconName;
  iconColor: string;
  iconBg: string;
  title: string;
  subtitle?: string;
  badge?: number;
  compact?: boolean;
  onPress: () => void;
}

/** Dashboard tile — port of the Flutter `_DashCard`. */
export function DashCard({
  icon,
  iconColor,
  iconBg,
  title,
  subtitle,
  badge,
  compact = false,
  onPress,
}: DashCardProps) {
  return (
    <AppCard onPress={onPress} style={compact ? styles.cardCompact : undefined}>
      <View style={styles.topRow}>
        <View
          style={[
            styles.iconBox,
            { backgroundColor: iconBg },
            compact && styles.iconBoxCompact,
          ]}
        >
          <MaterialIcons name={icon} size={compact ? 20 : 22} color={iconColor} />
        </View>
        {badge != null && badge > 0 && (
          <View style={styles.badge}>
            <Text style={styles.badgeText}>{badge}</Text>
          </View>
        )}
      </View>
      <View style={[styles.titleRow, { marginTop: compact ? 10 : 14 }]}>
        <Text
          style={[styles.title, { fontSize: compact ? 12 : 14 }]}
          numberOfLines={1}
          ellipsizeMode="tail"
        >
          {title}
        </Text>
        <MaterialIcons name="chevron-right" size={18} color={colors.textTertiary} />
      </View>
      {subtitle != null && (
        <Text style={styles.subtitle} numberOfLines={1} ellipsizeMode="tail">
          {subtitle}
        </Text>
      )}
    </AppCard>
  );
}

const styles = StyleSheet.create({
  cardCompact: {
    padding: 12,
  },
  topRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  iconBox: {
    width: 44,
    height: 44,
    borderRadius: 10,
    alignItems: 'center',
    justifyContent: 'center',
  },
  iconBoxCompact: {
    width: 40,
    height: 40,
  },
  badge: {
    width: 22,
    height: 22,
    borderRadius: 11,
    backgroundColor: colors.error,
    alignItems: 'center',
    justifyContent: 'center',
  },
  badgeText: {
    fontFamily: fonts.bold,
    fontSize: 11,
    color: '#FFFFFF',
  },
  titleRow: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  title: {
    ...typography.bodyMedium,
    fontFamily: fonts.semiBold,
    flex: 1,
  },
  subtitle: {
    ...typography.caption,
    color: colors.textTertiary,
    marginTop: 2,
  },
});
