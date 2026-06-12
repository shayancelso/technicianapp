import { StyleSheet, Text, View } from 'react-native';
import { Priority, PRIORITY_LABELS } from '@/constants/enums';
import { colors, fonts, priorityColors } from '@/theme';

function bgFor(priority: Priority): string {
  // p4 uses the border tint (matches Flutter PriorityBadge)
  return priority === 'p4' ? colors.border : priorityColors[priority];
}

interface PriorityBadgeProps {
  priority: Priority;
  compact?: boolean;
}

export function PriorityBadge({ priority, compact = false }: PriorityBadgeProps) {
  const textColor = priority === 'p4' ? colors.textSecondary : '#FFFFFF';
  return (
    <View style={[compact ? styles.compact : styles.pill, { backgroundColor: bgFor(priority) }]}>
      <Text style={[styles.label, { color: textColor, fontSize: compact ? 9 : 10 }]}>
        {PRIORITY_LABELS[priority]}
      </Text>
    </View>
  );
}

const styles = StyleSheet.create({
  compact: {
    width: 24,
    height: 24,
    borderRadius: 12,
    alignItems: 'center',
    justifyContent: 'center',
  },
  pill: {
    paddingHorizontal: 8,
    paddingVertical: 3,
    borderRadius: 12,
    alignSelf: 'flex-start',
  },
  // Only the Regular cut of JetBrainsMono is bundled — adding fontWeight here
  // would silently swap to the system font on Android.
  label: {
    fontFamily: fonts.mono,
  },
});
