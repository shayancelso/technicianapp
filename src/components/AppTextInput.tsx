import { useState } from 'react';
import {
  Pressable,
  StyleSheet,
  Text,
  TextInput,
  TextInputProps,
  View,
  ViewStyle,
} from 'react-native';
import { MaterialIcons } from '@expo/vector-icons';
import { colors, fonts, radii, sizes, spacing, typography } from '@/theme';

interface AppTextInputProps extends TextInputProps {
  label?: string;
  error?: string;
  isPassword?: boolean;
  containerStyle?: ViewStyle;
}

export function AppTextInput({
  label,
  error,
  isPassword = false,
  containerStyle,
  ...inputProps
}: AppTextInputProps) {
  const [focused, setFocused] = useState(false);
  const [obscured, setObscured] = useState(isPassword);

  const borderColor = error ? colors.error : focused ? colors.borderFocused : colors.border;

  return (
    <View style={containerStyle}>
      {label != null && <Text style={styles.label}>{label}</Text>}
      <View style={[styles.field, { borderColor, borderWidth: focused ? sizes.borderWidthFocused : sizes.borderWidth }]}>
        <TextInput
          {...inputProps}
          secureTextEntry={obscured}
          onFocus={(e) => {
            setFocused(true);
            inputProps.onFocus?.(e);
          }}
          onBlur={(e) => {
            setFocused(false);
            inputProps.onBlur?.(e);
          }}
          style={styles.input}
          placeholderTextColor={colors.textTertiary}
        />
        {isPassword && (
          <Pressable style={styles.eye} onPress={() => setObscured((o) => !o)} hitSlop={8}>
            <MaterialIcons
              name={obscured ? 'visibility-off' : 'visibility'}
              size={20}
              color={colors.textTertiary}
            />
          </Pressable>
        )}
      </View>
      {error != null && <Text style={styles.error}>{error}</Text>}
    </View>
  );
}

const styles = StyleSheet.create({
  label: {
    ...typography.caption,
    marginBottom: 6,
  },
  field: {
    height: sizes.inputHeight,
    borderRadius: radii.input,
    backgroundColor: colors.surface,
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: spacing.sm,
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
  eye: {
    paddingLeft: spacing.xs,
  },
  error: {
    ...typography.caption,
    color: colors.error,
    marginTop: 4,
  },
});
