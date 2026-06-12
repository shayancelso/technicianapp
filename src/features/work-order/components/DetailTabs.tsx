import { Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { colors, fonts, spacing, typography } from '@/theme';

interface DetailTabsProps {
  tabs: string[];
  activeIndex: number;
  onTabPress: (index: number) => void;
}

/** Hand-rolled scrollable tab strip — port of the Flutter detail TabBar. */
export function DetailTabs({ tabs, activeIndex, onTabPress }: DetailTabsProps) {
  return (
    <View style={styles.container}>
      <ScrollView
        horizontal
        showsHorizontalScrollIndicator={false}
        contentContainerStyle={styles.content}
      >
        {tabs.map((tab, i) => {
          const active = i === activeIndex;
          return (
            <Pressable key={tab} onPress={() => onTabPress(i)} style={styles.tab}>
              <Text style={[styles.label, active && styles.labelActive]}>{tab}</Text>
              <View style={[styles.indicator, active && styles.indicatorActive]} />
            </Pressable>
          );
        })}
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    backgroundColor: colors.surface,
    borderBottomWidth: 1,
    borderBottomColor: colors.border,
  },
  content: {
    paddingHorizontal: spacing.xs,
  },
  tab: {
    paddingHorizontal: 16,
  },
  label: {
    ...typography.bodySmall,
    color: colors.textSecondary,
    paddingVertical: 14,
    textAlign: 'center',
  },
  labelActive: {
    fontFamily: fonts.semiBold,
    color: colors.primary,
  },
  indicator: {
    height: 2,
    backgroundColor: 'transparent',
  },
  indicatorActive: {
    backgroundColor: colors.primary,
  },
});
