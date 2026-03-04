import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:streaming_app/core/constants/api_constants.dart';
import 'package:streaming_app/core/error/exceptions.dart';
import 'package:streaming_app/core/network/dio_client.dart';
import 'package:streaming_app/features/authentication/data/models/user_model.dart';

/// Remote data source for authentication
/// Handles API calls and Firebase authentication
abstract class AuthRemoteDataSource {
  /// Login with Google
  Future<UserModel> loginWithGoogle();

  /// Logout
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;
  final firebase_auth.FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  AuthRemoteDataSourceImpl({
    required this.dioClient,
    required this.firebaseAuth,
    required this.googleSignIn,
  });

  @override
  Future<UserModel> loginWithGoogle() async {
    try {
      // Trigger Google Sign In flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        throw const AuthException(
          message: 'Google Sign In was cancelled',
          code: 'sign_in_cancelled',
        );
      }

      // Obtain auth details from request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final accessToken = googleAuth.accessToken;

      if (accessToken == null) {
        throw const AuthException(
          message: 'Failed to get access token from Google',
          code: 'no_access_token',
        );
      }

      print('==================== GOOGLE AUTH TOKENS ====================');
      print('Access Token: $accessToken');
      print('===========================================================');

      // Send access token to backend API
      final response = await dioClient.post(
        ApiConstants.auth,
        data: {'token': accessToken},
      );

      print('==================== BACKEND RESPONSE ====================');
      print('Response: ${response.data}');
      print('=========================================================');

      // Parse response - response.data contains the JSON body
      final responseData = response.data as Map<String, dynamic>;
      final data = responseData['data'] as Map<String, dynamic>;
      final jwtToken = data['token'] as String;

      // Check if user data exists in response
      if (data.containsKey('user') && data['user'] != null) {
        // Existing user - has full user data
        final userJson = data['user'] as Map<String, dynamic>;
        final userModel = UserModel.fromJson(userJson);

        print('✅ Existing user authenticated: ${userModel.email}');
        return userModel;
      } else {
        // New user - only JWT token returned, needs onboarding
        print('🆕 New user detected - needs onboarding');
        throw NewUserException(
          message: 'New user needs to complete onboarding',
          jwtToken: jwtToken,
        );
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(
        message: e.message ?? 'Firebase authentication failed',
        code: e.code,
      );
    } catch (e) {
      if (e is AuthException) rethrow;
      if (e is NewUserException) rethrow;
      if (e is ServerException) rethrow;
      throw AuthException(message: 'Google Sign In failed: $e');
    }
  }


  @override
  Future<void> logout() async {
    try {
      await Future.wait([
        firebaseAuth.signOut(),
        googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw AuthException(message: 'Logout failed: $e');
    }
  }
}
