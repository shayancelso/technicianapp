import { FlatList, Pressable, StyleSheet, Text, View } from 'react-native';
import { MaterialIcons } from '@expo/vector-icons';
import { router } from 'expo-router';
import { ScreenHeader } from '@/components/ScreenHeader';
import { mockTeamDetails } from '@/data/mockTeam';
import { colors, spacing, typography } from '@/theme';
import { StaggeredItem } from '../components/StaggeredItem';
import { StatCard } from '../components/StatCard';
import { TeamMemberCard } from '../components/TeamMemberCard';

const PRIMARY_06 = '#1B43320F'; // colors.primary @ 6%

export default function ViewTeamScreen() {
  const punchedInCount = mockTeamDetails.filter((m) => m.isPunchedIn).length;

  return (
    <View style={styles.screen}>
      <ScreenHeader
        title="View Team"
        trailing={
          <Pressable
            style={({ pressed }) => [styles.addAction, pressed && styles.pressed]}
            onPress={() => router.push('/team/add')}
            hitSlop={8}
          >
            <MaterialIcons name="person-add-alt" size={16} color={colors.primary} />
            <Text style={styles.addLabel}>Add</Text>
          </Pressable>
        }
      />
      <View style={styles.headerBorder} />
      <FlatList
        data={mockTeamDetails}
        keyExtractor={(m) => m.id}
        contentContainerStyle={styles.listContent}
        ListHeaderComponent={
          <>
            {/* ── Stats Header ── */}
            <View style={styles.statsHeader}>
              <StatCard
                label="Total Members"
                value={`${mockTeamDetails.length}`}
                icon="group"
                iconColor={colors.primary}
                bgColor={PRIMARY_06}
              />
              <StatCard
                label="Punched In"
                value={`${punchedInCount}`}
                icon="login"
                iconColor={colors.success}
                bgColor={colors.successLight}
              />
              <StatCard
                label="Off Duty"
                value={`${mockTeamDetails.length - punchedInCount}`}
                icon="logout"
                iconColor={colors.textSecondary}
                bgColor={colors.surfaceAlt}
              />
            </View>
            {/* ── Section Label ── */}
            <Text style={[typography.overline, styles.sectionLabel]}>
              SORTED BY LONGEST SERVING
            </Text>
          </>
        }
        renderItem={({ item, index }) => (
          <StaggeredItem delay={index * 60}>
            <View style={styles.itemWrap}>
              <TeamMemberCard member={item} rank={index + 1} />
            </View>
          </StaggeredItem>
        )}
      />
    </View>
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
  addAction: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
    paddingHorizontal: 8,
    paddingVertical: 8,
  },
  addLabel: {
    ...typography.buttonSmall,
    color: colors.primary,
  },
  pressed: {
    opacity: 0.7,
  },
  listContent: {
    paddingBottom: spacing.lg + 16,
  },
  statsHeader: {
    flexDirection: 'row',
    gap: spacing.sm,
    backgroundColor: colors.surface,
    padding: spacing.md,
  },
  sectionLabel: {
    marginHorizontal: spacing.md,
    marginTop: spacing.md,
    marginBottom: spacing.xs,
  },
  itemWrap: {
    marginHorizontal: spacing.md,
    marginBottom: spacing.xs,
  },
});
