/// Backend API base URL (photo analysis, remote settings).
abstract final class ApiConfig {
  static const photoApiBaseUrl = String.fromEnvironment(
    'PHOTO_API_BASE_URL',
    defaultValue: 'https://use-by-date-server.vercel.app',
  );
}
