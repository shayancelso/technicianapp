enum WOType { rm, ppm, ss }

enum Priority { p1, p2, p3, p4 }

enum WOStatus {
  assigned,
  tripStarted,
  siteAttended,
  workStarted,
  workCompleted,
  outOfScopeRCQ,
  outOfScopeTBQ,
  outOfScopeDeclined,
  onHold,
  customerDeferred,
  customerNotResponding,
  customerNotAvailable,
  securityAccessIssue,
  delayed,
  readyToExecute,
  awaitingPTW,
  closed,
}

enum PunchType { punchIn, punchOut }

enum MemberType { primary, secondary }

enum TeamScope { favorite, workOrder }

enum AnnotationType { circle, square, arrow }

enum EstimationCategory { manpower, material, service }

enum EstimationStatus { draft, submitted, approved, rejected }

enum SyncOperation { create, update, delete }

enum SyncItemStatus { pending, inProgress, failed, completed }

enum ConnectivityState { online, offline, syncing, forcedOffline }

enum TaskResponse { yes, no, na }

// ── Extension helpers ──

extension WOTypeLabel on WOType {
  String get label => switch (this) {
    WOType.rm => 'Reactive Maintenance',
    WOType.ppm => 'Planned Preventive',
    WOType.ss => 'Soft Services',
  };

  String get shortLabel => switch (this) {
    WOType.rm => 'RM',
    WOType.ppm => 'PPM',
    WOType.ss => 'SS',
  };
}

extension PriorityLabel on Priority {
  String get label => switch (this) {
    Priority.p1 => 'P1',
    Priority.p2 => 'P2',
    Priority.p3 => 'P3',
    Priority.p4 => 'P4',
  };
}

extension WOStatusLabel on WOStatus {
  String get label => switch (this) {
    WOStatus.assigned => 'ASSIGNED',
    WOStatus.tripStarted => 'TRIP STARTED',
    WOStatus.siteAttended => 'SITE ATTENDED',
    WOStatus.workStarted => 'WORK STARTED',
    WOStatus.workCompleted => 'COMPLETED',
    WOStatus.outOfScopeRCQ => 'OUT OF SCOPE - RCQ',
    WOStatus.outOfScopeTBQ => 'OUT OF SCOPE - TBQ',
    WOStatus.outOfScopeDeclined => 'OUT OF SCOPE - DECLINED',
    WOStatus.onHold => 'ON HOLD',
    WOStatus.customerDeferred => 'CUSTOMER DEFERRED',
    WOStatus.customerNotResponding => 'CUSTOMER NOT RESPONDING',
    WOStatus.customerNotAvailable => 'CUSTOMER NOT AVAILABLE',
    WOStatus.securityAccessIssue => 'SECURITY ACCESS ISSUE',
    WOStatus.delayed => 'DELAYED',
    WOStatus.readyToExecute => 'READY TO EXECUTE',
    WOStatus.awaitingPTW => 'AWAITING PTW',
    WOStatus.closed => 'CLOSED',
  };

  bool get isTerminal => switch (this) {
    WOStatus.workCompleted ||
    WOStatus.closed ||
    WOStatus.outOfScopeDeclined => true,
    _ => false,
  };
}
