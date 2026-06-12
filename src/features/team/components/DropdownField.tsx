import { useState } from 'react';
import { FlatList, Modal, Pressable, StyleSheet, Text, View } from 'react-native';
import { MaterialIcons } from '@expo/vector-icons';
import { colors, radii, sizes, spacing, typography } from '@/theme';

interface DropdownFieldProps {
  label: string;
  value: string;
  items: string[];
  onChanged: (value: string) => void;
}

/**
 * Dropdown filter field, parity with Flutter _DropdownField (DropdownButton).
 * Options open in a modal sheet since RN has no built-in dropdown.
 */
export function DropdownField({ label, value, items, onChanged }: DropdownFieldProps) {
  const [open, setOpen] = useState(false);

  return (
    <>
      <Pressable
        style={styles.field}
        onPress={() => setOpen(true)}
        accessibilityLabel={label}
        accessibilityRole="button"
      >
        <Text style={[typography.bodySmall, styles.value]} numberOfLines={1}>
          {value}
        </Text>
        <MaterialIcons name="keyboard-arrow-down" size={20} color={colors.textSecondary} />
      </Pressable>
      <Modal visible={open} transparent animationType="fade" onRequestClose={() => setOpen(false)}>
        <Pressable style={styles.overlay} onPress={() => setOpen(false)}>
          <View style={styles.menu}>
            <FlatList
              data={items}
              keyExtractor={(item) => item}
              renderItem={({ item }) => (
                <Pressable
                  style={styles.option}
                  onPress={() => {
                    onChanged(item);
                    setOpen(false);
                  }}
                >
                  <Text style={[typography.bodySmall, styles.optionText]} numberOfLines={1}>
                    {item}
                  </Text>
                  {item === value && (
                    <MaterialIcons name="check" size={16} color={colors.primary} />
                  )}
                </Pressable>
              )}
            />
          </View>
        </Pressable>
      </Modal>
    </>
  );
}

const styles = StyleSheet.create({
  field: {
    height: 44,
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 12,
    backgroundColor: colors.surfaceAlt,
    borderRadius: radii.input,
    borderWidth: sizes.borderWidth,
    borderColor: colors.border,
  },
  value: {
    flex: 1,
    color: colors.textPrimary,
  },
  overlay: {
    flex: 1,
    backgroundColor: colors.overlay,
    justifyContent: 'center',
    paddingHorizontal: spacing.lg,
  },
  menu: {
    maxHeight: 360,
    backgroundColor: colors.surface,
    borderRadius: radii.card,
    borderWidth: sizes.borderWidth,
    borderColor: colors.border,
    paddingVertical: spacing.xs,
  },
  option: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.sm,
  },
  optionText: {
    flex: 1,
    color: colors.textPrimary,
  },
});
