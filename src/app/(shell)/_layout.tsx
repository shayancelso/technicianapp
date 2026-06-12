import { StyleSheet, View } from 'react-native';
import { Stack } from 'expo-router';
import { BottomNav, OfflineBanner } from '@/components';
import { colors } from '@/theme';

/** Persistent shell: stack content with the bottom nav always visible (port of AppShell). */
export default function ShellLayout() {
  return (
    <View style={styles.container}>
      <OfflineBanner />
      <View style={styles.content}>
        <Stack screenOptions={{ headerShown: false }} />
      </View>
      <BottomNav />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.scaffoldBg,
  },
  content: {
    flex: 1,
  },
});
