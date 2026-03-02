import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_app/core/usecases/usecase.dart';
import 'package:streaming_app/features/authentication/domain/usecases/get_current_user.dart';
import 'package:streaming_app/features/authentication/domain/usecases/login_with_google.dart';
import 'package:streaming_app/features/authentication/domain/usecases/logout.dart';
import 'package:streaming_app/features/authentication/presentation/bloc/auth_event.dart';
import 'package:streaming_app/features/authentication/presentation/bloc/auth_state.dart';

/// BLoC for managing authentication state
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginWithGoogle loginWithGoogle;
  final Logout logout;
  final GetCurrentUser getCurrentUser;

  AuthBloc({
    required this.loginWithGoogle,
    required this.logout,
    required this.getCurrentUser,
  }) : super(const AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LoginWithGoogleRequested>(_onLoginWithGoogleRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  /// Check if user is already logged in
  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await getCurrentUser(NoParams());

    result.fold(
      (failure) => emit(const AuthUnauthenticated()),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  /// Handle Google login
  Future<void> _onLoginWithGoogleRequested(
    LoginWithGoogleRequested event,
    Emitter<AuthState> emit,
  ) async {
    print('🔵 AuthBloc: LoginWithGoogleRequested event received');
    emit(const AuthLoading());
    print('🔵 AuthBloc: Emitted AuthLoading state');

    final result = await loginWithGoogle(NoParams());
    print('🔵 AuthBloc: Login result received');

    result.fold(
      (failure) {
        print('🔴 AuthBloc: Login failed - ${failure.message}');
        emit(AuthError(failure.message));
        // Return to unauthenticated state after showing error
        emit(const AuthUnauthenticated());
      },
      (user) {
        print('🟢 AuthBloc: Login successful - ${user.email}');
        emit(AuthAuthenticated(user));
      },
    );
  }

  /// Handle logout
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await logout(NoParams());

    result.fold(
      (failure) {
        emit(AuthError(failure.message));
        // Even if logout fails, go to unauthenticated state
        emit(const AuthUnauthenticated());
      },
      (_) => emit(const AuthUnauthenticated()),
    );
  }
}
