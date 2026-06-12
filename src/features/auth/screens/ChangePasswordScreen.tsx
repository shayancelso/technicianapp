import { useEffect, useState } from 'react';
import {
  Animated,
  Easing,
  KeyboardAvoidingView,
  Platform,
  Pressable,
  ScrollView,
  StyleSheet,
  Text,
  TextInput,
  View,
} from 'react-native';
import { MaterialIcons } from '@expo/vector-icons';
import { router } from 'expo-router';
import { AppButton, ScreenHeader, SectionLabel } from '@/components';
import { colors, fonts, radii, sizes, spacing, typography } from '@/theme';

// ── Password field tile (label above input, parity with _PasswordFieldTile) ──

interface PasswordFieldTileProps {
  label: string;
  value: string;
  onChangeText: (text: string) => void;
  error?: string;
  returnKeyType?: 'next' | 'done';
  onSubmitEditing?: () => void;
}

function PasswordFieldTile({
  label,
  value,
  onChangeText,
  error,
  returnKeyType = 'next',
  onSubmitEditing,
}: PasswordFieldTileProps) {
  const [obscured, setObscured] = useState(true);
  const [focused, setFocused] = useState(false);
  const borderColor = error ? colors.error : focused ? colors.borderFocused : colors.border;

  return (
    <View>
      <Text style={styles.fieldLabel}>{label}</Text>
      <View
        style={[
          styles.field,
          { borderColor, borderWidth: focused ? sizes.borderWidthFocused : sizes.borderWidth },
        ]}
      >
        <MaterialIcons
          name="lock-outline"
          size={sizes.iconMD}
          color={colors.textTertiary}
          style={styles.prefixIcon}
        />
        <TextInput
          value={value}
          onChangeText={onChangeText}
          placeholder="••••••••"
          placeholderTextColor={colors.textTertiary}
          secureTextEntry={obscured}
          autoCapitalize="none"
          returnKeyType={returnKeyType}
          onSubmitEditing={onSubmitEditing}
          onFocus={() => setFocused(true)}
          onBlur={() => setFocused(false)}
          style={styles.input}
        />
        <Pressable onPress={() => setObscured((o) => !o)} hitSlop={8} style={styles.suffix}>
          <MaterialIcons
            name={obscured ? 'visibility-off' : 'visibility'}
            size={sizes.iconMD}
            color={colors.textTertiary}
          />
        </Pressable>
      </View>
      {error != null && <Text style={styles.fieldError}>{error}</Text>}
    </View>
  );
}

// ── Policy row ───────────────────────────────────────────────────────────────

function PolicyRow({ text, met }: { text: string; met: boolean }) {
  return (
    <View style={styles.policyRow}>
      <MaterialIcons
        name={met ? 'check-circle' : 'radio-button-unchecked'}
        size={14}
        color={met ? colors.success : colors.textTertiary}
      />
      <Text style={[styles.policyText, { color: met ? colors.success : colors.textSecondary }]}>
        {text}
      </Text>
    </View>
  );
}

// ── Change Password Screen ───────────────────────────────────────────────────

const meetsPolicy = (pwd: string) => pwd.length >= 8 && /[A-Z]/.test(pwd) && /[0-9]/.test(pwd);

export default function ChangePasswordScreen() {
  const [currentPassword, setCurrentPassword] = useState('');
  const [newPassword, setNewPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [updated, setUpdated] = useState(false);
  const [errors, setErrors] = useState<{
    current?: string;
    next?: string;
    confirm?: string;
  }>({});

  // Entrance fade + slide (350ms easeOut)
  const [anim] = useState(() => new Animated.Value(0));
  useEffect(() => {
    Animated.timing(anim, {
      toValue: 1,
      duration: 350,
      easing: Easing.out(Easing.ease),
      useNativeDriver: true,
    }).start();
  }, [anim]);
  const translateY = anim.interpolate({ inputRange: [0, 1], outputRange: [16, 0] });

  const validate = () => {
    const next: { current?: string; next?: string; confirm?: string } = {};
    if (currentPassword.length === 0) next.current = 'Enter your current password';
    if (newPassword.length === 0) {
      next.next = 'Enter a new password';
    } else if (!meetsPolicy(newPassword)) {
      next.next = 'Password does not meet requirements';
    }
    if (confirmPassword.length === 0) {
      next.confirm = 'Please confirm your new password';
    } else if (confirmPassword !== newPassword) {
      next.confirm = 'Passwords do not match';
    }
    setErrors(next);
    return Object.keys(next).length === 0;
  };

  const handleSubmit = () => {
    if (isLoading) return;
    if (!validate()) return;

    setIsLoading(true);
    // Simulated network call
    setTimeout(() => {
      setIsLoading(false);
      // Flutter shows a success snackbar then pops; no snackbar primitive here,
      // so show an inline confirmation briefly before navigating back.
      setUpdated(true);
      setTimeout(() => router.back(), 900);
    }, 900);
  };

  return (
    <View style={styles.screen}>
      <ScreenHeader title="Change Password" />
      <View style={styles.hairline} />

      <KeyboardAvoidingView
        style={styles.flex}
        behavior={Platform.OS === 'ios' ? 'padding' : undefined}
      >
        <Animated.View style={[styles.flex, { opacity: anim, transform: [{ translateY }] }]}>
          <ScrollView
            contentContainerStyle={styles.scrollContent}
            keyboardShouldPersistTaps="handled"
          >
            <View style={{ height: 8 }} />
            <SectionLabel>Security</SectionLabel>
            <View style={{ height: 4 }} />

            <PasswordFieldTile
              label="Current Password"
              value={currentPassword}
              onChangeText={setCurrentPassword}
              error={errors.current}
            />
            <View style={{ height: 12 }} />

            <PasswordFieldTile
              label="New Password"
              value={newPassword}
              onChangeText={setNewPassword}
              error={errors.next}
            />
            <View style={{ height: 12 }} />

            <PasswordFieldTile
              label="Confirm New Password"
              value={confirmPassword}
              onChangeText={setConfirmPassword}
              error={errors.confirm}
              returnKeyType="done"
              onSubmitEditing={handleSubmit}
            />
            <View style={{ height: 24 }} />

            {/* Policy card */}
            <View style={styles.policyCard}>
              <View style={styles.policyHeader}>
                <MaterialIcons name="shield" size={sizes.iconMD} color={colors.primary} />
                <Text style={styles.policyTitle}>Password Requirements</Text>
              </View>
              <View style={{ height: 12 }} />
              <PolicyRow text="At least 8 characters" met={newPassword.length >= 8} />
              <View style={{ height: 6 }} />
              <PolicyRow text="Contains an uppercase letter" met={/[A-Z]/.test(newPassword)} />
              <View style={{ height: 6 }} />
              <PolicyRow text="Contains a number" met={/[0-9]/.test(newPassword)} />
            </View>

            {updated && (
              <View style={styles.successRow}>
                <MaterialIcons
                  name="check-circle-outline"
                  size={18}
                  color={colors.success}
                />
                <Text style={styles.successText}>Password updated successfully</Text>
              </View>
            )}
          </ScrollView>

          {/* Pinned submit button */}
          <View style={styles.bottomBar}>
            <AppButton label="Update Password" onPress={handleSubmit} loading={isLoading} />
          </View>
        </Animated.View>
      </KeyboardAvoidingView>
    </View>
  );
}

const styles = StyleSheet.create({
  screen: {
    flex: 1,
    backgroundColor: colors.surface,
  },
  flex: {
    flex: 1,
  },
  hairline: {
    height: 1,
    backgroundColor: colors.border,
  },
  scrollContent: {
    padding: spacing.lg,
  },
  fieldLabel: {
    ...typography.bodySmall,
    fontFamily: fonts.medium,
    color: colors.textSecondary,
    marginBottom: 6,
  },
  field: {
    height: sizes.inputHeight,
    borderRadius: radii.input,
    backgroundColor: colors.surface,
    flexDirection: 'row',
    alignItems: 'center',
  },
  prefixIcon: {
    marginLeft: 14,
    marginRight: 10,
  },
  input: {
    flex: 1,
    fontFamily: fonts.regular,
    fontSize: 15,
    color: colors.textPrimary,
    paddingVertical: 0,
    height: '100%',
    textAlignVertical: 'center',
  },
  suffix: {
    paddingRight: 14,
  },
  fieldError: {
    ...typography.caption,
    color: colors.error,
    marginTop: 4,
  },
  policyCard: {
    padding: spacing.md,
    backgroundColor: colors.surfaceAlt,
    borderRadius: radii.card,
    borderWidth: sizes.borderWidth,
    borderColor: colors.border,
  },
  policyHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
  },
  policyTitle: {
    ...typography.bodySmall,
    fontFamily: fonts.semiBold,
    color: colors.textPrimary,
  },
  policyRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
  },
  policyText: {
    ...typography.caption,
  },
  successRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 10,
    marginTop: spacing.md,
  },
  successText: {
    ...typography.bodySmall,
    color: colors.success,
  },
  bottomBar: {
    paddingHorizontal: spacing.lg,
    paddingVertical: spacing.md,
    backgroundColor: colors.surface,
    borderTopWidth: sizes.borderWidth,
    borderTopColor: colors.border,
  },
});
