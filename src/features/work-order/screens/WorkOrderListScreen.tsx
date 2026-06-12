import { ReactNode, useEffect, useMemo, useState } from 'react';
import {
  Animated,
  Easing,
  FlatList,
  Pressable,
  ScrollView,
  StyleSheet,
  Text,
  TextInput,
  View,
} from 'react-native';
import { MaterialIcons } from '@expo/vector-icons';
import { router, useLocalSearchParams } from 'expo-router';
import { ScreenHeader } from '@/components';
import { WOCard } from '../components/WOCard';
import { mockWorkOrders } from '@/data/mockWorkOrders';
import { isTerminalStatus } from '@/constants/enums';
import { colors, durations, fonts, radii, sizes, spacing, typography } from '@/theme';

// ── Filter Chip Data ──────────────────────────────────────────────────────────

const FILTER_OPTIONS = ['all', 'assigned', 'inProgress', 'completed'] as const;
type FilterOption = (typeof FILTER_OPTIONS)[number];

const FILTER_LABELS: Record<FilterOption, string> = {
  all: 'All',
  assigned: 'Assigned',
  inProgress: 'In Progress',
  completed: 'Completed',
};

// ── Main Screen ───────────────────────────────────────────────────────────────

export default function WorkOrderListScreen() {
  const { type, history } = useLocalSearchParams<{ type: string; history?: string }>();
  const woType = type === 'ppm' || type === 'ss' ? type : 'rm';
  const isHistory = history === 'true';

  const [searchQuery, setSearchQuery] = useState('');
  const [selectedFilter, setSelectedFilter] = useState<FilterOption>('all');
  const [expandedIds, setExpandedIds] = useState<Set<string>>(new Set());

  const suffix = isHistory ? ' History' : '';
  const title =
    woType === 'ppm'
      ? `PPM Work Orders${suffix}`
      : woType === 'ss'
        ? `SS Work Orders${suffix}`
        : `RM Work Orders${suffix}`;

  const filtered = useMemo(() => {
    let list = mockWorkOrders.filter((wo) => {
      if (searchQuery.length > 0) {
        const q = searchQuery.toLowerCase();
        return (
          wo.woNumber.toLowerCase().includes(q) ||
          wo.contractName.toLowerCase().includes(q) ||
          wo.location.toLowerCase().includes(q) ||
          wo.assetName.toLowerCase().includes(q)
        );
      }
      return true;
    });

    if (selectedFilter === 'assigned') {
      list = list.filter((wo) => wo.status === 'assigned');
    } else if (selectedFilter === 'inProgress') {
      list = list.filter(
        (wo) =>
          wo.status === 'tripStarted' ||
          wo.status === 'siteAttended' ||
          wo.status === 'workStarted',
      );
    } else if (selectedFilter === 'completed') {
      list = list.filter((wo) => isTerminalStatus(wo.status));
    }

    return list;
  }, [searchQuery, selectedFilter]);

  const toggleExpanded = (id: string) => {
    setExpandedIds((prev) => {
      const next = new Set(prev);
      if (next.has(id)) {
        next.delete(id);
      } else {
        next.add(id);
      }
      return next;
    });
  };

  return (
    <View style={styles.screen}>
      <ScreenHeader title={title} />
      <View style={styles.headerBorder} />

      {/* ── Search Bar ── */}
      <View style={styles.searchBarContainer}>
        <View style={styles.searchField}>
          <MaterialIcons name="search" size={sizes.iconMD} color={colors.textTertiary} />
          <TextInput
            style={styles.searchInput}
            value={searchQuery}
            onChangeText={setSearchQuery}
            placeholder="Search WO #, contract, location…"
            placeholderTextColor={colors.textTertiary}
          />
          {searchQuery.length > 0 && (
            <Pressable onPress={() => setSearchQuery('')} hitSlop={8} style={styles.clearButton}>
              <MaterialIcons name="close" size={sizes.iconSM} color={colors.textTertiary} />
            </Pressable>
          )}
        </View>
      </View>

      {/* ── Filter Chips ── */}
      <View style={styles.chipsContainer}>
        <ScrollView horizontal showsHorizontalScrollIndicator={false}>
          {FILTER_OPTIONS.map((opt, i) => {
            const selected = opt === selectedFilter;
            return (
              <Pressable
                key={opt}
                onPress={() => setSelectedFilter(opt)}
                style={[
                  styles.chip,
                  i > 0 && { marginLeft: 8 },
                  selected ? styles.chipSelected : styles.chipUnselected,
                ]}
              >
                <Text
                  style={[
                    styles.chipLabel,
                    { color: selected ? colors.textOnPrimary : colors.textSecondary },
                  ]}
                >
                  {FILTER_LABELS[opt]}
                </Text>
              </Pressable>
            );
          })}
        </ScrollView>
      </View>

      {/* ── List ── */}
      <FlatList
        data={filtered}
        keyExtractor={(wo) => wo.id}
        contentContainerStyle={styles.listContent}
        ItemSeparatorComponent={() => <View style={{ height: spacing.sm }} />}
        renderItem={({ item, index }) => (
          <StaggeredItem delay={index * durations.stagger}>
            <WOCard
              wo={item}
              isExpanded={expandedIds.has(item.id)}
              onExpandToggle={() => toggleExpanded(item.id)}
              onViewInfo={() => router.push(`/work-order/${item.id}`)}
              onChangeStatus={() => router.push(`/change-status/${item.id}`)}
            />
          </StaggeredItem>
        )}
      />
    </View>
  );
}

// ── Staggered Fade-in Wrapper ─────────────────────────────────────────────────

function StaggeredItem({ children, delay }: { children: ReactNode; delay: number }) {
  const [anim] = useState(() => new Animated.Value(0));

  useEffect(() => {
    const timer = setTimeout(() => {
      Animated.timing(anim, {
        toValue: 1,
        duration: durations.slow,
        easing: Easing.out(Easing.ease),
        useNativeDriver: true,
      }).start();
    }, delay);
    return () => clearTimeout(timer);
  }, [anim, delay]);

  return (
    <Animated.View
      style={{
        opacity: anim,
        transform: [
          {
            translateY: anim.interpolate({ inputRange: [0, 1], outputRange: [10, 0] }),
          },
        ],
      }}
    >
      {children}
    </Animated.View>
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
  searchBarContainer: {
    backgroundColor: colors.surface,
    paddingHorizontal: spacing.md,
    paddingTop: spacing.md,
    paddingBottom: spacing.xs,
  },
  searchField: {
    height: sizes.inputHeight,
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 12,
    backgroundColor: colors.surfaceAlt,
    borderRadius: radii.input,
    borderWidth: sizes.borderWidth,
    borderColor: colors.border,
  },
  searchInput: {
    ...typography.body,
    flex: 1,
    paddingHorizontal: 4,
    paddingVertical: 0,
    height: '100%',
  },
  clearButton: {
    padding: 4,
  },
  chipsContainer: {
    backgroundColor: colors.surface,
    paddingBottom: spacing.xs,
    paddingLeft: spacing.md,
  },
  chip: {
    height: 36,
    paddingHorizontal: 16,
    borderRadius: radii.chip,
    borderWidth: sizes.borderWidth,
    alignItems: 'center',
    justifyContent: 'center',
  },
  chipSelected: {
    backgroundColor: colors.primary,
    borderColor: colors.primary,
  },
  chipUnselected: {
    backgroundColor: colors.surfaceAlt,
    borderColor: colors.border,
  },
  chipLabel: {
    ...typography.caption,
    fontFamily: fonts.semiBold,
    fontSize: 12,
    lineHeight: 16,
  },
  listContent: {
    padding: spacing.md,
    paddingBottom: spacing.lg + 16,
  },
});
