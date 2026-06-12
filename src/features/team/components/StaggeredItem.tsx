import { useState, ReactNode, useEffect } from 'react';
import { Animated, Easing } from 'react-native';
import { durations } from '@/theme';

interface StaggeredItemProps {
  children: ReactNode;
  /** Delay before the fade/slide starts, in milliseconds. */
  delay: number;
}

/** Staggered fade-in + slide-up, parity with Flutter _StaggeredItem. */
export function StaggeredItem({ children, delay }: StaggeredItemProps) {
  const [progress] = useState(() => new Animated.Value(0));

  useEffect(() => {
    const animation = Animated.timing(progress, {
      toValue: 1,
      duration: durations.slow,
      delay,
      easing: Easing.out(Easing.ease),
      useNativeDriver: true,
    });
    animation.start();
    return () => animation.stop();
  }, [progress, delay]);

  const translateY = progress.interpolate({ inputRange: [0, 1], outputRange: [8, 0] });

  return (
    <Animated.View style={{ opacity: progress, transform: [{ translateY }] }}>
      {children}
    </Animated.View>
  );
}
