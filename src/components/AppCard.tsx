import { useState, ReactNode } from 'react';
import { Animated, Pressable, StyleSheet, ViewStyle } from 'react-native';
import { colors, durations, radii, sizes, spacing } from '@/theme';

interface AppCardProps {
  children: ReactNode;
  onPress?: () => void;
  style?: ViewStyle;
  backgroundColor?: string;
  borderColor?: string;
}

/** Stripe-style card: white, 1px border, no shadow, subtle press animation. */
export function AppCard({ children, onPress, style, backgroundColor, borderColor }: AppCardProps) {
  const [scale] = useState(() => new Animated.Value(1));

  const animateTo = (value: number) =>
    Animated.timing(scale, {
      toValue: value,
      duration: durations.fast,
      useNativeDriver: true,
    }).start();

  return (
    <Pressable
      onPress={onPress}
      disabled={!onPress}
      onPressIn={onPress ? () => animateTo(0.98) : undefined}
      onPressOut={onPress ? () => animateTo(1) : undefined}
    >
      <Animated.View
        style={[
          styles.card,
          backgroundColor != null && { backgroundColor },
          borderColor != null && { borderColor },
          style,
          { transform: [{ scale }] },
        ]}
      >
        {children}
      </Animated.View>
    </Pressable>
  );
}

const styles = StyleSheet.create({
  card: {
    backgroundColor: colors.surface,
    borderRadius: radii.card,
    borderWidth: sizes.borderWidth,
    borderColor: colors.border,
    padding: spacing.md,
  },
});
