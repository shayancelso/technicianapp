import { useState, useEffect } from 'react';
import { ActivityIndicator, Animated, StyleSheet, Text, View } from 'react-native';
import { MaterialIcons } from '@expo/vector-icons';
import { useConnectivity } from '@/context/ConnectivityContext';
import { colors, durations, fonts } from '@/theme';

const BANNER_HEIGHT = 38;

export function OfflineBanner() {
  const { state, isOnline } = useConnectivity();
  const isSyncing = state === 'syncing';
  const visible = !isOnline;

  const [translateY] = useState(() => new Animated.Value(visible ? 0 : -BANNER_HEIGHT));
  const [opacity] = useState(() => new Animated.Value(visible ? 1 : 0));

  useEffect(() => {
    Animated.parallel([
      Animated.timing(translateY, {
        toValue: visible ? 0 : -BANNER_HEIGHT,
        duration: durations.slow,
        useNativeDriver: true,
      }),
      Animated.timing(opacity, {
        toValue: visible ? 1 : 0,
        duration: durations.normal,
        useNativeDriver: true,
      }),
    ]).start();
  }, [visible, translateY, opacity]);

  const tint = isSyncing ? colors.info : colors.warning;

  return (
    <Animated.View
      style={[
        styles.banner,
        { backgroundColor: isSyncing ? colors.infoLight : colors.warningLight },
        { opacity, transform: [{ translateY }] },
      ]}
      pointerEvents="none"
    >
      {isSyncing ? (
        <ActivityIndicator size={14} color={colors.info} />
      ) : (
        <MaterialIcons name="cloud-off" size={16} color={tint} />
      )}
      <View style={styles.gap} />
      <Text style={[styles.text, { color: tint }]} numberOfLines={1}>
        {isSyncing ? 'Syncing changes...' : 'You are offline. Changes will sync when connected.'}
      </Text>
    </Animated.View>
  );
}

const styles = StyleSheet.create({
  banner: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 16,
    paddingVertical: 10,
  },
  gap: { width: 8 },
  text: {
    flex: 1,
    fontFamily: fonts.semiBold,
    fontSize: 11,
  },
});
