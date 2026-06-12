import { StyleSheet, Text, View } from 'react-native';
import { colors, fonts } from '@/theme';

interface InitialsAvatarProps {
  initials: string;
  size?: number;
  backgroundColor?: string;
  color?: string;
}

export function InitialsAvatar({
  initials,
  size = 48,
  backgroundColor = colors.primary,
  color = colors.textOnPrimary,
}: InitialsAvatarProps) {
  return (
    <View
      style={[
        styles.circle,
        { width: size, height: size, borderRadius: size / 2, backgroundColor },
      ]}
    >
      <Text style={[styles.text, { color, fontSize: size * 0.36 }]}>{initials}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  circle: {
    alignItems: 'center',
    justifyContent: 'center',
  },
  text: {
    fontFamily: fonts.semiBold,
  },
});
