// Ported from lib/config/constants/app_constants.dart (flutter-legacy)

export const appConstants = {
  appName: 'Reflexion',
  appVersion: '1.0.0',
  copyright: 'Lattice Software Solutions LLC',

  // API
  baseUrl: 'https://api.reflexion.lattice.ae/v4',
  connectionTimeoutMs: 30_000,
  receiveTimeoutMs: 30_000,

  // Sync
  syncIntervalMinutes: 5,
  maxSyncRetries: 5,
  pingIntervalSeconds: 10,

  // Storage Keys
  accessTokenKey: 'access_token',
  refreshTokenKey: 'refresh_token',
  userKey: 'user_data',
  lastSyncKey: 'last_sync_timestamp',
  offlineModeKey: 'forced_offline',

  // Photo
  photoMaxWidth: 1280,
  photoQuality: 80,
  maxPhotosPerStatus: 10,

  // SLA Timer
  customerNotRespondingTimeoutMinutes: 10,
} as const;
