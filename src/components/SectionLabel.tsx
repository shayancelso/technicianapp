import { StyleSheet, Text } from 'react-native';
import { spacing, typography } from '@/theme';

/** Overline-style section header (uppercase, letter-spaced). */
export function SectionLabel({ children }: { children: string }) {
  return <Text style={styles.label}>{children.toUpperCase()}</Text>;
}

const styles = StyleSheet.create({
  label: {
    ...typography.overline,
    marginBottom: spacing.sm,
  },
});
