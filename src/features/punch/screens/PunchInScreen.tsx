import { useEffect, useRef, useState } from 'react';
import {
  ActivityIndicator,
  Animated,
  Easing,
  Modal,
  Pressable,
  ScrollView,
  StyleSheet,
  Text,
  View,
} from 'react-native';
import { MaterialIcons } from '@expo/vector-icons';
import { router } from 'expo-router';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { punchLocations } from '@/data/mockLocations';
import { colors, fonts, radii, sizes, spacing, typography } from '@/theme';

const MONTHS = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
const WEEKDAYS = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

/** Flutter `DateFormat('dd MMM yyyy')` */
function formatDate(d: Date): string {
  return `${String(d.getDate()).padStart(2, '0')} ${MONTHS[d.getMonth()]} ${d.getFullYear()}`;
}

/** Flutter `DateFormat('h:mm:ss a')` */
function formatTime(d: Date): string {
  const h24 = d.getHours();
  const h = h24 % 12 === 0 ? 12 : h24 % 12;
  const mm = String(d.getMinutes()).padStart(2, '0');
  const ss = String(d.getSeconds()).padStart(2, '0');
  return `${h}:${mm}:${ss} ${h24 < 12 ? 'AM' : 'PM'}`;
}

export default function PunchInScreen() {
  const insets = useSafeAreaInsets();

  const [now, setNow] = useState(new Date());
  const [hasSelfie, setHasSelfie] = useState(false);
  const [isPunchingIn, setIsPunchingIn] = useState(false);
  const [selectedLocation, setSelectedLocation] = useState<string | null>(null);
  const [pickerVisible, setPickerVisible] = useState(false);
  const [snack, setSnack] = useState<string | null>(null);

  const [fadeAnim] = useState(() => new Animated.Value(0));
  const snackTimer = useRef<ReturnType<typeof setTimeout> | null>(null);

  // Live clock — tick every second.
  useEffect(() => {
    const timer = setInterval(() => setNow(new Date()), 1000);
    return () => clearInterval(timer);
  }, []);

  // Entrance fade (Flutter: 500ms easeOut, delayed 100ms).
  useEffect(() => {
    const animation = Animated.timing(fadeAnim, {
      toValue: 1,
      duration: 500,
      delay: 100,
      easing: Easing.out(Easing.ease),
      useNativeDriver: true,
    });
    animation.start();
    return () => animation.stop();
  }, [fadeAnim]);

  useEffect(() => {
    return () => {
      if (snackTimer.current) clearTimeout(snackTimer.current);
    };
  }, []);

  const showSnack = (msg: string) => {
    if (snackTimer.current) clearTimeout(snackTimer.current);
    setSnack(msg);
    snackTimer.current = setTimeout(() => setSnack(null), 3000);
  };

  // Selfie capture stub — short delay then mark captured (matches Flutter).
  const handleTakeSelfie = () => {
    setTimeout(() => setHasSelfie(true), 400);
  };

  const handlePunchIn = () => {
    if (!hasSelfie) {
      showSnack('Please take a selfie before punching in');
      return;
    }
    if (selectedLocation == null) {
      showSnack('Please select a location');
      return;
    }
    setIsPunchingIn(true);
    setTimeout(() => {
      setIsPunchingIn(false);
      router.replace('/dashboard');
    }, 1000);
  };

  return (
    <View style={[styles.root, { paddingTop: insets.top }]}>
      <Animated.View style={[styles.fill, { opacity: fadeAnim }]}>
        <ScrollView style={styles.fill} contentContainerStyle={styles.scrollContent}>
          {/* ── Welcome Header ── */}
          <View style={styles.welcomeRow}>
            <View style={styles.avatar}>
              <MaterialIcons name="person-outline" size={26} color={colors.textOnPrimary} />
            </View>
            <View>
              <Text style={styles.welcomeBack}>Welcome back,</Text>
              <Text style={[typography.h2, styles.tinyGapTop]}>Demo Technician</Text>
              <Text style={[typography.bodySmall, styles.tinyGapTop, { color: colors.textTertiary }]}>
                Let&apos;s get your day started.
              </Text>
            </View>
          </View>

          {/* ── Date & Time Card ── */}
          <View style={[styles.card, { marginTop: 20 }]}>
            <View style={styles.row}>
              <View style={styles.calendarIconBox}>
                <MaterialIcons name="calendar-today" size={20} color={colors.primary} />
              </View>
              <Text style={[typography.overline, { marginLeft: 12 }]}>DATE &amp; TIME</Text>
            </View>
            <Text style={styles.dateTimeText}>
              {formatDate(now)}  •  {formatTime(now)}
            </Text>
            <Text style={[typography.bodySmall, styles.tinyGapTop]}>{WEEKDAYS[now.getDay()]}</Text>
            <View style={[styles.row, { marginTop: 8 }]}>
              <MaterialIcons name="lock-outline" size={14} color={colors.textTertiary} />
              <Text style={styles.mutedNote}>Auto captured • Not editable</Text>
            </View>
          </View>

          {/* ── Attendance Selfie Card ── */}
          <View style={[styles.card, { marginTop: 16 }]}>
            <Text style={styles.cardOverline}>ATTENDANCE SELFIE</Text>
            <Text style={[typography.bodySmall, styles.tinyGapTop]}>Required for verification</Text>

            <View style={styles.selfieWrap}>
              {hasSelfie ? (
                <View style={styles.selfieDone}>
                  <MaterialIcons name="check-circle" size={36} color={colors.success} />
                  <Text style={styles.selfieDoneText}>Selfie captured</Text>
                </View>
              ) : (
                <Pressable onPress={handleTakeSelfie} style={styles.selfieEmpty}>
                  <MaterialIcons name="camera-alt" size={32} color="rgba(27, 67, 50, 0.6)" />
                  <Text style={styles.selfieEmptyText}>Tap to take selfie</Text>
                </Pressable>
              )}
            </View>

            <View style={[styles.row, styles.centeredRow]}>
              <MaterialIcons name="verified-user" size={14} color={colors.textTertiary} />
              <Text style={styles.mutedNote}>Photo is used for attendance verification only</Text>
            </View>
          </View>

          {/* ── Location / Contract Card ── */}
          <View style={[styles.card, { marginTop: 16 }]}>
            <Text style={styles.cardOverline}>LOCATION / CONTRACT</Text>
            <Text style={[typography.bodySmall, styles.tinyGapTop]}>
              Select the client, contract, or location you&apos;ll be working at today.
            </Text>

            <Pressable style={styles.dropdownField} onPress={() => setPickerVisible(true)}>
              {selectedLocation == null ? (
                <View style={styles.row}>
                  <MaterialIcons name="location-on" size={18} color={colors.textTertiary} />
                  <Text style={[typography.body, { color: colors.textTertiary, marginLeft: 10 }]}>
                    Select Location
                  </Text>
                </View>
              ) : (
                <View style={styles.row}>
                  <MaterialIcons name="location-on" size={16} color={colors.accent} />
                  <Text style={[typography.body, { marginLeft: 8 }]}>{selectedLocation}</Text>
                </View>
              )}
              <MaterialIcons name="keyboard-arrow-down" size={24} color={colors.textSecondary} />
            </Pressable>

            <View style={[styles.row, { marginTop: 12 }]}>
              <MaterialIcons name="info-outline" size={14} color={colors.textTertiary} />
              <Text style={styles.mutedNote}>This helps us track where you&apos;re working.</Text>
            </View>
          </View>
        </ScrollView>

        {/* ── Bottom: Punch In Button ── */}
        <View style={[styles.bottomBar, { paddingBottom: insets.bottom + 8 }]}>
          <Pressable
            onPress={handlePunchIn}
            disabled={isPunchingIn}
            style={({ pressed }) => [styles.punchButton, pressed && !isPunchingIn && styles.pressed]}
          >
            {isPunchingIn ? (
              <ActivityIndicator size="small" color={colors.textOnPrimary} />
            ) : (
              <View style={styles.row}>
                <MaterialIcons name="fingerprint" size={22} color={colors.textOnPrimary} />
                <Text style={styles.punchButtonText}>PUNCH IN</Text>
              </View>
            )}
          </Pressable>
          <View style={[styles.row, styles.centeredRow, { marginTop: 10 }]}>
            <MaterialIcons name="lock-outline" size={12} color={colors.textTertiary} />
            <Text style={styles.mutedNote}>Your attendance data is secure and confidential.</Text>
          </View>
        </View>
      </Animated.View>

      {/* ── Snackbar (Flutter ScaffoldMessenger equivalent) ── */}
      {snack != null && (
        <View style={[styles.snack, { bottom: insets.bottom + 110 }]} pointerEvents="none">
          <Text style={[typography.bodySmall, { color: '#FFFFFF' }]}>{snack}</Text>
        </View>
      )}

      {/* ── Location Picker (bottom-sheet port of DropdownButton) ── */}
      <Modal
        visible={pickerVisible}
        transparent
        animationType="slide"
        onRequestClose={() => setPickerVisible(false)}
      >
        <Pressable style={styles.modalBackdrop} onPress={() => setPickerVisible(false)} />
        <View style={[styles.sheet, { paddingBottom: insets.bottom + spacing.md }]}>
          <Text style={[typography.overline, styles.sheetTitle]}>SELECT LOCATION</Text>
          {punchLocations.map((loc) => {
            const selected = loc === selectedLocation;
            return (
              <Pressable
                key={loc}
                style={({ pressed }) => [styles.sheetOption, pressed && styles.sheetOptionPressed]}
                onPress={() => {
                  setSelectedLocation(loc);
                  setPickerVisible(false);
                }}
              >
                <MaterialIcons name="location-on" size={16} color={colors.accent} />
                <Text style={[typography.body, styles.sheetOptionText]}>{loc}</Text>
                {selected && <MaterialIcons name="check" size={18} color={colors.primary} />}
              </Pressable>
            );
          })}
        </View>
      </Modal>
    </View>
  );
}

const styles = StyleSheet.create({
  root: {
    flex: 1,
    backgroundColor: colors.surface,
  },
  fill: {
    flex: 1,
  },
  scrollContent: {
    paddingHorizontal: spacing.md,
    paddingTop: 24,
    paddingBottom: 24,
  },
  row: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  centeredRow: {
    justifyContent: 'center',
    marginTop: 16,
  },
  tinyGapTop: {
    marginTop: 2,
  },

  // ── Welcome header ──
  welcomeRow: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  avatar: {
    width: 52,
    height: 52,
    borderRadius: 26,
    backgroundColor: colors.primary,
    alignItems: 'center',
    justifyContent: 'center',
    marginRight: 14,
  },
  welcomeBack: {
    ...typography.bodySmall,
    fontFamily: fonts.medium,
    color: colors.primary,
  },

  // ── Cards ──
  card: {
    backgroundColor: colors.surfaceAlt,
    borderRadius: radii.card,
    borderWidth: sizes.borderWidth,
    borderColor: colors.border,
    padding: spacing.md,
  },
  cardOverline: {
    ...typography.overline,
    fontFamily: fonts.bold,
    color: colors.primary,
  },
  calendarIconBox: {
    width: 40,
    height: 40,
    borderRadius: 10,
    backgroundColor: 'rgba(27, 67, 50, 0.1)',
    alignItems: 'center',
    justifyContent: 'center',
  },
  dateTimeText: {
    ...typography.h2,
    fontFamily: fonts.bold,
    fontSize: 19,
    letterSpacing: -0.3,
    marginTop: 12,
  },
  mutedNote: {
    ...typography.caption,
    color: colors.textTertiary,
    marginLeft: 6,
  },

  // ── Selfie ──
  selfieWrap: {
    alignItems: 'center',
    marginTop: 20,
  },
  selfieDone: {
    width: 140,
    height: 140,
    borderRadius: 70,
    backgroundColor: colors.successLight,
    borderWidth: 2,
    borderColor: colors.success,
    alignItems: 'center',
    justifyContent: 'center',
  },
  selfieDoneText: {
    ...typography.caption,
    fontFamily: fonts.semiBold,
    color: colors.success,
    marginTop: 6,
  },
  selfieEmpty: {
    width: 140,
    height: 140,
    borderRadius: 70,
    backgroundColor: 'rgba(232, 238, 235, 0.3)',
    borderWidth: 1.5,
    borderStyle: 'dashed',
    borderColor: colors.border,
    alignItems: 'center',
    justifyContent: 'center',
  },
  selfieEmptyText: {
    ...typography.bodySmall,
    fontFamily: fonts.medium,
    color: 'rgba(27, 67, 50, 0.7)',
    marginTop: 8,
  },

  // ── Location dropdown ──
  dropdownField: {
    height: sizes.inputHeight,
    marginTop: 16,
    paddingHorizontal: spacing.sm,
    borderWidth: sizes.borderWidth,
    borderColor: colors.border,
    borderRadius: radii.input,
    backgroundColor: colors.surface,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },

  // ── Bottom bar ──
  bottomBar: {
    paddingHorizontal: spacing.md,
    paddingTop: 12,
    backgroundColor: colors.surface,
    borderTopWidth: 1,
    borderTopColor: colors.divider,
  },
  punchButton: {
    height: 52,
    borderRadius: radii.button,
    backgroundColor: colors.primary,
    alignItems: 'center',
    justifyContent: 'center',
  },
  punchButtonText: {
    ...typography.button,
    color: colors.textOnPrimary,
    letterSpacing: 1,
    marginLeft: 10,
  },
  pressed: {
    opacity: 0.85,
  },

  // ── Snackbar ──
  snack: {
    position: 'absolute',
    left: spacing.md,
    right: spacing.md,
    backgroundColor: '#323232',
    borderRadius: radii.small,
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.sm,
  },

  // ── Bottom sheet ──
  modalBackdrop: {
    flex: 1,
    backgroundColor: colors.overlay,
  },
  sheet: {
    backgroundColor: colors.surface,
    borderTopLeftRadius: radii.card,
    borderTopRightRadius: radii.card,
    paddingTop: spacing.md,
    paddingHorizontal: spacing.xs,
  },
  sheetTitle: {
    paddingHorizontal: spacing.xs,
    marginBottom: spacing.xs,
  },
  sheetOption: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: 14,
    paddingHorizontal: spacing.xs,
    borderRadius: radii.small,
  },
  sheetOptionPressed: {
    backgroundColor: colors.surfaceAlt,
  },
  sheetOptionText: {
    marginLeft: 8,
    flex: 1,
  },
});
