import { useState, useEffect } from 'react';
import { Animated, StyleSheet, View, ViewStyle } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { colors, radii, spacing } from '@/theme';

interface ShimmerProps {
  width?: number | `${number}%`;
  height?: number;
  borderRadius?: number;
  style?: ViewStyle;
}

/** Skeleton block with an animated highlight sweep (port of shimmer_loading.dart). */
export function Shimmer({ width = '100%', height = 16, borderRadius = radii.small, style }: ShimmerProps) {
  const [sweep] = useState(() => new Animated.Value(-1));

  useEffect(() => {
    const loop = Animated.loop(
      Animated.timing(sweep, { toValue: 1, duration: 1200, useNativeDriver: true }),
    );
    loop.start();
    return () => loop.stop();
  }, [sweep]);

  const translateX = sweep.interpolate({
    inputRange: [-1, 1],
    outputRange: [-200, 200],
  });

  return (
    <View style={[{ width, height, borderRadius, backgroundColor: colors.shimmerBase, overflow: 'hidden' }, style]}>
      <Animated.View style={[StyleSheet.absoluteFill, { transform: [{ translateX }] }]}>
        <LinearGradient
          colors={[colors.shimmerBase, colors.shimmerHighlight, colors.shimmerBase]}
          start={{ x: 0, y: 0.5 }}
          end={{ x: 1, y: 0.5 }}
          style={StyleSheet.absoluteFill}
        />
      </Animated.View>
    </View>
  );
}

export function ShimmerCard() {
  return (
    <View style={styles.card}>
      <Shimmer width="40%" height={12} />
      <View style={styles.spacer} />
      <Shimmer width="80%" height={16} />
      <View style={styles.spacer} />
      <Shimmer width="60%" height={12} />
    </View>
  );
}

export function ShimmerList({ count = 5 }: { count?: number }) {
  return (
    <View>
      {Array.from({ length: count }, (_, i) => (
        <View key={i} style={styles.listItem}>
          <ShimmerCard />
        </View>
      ))}
    </View>
  );
}

const styles = StyleSheet.create({
  card: {
    backgroundColor: colors.surface,
    borderRadius: radii.card,
    borderWidth: 1,
    borderColor: colors.border,
    padding: spacing.md,
    height: 100,
    justifyContent: 'center',
  },
  spacer: { height: spacing.xs },
  listItem: { marginBottom: spacing.sm },
});
