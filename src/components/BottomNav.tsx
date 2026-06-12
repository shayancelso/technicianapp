import { Pressable, StyleSheet, Text, View } from 'react-native';
import { MaterialIcons } from '@expo/vector-icons';
import { router, usePathname } from 'expo-router';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { colors, fonts } from '@/theme';

interface NavItemProps {
  icon: keyof typeof MaterialIcons.glyphMap;
  label: string;
  isActive: boolean;
  badgeCount?: number;
  onPress: () => void;
}

function NavItem({ icon, label, isActive, badgeCount, onPress }: NavItemProps) {
  const tint = isActive ? colors.primary : colors.textTertiary;
  return (
    <Pressable style={styles.item} onPress={onPress}>
      <View>
        <MaterialIcons name={icon} size={24} color={tint} />
        {badgeCount != null && badgeCount > 0 && (
          <View style={styles.badge}>
            <Text style={styles.badgeText}>{badgeCount}</Text>
          </View>
        )}
      </View>
      <Text
        style={[styles.label, { color: tint, fontFamily: isActive ? fonts.semiBold : fonts.medium }]}
        numberOfLines={1}
      >
        {label}
      </Text>
    </Pressable>
  );
}

/** Persistent bottom navigation bar (port of app_shell.dart). */
export function BottomNav() {
  const pathname = usePathname();
  const insets = useSafeAreaInsets();

  const activeIndex = pathname.startsWith('/dashboard')
    ? 0
    : pathname.startsWith('/work-orders')
      ? 1
      : pathname.startsWith('/notifications')
        ? 3
        : pathname.startsWith('/profile')
          ? 4
          : -1;

  return (
    <View style={[styles.bar, { paddingBottom: insets.bottom }]}>
      <View style={styles.row}>
        <NavItem
          icon="home"
          label="Home"
          isActive={activeIndex === 0}
          onPress={() => router.navigate('/dashboard')}
        />
        <NavItem
          icon="assignment"
          label="Work Orders"
          isActive={activeIndex === 1}
          onPress={() => router.push('/work-orders/rm')}
        />
        {/* Center FAB (non-functional, parity with Flutter shell) */}
        <Pressable style={styles.item} onPress={() => {}}>
          <View style={styles.fab}>
            <MaterialIcons name="add" size={28} color={colors.textOnPrimary} />
          </View>
        </Pressable>
        <NavItem
          icon="notifications-none"
          label="Notifications"
          isActive={activeIndex === 3}
          badgeCount={3}
          onPress={() => {}}
        />
        <NavItem
          icon="person-outline"
          label="Profile"
          isActive={activeIndex === 4}
          onPress={() => router.push('/profile')}
        />
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  bar: {
    backgroundColor: colors.surface,
    borderTopWidth: 1,
    borderTopColor: colors.border,
  },
  row: {
    height: 64,
    flexDirection: 'row',
  },
  item: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  label: {
    fontSize: 10,
    marginTop: 4,
  },
  fab: {
    width: 48,
    height: 48,
    borderRadius: 24,
    backgroundColor: colors.primary,
    alignItems: 'center',
    justifyContent: 'center',
  },
  badge: {
    position: 'absolute',
    top: -4,
    right: -8,
    minWidth: 14,
    height: 14,
    borderRadius: 7,
    paddingHorizontal: 3,
    backgroundColor: colors.error,
    alignItems: 'center',
    justifyContent: 'center',
  },
  badgeText: {
    color: '#FFFFFF',
    fontSize: 8,
    fontFamily: fonts.bold,
  },
});
