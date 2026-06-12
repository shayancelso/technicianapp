import { useState } from 'react';
import { Animated, Easing, Pressable, StyleSheet, Text, View } from 'react-native';
import { MaterialIcons } from '@expo/vector-icons';
import { colors, durations, radii, sizes, spacing, typography } from '@/theme';

export interface FabMenuAction {
  icon: keyof typeof MaterialIcons.glyphMap;
  label: string;
  onPress: () => void;
}

interface FabMenuProps {
  actions: FabMenuAction[];
}

/**
 * Expandable floating action button (bottom-right) — port of the Flutter
 * detail-screen FAB column. Actions stagger in; a full-screen backdrop
 * Pressable dismisses the menu.
 */
export function FabMenu({ actions }: FabMenuProps) {
  const [expanded, setExpanded] = useState(false);
  const [rotation] = useState(() => new Animated.Value(0));
  const [actionAnims] = useState(() => actions.map(() => new Animated.Value(0)));

  const open = () => {
    setExpanded(true);
    Animated.timing(rotation, {
      toValue: 1,
      duration: durations.normal,
      easing: Easing.out(Easing.ease),
      useNativeDriver: true,
    }).start();
    // Stagger from the bottom action upward (closest to the FAB first).
    Animated.stagger(
      durations.stagger,
      [...actionAnims].reverse().map((v) =>
        Animated.timing(v, {
          toValue: 1,
          duration: durations.normal,
          easing: Easing.out(Easing.ease),
          useNativeDriver: true,
        }),
      ),
    ).start();
  };

  const close = () => {
    setExpanded(false);
    Animated.timing(rotation, {
      toValue: 0,
      duration: durations.normal,
      easing: Easing.out(Easing.ease),
      useNativeDriver: true,
    }).start();
    actionAnims.forEach((v) => v.setValue(0));
  };

  const rotate = rotation.interpolate({
    inputRange: [0, 1],
    outputRange: ['0deg', '45deg'],
  });

  return (
    <>
      {expanded && <Pressable style={styles.backdrop} onPress={close} />}
      <View style={styles.container} pointerEvents="box-none">
        {expanded &&
          actions.map((action, i) => (
            <Animated.View
              key={action.label}
              style={{
                opacity: actionAnims[i],
                transform: [
                  {
                    translateY: actionAnims[i].interpolate({
                      inputRange: [0, 1],
                      outputRange: [10, 0],
                    }),
                  },
                ],
              }}
            >
              <Pressable
                onPress={() => {
                  close();
                  action.onPress();
                }}
                style={({ pressed }) => [styles.action, pressed && styles.pressed]}
              >
                <MaterialIcons name={action.icon} size={sizes.iconMD} color={colors.primary} />
                <Text style={styles.actionLabel}>{action.label}</Text>
              </Pressable>
            </Animated.View>
          ))}
        <Pressable
          onPress={expanded ? close : open}
          style={({ pressed }) => [styles.fab, pressed && styles.pressed]}
        >
          <Animated.View style={{ transform: [{ rotate }] }}>
            <MaterialIcons name="add" size={sizes.iconLG} color={colors.textOnPrimary} />
          </Animated.View>
          <Text style={styles.fabLabel}>{expanded ? 'Close' : '+ Actions'}</Text>
        </Pressable>
      </View>
    </>
  );
}

const styles = StyleSheet.create({
  backdrop: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    zIndex: 10,
  },
  container: {
    position: 'absolute',
    right: spacing.md,
    bottom: spacing.md,
    alignItems: 'flex-end',
    zIndex: 11,
  },
  action: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 16,
    paddingVertical: 12,
    marginBottom: 8,
    backgroundColor: colors.surface,
    borderRadius: radii.button,
    borderWidth: sizes.borderWidth,
    borderColor: colors.border,
  },
  actionLabel: {
    ...typography.bodyMedium,
    color: colors.primary,
    marginLeft: 8,
  },
  fab: {
    flexDirection: 'row',
    alignItems: 'center',
    height: sizes.buttonHeight,
    paddingHorizontal: 16,
    marginTop: 4,
    backgroundColor: colors.primary,
    borderRadius: radii.button,
  },
  fabLabel: {
    ...typography.button,
    color: colors.textOnPrimary,
    marginLeft: 8,
  },
  pressed: {
    opacity: 0.9,
  },
});
