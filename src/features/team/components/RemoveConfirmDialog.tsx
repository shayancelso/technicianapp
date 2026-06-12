import { ComponentProps, useState } from 'react';
import { Modal, Pressable, StyleSheet, Text, View } from 'react-native';
import { MaterialCommunityIcons, MaterialIcons } from '@expo/vector-icons';
import { TeamMember } from '@/types/models';
import { colors, fonts, radii, sizes, spacing, typography } from '@/theme';

const ERROR_LIGHT_50 = '#FEE2E280'; // colors.errorLight @ 50%

// ── Option Tile (parity with Flutter _OptionTile) ─────────────────────────────

interface OptionTileProps {
  isSelected: boolean;
  icon: ComponentProps<typeof MaterialCommunityIcons>['name'];
  iconColor: string;
  title: string;
  subtitle: string;
  onPress?: () => void;
  disabled?: boolean;
}

function OptionTile({
  isSelected,
  icon,
  iconColor,
  title,
  subtitle,
  onPress,
  disabled = false,
}: OptionTileProps) {
  const showSelected = isSelected && !disabled;
  return (
    <Pressable onPress={onPress} disabled={disabled || onPress == null}>
      <View
        style={[
          styles.optionTile,
          {
            backgroundColor: !disabled && isSelected ? ERROR_LIGHT_50 : colors.surfaceAlt,
            borderColor: !disabled && isSelected ? colors.error : colors.border,
            borderWidth: isSelected ? 1.5 : 1,
          },
        ]}
      >
        <MaterialCommunityIcons
          name={icon}
          size={18}
          color={disabled ? colors.border : iconColor}
        />
        <View style={styles.optionText}>
          <Text
            style={[
              styles.optionTitle,
              { color: disabled ? colors.textTertiary : colors.textPrimary },
            ]}
          >
            {title}
          </Text>
          <Text
            style={[
              typography.caption,
              { color: disabled ? colors.textTertiary : colors.textSecondary },
            ]}
          >
            {subtitle}
          </Text>
        </View>
        <View
          style={[
            styles.optionRadio,
            {
              backgroundColor: showSelected ? colors.error : colors.surface,
              borderColor: showSelected ? colors.error : colors.border,
            },
          ]}
        >
          {showSelected && <MaterialIcons name="check" size={10} color="#FFFFFF" />}
        </View>
      </View>
    </Pressable>
  );
}

// ── Remove Confirmation Dialog (parity with Flutter _RemoveConfirmDialog) ─────

interface RemoveConfirmDialogProps {
  members: TeamMember[];
  onConfirm: (punchOut: boolean) => void;
  onDismiss: () => void;
}

export function RemoveConfirmDialog({ members, onConfirm, onDismiss }: RemoveConfirmDialogProps) {
  const [punchOut, setPunchOut] = useState(false);
  const hasPunchedInMembers = members.some((m) => m.isPunchedIn);

  return (
    <Modal visible transparent animationType="fade" onRequestClose={onDismiss}>
      <Pressable style={styles.overlay} onPress={onDismiss}>
        <Pressable style={styles.dialog} onPress={() => {}}>
          {/* Header */}
          <View style={styles.headerRow}>
            <View style={styles.headerIcon}>
              <MaterialIcons name="person-remove" size={24} color={colors.error} />
            </View>
            <View style={styles.headerText}>
              <Text style={typography.h3}>Remove Member</Text>
              <Text style={typography.bodySmall}>
                {members.length} member{members.length > 1 ? 's' : ''} selected
              </Text>
            </View>
          </View>
          {/* Member list preview */}
          <View style={styles.preview}>
            {members.slice(0, 3).map((m) => (
              <View key={m.id} style={styles.previewRow}>
                <View
                  style={[
                    styles.previewDot,
                    { backgroundColor: m.isPunchedIn ? colors.success : colors.border },
                  ]}
                />
                <Text style={[typography.bodySmall, styles.previewText]} numberOfLines={1}>
                  {m.name} — {m.empId}
                </Text>
              </View>
            ))}
            {members.length > 3 && (
              <Text style={typography.caption}>+ {members.length - 3} more</Text>
            )}
          </View>
          {/* Divider */}
          <View style={styles.divider} />
          {/* Option 1: Remove only from team */}
          <OptionTile
            isSelected={!punchOut}
            icon="account-multiple-minus-outline"
            iconColor={colors.textSecondary}
            title="Remove only from team"
            subtitle="Member stays in system, not in this WO"
            onPress={() => setPunchOut(false)}
          />
          {/* Option 2: Remove and punch out */}
          <View style={styles.optionSpacer} />
          <OptionTile
            isSelected={punchOut}
            icon="logout"
            iconColor={hasPunchedInMembers ? colors.error : colors.border}
            title="Remove and punch out"
            subtitle={
              hasPunchedInMembers
                ? 'End their shift for this work order'
                : 'No punched-in members selected'
            }
            onPress={hasPunchedInMembers ? () => setPunchOut(true) : undefined}
            disabled={!hasPunchedInMembers}
          />
          {/* Buttons */}
          <View style={styles.buttonsRow}>
            <Pressable
              style={({ pressed }) => [styles.cancelButton, pressed && styles.pressed]}
              onPress={onDismiss}
            >
              <Text style={[typography.buttonSmall, styles.cancelLabel]}>Cancel</Text>
            </Pressable>
            <Pressable
              style={({ pressed }) => [styles.confirmButton, pressed && styles.pressed]}
              onPress={() => onConfirm(punchOut)}
            >
              <Text style={[typography.buttonSmall, styles.confirmLabel]}>Confirm</Text>
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
    backgroundColor: colors.errorLight,
    alignItems: 'center',
    justifyContent: 'center',
    marginRight: 12,
  },
  headerText: {
    flex: 1,
  },
  preview: {
    marginTop: spacing.md,
  },
  previewRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 6,
  },
  previewDot: {
    width: 6,
    height: 6,
    borderRadius: 3,
    marginRight: 8,
  },
  previewText: {
    flex: 1,
    color: colors.textPrimary,
  },
  divider: {
    height: 1,
    backgroundColor: colors.border,
    marginVertical: spacing.md,
  },
  optionTile: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 12,
    borderRadius: radii.button,
  },
  optionText: {
    flex: 1,
    marginLeft: 10,
  },
  optionTitle: {
    fontFamily: fonts.semiBold,
    fontSize: 13,
    lineHeight: 19.5,
  },
  optionRadio: {
    width: 18,
    height: 18,
    borderRadius: 9,
    borderWidth: 2,
    alignItems: 'center',
    justifyContent: 'center',
  },
  optionSpacer: {
    height: 8,
  },
  buttonsRow: {
    flexDirection: 'row',
    marginTop: spacing.lg,
    gap: spacing.sm,
  },
  cancelButton: {
    flex: 1,
    height: sizes.buttonHeight,
    borderRadius: radii.button,
    borderWidth: 1,
    borderColor: colors.border,
    backgroundColor: colors.surface,
    alignItems: 'center',
    justifyContent: 'center',
  },
  cancelLabel: {
    color: colors.textSecondary,
  },
  confirmButton: {
    flex: 1,
    height: sizes.buttonHeight,
    borderRadius: radii.button,
    backgroundColor: colors.error,
    alignItems: 'center',
    justifyContent: 'center',
  },
  confirmLabel: {
    color: '#FFFFFF',
  },
  pressed: {
    opacity: 0.85,
  },
});
