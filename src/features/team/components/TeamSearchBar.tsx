import { Pressable, StyleSheet, TextInput, View } from 'react-native';
import { MaterialIcons } from '@expo/vector-icons';
import { colors, fonts, radii, sizes, spacing } from '@/theme';

interface TeamSearchBarProps {
  value: string;
  onChangeText: (value: string) => void;
  placeholder: string;
}

/** Search field used by the add/remove member screens (parity with Flutter _buildSearchBar). */
export function TeamSearchBar({ value, onChangeText, placeholder }: TeamSearchBarProps) {
  return (
    <View style={styles.container}>
      <MaterialIcons
        name="search"
        size={sizes.iconMD}
        color={colors.textTertiary}
        style={styles.prefix}
      />
      <TextInput
        value={value}
        onChangeText={onChangeText}
        placeholder={placeholder}
        placeholderTextColor={colors.textTertiary}
        style={styles.input}
      />
      {value.length > 0 && (
        <Pressable style={styles.clear} onPress={() => onChangeText('')} hitSlop={8}>
          <MaterialIcons name="close" size={sizes.iconSM} color={colors.textTertiary} />
        </Pressable>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    height: sizes.inputHeight,
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: colors.surfaceAlt,
    borderRadius: radii.input,
    borderWidth: sizes.borderWidth,
    borderColor: colors.border,
  },
  prefix: {
    paddingLeft: spacing.sm,
    paddingRight: 4,
  },
  input: {
    flex: 1,
    height: '100%',
    paddingHorizontal: 4,
    paddingVertical: 0,
    fontFamily: fonts.regular,
    fontSize: 15,
    color: colors.textPrimary,
    textAlignVertical: 'center',
  },
  clear: {
    paddingHorizontal: spacing.sm,
    height: '100%',
    justifyContent: 'center',
  },
});
