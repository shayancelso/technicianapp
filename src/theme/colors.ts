/**
 * Reflexion Technician App color palette.
 * Inspired by Apple HIG clarity and Stripe Dashboard elegance.
 * White backgrounds, dark forest green primary.
 */
export const colors = {
  // ── Primary Green Scale ──
  primary: '#1B4332',
  primaryLight: '#2D6A4F',
  primaryDark: '#081C15',
  accent: '#40916C',
  primaryMuted: '#52B788',

  // ── Surfaces ──
  surface: '#FFFFFF',
  surfaceAlt: '#F8FAF9',
  scaffoldBg: '#F8FAF9',

  // ── Borders & Dividers ──
  border: '#E8EEEB',
  borderFocused: '#1B4332',
  divider: '#F0F3F1',

  // ── Text ──
  textPrimary: '#1A1A1A',
  textSecondary: '#6B7280',
  textTertiary: '#9CA3AF',
  textOnPrimary: '#FFFFFF',

  // ── Semantic ──
  success: '#059669',
  successLight: '#D1FAE5',
  warning: '#D97706',
  warningLight: '#FEF3C7',
  error: '#DC2626',
  errorLight: '#FEE2E2',
  info: '#2563EB',
  infoLight: '#DBEAFE',

  // ── Misc ──
  shimmerBase: '#E8EEEB',
  shimmerHighlight: '#F8FAF9',
  overlay: 'rgba(0, 0, 0, 0.5)',
} as const;

export const priorityColors = {
  p1: '#DC2626',
  p2: '#EA580C',
  p3: '#2563EB',
  p4: '#6B7280',
} as const;

export const statusColors = {
  assigned: { bg: '#E8EEEB', text: '#6B7280' },
  tripStarted: { bg: '#DBEAFE', text: '#2563EB' },
  siteAttended: { bg: '#FEF3C7', text: '#D97706' },
  workStarted: { bg: '#D1FAE5', text: '#059669' },
  completed: { bg: '#1B4332', text: '#FFFFFF' },
  onHold: { bg: '#FEE2E2', text: '#DC2626' },
  delayed: { bg: '#FEF3C7', text: '#D97706' },
} as const;
