import { StyleSheet, Text, View } from 'react-native';
import { colors, fonts, typography } from '@/theme';

interface TimerChipProps {
  label: string;
  value: string;
}

/** SLA timer column (APT / RRT / JCT) — port of Flutter _TimerChip. */
export function TimerChip({ label, value }: TimerChipProps) {
  const isZero = value === '00:00:00';
  return (
    <View style={styles.container}>
      <Text style={styles.label}>{label}</Text>
      <Text style={[styles.value, { color: isZero ? colors.textTertiary : colors.textPrimary }]}>
        {value}
      </Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
  },
  label: {
    ...typography.overline,
    fontSize: 9,
    lineHeight: 13,
  },
  value: {
    fontFamily: fonts.mono,
    fontSize: 12,
    lineHeight: 17,
    marginTop: 2,
  },
});
