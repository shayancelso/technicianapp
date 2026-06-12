import { StyleSheet, Text, View } from 'react-native';
import { WOStatus, WO_STATUS_LABELS } from '@/constants/enums';
import { fonts, radii, statusColors } from '@/theme';

function colorsFor(status: WOStatus): { bg: string; text: string } {
  switch (status) {
    case 'assigned':
      return statusColors.assigned;
    case 'tripStarted':
      return statusColors.tripStarted;
    case 'siteAttended':
      return statusColors.siteAttended;
    case 'workStarted':
      return statusColors.workStarted;
    case 'workCompleted':
      return statusColors.completed;
    case 'onHold':
    case 'outOfScopeDeclined':
      return statusColors.onHold;
    case 'delayed':
    case 'customerNotResponding':
    case 'customerDeferred':
    case 'customerNotAvailable':
    case 'securityAccessIssue':
      return statusColors.delayed;
    default:
      return statusColors.assigned;
  }
}

export function StatusBadge({ status }: { status: WOStatus }) {
  const { bg, text } = colorsFor(status);
  return (
    <View style={[styles.badge, { backgroundColor: bg }]}>
      <Text style={[styles.label, { color: text }]}>{WO_STATUS_LABELS[status]}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  badge: {
    paddingHorizontal: 10,
    paddingVertical: 4,
    borderRadius: radii.chip,
    alignSelf: 'flex-start',
  },
  label: {
    fontFamily: fonts.semiBold,
    fontSize: 10,
    letterSpacing: 0.5,
  },
});
