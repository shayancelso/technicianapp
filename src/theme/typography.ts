import { TextStyle } from 'react-native';
import { colors } from './colors';

/**
 * Custom fonts in React Native ignore `fontWeight` — each weight is its own
 * fontFamily. Never combine these styles with a fontWeight override: on
 * Android that silently falls back to the system font.
 */
export const fonts = {
  regular: 'Inter-Regular',
  medium: 'Inter-Medium',
  semiBold: 'Inter-SemiBold',
  bold: 'Inter-Bold',
  mono: 'JetBrainsMono-Regular',
} as const;

// lineHeight = fontSize * Flutter `height` multiplier
export const typography = {
  display: {
    fontFamily: fonts.bold,
    fontSize: 28,
    lineHeight: 33.6,
    color: colors.textPrimary,
  },
  h1: {
    fontFamily: fonts.semiBold,
    fontSize: 24,
    lineHeight: 31.2,
    color: colors.textPrimary,
  },
  h2: {
    fontFamily: fonts.semiBold,
    fontSize: 20,
    lineHeight: 26,
    color: colors.textPrimary,
  },
  h3: {
    fontFamily: fonts.medium,
    fontSize: 17,
    lineHeight: 23,
    color: colors.textPrimary,
  },
  body: {
    fontFamily: fonts.regular,
    fontSize: 15,
    lineHeight: 22.5,
    color: colors.textPrimary,
  },
  bodyMedium: {
    fontFamily: fonts.medium,
    fontSize: 15,
    lineHeight: 22.5,
    color: colors.textPrimary,
  },
  bodySmall: {
    fontFamily: fonts.regular,
    fontSize: 13,
    lineHeight: 19.5,
    color: colors.textSecondary,
  },
  caption: {
    fontFamily: fonts.medium,
    fontSize: 11,
    lineHeight: 15.4,
    color: colors.textSecondary,
  },
  overline: {
    fontFamily: fonts.semiBold,
    fontSize: 11,
    lineHeight: 15.4,
    letterSpacing: 1.5,
    color: colors.textSecondary,
  },
  mono: {
    fontFamily: fonts.mono,
    fontSize: 13,
    lineHeight: 18.2,
    color: colors.textPrimary,
  },
  monoLarge: {
    fontFamily: fonts.mono,
    fontSize: 15,
    lineHeight: 21,
    color: colors.textPrimary,
  },
  button: {
    fontFamily: fonts.semiBold,
    fontSize: 15,
    lineHeight: 18,
  },
  buttonSmall: {
    fontFamily: fonts.semiBold,
    fontSize: 13,
    lineHeight: 15.6,
  },
} as const satisfies Record<string, TextStyle>;
