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
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { AppButton } from '@/components';
import { colors, fonts, radii, sizes, spacing, typography } from '@/theme';

const EMAIL_RX = /^[\w\-.]+@([\w\-]+\.)+[\w\-]{2,4}$/;

export default function ForgotPasswordScreen() {
  const insets = useSafeAreaInsets();

  const [email, setEmail] = useState('');
  const [error, setError] = useState<string | undefined>(undefined);
  const [isLoading, setIsLoading] = useState(false);
  const [sent, setSent] = useState(false);
  const [focused, setFocused] = useState(false);

  // Entrance fade + slide (400ms easeOut)
  const [anim] = useState(() => new Animated.Value(0));
  useEffect(() => {
    Animated.timing(anim, {
      toValue: 1,
      duration: 400,
      easing: Easing.out(Easing.ease),
      useNativeDriver: true,
    }).start();
  }, [anim]);
  const translateY = anim.interpolate({ inputRange: [0, 1], outputRange: [20, 0] });

  const validate = () => {
    if (email.trim().length === 0) {
      setError('Enter your email address');
      return false;
    }
    if (!EMAIL_RX.test(email.trim())) {
      setError('Enter a valid email address');
      return false;
    }
    setError(undefined);
    return true;
  };

  const handleSend = () => {
    if (isLoading) return;
    if (!validate()) return;

    setIsLoading(true);
    // Simulated network call
    setTimeout(() => {
      setIsLoading(false);
      setSent(true);
    }, 800);
  };

  const borderColor = error ? colors.error : focused ? colors.borderFocused : colors.border;

  return (
    <View style={[styles.screen, { paddingTop: insets.top, paddingBottom: insets.bottom }]}>
      {/* App bar (parity with Flutter AppBar + 1px bottom border) */}
      <View style={styles.appBar}>
        <Pressable style={styles.backButton} onPress={() => router.back()} hitSlop={8}>
          <MaterialIcons name="arrow-back-ios-new" size={18} color={colors.textPrimary} />
        </Pressable>
        <Text style={typography.h2}>Forgot Password</Text>
      </View>
      <View style={styles.hairline} />

      <KeyboardAvoidingView
        style={styles.flex}
        behavior={Platform.OS === 'ios' ? 'padding' : undefined}
      >
        <ScrollView
          contentContainerStyle={styles.scrollContent}
          keyboardShouldPersistTaps="handled"
        >
          <Animated.View style={[styles.content, { opacity: anim, transform: [{ translateY }] }]}>
            <View style={{ height: 8 }} />
            <View style={styles.iconBadge}>
              <MaterialIcons name="mail-outline" size={sizes.iconLG} color={colors.primary} />
            </View>
            <View style={{ height: 20 }} />
            <Text style={typography.h1}>Reset your password</Text>
            <View style={{ height: 8 }} />
            <Text style={styles.subtitle}>
              Enter the email address linked to your account. We&apos;ll send you a verification code.
            </Text>
            <View style={{ height: 32 }} />

            {/* Email field */}
            <View
              style={[
                styles.field,
                { borderColor, borderWidth: focused ? sizes.borderWidthFocused : sizes.borderWidth },
              ]}
            >
              <MaterialIcons
                name="alternate-email"
                size={sizes.iconMD}
                color={colors.textTertiary}
                style={styles.prefixIcon}
              />
              <TextInput
                value={email}
                onChangeText={setEmail}
                placeholder="your@email.com"
                placeholderTextColor={colors.textTertiary}
                keyboardType="email-address"
                autoCapitalize="none"
                returnKeyType="done"
                onSubmitEditing={handleSend}
                onFocus={() => setFocused(true)}
                onBlur={() => setFocused(false)}
                style={styles.input}
              />
              {sent && (
                <MaterialIcons
                  name="check-circle"
                  size={sizes.iconMD}
                  color={colors.success}
                  style={styles.suffixIcon}
                />
              )}
            </View>
            {error != null && <Text style={styles.fieldError}>{error}</Text>}
            <View style={{ height: 24 }} />

            <AppButton
              label={sent ? 'Resend Code' : 'Send Verification Code'}
              onPress={handleSend}
              loading={isLoading}
            />

            {sent && (
              <>
                <View style={{ height: 20 }} />
                <View style={styles.successCard}>
                  <MaterialIcons
                    name="check-circle-outline"
                    size={sizes.iconMD}
                    color={colors.success}
                  />
                  <Text style={styles.successText}>
                    Code sent! Check your inbox and use it to reset your password within 10
                    minutes.
                  </Text>
                </View>
              </>
            )}
          </Animated.View>
        </ScrollView>
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
  appBar: {
    height: sizes.appBarHeight,
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: colors.surface,
  },
  backButton: {
    width: 48,
    height: '100%',
    alignItems: 'center',
    justifyContent: 'center',
  },
  hairline: {
    height: 1,
    backgroundColor: colors.border,
  },
  scrollContent: {
    padding: spacing.xl,
  },
  content: {
    width: '100%',
    maxWidth: 440,
  },
  iconBadge: {
    width: 48,
    height: 48,
    borderRadius: radii.card,
    backgroundColor: colors.surfaceAlt,
    borderWidth: sizes.borderWidth,
    borderColor: colors.border,
    alignItems: 'center',
    justifyContent: 'center',
  },
  subtitle: {
    ...typography.bodySmall,
    color: colors.textSecondary,
    lineHeight: 13 * 1.6,
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
  suffixIcon: {
    marginRight: 14,
  },
  fieldError: {
    ...typography.caption,
    color: colors.error,
    marginTop: 4,
  },
  successCard: {
    flexDirection: 'row',
    alignItems: 'flex-start',
    gap: 10,
    padding: spacing.md,
    backgroundColor: colors.successLight,
    borderRadius: radii.card,
    borderWidth: sizes.borderWidth,
    borderColor: 'rgba(5, 150, 105, 0.3)',
  },
  successText: {
    ...typography.bodySmall,
    flex: 1,
    color: colors.success,
    lineHeight: 13 * 1.5,
  },
});
