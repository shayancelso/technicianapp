import { StyleSheet, Text, View } from 'react-native';
import { MemberType } from '@/constants/enums';
import { colors, fonts } from '@/theme';

const PRIMARY_10 = '#1B43321A'; // colors.primary @ 10%
const INFO_10 = '#2563EB1A'; // colors.info @ 10%

/** Primary/Secondary member badge ("P" / "S"), parity with Flutter _PSBadge. */
export function PSBadge({ type }: { type: MemberType }) {
  const isPrimary = type === 'primary';
  return (
    <View style={[styles.badge, { backgroundColor: isPrimary ? PRIMARY_10 : INFO_10 }]}>
      <Text style={[styles.label, { color: isPrimary ? colors.primary : colors.info }]}>
        {isPrimary ? 'P' : 'S'}
      </Text>
    </View>
  );
}

const styles = StyleSheet.create({
  badge: {
    paddingHorizontal: 6,
    paddingVertical: 2,
    borderRadius: 4,
  },
  label: {
    fontFamily: fonts.bold,
    fontSize: 10,
    lineHeight: 14,
  },
});
