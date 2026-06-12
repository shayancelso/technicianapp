import { Modal, Pressable, StyleSheet, Text, View } from 'react-native';
import { MaterialIcons } from '@expo/vector-icons';
import { Technician } from '@/types/models';
import { colors, radii, sizes, spacing, typography } from '@/theme';

interface PunchInDialogProps {
  technician: Technician;
  onConfirm: (punchIn: boolean) => void;
  onDismiss: () => void;
}

/** Punch-in confirmation dialog after adding a member, parity with Flutter _PunchInDialog. */
export function PunchInDialog({ technician, onConfirm, onDismiss }: PunchInDialogProps) {
  return (
    <Modal visible transparent animationType="fade" onRequestClose={onDismiss}>
      <Pressable style={styles.overlay} onPress={onDismiss}>
        <Pressable style={styles.dialog} onPress={() => {}}>
          {/* Header */}
          <View style={styles.headerRow}>
            <View style={styles.headerIcon}>
              <MaterialIcons name="check" size={24} color={colors.success} />
            </View>
            <View style={styles.headerText}>
              <Text style={typography.h3}>Member Added</Text>
              <Text style={typography.bodySmall} numberOfLines={1}>
                {technician.name}
              </Text>
            </View>
          </View>
          {/* Prompt */}
          <View style={styles.prompt}>
            <MaterialIcons name="access-time" size={16} color={colors.primary} />
            <Text style={[typography.bodySmall, styles.promptText]}>
              Would you like to punch in {technician.name.split(' ')[0]} for this work order?
            </Text>
          </View>
          {/* Buttons */}
          <View style={styles.buttonsRow}>
            <Pressable
              style={({ pressed }) => [styles.skipButton, pressed && styles.pressed]}
              onPress={() => onConfirm(false)}
            >
              <Text style={[typography.buttonSmall, styles.skipLabel]}>Skip</Text>
            </Pressable>
            <Pressable
              style={({ pressed }) => [styles.punchInButton, pressed && styles.pressed]}
              onPress={() => onConfirm(true)}
            >
              <MaterialIcons name="login" size={16} color={colors.textOnPrimary} />
              <Text style={[typography.buttonSmall, styles.punchInLabel]}>Punch In</Text>
            </Pressable>
          </View>
        </Pressable>
      </Pressable>
    </Modal>
  );
}

const styles = StyleSheet.create({
  overlay: {
    flex: 1,
    backgroundColor: colors.overlay,
    justifyContent: 'center',
    paddingHorizontal: spacing.lg,
  },
  dialog: {
    backgroundColor: colors.surface,
    borderRadius: radii.card,
    borderWidth: sizes.borderWidth,
    borderColor: colors.border,
    padding: spacing.lg,
  },
  headerRow: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  headerIcon: {
    width: 48,
    height: 48,
    borderRadius: 24,
    backgroundColor: colors.successLight,
    alignItems: 'center',
    justifyContent: 'center',
    marginRight: 12,
  },
  headerText: {
    flex: 1,
  },
  prompt: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 12,
    backgroundColor: colors.surfaceAlt,
    borderRadius: radii.small,
    borderWidth: 1,
    borderColor: colors.border,
    marginTop: spacing.md,
  },
  promptText: {
    flex: 1,
    color: colors.textPrimary,
    marginLeft: 8,
  },
  buttonsRow: {
    flexDirection: 'row',
    marginTop: spacing.lg,
    gap: spacing.sm,
  },
  skipButton: {
    flex: 1,
    height: sizes.buttonHeight,
    borderRadius: radii.button,
    borderWidth: 1,
    borderColor: colors.border,
    backgroundColor: colors.surface,
    alignItems: 'center',
    justifyContent: 'center',
  },
  skipLabel: {
    color: colors.textSecondary,
  },
  punchInButton: {
    flex: 1,
    height: sizes.buttonHeight,
    borderRadius: radii.button,
    backgroundColor: colors.primary,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 6,
  },
  punchInLabel: {
    color: colors.textOnPrimary,
  },
  pressed: {
    opacity: 0.85,
  },
});
