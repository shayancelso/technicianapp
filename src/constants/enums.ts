// Ported from lib/config/constants/enums.dart (flutter-legacy)

export const WO_TYPES = ['rm', 'ppm', 'ss'] as const;
export type WOType = (typeof WO_TYPES)[number];

export const WO_TYPE_LABELS: Record<WOType, string> = {
  rm: 'Reactive Maintenance',
  ppm: 'Planned Preventive',
  ss: 'Soft Services',
};

export const WO_TYPE_SHORT_LABELS: Record<WOType, string> = {
  rm: 'RM',
  ppm: 'PPM',
  ss: 'SS',
};

export const PRIORITIES = ['p1', 'p2', 'p3', 'p4'] as const;
export type Priority = (typeof PRIORITIES)[number];

export const PRIORITY_LABELS: Record<Priority, string> = {
  p1: 'P1',
  p2: 'P2',
  p3: 'P3',
  p4: 'P4',
};

export const WO_STATUSES = [
  'assigned',
  'tripStarted',
  'siteAttended',
  'workStarted',
  'workCompleted',
  'outOfScopeRCQ',
  'outOfScopeTBQ',
  'outOfScopeDeclined',
  'onHold',
  'customerDeferred',
  'customerNotResponding',
  'customerNotAvailable',
  'securityAccessIssue',
  'delayed',
  'readyToExecute',
  'awaitingPTW',
  'closed',
] as const;
export type WOStatus = (typeof WO_STATUSES)[number];

export const WO_STATUS_LABELS: Record<WOStatus, string> = {
  assigned: 'ASSIGNED',
  tripStarted: 'TRIP STARTED',
  siteAttended: 'SITE ATTENDED',
  workStarted: 'WORK STARTED',
  workCompleted: 'COMPLETED',
  outOfScopeRCQ: 'OUT OF SCOPE - RCQ',
  outOfScopeTBQ: 'OUT OF SCOPE - TBQ',
  outOfScopeDeclined: 'OUT OF SCOPE - DECLINED',
  onHold: 'ON HOLD',
  customerDeferred: 'CUSTOMER DEFERRED',
  customerNotResponding: 'CUSTOMER NOT RESPONDING',
  customerNotAvailable: 'CUSTOMER NOT AVAILABLE',
  securityAccessIssue: 'SECURITY ACCESS ISSUE',
  delayed: 'DELAYED',
  readyToExecute: 'READY TO EXECUTE',
  awaitingPTW: 'AWAITING PTW',
  closed: 'CLOSED',
};

export const isTerminalStatus = (status: WOStatus): boolean =>
  status === 'workCompleted' || status === 'closed' || status === 'outOfScopeDeclined';

export type PunchType = 'punchIn' | 'punchOut';
export type MemberType = 'primary' | 'secondary';
export type TeamScope = 'favorite' | 'workOrder';
export type AnnotationType = 'circle' | 'square' | 'arrow';
export type EstimationCategory = 'manpower' | 'material' | 'service';
export type EstimationStatus = 'draft' | 'submitted' | 'approved' | 'rejected';
export type SyncOperation = 'create' | 'update' | 'delete';
export type SyncItemStatus = 'pending' | 'inProgress' | 'failed' | 'completed';
export type ConnectivityState = 'online' | 'offline' | 'syncing' | 'forcedOffline';
export type TaskResponse = 'yes' | 'no' | 'na';
