import { useState, useEffect } from 'react';
import { Animated, Easing, Pressable, StyleSheet, Text, View } from 'react-native';
import { MaterialIcons } from '@expo/vector-icons';
import { AppCard, PriorityBadge, StatusBadge } from '@/components';
import { TimerChip } from './TimerChip';
import { WorkOrder } from '@/types/models';
import { colors, durations, fonts, radii, sizes, spacing, typography } from '@/theme';

interface WOCardProps {
  wo: WorkOrder;
  isExpanded: boolean;
  onExpandToggle: () => void;
  onViewInfo: () => void;
  onChangeStatus: () => void;
}

/** Expandable work-order card — port of Flutter _WOCard + _ExpandedContent. */
export function WOCard({ wo, isExpanded, onExpandToggle, onViewInfo, onChangeStatus }: WOCardProps) {
  const [expandAnim] = useState(() => new Animated.Value(isExpanded ? 1 : 0));

  useEffect(() => {
    Animated.timing(expandAnim, {
      toValue: isExpanded ? 1 : 0,
      duration: durations.slow,
      easing: Easing.inOut(Easing.ease),
      useNativeDriver: true,
    }).start();
  }, [isExpanded, expandAnim]);

  const chevronRotation = expandAnim.interpolate({
    inputRange: [0, 1],
    outputRange: ['0deg', '180deg'],
  });

  return (
    <AppCard style={styles.cardOverride}>
      {/* ── Header Row ── */}
      <Pressable onPress={onExpandToggle} style={styles.headerRow}>
        <PriorityBadge priority={wo.priority} compact />
        <Text style={styles.woNumber} numberOfLines={1}>
          {wo.woNumber}
        </Text>
        <StatusBadge status={wo.status} />
        <Animated.View style={{ marginLeft: 8, transform: [{ rotate: chevronRotation }] }}>
          <MaterialIcons name="keyboard-arrow-down" size={sizes.iconMD} color={colors.textTertiary} />
        </Animated.View>
      </Pressable>

      {/* ── Expanded Section ── */}
      {isExpanded && (
        <Animated.View style={{ opacity: expandAnim }}>
          <View style={styles.divider} />
          <View style={styles.expandedBody}>
            <InfoLine icon="business" text={wo.contractName} />
            <InfoLine icon="location-on" text={wo.location} />
            <InfoLine icon="settings" text={wo.assetName} />

            {/* SLA Timers */}
            <View style={styles.timersBox}>
              <TimerChip label="APT" value={wo.aptTimer} />
              <View style={styles.timerDivider} />
              <TimerChip label="RRT" value={wo.rrtTimer} />
              <View style={styles.timerDivider} />
              <TimerChip label="JCT" value={wo.jctTimer} />
            </View>

            {/* Action Buttons */}
            <View style={styles.actionsRow}>
              <Pressable
                onPress={onViewInfo}
                style={({ pressed }) => [styles.outlinedButton, pressed && styles.pressed]}
              >
                <Text style={[typography.buttonSmall, { color: colors.primary }]}>View Info</Text>
              </Pressable>
              <View style={{ width: spacing.sm }} />
              <Pressable
                onPress={onChangeStatus}
                style={({ pressed }) => [styles.filledButton, pressed && styles.pressed]}
              >
                <Text style={[typography.buttonSmall, { color: colors.textOnPrimary }]}>
                  {wo.status === 'assigned' ? 'Start Trip' : 'Change Status'}
                </Text>
              </Pressable>
            </View>
          </View>
        </Animated.View>
      )}
    </AppCard>
  );
}

function InfoLine({ icon, text }: { icon: keyof typeof MaterialIcons.glyphMap; text: string }) {
  return (
    <View style={styles.infoLine}>
      <MaterialIcons name={icon} size={14} color={colors.textTertiary} />
      <Text style={styles.infoLineText} numberOfLines={1}>
        {text}
      </Text>
    </View>
  );
}

const styles = StyleSheet.create({
  cardOverride: {
    padding: 0,
  },
  headerRow: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: spacing.md,
  },
  woNumber: {
    ...typography.mono,
    fontFamily: fonts.mono,
    color: colors.textPrimary,
    flex: 1,
    marginLeft: 12,
  },
  divider: {
    height: 1,
    backgroundColor: colors.divider,
    marginHorizontal: spacing.md,
  },
  expandedBody: {
    padding: spacing.md,
  },
  infoLine: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 8,
  },
  infoLineText: {
    ...typography.bodySmall,
    color: colors.textSecondary,
    flex: 1,
    marginLeft: 6,
  },
  timersBox: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 12,
    marginTop: 4,
    backgroundColor: colors.surfaceAlt,
    borderRadius: radii.small,
    borderWidth: sizes.borderWidth,
    borderColor: colors.border,
  },
  timerDivider: {
    width: 1,
    height: 28,
    backgroundColor: colors.border,
    marginHorizontal: 4,
  },
  actionsRow: {
    flexDirection: 'row',
    marginTop: 12,
  },
  outlinedButton: {
    flex: 1,
    height: sizes.buttonHeight,
    borderRadius: radii.button,
    borderWidth: sizes.borderWidth,
    borderColor: colors.primary,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: colors.surface,
  },
  filledButton: {
    flex: 1,
    height: sizes.buttonHeight,
    borderRadius: radii.button,
    backgroundColor: colors.primary,
    alignItems: 'center',
    justifyContent: 'center',
  },
  pressed: {
    opacity: 0.85,
  },
});
