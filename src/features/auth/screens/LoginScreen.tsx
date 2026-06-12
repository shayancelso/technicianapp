import { useEffect, useState } from 'react';
import {
  Animated,
  Easing,
  Image,
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

// ── Reusable input field (parity with Flutter _InputField) ──────────────────

interface InputFieldProps {
  value: string;
  onChangeText: (text: string) => void;
  placeholder: string;
  prefixIcon: keyof typeof MaterialIcons.glyphMap;
  error?: string;
  secureTextEntry?: boolean;
  showToggle?: boolean;
  onToggleSecure?: () => void;
  returnKeyType?: 'next' | 'done';
  onSubmitEditing?: () => void;
}

function InputField({
  value,
  onChangeText,
  placeholder,
  prefixIcon,
  error,
  secureTextEntry = false,
  showToggle = false,
  onToggleSecure,
  returnKeyType = 'next',
  onSubmitEditing,
}: InputFieldProps) {
  const [focused, setFocused] = useState(false);
  const borderColor = error ? colors.error : focused ? colors.borderFocused : colors.border;

  return (
    <View style={styles.fieldWrap}>
      <View
        style={[
          styles.field,
          { borderColor, borderWidth: focused ? sizes.borderWidthFocused : sizes.borderWidth },
        ]}
      >
        <MaterialIcons
          name={prefixIcon}
          size={sizes.iconMD}
          color={colors.textTertiary}
          style={styles.prefixIcon}
        />
        <TextInput
          value={value}
          onChangeText={onChangeText}
          placeholder={placeholder}
          placeholderTextColor={colors.textTertiary}
          secureTextEntry={secureTextEntry}
          returnKeyType={returnKeyType}
          onSubmitEditing={onSubmitEditing}
          onFocus={() => setFocused(true)}
          onBlur={() => setFocused(false)}
          autoCapitalize="none"
          style={styles.input}
        />
        {showToggle && (
          <Pressable onPress={onToggleSecure} hitSlop={8} style={styles.suffix}>
            <MaterialIcons
              name={secureTextEntry ? 'visibility-off' : 'visibility'}
              size={sizes.iconMD}
              color={colors.textTertiary}
            />
          </Pressable>
        )}
      </View>
      {error != null && <Text style={styles.fieldError}>{error}</Text>}
    </View>
  );
}

// ── Login Screen ─────────────────────────────────────────────────────────────

export default function LoginScreen() {
  const insets = useSafeAreaInsets();

  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [rememberMe, setRememberMe] = useState(false);
  const [obscurePassword, setObscurePassword] = useState(true);
  const [isLoading, setIsLoading] = useState(false);
  const [errors, setErrors] = useState<{ username?: string; password?: string }>({});

  // Entrance fade + slide (600ms easeOut, staggered 80ms)
  const [anim] = useState(() => new Animated.Value(0));
  useEffect(() => {
    const timer = setTimeout(() => {
      Animated.timing(anim, {
        toValue: 1,
        duration: 600,
        easing: Easing.out(Easing.ease),
        useNativeDriver: true,
      }).start();
    }, 80);
    return () => clearTimeout(timer);
  }, [anim]);
  const translateY = anim.interpolate({ inputRange: [0, 1], outputRange: [24, 0] });

  const validate = () => {
    const next: { username?: string; password?: string } = {};
    if (username.trim().length === 0) next.username = 'Enter your username';
    if (password.length === 0) next.password = 'Enter your password';
    setErrors(next);
    return Object.keys(next).length === 0;
  };

  const handleSignIn = () => {
    if (isLoading) return;
    if (!validate()) return;

    setIsLoading(true);
    // Simulated network call
    setTimeout(() => {
      setIsLoading(false);
      router.replace('/punch-in');
    }, 900);
  };

  return (
    <View style={[styles.screen, { paddingTop: insets.top, paddingBottom: insets.bottom }]}>
      <KeyboardAvoidingView
        style={styles.flex}
        behavior={Platform.OS === 'ios' ? 'padding' : undefined}
      >
        <ScrollView
          contentContainerStyle={styles.scrollContent}
          keyboardShouldPersistTaps="handled"
        >
          <Animated.View style={[styles.form, { opacity: anim, transform: [{ translateY }] }]}>
            <View style={{ height: 24 }} />
            <Image
              source={require('@/assets/images/reflexion_logo.png')}
              style={styles.logo}
              resizeMode="contain"
            />
            <View style={{ height: 12 }} />
            <Text style={styles.appSubtitle}>Technician App</Text>
            <View style={{ height: 48 }} />

            {/* Username field */}
            <InputField
              value={username}
              onChangeText={setUsername}
              placeholder="Username"
              prefixIcon="person-outline"
              error={errors.username}
              returnKeyType="next"
            />
            <View style={{ height: 12 }} />

            {/* Password field */}
            <InputField
              value={password}
              onChangeText={setPassword}
              placeholder="Password"
              prefixIcon="lock-outline"
              error={errors.password}
              secureTextEntry={obscurePassword}
              showToggle
              onToggleSecure={() => setObscurePassword((o) => !o)}
              returnKeyType="done"
              onSubmitEditing={handleSignIn}
            />
            <View style={{ height: 16 }} />

            {/* Remember me + Forgot password row */}
            <View style={styles.optionsRow}>
              <Pressable
                style={styles.rememberRow}
                onPress={() => setRememberMe((v) => !v)}
                hitSlop={8}
              >
                <View style={[styles.checkbox, rememberMe && styles.checkboxChecked]}>
                  {rememberMe && (
                    <MaterialIcons name="check" size={14} color={colors.textOnPrimary} />
                  )}
                </View>
                <Text style={styles.rememberLabel}>Remember Me</Text>
              </Pressable>
              <Pressable onPress={() => router.push('/forgot-password')} hitSlop={8}>
                <Text style={styles.forgotLink}>Forgot Password?</Text>
              </Pressable>
            </View>
            <View style={{ height: 28 }} />

            {/* Sign In button */}
            <AppButton
              label="Sign In"
              onPress={handleSignIn}
              loading={isLoading}
              style={styles.signInButton}
            />
            <View style={{ height: 48 }} />

            {/* Version */}
            <Text style={styles.version}>Version 1.0.0</Text>
            <View style={{ height: 12 }} />
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
  scrollContent: {
    flexGrow: 1,
    justifyContent: 'center',
    alignItems: 'center',
    paddingHorizontal: spacing.xl,
    paddingVertical: spacing.xl,
  },
  form: {
    width: '100%',
    maxWidth: 400,
    alignItems: 'center',
  },
  logo: {
    width: 220,
    height: 64,
  },
  appSubtitle: {
    ...typography.bodySmall,
    color: colors.textTertiary,
    letterSpacing: 0.3,
  },
  fieldWrap: {
    width: '100%',
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
  optionsRow: {
    width: '100%',
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  rememberRow: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  checkbox: {
    width: 20,
    height: 20,
    borderRadius: 4,
    borderWidth: 1.5,
    borderColor: colors.border,
    alignItems: 'center',
    justifyContent: 'center',
    marginRight: 8,
  },
  checkboxChecked: {
    backgroundColor: colors.primary,
    borderColor: colors.primary,
  },
  rememberLabel: {
    ...typography.bodySmall,
    color: colors.textSecondary,
  },
  forgotLink: {
    ...typography.bodySmall,
    fontFamily: fonts.medium,
    color: colors.primaryLight,
  },
  version: {
    ...typography.caption,
    color: colors.textTertiary,
  },
  signInButton: {
    width: '100%',
  },
});
