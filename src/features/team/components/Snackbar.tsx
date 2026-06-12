import { useState, useEffect } from 'react';
import { Animated, StyleSheet, Text } from 'react-native';
import { colors, durations, radii, spacing, typography } from '@/theme';

interface SnackbarProps {
  message: string;
  backgroundColor: string;
  /** Distance from the bottom of the screen (keeps it above the bottom bar). */
  bottomOffset?: number;
}

/**
 * Floating snackbar mirroring Flutter's SnackBarBehavior.floating feedback
 * shown after add/remove confirmations.
 */
export function Snackbar({ message, backgroundColor, bottomOffset = 96 }: SnackbarProps) {
  const [progress] = useState(() => new Animated.Value(0));

  useEffect(() => {
    Animated.timing(progress, {
      toValue: 1,
      duration: durations.normal,
      useNativeDriver: true,
    }).start();
  }, [progress]);

  const translateY = progress.interpolate({ inputRange: [0, 1], outputRange: [12, 0] });

  return (
    <Animated.View
      pointerEvents="none"
      style={[
        styles.snackbar,
        { backgroundColor, bottom: bottomOffset, opacity: progress, transform: [{ translateY }] },
      ]}
    >
      <Text style={[typography.bodySmall, styles.text]}>{message}</Text>
    </Animated.View>
  );
}

const styles = StyleSheet.create({
  snackbar: {
    position: 'absolute',
    left: spacing.md,
    right: spacing.md,
    borderRadius: radii.button,
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.sm,
  },
  text: {
    color: colors.textOnPrimary,
  },
});
