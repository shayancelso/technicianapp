abstract final class AppConstants {
  static const appName = 'Reflexion';
  static const appVersion = '1.0.0';
  static const copyright = 'Lattice Software Solutions LLC';

  // API
  static const baseUrl = 'https://api.reflexion.lattice.ae/v4';
  static const connectionTimeout = Duration(seconds: 30);
  static const receiveTimeout = Duration(seconds: 30);

  // Sync
  static const syncIntervalMinutes = 5;
  static const maxSyncRetries = 5;
  static const pingIntervalSeconds = 10;

  // Storage Keys
  static const accessTokenKey = 'access_token';
  static const refreshTokenKey = 'refresh_token';
  static const userKey = 'user_data';
  static const lastSyncKey = 'last_sync_timestamp';
  static const offlineModeKey = 'forced_offline';

  // Photo
  static const photoMaxWidth = 1280.0;
  static const photoQuality = 80;
  static const maxPhotosPerStatus = 10;

  // SLA Timer
  static const customerNotRespondingTimeoutMinutes = 10;
}
