import { ReactNode } from 'react';
import { Pressable, StyleSheet, Text, View } from 'react-native';
import { MaterialIcons } from '@expo/vector-icons';
import { router } from 'expo-router';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { colors, sizes, typography } from '@/theme';

interface ScreenHeaderProps {
  title: string;
  onBack?: () => void;
  showBack?: boolean;
  trailing?: ReactNode;
}

/** 56px app bar: back chevron + title, white surface (parity with Flutter AppBars). */
export function ScreenHeader({ title, onBack, showBack = true, trailing }: ScreenHeaderProps) {
  const insets = useSafeAreaInsets();
  return (
    <View style={[styles.container, { paddingTop: insets.top }]}>
      <View style={styles.bar}>
        {showBack && (
          <Pressable
            style={styles.back}
            onPress={onBack ?? (() => router.back())}
            hitSlop={8}
          >
            <MaterialIcons name="arrow-back-ios-new" size={20} color={colors.textPrimary} />
          </Pressable>
        )}
        <Text style={[typography.h3, styles.title]} numberOfLines={1}>
          {title}
        </Text>
        {trailing != null && <View style={styles.trailing}>{trailing}</View>}
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    backgroundColor: colors.surface,
  },
  bar: {
    height: sizes.appBarHeight,
    flexDirection: 'row',
    alignItems: 'center',
  },
  back: {
    width: 48,
    height: '100%',
    alignItems: 'center',
    justifyContent: 'center',
  },
  title: {
    flex: 1,
  },
  trailing: {
    paddingRight: 12,
  },
});
