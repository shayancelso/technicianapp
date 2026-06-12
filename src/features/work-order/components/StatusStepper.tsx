import { StyleSheet, Text, View } from 'react-native';
import { MaterialIcons } from '@expo/vector-icons';
import { statusPipeline } from '@/data/statusTransitions';
import { colors, fonts, spacing, typography } from '@/theme';

interface StatusStepperProps {
  /** Index of the current step in statusPipeline; -1 if not in the pipeline. */
  currentIndex: number;
}

/** Horizontal pipeline stepper — port of Flutter _buildPipeline + _StepCircle. */
export function StatusStepper({ currentIndex }: StatusStepperProps) {
  return (
    <View style={styles.container}>
      <View style={styles.row}>
        {statusPipeline.map((step, idx) => {
          const isCompleted = idx < currentIndex;
          const isCurrent = idx === currentIndex;
          const isLast = idx === statusPipeline.length - 1;
          return (
            <View key={step.status} style={styles.stepWrap}>
              <View style={styles.step}>
                <StepCircle
                  isCompleted={isCompleted}
                  isCurrent={isCurrent}
                  icon={step.icon as keyof typeof MaterialIcons.glyphMap}
                />
                <Text
                  style={[
                    styles.stepLabel,
                    {
                      color:
                        isCurrent || isCompleted ? colors.primary : colors.textTertiary,
                      fontFamily: isCurrent ? fonts.bold : fonts.medium,
                    },
                  ]}
                  numberOfLines={2}
                >
                  {step.label}
                </Text>
              </View>
              {!isLast && (
                <View
                  style={[
                    styles.connector,
                    { backgroundColor: isCompleted ? colors.success : colors.border },
                  ]}
                />
              )}
            </View>
          );
        })}
      </View>
    </View>
  );
}

function StepCircle({
  isCompleted,
  isCurrent,
  icon,
}: {
  isCompleted: boolean;
  isCurrent: boolean;
  icon: keyof typeof MaterialIcons.glyphMap;
}) {
  if (isCompleted) {
    return (
      <View style={[styles.circle, styles.circleCompleted]}>
        <MaterialIcons name="check" size={14} color="#FFFFFF" />
      </View>
    );
  }
  if (isCurrent) {
    return (
      <View style={[styles.circle, styles.circleCurrent]}>
        <MaterialIcons name={icon} size={14} color="#FFFFFF" />
      </View>
    );
  }
  return (
    <View style={[styles.circle, styles.circleUpcoming]}>
      <MaterialIcons name={icon} size={14} color={colors.textTertiary} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    backgroundColor: colors.surface,
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.lg,
  },
  row: {
    flexDirection: 'row',
    height: 72,
  },
  stepWrap: {
    flex: 1,
    flexDirection: 'row',
  },
  step: {
    flex: 1,
    alignItems: 'center',
  },
  stepLabel: {
    ...typography.caption,
    fontSize: 9,
    lineHeight: 12,
    textAlign: 'center',
    marginTop: 6,
  },
  connector: {
    width: 24,
    height: 2,
    borderRadius: 1,
    alignSelf: 'flex-start',
    marginTop: 13,
  },
  circle: {
    width: 28,
    height: 28,
    borderRadius: 14,
    alignItems: 'center',
    justifyContent: 'center',
  },
  circleCompleted: {
    backgroundColor: colors.success,
  },
  circleCurrent: {
    backgroundColor: colors.primary,
    shadowColor: colors.primary,
    shadowOpacity: 0.35,
    shadowRadius: 8,
    shadowOffset: { width: 0, height: 3 },
    elevation: 4,
  },
  circleUpcoming: {
    backgroundColor: colors.surface,
    borderWidth: 2,
    borderColor: colors.border,
  },
});
