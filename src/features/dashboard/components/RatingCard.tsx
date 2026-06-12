import { StyleSheet, Text, View } from 'react-native';
import { MaterialIcons } from '@expo/vector-icons';
import { colors, fonts, radii, sizes, spacing, typography } from '@/theme';

export interface StarBreakdownItem {
  stars: number;
  count: number;
}

interface RatingCardProps {
  overallRating: number;
  starBreakdown: StarBreakdownItem[];
}

/** Flutter `_starColor`: 4–5 stars → primary, 3 and below → error. */
function starColor(stars: number): string {
  if (stars >= 4) return colors.primary;
  return colors.error;
}

/** 30-day rating summary card with star breakdown bars (plain Views, no chart lib). */
export function RatingCard({ overallRating, starBreakdown }: RatingCardProps) {
  const maxCount = Math.max(...starBreakdown.map((s) => s.count));

  return (
    <View style={styles.card}>
      {/* Rating header row */}
      <View style={styles.headerRow}>
        <Text style={styles.ratingValue}>{overallRating.toFixed(1)}/5</Text>
        <View style={styles.starsRow}>
          {Array.from({ length: 5 }, (_, i) => {
            let name: 'star' | 'star-half' = 'star';
            let color = '#E0E0E0';
            if (overallRating >= i + 1) {
              color = colors.warning;
            } else if (overallRating > i) {
              name = 'star-half';
              color = colors.warning;
            }
            return <MaterialIcons key={i} name={name} size={20} color={color} />;
          })}
        </View>
        <Text style={[typography.bodySmall, { marginLeft: 10 }]}>Rating (30d)</Text>
        <MaterialIcons
          name="info-outline"
          size={16}
          color={colors.textTertiary}
          style={{ marginLeft: 4 }}
        />
      </View>

      {/* Star breakdown bars */}
      <View style={{ marginTop: 20 }}>
        {starBreakdown.map((data) => {
          const fraction = Math.min(Math.max(data.count / maxCount, 0), 1);
          return (
            <View key={data.stars} style={styles.barRow}>
              <Text style={styles.starLabel}>{data.stars}</Text>
              <MaterialIcons
                name="star"
                size={14}
                color={starColor(data.stars)}
                style={{ marginLeft: 4 }}
              />
              <View style={styles.track}>
                <View
                  style={[
                    styles.fill,
                    { width: `${fraction * 100}%`, backgroundColor: starColor(data.stars) },
                  ]}
                />
              </View>
              <Text style={styles.countLabel}>{data.count}</Text>
            </View>
          );
        })}
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  card: {
    backgroundColor: colors.surface,
    borderRadius: radii.card,
    borderWidth: sizes.borderWidth,
    borderColor: colors.border,
    padding: spacing.md,
  },
  headerRow: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  ratingValue: {
    ...typography.h1,
    fontFamily: fonts.bold,
    marginRight: 8,
  },
  starsRow: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  barRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 10,
  },
  starLabel: {
    ...typography.bodySmall,
    fontFamily: fonts.semiBold,
    width: 14,
    textAlign: 'center',
  },
  track: {
    flex: 1,
    height: 8,
    borderRadius: 4,
    backgroundColor: colors.border,
    marginHorizontal: 10,
    overflow: 'hidden',
  },
  fill: {
    height: 8,
    borderRadius: 4,
  },
  countLabel: {
    ...typography.bodySmall,
    fontFamily: fonts.semiBold,
    width: 24,
    textAlign: 'right',
  },
});
