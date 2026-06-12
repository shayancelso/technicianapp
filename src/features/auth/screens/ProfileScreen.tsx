import { useState, Fragment, useEffect } from 'react';
import {
  Animated,
  Easing,
  Pressable,
  ScrollView,
  StyleSheet,
  Text,
  View,
} from 'react-native';
import { MaterialIcons } from '@expo/vector-icons';
import { router } from 'expo-router';
import { InitialsAvatar, ScreenHeader, SectionLabel } from '@/components';
import { mockProfileFields, mockUser } from '@/data/mockUser';
import { colors, fonts, radii, sizes, spacing, typography } from '@/theme';

export default function ProfileScreen() {
  // Entrance fade (350ms easeOut)
  const [anim] = useState(() => new Animated.Value(0));
  useEffect(() => {
    Animated.timing(anim, {
      toValue: 1,
      duration: 350,
      easing: Easing.out(Easing.ease),
      useNativeDriver: true,
    }).start();
  }, [anim]);

  return (
    <View style={styles.screen}>
      <ScreenHeader title="Profile" />
      <View style={styles.hairline} />

      <Animated.View style={[styles.flex, { opacity: anim }]}>
        <ScrollView>
          {/* Avatar + name header */}
          <View style={styles.header}>
            <View style={styles.avatarRing}>
              <InitialsAvatar initials={mockUser.initials} size={80} />
            </View>
            <View style={{ height: 16 }} />
            <Text style={typography.h2}>{mockUser.displayName}</Text>
            <View style={{ height: 4 }} />
            <View style={styles.designationChip}>
              <Text style={styles.designationText}>{mockUser.designation}</Text>
            </View>
          </View>

          <View style={styles.hairline} />

          {/* Section header */}
          <View style={styles.sectionHeader}>
            <SectionLabel>Personal Information</SectionLabel>
          </View>

          {/* Fields list */}
          <View style={styles.fieldsCard}>
            {mockProfileFields.map((field, index) => (
              <Fragment key={field.label}>
                {index > 0 && <View style={styles.fieldDivider} />}
                <View style={styles.fieldTile}>
                  <Text style={styles.fieldLabel}>{field.label}</Text>
                  <View style={{ height: 4 }} />
                  <Text style={styles.fieldValue}>{field.value}</Text>
                </View>
              </Fragment>
            ))}
          </View>

          <View style={{ height: spacing.xl }} />
        </ScrollView>

        {/* Bottom action */}
        <View style={styles.bottomBar}>
          <Pressable
            style={({ pressed }) => [styles.outlinedButton, pressed && styles.pressed]}
            onPress={() => router.push('/change-password')}
          >
            <MaterialIcons name="lock-outline" size={sizes.iconMD} color={colors.primary} />
            <Text style={styles.outlinedButtonLabel}>Change Password</Text>
          </Pressable>
        </View>
      </Animated.View>
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
  header: {
    width: '100%',
    alignItems: 'center',
    backgroundColor: colors.surface,
    paddingHorizontal: spacing.lg,
    paddingVertical: spacing.xl,
  },
  avatarRing: {
    width: 84,
    height: 84,
    borderRadius: 42,
    borderWidth: 2,
    borderColor: 'rgba(8, 28, 21, 0.2)', // primaryDark @ 20%
    alignItems: 'center',
    justifyContent: 'center',
  },
  designationChip: {
    paddingHorizontal: 10,
    paddingVertical: 4,
    borderRadius: radii.chip,
    backgroundColor: 'rgba(27, 67, 50, 0.08)', // primary @ 8%
  },
  designationText: {
    ...typography.caption,
    fontFamily: fonts.semiBold,
    color: colors.primary,
  },
  sectionHeader: {
    paddingHorizontal: spacing.lg,
    paddingTop: spacing.lg,
  },
  fieldsCard: {
    marginHorizontal: spacing.md,
    backgroundColor: colors.surface,
    borderRadius: radii.card,
    borderWidth: sizes.borderWidth,
    borderColor: colors.border,
  },
  fieldDivider: {
    height: 1,
    marginHorizontal: spacing.md,
    backgroundColor: colors.divider,
  },
  fieldTile: {
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.sm,
  },
  fieldLabel: {
    ...typography.caption,
    color: colors.textTertiary,
    letterSpacing: 0.3,
  },
  fieldValue: {
    ...typography.body,
    color: colors.textPrimary,
  },
  bottomBar: {
    paddingHorizontal: spacing.lg,
    paddingVertical: spacing.md,
    backgroundColor: colors.surface,
    borderTopWidth: sizes.borderWidth,
    borderTopColor: colors.border,
  },
  outlinedButton: {
    height: sizes.buttonHeight,
    borderRadius: radii.button,
    borderWidth: sizes.borderWidth,
    borderColor: colors.primary,
    backgroundColor: colors.surface,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 8,
  },
  outlinedButtonLabel: {
    ...typography.button,
    color: colors.primary,
  },
  pressed: {
    opacity: 0.85,
  },
});
