import { useCallback, useRef, useState } from 'react';
import {
  ActivityIndicator,
  Modal,
  Pressable,
  ScrollView,
  StyleSheet,
  Text,
  TextInput,
  View,
} from 'react-native';
import { MaterialIcons } from '@expo/vector-icons';
import { router, useLocalSearchParams } from 'expo-router';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { ScreenHeader } from '@/components';
import { StatusStepper } from '../components/StatusStepper';
import { WOStatus, WO_STATUS_LABELS } from '@/constants/enums';
import {
  NextStatusOption,
  statusPipeline,
  validNextOptions,
} from '@/data/statusTransitions';
import { colors, fonts, radii, sizes, spacing, typography } from '@/theme';

const DELAY_REASONS = [
  'Awaiting spare parts',
  'Awaiting PTW / permit',
  'Client not available',
  'Safety clearance pending',
  'Traffic / travel delay',
  'Awaiting additional manpower',
  'Other',
];

// ── Main Screen ───────────────────────────────────────────────────────────────

export default function ChangeStatusScreen() {
  useLocalSearchParams<{ id: string }>();
  const insets = useSafeAreaInsets();

  const [currentStatus, setCurrentStatus] = useState<WOStatus>('assigned');
  const [selectedNext, setSelectedNext] = useState<WOStatus | null>(null);
  const [remarks, setRemarks] = useState('');
  const [photoCount, setPhotoCount] = useState(0);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [delaySheetVisible, setDelaySheetVisible] = useState(false);
  const [snack, setSnack] = useState<string | null>(null);
  const snackTimer = useRef<ReturnType<typeof setTimeout> | null>(null);

  const currentStepIndex = statusPipeline.findIndex((s) => s.status === currentStatus);
  const validOptions = validNextOptions(currentStatus);

  const showSnack = useCallback((message: string) => {
    if (snackTimer.current) clearTimeout(snackTimer.current);
    setSnack(message);
    snackTimer.current = setTimeout(() => setSnack(null), 2500);
  }, []);

  const handleDelaySubmit = (reason: string) => {
    setDelaySheetVisible(false);
    setCurrentStatus('delayed');
    showSnack(`Delay reported: ${reason}`);
  };

  const submitStatus = async () => {
    if (selectedNext == null) {
      showSnack('Please select a next status');
      return;
    }
    setIsSubmitting(true);
    await new Promise((resolve) => setTimeout(resolve, 800));

    const nextStatus = selectedNext;

    // If completed, navigate back to dashboard (Flutter: context.go(dashboard)).
    if (nextStatus === 'workCompleted') {
      setIsSubmitting(false);
      showSnack('Work Order Completed!');
      await new Promise((resolve) => setTimeout(resolve, 500));
      router.dismissTo('/dashboard');
      return;
    }

    setIsSubmitting(false);
    setCurrentStatus(nextStatus);
    setSelectedNext(null);
    setRemarks('');
    setPhotoCount(0);
    showSnack(`Status updated to: ${WO_STATUS_LABELS[nextStatus]}`);
  };

  return (
    <View style={styles.screen}>
      <ScreenHeader title="Change Status" />
      <View style={styles.headerBorder} />

      <ScrollView contentContainerStyle={styles.scroll}>
        {/* ── Pipeline Stepper ── */}
        <StatusStepper currentIndex={currentStepIndex} />
        <View style={{ height: spacing.md }} />

        {/* ── Current Status Card ── */}
        <View style={styles.currentCard}>
          <View style={styles.currentIconBox}>
            <MaterialIcons name="my-location" size={20} color={colors.textOnPrimary} />
          </View>
          <View style={{ marginLeft: 12 }}>
            <Text style={styles.currentOverline}>CURRENT STATUS</Text>
            <Text style={[typography.bodyMedium, { color: colors.primary, marginTop: 2 }]}>
              {WO_STATUS_LABELS[currentStatus]}
            </Text>
          </View>
        </View>
        <View style={{ height: spacing.md }} />

        {/* ── Next Status Options ── */}
        <Text style={styles.sectionLabel}>SELECT NEXT STATUS</Text>
        {validOptions.map((opt) => (
          <NextStatusCard
            key={opt.status}
            option={opt}
            isSelected={selectedNext === opt.status}
            onPress={() => setSelectedNext(opt.status)}
          />
        ))}
        <View style={{ height: spacing.md }} />

        {/* ── Remarks Field ── */}
        <Text style={styles.sectionLabel}>REMARKS / DESCRIPTION</Text>
        <View style={styles.remarksBox}>
          <TextInput
            style={styles.remarksInput}
            value={remarks}
            onChangeText={setRemarks}
            placeholder="Add notes or description about the status change…"
            placeholderTextColor={colors.textTertiary}
            multiline
            numberOfLines={4}
            textAlignVertical="top"
          />
        </View>
        <View style={{ height: spacing.md }} />

        {/* ── Photo Section ── */}
        <Text style={styles.sectionLabel}>PHOTOS</Text>
        <Pressable
          onPress={() => setPhotoCount((c) => c + 1)}
          style={({ pressed }) => [styles.photoCard, pressed && { opacity: 0.85 }]}
        >
          <View style={styles.photoIconBox}>
            <MaterialIcons name="camera-alt" size={sizes.iconMD} color={colors.textSecondary} />
          </View>
          <View style={styles.photoTextWrap}>
            <Text style={typography.bodyMedium}>Add Photos</Text>
            <Text style={typography.caption}>Tap to attach images from camera or gallery</Text>
          </View>
          {photoCount > 0 && (
            <View style={styles.photoCountChip}>
              <Text style={styles.photoCountText}>{photoCount}</Text>
            </View>
          )}
        </Pressable>
        <View style={{ height: spacing.lg }} />
      </ScrollView>

      {/* ── Bottom Action Bar ── */}
      <View style={[styles.bottomBar, { paddingBottom: spacing.md + insets.bottom }]}>
        <Pressable
          onPress={() => setDelaySheetVisible(true)}
          style={({ pressed }) => [styles.delayButton, pressed && { opacity: 0.85 }]}
        >
          <MaterialIcons name="warning-amber" size={sizes.iconSM} color={colors.warning} />
          <Text style={[typography.button, { color: colors.warning, marginLeft: 8 }]}>
            Report Delay
          </Text>
        </Pressable>
        <View style={{ height: spacing.xs }} />
        <Pressable
          onPress={submitStatus}
          disabled={isSubmitting}
          style={({ pressed }) => [
            styles.submitButton,
            isSubmitting && { backgroundColor: colors.border },
            pressed && !isSubmitting && { opacity: 0.85 },
          ]}
        >
          {isSubmitting ? (
            <ActivityIndicator size="small" color={colors.textOnPrimary} />
          ) : (
            <Text style={[typography.button, { color: colors.textOnPrimary }]}>
              Submit Status Change
            </Text>
          )}
        </Pressable>
      </View>

      {/* ── Snackbar ── */}
      {snack != null && (
        <View style={[styles.snack, { bottom: 140 + insets.bottom }]} pointerEvents="none">
          <Text style={[typography.bodySmall, { color: colors.textOnPrimary }]}>{snack}</Text>
        </View>
      )}

      {/* ── Delay Bottom Sheet ── */}
      <DelayBottomSheet
        visible={delaySheetVisible}
        onClose={() => setDelaySheetVisible(false)}
        onSubmit={handleDelaySubmit}
      />
    </View>
  );
}

// ── Next Status Card ──────────────────────────────────────────────────────────

function NextStatusCard({
  option,
  isSelected,
  onPress,
}: {
  option: NextStatusOption;
  isSelected: boolean;
  onPress: () => void;
}) {
  return (
    <Pressable
      onPress={onPress}
      style={[
        styles.optionCard,
        isSelected && {
          backgroundColor: 'rgba(27, 67, 50, 0.04)',
          borderColor: colors.primary,
          borderWidth: sizes.borderWidthFocused,
        },
      ]}
    >
      <View style={[styles.optionIconBox, { backgroundColor: `${option.iconColor}1A` }]}>
        <MaterialIcons
          name={option.icon as keyof typeof MaterialIcons.glyphMap}
          size={sizes.iconMD}
          color={option.iconColor}
        />
      </View>
      <View style={styles.optionTextWrap}>
        <Text style={typography.bodyMedium}>{option.title}</Text>
        <Text style={[typography.caption, { marginTop: 2 }]}>{option.description}</Text>
      </View>
      <View style={[styles.optionRadio, isSelected && styles.optionRadioSelected]}>
        {isSelected && <MaterialIcons name="check" size={12} color="#FFFFFF" />}
      </View>
    </Pressable>
  );
}

// ── Delay Bottom Sheet ────────────────────────────────────────────────────────

function DelayBottomSheet({
  visible,
  onClose,
  onSubmit,
}: {
  visible: boolean;
  onClose: () => void;
  onSubmit: (reason: string) => void;
}) {
  const insets = useSafeAreaInsets();
  const [selectedReason, setSelectedReason] = useState<string | null>(null);
  const [otherText, setOtherText] = useState('');

  const handleSubmit = () => {
    if (selectedReason == null) return;
    const reason =
      selectedReason === 'Other' ? (otherText.length > 0 ? otherText : 'Other') : selectedReason;
    setSelectedReason(null);
    setOtherText('');
    onSubmit(reason);
  };

  return (
    <Modal visible={visible} transparent animationType="slide" onRequestClose={onClose}>
      <View style={styles.sheetOverlay}>
        <Pressable style={{ flex: 1 }} onPress={onClose} />
        <View style={[styles.sheet, { paddingBottom: spacing.md + insets.bottom }]}>
          {/* Handle */}
          <View style={styles.sheetHandle} />
          <View style={{ height: spacing.md }} />
          <View style={styles.sheetTitleRow}>
            <MaterialIcons name="warning-amber" size={sizes.iconMD} color={colors.warning} />
            <Text style={[typography.h3, { marginLeft: 8 }]}>Report Delay</Text>
          </View>
          <Text style={[typography.bodySmall, { marginTop: 4 }]}>
            Select the reason for the delay
          </Text>
          <View style={{ height: spacing.md }} />

          {DELAY_REASONS.map((reason) => {
            const isSelected = selectedReason === reason;
            return (
              <Pressable
                key={reason}
                onPress={() => setSelectedReason(reason)}
                style={[styles.reasonRow, isSelected && styles.reasonRowSelected]}
              >
                <Text
                  style={[
                    typography.bodySmall,
                    { flex: 1, color: colors.textPrimary },
                    isSelected && { fontFamily: fonts.semiBold, color: '#92400E' },
                  ]}
                >
                  {reason}
                </Text>
                {isSelected && <MaterialIcons name="check" size={16} color={colors.warning} />}
              </Pressable>
            );
          })}

          {selectedReason === 'Other' && (
            <TextInput
              style={styles.otherInput}
              value={otherText}
              onChangeText={setOtherText}
              placeholder="Describe the delay reason…"
              placeholderTextColor={colors.textTertiary}
              multiline
              numberOfLines={2}
              textAlignVertical="top"
            />
          )}

          <View style={{ height: 4 }} />
          <Pressable
            onPress={handleSubmit}
            disabled={selectedReason == null}
            style={({ pressed }) => [
              styles.sheetSubmit,
              selectedReason == null && { backgroundColor: colors.border },
              pressed && selectedReason != null && { opacity: 0.85 },
            ]}
          >
            <Text style={[typography.button, { color: '#FFFFFF' }]}>Submit Delay Report</Text>
          </Pressable>
        </View>
      </View>
    </Modal>
  );
}

const styles = StyleSheet.create({
  screen: {
    flex: 1,
    backgroundColor: colors.scaffoldBg,
  },
  headerBorder: {
    height: 1,
    backgroundColor: colors.border,
  },
  scroll: {
    paddingBottom: spacing.lg + 80,
  },
  currentCard: {
    flexDirection: 'row',
    alignItems: 'center',
    marginHorizontal: spacing.md,
    padding: spacing.md,
    backgroundColor: 'rgba(27, 67, 50, 0.04)',
    borderRadius: radii.card,
    borderWidth: sizes.borderWidth,
    borderColor: 'rgba(27, 67, 50, 0.2)',
  },
  currentIconBox: {
    width: 40,
    height: 40,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: colors.primary,
    borderRadius: radii.small,
  },
  currentOverline: {
    ...typography.overline,
    fontSize: 9,
    lineHeight: 13,
  },
  sectionLabel: {
    ...typography.overline,
    paddingHorizontal: spacing.md,
    paddingBottom: 4,
  },
  optionCard: {
    flexDirection: 'row',
    alignItems: 'center',
    marginHorizontal: spacing.md,
    marginBottom: spacing.xs,
    padding: spacing.md,
    backgroundColor: colors.surface,
    borderRadius: radii.card,
    borderWidth: sizes.borderWidth,
    borderColor: colors.border,
  },
  optionIconBox: {
    width: 44,
    height: 44,
    alignItems: 'center',
    justifyContent: 'center',
    borderRadius: radii.small,
  },
  optionTextWrap: {
    flex: 1,
    marginLeft: 12,
    marginRight: 8,
  },
  optionRadio: {
    width: 22,
    height: 22,
    borderRadius: 11,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: colors.surface,
    borderWidth: 2,
    borderColor: colors.border,
  },
  optionRadioSelected: {
    backgroundColor: colors.primary,
    borderColor: colors.primary,
  },
  remarksBox: {
    marginHorizontal: spacing.md,
    backgroundColor: colors.surface,
    borderRadius: radii.card,
    borderWidth: sizes.borderWidth,
    borderColor: colors.border,
  },
  remarksInput: {
    ...typography.body,
    minHeight: 110,
    padding: spacing.md,
  },
  photoCard: {
    flexDirection: 'row',
    alignItems: 'center',
    marginHorizontal: spacing.md,
    padding: spacing.md,
    backgroundColor: colors.surface,
    borderRadius: radii.card,
    borderWidth: sizes.borderWidth,
    borderColor: colors.border,
  },
  photoIconBox: {
    width: 48,
    height: 48,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: colors.surfaceAlt,
    borderRadius: radii.small,
    borderWidth: sizes.borderWidth,
    borderColor: colors.border,
  },
  photoTextWrap: {
    flex: 1,
    marginLeft: 12,
  },
  photoCountChip: {
    paddingHorizontal: 10,
    paddingVertical: 4,
    backgroundColor: colors.successLight,
    borderRadius: radii.chip,
  },
  photoCountText: {
    ...typography.caption,
    fontFamily: fonts.bold,
    color: colors.success,
  },
  bottomBar: {
    backgroundColor: colors.surface,
    borderTopWidth: sizes.borderWidth,
    borderTopColor: colors.border,
    padding: spacing.md,
  },
  delayButton: {
    height: sizes.buttonHeight,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: colors.warningLight,
    borderRadius: radii.button,
    borderWidth: 1.5,
    borderColor: colors.warning,
  },
  submitButton: {
    height: sizes.buttonHeight,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: colors.primary,
    borderRadius: radii.button,
  },
  snack: {
    position: 'absolute',
    left: spacing.md,
    right: spacing.md,
    paddingHorizontal: spacing.md,
    paddingVertical: 12,
    backgroundColor: colors.primary,
    borderRadius: radii.button,
  },
  // ── Delay bottom sheet ──
  sheetOverlay: {
    flex: 1,
    backgroundColor: colors.overlay,
  },
  sheet: {
    backgroundColor: colors.surface,
    borderTopLeftRadius: radii.card,
    borderTopRightRadius: radii.card,
    paddingHorizontal: spacing.md,
    paddingTop: spacing.md,
  },
  sheetHandle: {
    width: 40,
    height: 4,
    alignSelf: 'center',
    backgroundColor: colors.border,
    borderRadius: 2,
  },
  sheetTitleRow: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  reasonRow: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 14,
    paddingVertical: 12,
    marginBottom: 8,
    backgroundColor: colors.surfaceAlt,
    borderRadius: radii.button,
    borderWidth: sizes.borderWidth,
    borderColor: colors.border,
  },
  reasonRowSelected: {
    backgroundColor: colors.warningLight,
    borderColor: colors.warning,
    borderWidth: 1.5,
  },
  otherInput: {
    ...typography.body,
    minHeight: 64,
    padding: 12,
    marginBottom: spacing.xs,
    backgroundColor: colors.surfaceAlt,
    borderRadius: radii.input,
    borderWidth: sizes.borderWidth,
    borderColor: colors.border,
  },
  sheetSubmit: {
    height: sizes.buttonHeight,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: colors.warning,
    borderRadius: radii.button,
  },
});
