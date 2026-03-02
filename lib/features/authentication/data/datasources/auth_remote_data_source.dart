import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
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

  /// Get current Firebase user
  UserModel? getCurrentFirebaseUser();
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

      // ============================================
      // LOG TOKENS (for backend API use)
      // ============================================
      print('==================== GOOGLE AUTH TOKENS ====================');
      print('Access Token: ${googleAuth.accessToken}');
      print('ID Token: ${googleAuth.idToken}');
      print('===========================================================');

      // TODO: Send tokens to backend API to get user data
      // Example:
      // final response = await dioClient.post('/auth/google', data: {
      //   'accessToken': googleAuth.accessToken,
      //   'idToken': googleAuth.idToken,
      // });
      // final userModel = UserModel.fromJson(response.data);
      // return userModel;

      // TEMPORARY: Throw exception since we don't have backend API yet
      throw const AuthException(
        message: 'Backend API integration pending. Tokens logged to console.',
        code: 'backend_not_implemented',
      );

      // ============================================
      // OLD CODE (keeping for reference - Firebase authentication)
      // ============================================
      // Create a new credential
      // final credential = firebase_auth.GoogleAuthProvider.credential(
      //   accessToken: googleAuth.accessToken,
      //   idToken: googleAuth.idToken,
      // );

      // Sign in to Firebase with the credential
      // final userCredential =
      //     await firebaseAuth.signInWithCredential(credential);

      // if (userCredential.user == null) {
      //   throw const AuthException(
      //     message: 'Failed to sign in with Google',
      //     code: 'sign_in_failed',
      //   );
      // }

      // Convert Firebase user to UserModel
      // final userModel =
      //     UserModel.fromFirebaseUser(userCredential.user!);

      // return userModel;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(
        message: e.message ?? 'Firebase authentication failed',
        code: e.code,
      );
    } catch (e) {
      if (e is AuthException) rethrow;
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

  @override
  UserModel? getCurrentFirebaseUser() {
    final user = firebaseAuth.currentUser;
    return user != null ? UserModel.fromFirebaseUser(user) : null;
  }
}
