/// API endpoints and configuration
class ApiConstants {
  ApiConstants._();

  // Base URLs
  static const String baseUrl = 'https://aura-backend-jezt.onrender.com/api/v1/';
  static const String socketUrl = 'https://chat.yourbackend.com'; // TODO: Update with actual Socket URL

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // API Endpoints - Authentication
  static const String auth = 'auth'; // Google Sign-In authentication
  static const String onboard = 'auth/onboard'; // Complete user profile after sign-in
  static const String logout = 'auth/logout';
  static const String me = 'auth/me';

  // API Endpoints - Streams
  static const String streams = '/streams';
  static const String liveStreams = '/streams/live';
  static String streamById(String id) => '/streams/$id';
  static const String createStream = '/streams';
  static const String joinStream = '/streams/join';
  static const String leaveStream = '/streams/leave';

  // API Endpoints - Users/Profile
  static const String profile = '/user/profile';
  static const String updateProfile = '/user/profile';
  static const String uploadAvatar = '/user/avatar';

  // API Endpoints - Chat
  static const String messages = '/chat/messages';
  static const String sendMessage = '/chat/send';
  static String chatRoom(String roomId) => '/chat/rooms/$roomId';

  // Headers
  static const String authHeader = 'Authorization';
  static const String contentType = 'Content-Type';
  static const String accept = 'Accept';
  static const String applicationJson = 'application/json';
}
