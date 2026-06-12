import { WOStatus } from '@/constants/enums';
import { colors } from '@/theme';

export interface StatusStep {
  status: WOStatus;
  label: string;
  icon: string; // MaterialIcons glyph name
}

export const statusPipeline: StatusStep[] = [
  { status: 'assigned', label: 'Assigned', icon: 'assignment' },
  { status: 'tripStarted', label: 'Trip Started', icon: 'directions-car' },
  { status: 'siteAttended', label: 'Site Attended', icon: 'location-on' },
  { status: 'workStarted', label: 'Work Started', icon: 'build' },
  { status: 'workCompleted', label: 'Completed', icon: 'check-circle-outline' },
];

export interface NextStatusOption {
  status: WOStatus;
  title: string;
  description: string;
  icon: string;
  iconColor: string;
}

export const nextStatusOptions: NextStatusOption[] = [
  {
    status: 'tripStarted',
    title: 'Start Trip',
    description: 'Mark that you are now traveling to the job site.',
    icon: 'directions-car',
    iconColor: colors.info,
  },
  {
    status: 'siteAttended',
    title: 'Mark Site Attended',
    description: 'Confirm you have arrived and are on-site.',
    icon: 'location-on',
    iconColor: colors.warning,
  },
  {
    status: 'workStarted',
    title: 'Start Work',
    description: 'Begin active work on the reported fault or task.',
    icon: 'build',
    iconColor: colors.success,
  },
  {
    status: 'workCompleted',
    title: 'Complete Work Order',
    description: 'Mark all tasks done and close the work order.',
    icon: 'check-circle',
    iconColor: colors.primary,
  },
];

/** Options strictly after the current step in the pipeline (mirrors _validOptions). */
export function validNextOptions(current: WOStatus): NextStatusOption[] {
  const idx = statusPipeline.findIndex((s) => s.status === current);
  if (idx < 0) return nextStatusOptions;
  return nextStatusOptions.filter(
    (o) => statusPipeline.findIndex((s) => s.status === o.status) > idx,
  );
}
