import { ComponentProps } from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { MaterialIcons } from '@expo/vector-icons';
import { colors, radii, sizes, typography } from '@/theme';

interface StatCardProps {
  label: string;
  value: string;
  icon: ComponentProps<typeof MaterialIcons>['name'];
  iconColor: string;
  bgColor: string;
}

/** Stats tile in the View Team header, parity with Flutter _StatCard. */
export function StatCard({ label, value, icon, iconColor, bgColor }: StatCardProps) {
  return (
    <View style={[styles.card, { backgroundColor: bgColor }]}>
      <MaterialIcons name={icon} size={sizes.iconMD} color={iconColor} />
      <Text style={[typography.h2, styles.value, { color: iconColor }]}>{value}</Text>
      <Text style={typography.caption}>{label}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  card: {
    flex: 1,
    padding: 12,
    borderRadius: radii.card,
    borderWidth: sizes.borderWidth,
    borderColor: colors.border,
  },
  value: {
    marginTop: 8,
  },
});
